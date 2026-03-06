#!/usr/bin/env bash
set -e

# Netlify build script for Flutter web
# Uses cached Flutter SDK when available (Netlify caches $HOME/flutter)

FLUTTER_DIR="$HOME/flutter"
FLUTTER_BIN="$FLUTTER_DIR/bin/flutter"

if [ ! -f "$FLUTTER_BIN" ]; then
  echo "Installing Flutter SDK..."
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
  export PATH="$FLUTTER_DIR/bin:$PATH"
  flutter precache --web
else
  echo "Using cached Flutter SDK..."
  export PATH="$FLUTTER_DIR/bin:$PATH"
  flutter upgrade
fi

flutter pub get
flutter build web --release

echo "Build complete. Output in build/web"
