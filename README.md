# flutter-release-action

A GitHub action of [flutter_release](https://github.com/Oberhauser-Dev/dart_packages/tree/main/packages/flutter_release) to build, release, publish and deploy Flutter apps for Web, Android, iOS, macOS, Linux, Windows.
The action itself runs on Linux, Windows, and macOS.
For a full example you can check out the workflow of [wrestling_scoreboard](https://github.com/Oberhauser-Dev/wrestling_scoreboard/blob/main/.github/workflows/release-client.yml).

## Usage

A complete guide how to set up publishing can be found in the [flutter_release](https://github.com/Oberhauser-Dev/dart_packages/tree/main/packages/flutter_release#setup) repo.

### Upload to a GitHub release

```yaml
steps:
- uses: actions/checkout@v4
- uses: subosito/flutter-action@v2
- uses: oberhauser-dev/flutter-release-action@v0
  with:
    token: ${{ github.token }}
    dry-run: true
    app-name: 'my_flutter_app' # Optional, takes the name from pubspec.yaml by default
    app-version: ${{ github.ref_name }} # or set manually: 'v1.2.3-alpha.4', optional, takes the version from pubspec.yaml by default
    tag: ${{ github.ref }}
    build-type: 'debian'
    build-args: |-
      --dart-define=API_URL="https://example.com"
      --dart-define=API_KEY=12345678
    upload-release-asset: '' # Optional, uploads all build types except 'msix-store' to the GitHub release by default
    # Windows: Optional, otherwise 'msix' is signed with a test certificate
    windows-certificate-file-base64: ${{ secrets.WINDOWS_CERTIFICATE }}
    windows-certificate-password: ${{ secrets.WINDOWS_CERTIFICATE_PASSWORD }}
```

The MSIX installer is configured via `msix_config` in your `pubspec.yaml`,
see [flutter_release](https://github.com/Oberhauser-Dev/dart_packages/tree/main/packages/flutter_release#windows---msix-installer).

### Publish

Store your `Repository secrets` here: `https://github.com/<username>/<repository>/settings/secrets/actions`.

```yaml
steps:
- uses: actions/checkout@v4
- uses: subosito/flutter-action@v2
- uses: oberhauser-dev/flutter-release-action@v0
  with:
    dry-run: true
    verbose: false # Optional
    app-name: 'my_flutter_app' # Optional
    app-version: ${{ github.ref_name }} # Optional
    main-path: 'lib/main.dart' # Optional
    flavor: 'prod' # Optional
    tag: ${{ github.ref }} # Optional
    token: ${{ github.token }}
    build-args: |-
      --dart-define=API_URL="https://example.com"
    publish-stage: 'internal'
    publish-distributor: 'android-google-play'
    # Android
    publish-android-fastlane-secrets-json-base64: ${{ secrets.ANDROID_GOOGLE_PLAY_JSON }}
    publish-android-release-status: 'completed' # Optional, default: 'draft'. You need to have released an alpha version for `completed` status to work: https://github.com/fastlane/fastlane/discussions/18293
    android-keystore-file-base64: ${{ secrets.ANDROID_KEYSTORE }}
    android-keystore-password: ${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
    android-key-alias: ${{ secrets.ANDROID_KEY_ALIAS }}
    android-key-password: ${{ secrets.ANDROID_KEY_PASSWORD }}
    # iOS
    ios-apple-username: ${{ secrets.IOS_APPLE_USERNAME }}
    ios-api-key-id: ${{ secrets.IOS_API_KEY_ID }}
    ios-api-issuer-id: ${{ secrets.IOS_API_ISSUER_ID }}
    ios-api-private-key-base64: ${{ secrets.IOS_API_PRIVATE_KEY }}
    ios-content-provider-id: ${{ secrets.IOS_CONTENT_PROVIDER_ID }}
    ios-team-id: ${{ secrets.IOS_TEAM_ID }}
    ios-distribution-private-key-base64: ${{ secrets.IOS_DISTRIBUTION_PRIVATE_KEY }}
    ios-distribution-cert-base64: ${{ secrets.IOS_DISTRIBUTION_CERT }}
    ios-team-enterprise: ${{ secrets.IOS_TEAM_ENTERPRISE }} # Optional
    ios-update-provisioning: false # Optional
    ios-xcode-scheme: 'Runner' # Optional, only use if value differs from flavor input
    # Web
    publish-web-host: ${{ secrets.WEB_HOST }}
    publish-web-path: ${{ secrets.WEB_PATH }}
    publish-web-ssh-port: ${{ secrets.WEB_SSH_PORT }}
    publish-web-ssh-user: ${{ secrets.WEB_SSH_USER }}
    publish-web-ssh-private-key-base64: ${{ secrets.WEB_SSH_PRIVATE_KEY }}
    # Windows (Microsoft Store)
    publish-windows-tenant-id: ${{ secrets.WINDOWS_STORE_TENANT_ID }}
    publish-windows-client-id: ${{ secrets.WINDOWS_STORE_CLIENT_ID }}
    publish-windows-client-secret: ${{ secrets.WINDOWS_STORE_CLIENT_SECRET }}
    publish-windows-seller-id: ${{ secrets.WINDOWS_STORE_SELLER_ID }}
    publish-windows-product-id: ${{ secrets.WINDOWS_STORE_PRODUCT_ID }}
    publish-windows-packages: '' # Optional, newline separated paths, uses the packages of the `msix-store` builds by default
    publish-windows-flight-id: '' # Optional, publishes to the public by default
    publish-windows-rollout-percentage: '' # Optional, for a gradual rollout
    publish-windows-release-status: 'draft' # Optional, default: 'draft'. Use 'completed' to submit for certification
```

#### Microsoft Store

Unlike the other distributors, `windows-ms-store` does not build the app (see [flutter_release](https://github.com/Oberhauser-Dev/dart_packages/tree/main/packages/flutter_release#windows---microsoft-store-via-windows-only)).
Before publishing, build the installer for each architecture in previous jobs of the same workflow run with `build-type: 'msix-store'`.
These builds upload their unsigned installer as workflow artifact (not to the GitHub release):

```yaml
steps:
- uses: actions/checkout@v4
- uses: subosito/flutter-action@v2
- uses: oberhauser-dev/flutter-release-action@v0
  with:
    dry-run: false
    app-version: ${{ github.ref_name }}
    build-type: 'msix-store'
    upload-workflow-artifact: true # Optional, enabled by default for 'msix-store'
    # Required, see Partner Center > Product identity
    windows-msix-publisher: ${{ secrets.WINDOWS_STORE_PUBLISHER }}
    windows-msix-identity-name: ${{ secrets.WINDOWS_STORE_IDENTITY_NAME }}
    windows-msix-publisher-display-name: ${{ secrets.WINDOWS_STORE_PUBLISHER_DISPLAY_NAME }}
```

The publishing job (running on Windows) downloads these installers, bundles and uploads them to the Microsoft Store.
Therefore, let the publishing job depend on the build jobs (`needs`) and use the same `app-name` and `flavor`.
