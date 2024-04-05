# flutter-release-action

A GitHub action of [flutter_release](https://github.com/Oberhauser-Dev/flutter_release) to build, release, publish and deploy Flutter apps for Web, Android, iOS, macOS, Linux, Windows.
The action itself runs on Linux, Windows, and macOS.
For a full example you can check out the workflow of [wrestling_scoreboard](https://github.com/Oberhauser-Dev/wrestling_scoreboard/blob/main/.github/workflows/release.yml).

## Usage

### Upload to a GitHub release

```yaml
steps:
- uses: actions/checkout@v4
- uses: subosito/flutter-action@v2
- uses: oberhauser-dev/flutter-release-action@v0
  with:
    token: ${{ github.token }}
    dry-run: true
    app-name: 'my_flutter_app'
    app-version: ${{ github.ref_name }} # or set manually: 'v1.2.3-alpha.4'
    tag: ${{ github.ref }}
    build-type: 'debian'
    build-args: |-
      --dart-define=API_URL="https://example.com"
      --dart-define=API_KEY=12345678
```

### Publish

```yaml
steps:
- uses: actions/checkout@v4
- uses: subosito/flutter-action@v2
- uses: oberhauser-dev/flutter-release-action@v0
  with:
    app-name: 'my_flutter_app'
    app-version: ${{ github.ref_name }} # or set manually: 'v1.2.3-alpha.4'
    tag: ${{ github.ref }}
    token: ${{ github.token }}
    build-args: |-
      --dart-define=API_URL="https://example.com"
      --dart-define=APP_ENV=prod
    dry-run: true
    publish-stage: internal
    publish-distributor: 'android-google-play'
    publish-android-fastlane-secrets-json-base64: ${{ secrets.ANDROID_GOOGLE_PLAY_JSON }}
    android-keystore-file-base64: ${{ secrets.ANDROID_KEYSTORE }}
    android-keystore-password: ${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
    android-key-alias: ${{ secrets.ANDROID_KEY_ALIAS }}
    android-key-password: ${{ secrets.ANDROID_KEY_PASSWORD }}
```
