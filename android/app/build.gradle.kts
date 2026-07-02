import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

// ── Load android/key.properties (never committed to source control) ───────────
// Create this file before running a release build. See docs/ANDROID_SIGNING.md.
val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties().apply {
    if (keyPropertiesFile.exists()) {
        load(keyPropertiesFile.inputStream())
    }
}

android {
    namespace = "com.productivemuslim.app"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    signingConfigs {
        create("release") {
            val storeFilePath = keyProperties.getProperty("storeFile")
            if (storeFilePath != null) {
                storeFile = file(storeFilePath)
            }
            storePassword = keyProperties.getProperty("storePassword")
                ?: System.getenv("KEYSTORE_PASSWORD") ?: ""
            keyAlias = keyProperties.getProperty("keyAlias")
                ?: System.getenv("KEY_ALIAS") ?: "productive_muslim"
            keyPassword = keyProperties.getProperty("keyPassword")
                ?: System.getenv("KEY_PASSWORD") ?: ""
        }
    }

    defaultConfig {
        applicationId = "com.productivemuslim.app"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        // ── Google Sign-In / Firebase ─────────────────────────────────────────
        // After adding google-services.json, register your SHA-1 fingerprint in
        // the Firebase Console (Project Settings → Your Android App → Add SHA-1).
        // To get the debug SHA-1:
        //   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey \
        //           -storepass android -keypass android
        // For release SHA-1, use your production keystore instead.
        // No code change needed here — Firebase reads SHA-1 from the console, not gradle.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        debug {
            // applicationIdSuffix removed: google-services.json only registers
            // com.productivemuslim.app; adding a suffix breaks processGoogleServices.
            // Register com.productivemuslim.app.debug in Firebase Console to restore it.
            versionNameSuffix = "-debug"
        }
        release {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation(platform("com.google.firebase:firebase-bom:33.5.1"))
    implementation("com.google.firebase:firebase-crashlytics")
    implementation("com.google.firebase:firebase-analytics")
}
