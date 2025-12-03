package uz.shs.better_player_plus

import android.content.Context
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

/**
 * Activity responsible for rendering Better Player in Picture-in-Picture mode.
 *
 * This activity uses a cached FlutterEngine so it can be started in a separate task without
 * tearing down the main application state. Host apps must preload the engine and store it in
 * the [FlutterEngineCache] with the [PIP_ENGINE_CACHE_KEY] key.
 */
class BetterPlayerPIPScreen : FlutterActivity() {
    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        val flutterEngine = FlutterEngineCache.getInstance().get(PIP_ENGINE_CACHE_KEY) ?: return null
        ensureDartEntrypointStarted(flutterEngine)
        return flutterEngine
    }

    private fun ensureDartEntrypointStarted(flutterEngine: FlutterEngine) {
        if (flutterEngine.dartExecutor.isExecutingDart) {
            return
        }
        val flutterLoader = FlutterInjector.instance().flutterLoader()
        val dartEntrypoint = DartExecutor.DartEntrypoint(
            flutterLoader.findAppBundlePath(),
            PIP_ENGINE_ENTRY_POINT
        )
        flutterEngine.dartExecutor.executeDartEntrypoint(dartEntrypoint)
    }

    companion object {
        const val PIP_ENGINE_CACHE_KEY = "better_player_pip_engine"
        private const val PIP_ENGINE_ENTRY_POINT = "pipMain"
    }
}

