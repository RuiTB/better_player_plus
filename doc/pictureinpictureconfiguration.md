## Picture in Picture configuration
Picture in Picture is not supported on all devices.

Requirements:
* iOS: iOS version greater than 14.0
* Android: Android version greater than 8.0, enough RAM, v2 Flutter android embedding

Each OS provides method to check if given device supports PiP. If device doesn't support PiP, then
error will be printed in console.

Check if PiP is supported in given device:
```dart
_betterPlayerController.isPictureInPictureSupported();
```

To show PiP mode call this method:

```dart
_betterPlayerController.enablePictureInPicture(_betterPlayerKey);
```
`_betterPlayerKey` is a key which is used in BetterPlayer widget:

```dart
GlobalKey _betterPlayerKey = GlobalKey();
...
    AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer(
            controller: _betterPlayerController,
            key: _betterPlayerKey,
        ),
    ),
```

To hide PiP mode call this method:
```dart
betterPlayerController.disablePictureInPicture();
```

### Android PiP screen running in a separate Activity

Better Player also exposes an Android-only helper that launches a dedicated FlutterActivity backed by a
cached FlutterEngine. This keeps your primary app task alive while the user interacts with the PiP UI.

1. **Create a PiP entry-point** inside your Flutter app (see `example/lib/main.dart` for a full sample):
   ```dart
   @pragma('vm:entry-point')
   void pipMain() {
     WidgetsFlutterBinding.ensureInitialized();
     runApp(const BetterPlayerPipApp());
   }
   ```
2. **Preload and cache a FlutterEngine** from your Android `MainActivity` and point it to the `pipMain`
   entry-point:
   ```kotlin
   val pipEngine = FlutterEngine(this)
   val flutterLoader = FlutterInjector.instance().flutterLoader()
   pipEngine.dartExecutor.executeDartEntrypoint(
       DartExecutor.DartEntrypoint(flutterLoader.findAppBundlePath(), "pipMain")
   )
   FlutterEngineCache.getInstance().put("better_player_pip_engine", pipEngine)
   ```
3. **Launch the PiP screen** from Dart whenever you need to show it:
   ```dart
   await betterPlayerController.showPictureInPictureScreen();
   ```

PiP menu item is enabled as default in both Material and Cuperino controls. You can disable it with
`BetterPlayerControlsConfiguration`'s variable: `enablePip`. You can change PiP control menu icon with
`pipMenuIcon` variable in `BetterPlayerControlsConfiguration`.

### iOS linear playback controls
By default iOS 14+ PiP uses the standard system transport controls (`pipRequiresLinearPlayback = false`). Set
`BetterPlayerConfiguration(pipRequiresLinearPlayback: true)` to restrict the PiP UI to linear playback only
when your content requires stricter control.

Warning:
Both Android and iOS PiP versions are in very early stage. There can be bugs and small issues. Please
make sure that you've checked state of the PiP in Better Player before moving it to the production.

Known limitations:
Android: When PiP is enabled, Better Player will open full screen mode to play video correctly. When
user disables PiP, Better Player will back to the previous settings and for a half of second your device
will have incorrect orientation.