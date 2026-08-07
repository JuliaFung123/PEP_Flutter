#!/usr/bin/env bash
# Vercel build: install Flutter SDK, then build web release.
set -euo pipefail

FLUTTER_DIR="${HOME}/flutter"
if [[ ! -x "${FLUTTER_DIR}/bin/flutter" ]]; then
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable "${FLUTTER_DIR}"
fi

export PATH="${FLUTTER_DIR}/bin:${PATH}"
flutter config --no-analytics --enable-web
flutter precache --web
flutter pub get
flutter build web --release --no-tree-shake-icons
