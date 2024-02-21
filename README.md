# flutter-release-action

A GitHub action of [flutter_release](https://github.com/Oberhauser-Dev/flutter_release) to build, release, publish and deploy Flutter apps for Web, Android, iOS, macOS, Linux, Windows.
The action itself runs on Linux, Windows, and macOS.
As example you can check out the workflow of [wrestling_scoreboard](https://github.com/Oberhauser-Dev/wrestling_scoreboard/blob/main/.github/workflows/release.yml).

## Usage

```yaml
steps:
- uses: actions/checkout@v3
- uses: subosito/flutter-action@v2
- uses: oberhauser-dev/flutter-release-action@v0
  with:
    app-name: 'my_flutter_app'
    app-version: ${{ github.ref_name }} # or set manually: 'v1.2.3-alpha.4'
    tag: ${{ github.ref }}
    release-type: 'debian'
    build-args: |-
      --dart-define=API_URL="https://example.com"
      --dart-define=APP_ENV=dev
    token: ${{ github.token }}
```
