package com.simple.app

import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val btnOpenFlutter = findViewById<Button>(R.id.btnOpenFlutter)
        btnOpenFlutter.setOnClickListener {
            // 启动 Flutter 页面
            startActivity(
                FlutterActivity
                    .withNewEngine()
                    .initialRoute("/")
                    .build(this)
            )
        }
    }
}

