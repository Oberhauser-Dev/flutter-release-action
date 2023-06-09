# flutter-release-action

Build, release, publish and deploy Flutter apps for Web, Android, iOS, macOS, Linux, Windows.
The action itself runs on Linux, Windows, and macOS.

## Usage

```yaml
steps:
- uses: actions/checkout@v3
- uses: subosito/flutter-action@v2
- uses: oberhauser-dev/flutter-release-action@v1
  with:
    app-name: 'my_flutter_app'
    app-version: 'v1.2.3-alpha.4'
    tag: 'my_flutter_app-v1.2.3-alpha.4'
    release-type: 'debian'
    build-args: |-
      --dart-define=API_URL="https://example.com"
      --dart-define=APP_ENV=dev
```
