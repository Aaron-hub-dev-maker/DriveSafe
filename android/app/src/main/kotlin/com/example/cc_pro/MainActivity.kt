package com.example.cc_pro
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.Manifest
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            requestPermissions(arrayOf(
                Manifest.permission.MANAGE_EXTERNAL_STORAGE
            ), 1001)
        }
    }
}
