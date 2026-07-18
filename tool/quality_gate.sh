#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
BUILD_WEB=false

case "${1-}" in
  "")
    ;;
  --build-web)
    BUILD_WEB=true
    ;;
  *)
    echo "Usage: $0 [--build-web]" >&2
    exit 64
    ;;
esac

cd "$ROOT"

section() {
  printf '\n== %s ==\n' "$1"
}

section "Pinned SDK"
FLUTTER_VERSION=$(flutter --no-version-check --version)
printf '%s\n' "$FLUTTER_VERSION"
printf '%s\n' "$FLUTTER_VERSION" | grep -q 'Flutter 3.38.3'
printf '%s\n' "$FLUTTER_VERSION" | grep -q 'Dart 3.10.1'

section "Agent rules"
dart run tool/validate_agent_rules.dart

section "Formatting"
dart format --output=none --set-exit-if-changed .

section "Analyzer"
flutter --no-version-check analyze

section "Tests"
flutter --no-version-check test

if [ "$BUILD_WEB" = true ]; then
  section "Web build"
  flutter --no-version-check build web
fi

section "Quality gate passed"
