plugins {
    id("com.android.library")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_demo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        // Note: targetSdk is deprecated for library modules, but kept for compatibility
        // versionCode and versionName are not supported in library modules
    }

    buildTypes {
        release {
            isMinifyEnabled = false
        }
        debug {
            isMinifyEnabled = false
        }
    }
}

flutter {
    source = "../.."
}
