import 'dart:io';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PictureInPicturePage extends StatefulWidget {
  const PictureInPicturePage({super.key});

  @override
  State<PictureInPicturePage> createState() => _PictureInPicturePageState();
}

class _PictureInPicturePageState extends State<PictureInPicturePage> {
  late BetterPlayerController _betterPlayerController;
  final GlobalKey _betterPlayerKey = GlobalKey();

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration = BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      pipRequiresLinearPlayback: true,
      eventListener: (BetterPlayerEvent event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
          print('progress: ${event.parameters?['progress']}');
        }
      },
      fullScreenByDefault: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      deviceOrientationsOnFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      autoPlay: true,
    );
    final BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      'https://dy35qflylzlrr.cloudfront.net/course-videos/1ca87b1a-def5-41ec-ae3c-2eaf18ac69be/AppleHLS1/b20fdefa-6622-41ca-9a3f-d0680f47b518.m3u8',
      cacheConfiguration: BetterPlayerCacheConfiguration(useCache: false),
      bufferingConfiguration: BetterPlayerBufferingConfiguration(
        minBufferMs: 5000,
        maxBufferMs: 5000,
        bufferForPlaybackMs: 2000,
        bufferForPlaybackAfterRebufferMs: 3000,
      ),
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Picture in Picture player')),
    body: Column(
      children: [
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Example which shows how to use PiP.', style: TextStyle(fontSize: 16)),
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer(controller: _betterPlayerController, key: _betterPlayerKey),
        ),
        ElevatedButton(
          child: const Text('Show PiP'),
          onPressed: () {
            _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
          },
        ),
        ElevatedButton(
          child: const Text('Disable PiP'),
          onPressed: () async {
            _betterPlayerController.disablePictureInPicture();
          },
        ),
        if (Platform.isAndroid)
          ElevatedButton(
            child: const Text('Open dedicated PiP screen (Android)'),
            onPressed: () {
              _betterPlayerController.showPictureInPictureScreen();
            },
          ),
      ],
    ),
  );
}
