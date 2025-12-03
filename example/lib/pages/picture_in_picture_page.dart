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
      'https://dy35qflylzlrr.cloudfront.net/course-videos/3cb2be8f-f384-4581-8093-4da5756de602/AppleHLS1/a4400920-0bde-491b-80ca-7d56c2389e34.m3u8',
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
    _betterPlayerController.setMixWithOthers(true);
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
          onPressed: () async {
            if (!(await _betterPlayerController.isPictureInPictureSupported())) {
              return;
            }
            _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
            if (Platform.isIOS) {
              Navigator.of(context).pop();
            }
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
