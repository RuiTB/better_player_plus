import 'package:better_player_example/pages/picture_in_picture_page.dart';
import 'package:better_player_example/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const MyApp());

@pragma('vm:entry-point')
void pipMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BetterPlayerPipApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => Shortcuts(
    shortcuts: <LogicalKeySet, Intent>{LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()},
    child: MaterialApp(
      title: 'Better player demo',
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
      supportedLocales: const [Locale('en', 'US'), Locale('pl', 'PL')],
      theme: ThemeData(primarySwatch: Colors.green),
      home: const WelcomePage(),
    ),
  );
}

class BetterPlayerPipApp extends StatelessWidget {
  const BetterPlayerPipApp({super.key});

  @override
  Widget build(BuildContext context) =>
      MaterialApp(title: 'Better Player PiP', theme: ThemeData.dark(), home: PictureInPicturePage());
}
