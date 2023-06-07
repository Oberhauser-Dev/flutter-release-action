powershell flutter build windows^
 --dart-define=APP_ENVIRONMENT=development^
 --dart-define=API_URL="https://server.wrestling-scoreboard.oberhauser.dev/api"^
 --dart-define=WEB_SOCKET_URL="wss://server.wrestling-scoreboard.oberhauser.dev/ws"

powershell Compress-Archive -Force -Path build\windows\runner\Release\* -DestinationPath build\windows\wrestling-scoreboard-client-windows.zip
