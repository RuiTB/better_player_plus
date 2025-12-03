package uz.shs.better_player_example

import android.content.Intent
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        cacheBetterPlayerPipEngine()
        startNotificationService()
    }

    override fun onDestroy() {
        super.onDestroy()
        stopNotificationService()
    }

    private fun cacheBetterPlayerPipEngine() {
        if (FlutterEngineCache.getInstance().get(PIP_ENGINE_CACHE_KEY) != null) {
            return
        }
        FlutterEngineCache.getInstance().put(PIP_ENGINE_CACHE_KEY, FlutterEngine(this))
    }

    ///TODO: Call this method via channel after remote notification start
    private fun startNotificationService() {
        try {
            val intent = Intent(this, BetterPlayerService::class.java)
            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.O) {
                startForegroundService(intent)
            } else {
                startService(intent)
            }
        } catch (_: Exception) {
        }
    }

    ///TODO: Call this method via channel after remote notification stop
    private fun stopNotificationService() {
        try {
            val intent = Intent(this, BetterPlayerService::class.java)
            stopService(intent)
        } catch (_: Exception) {

        }
    }

    companion object {
        private const val PIP_ENGINE_CACHE_KEY = "better_player_pip_engine"
    }
}
