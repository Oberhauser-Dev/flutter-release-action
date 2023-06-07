#!/usr/bin/env bash
set -x

apt-get update

# Install Flutter requirements
apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev

# Install libunwind-dev, see https://github.com/actions/runner-images/issues/6399#issuecomment-1285011525
apt-get install -y libunwind-dev

# Activate flutter_to_debian
dart pub global activate https://github.com/gustl22/flutter_to_debian.git --source git --git-ref=dev

# Build 
flutter build linux \
  --dart-define=APP_ENVIRONMENT=development \
  --dart-define=API_URL="https://server.wrestling-scoreboard.oberhauser.dev/api" \
  --dart-define=WEB_SOCKET_URL="wss://server.wrestling-scoreboard.oberhauser.dev/ws"

# Bundle Debian package
flutter_to_debian
