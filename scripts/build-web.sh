#!/usr/bin/env bash
set -x

# Build 
flutter build web \
  --dart-define=APP_ENVIRONMENT=development \
  --dart-define=API_URL="https://server.wrestling-scoreboard.oberhauser.dev/api" \
  --dart-define=WEB_SOCKET_URL="wss://server.wrestling-scoreboard.oberhauser.dev/ws"

tar -czvf build/wrestling-scoreboard-client-web.tar.gz -C build web
