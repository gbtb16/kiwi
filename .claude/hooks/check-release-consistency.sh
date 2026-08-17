#!/bin/sh
# Reproduces the `changelog` CI gate locally, plus the example-pubspec version
# check that no CI job covers.
#
# 1. CHANGELOG.md of each published package must start with `# <pubspec version>`
#    — this is exactly what tools/kiwi_cli_actions asserts. The workflow exits 1
#    otherwise, and it runs on every push/PR, not only on version bumps.
# 2. The examples' `kiwi:` / `kiwi_generator:` constraints must accept the same
#    major as the packages they point at. The examples use dependency_overrides
#    pointing at local paths, so a stale constraint resolves fine in CI and only
#    breaks for real users.
#
# Warns; never blocks. Exits 0 and prints nothing when everything lines up.
# POSIX sh, no jq — this ships to every fork.

set -u

root="${CLAUDE_PROJECT_DIR:-}"
if [ -z "$root" ] || [ ! -d "$root/packages" ]; then
  root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
fi
[ -d "$root/packages" ] || exit 0

# Reads `version:` from a pubspec, or a dependency constraint when `pkg` is set.
# Keeping the extraction in awk avoids quoting the apostrophe through sh.
read_version() {
  awk -v pkg="${2:-}" '
    function clean(v) {
      gsub(/[\047"]/, "", v)
      sub(/[ \t].*$/, "", v)
      return v
    }
    pkg == "" && /^version:/ {
      v = $0
      sub(/^version:[ \t]*/, "", v)
      print clean(v)
      exit
    }
    # An indented `<pkg>:` whose value starts a version range on the same line.
    # This skips the bare `kiwi:` under dependency_overrides (its value is a
    # nested `path:`), which is the whole point of looking for a digit.
    pkg != "" && $0 ~ ("^[ \t]+" pkg ":[ \t]*[\\^><=~ ]*[0-9]") {
      v = $0
      sub(/^[ \t]+[A-Za-z0-9_]+:[ \t]*/, "", v)
      print clean(v)
      exit
    }
  ' "$1" 2>/dev/null
}

major() {
  echo "$1" | sed -e 's/^[^0-9]*//' -e 's/[.+-].*$//'
}

problems=""
# The message ends up inside a hand-built JSON string, so drop the two
# characters that would break it rather than escaping them.
note() {
  msg=$(printf '%s' "$1" | tr -d '"\\' | tr -s ' \t' ' ')
  if [ -z "$problems" ]; then
    problems="$msg"
  else
    problems="$problems; $msg"
  fi
}

# --- 1. CHANGELOG heading matches pubspec version (the CI gate) ---------------
for pkg in kiwi kiwi_generator; do
  pubspec="$root/packages/$pkg/pubspec.yaml"
  changelog="$root/packages/$pkg/CHANGELOG.md"
  [ -f "$pubspec" ] && [ -f "$changelog" ] || continue

  version=$(read_version "$pubspec")
  [ -n "$version" ] || continue

  heading=$(head -n 1 "$changelog")
  case "$heading" in
    "# $version"*) ;;
    *)
      note "packages/$pkg/CHANGELOG.md starts with [$heading] but pubspec version is $version - the changelog workflow exits 1 until that file starts with a [# $version] heading"
      ;;
  esac
done

# --- 2. Example constraints accept the packages' current major ---------------
for pkg in kiwi kiwi_generator; do
  pubspec="$root/packages/$pkg/pubspec.yaml"
  [ -f "$pubspec" ] || continue

  version=$(read_version "$pubspec")
  [ -n "$version" ] || continue
  pkg_major=$(major "$version")
  [ -n "$pkg_major" ] || continue

  for example in dart_kiwi flutter_kiwi; do
    example_pubspec="$root/examples/$example/pubspec.yaml"
    [ -f "$example_pubspec" ] || continue

    constraint=$(read_version "$example_pubspec" "$pkg")
    [ -n "$constraint" ] || continue
    constraint_major=$(major "$constraint")
    [ -n "$constraint_major" ] || continue

    if [ "$pkg_major" != "$constraint_major" ]; then
      note "examples/$example/pubspec.yaml requires $pkg: $constraint but packages/$pkg is $version - dependency_overrides hides this in CI, real users hit it"
    fi
  done
done

# --- 3. The generator's own kiwi: constraint accepts the kiwi major ----------
# The generator depends on kiwi from pub, not via a path override. If kiwi's
# major moves and this constraint does not, the published generator cannot
# resolve for anyone — and CI still passes, because the examples override both
# packages to local paths. This is the failure that went unnoticed for months.
kiwi_pubspec="$root/packages/kiwi/pubspec.yaml"
generator_pubspec="$root/packages/kiwi_generator/pubspec.yaml"
if [ -f "$kiwi_pubspec" ] && [ -f "$generator_pubspec" ]; then
  kiwi_version=$(read_version "$kiwi_pubspec")
  generator_constraint=$(read_version "$generator_pubspec" kiwi)
  if [ -n "$kiwi_version" ] && [ -n "$generator_constraint" ]; then
    kiwi_major=$(major "$kiwi_version")
    constraint_major=$(major "$generator_constraint")
    if [ -n "$kiwi_major" ] && [ -n "$constraint_major" ] \
      && [ "$kiwi_major" != "$constraint_major" ]; then
      note "packages/kiwi_generator/pubspec.yaml requires kiwi: $generator_constraint but packages/kiwi is $kiwi_version - the generator resolves kiwi from pub, so a published generator would fail to resolve while CI stays green"
    fi
  fi
fi

[ -n "$problems" ] || exit 0

# additionalContext feeds the warning back to Claude without ending the turn.
printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"Release consistency: %s"}}\n' "$problems"
exit 0
