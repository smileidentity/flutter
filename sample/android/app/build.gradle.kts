plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.smileidentity.flutter.sample"
    compileSdk = 35

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        applicationId = "com.smileidentity.flutter.sample"
        minSdk = 21
        targetSdk = 35
        versionCode = 1
        versionName = "1.0.0"
    }

    buildTypes {
        getByName("release") {
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    kotlinOptions {
        jvmTarget = "17"
        freeCompilerArgs += listOf("-Xskip-metadata-version-check")
    }
}
val checkSmileConfigFileTask = tasks.register("checkSmileConfigFile") {
    doLast {
        val configFile = file("src/main/assets/smile_config.json")
        if (configFile.readText().isBlank()) {
            throw IllegalArgumentException("Empty smile_config.json file in src/main/assets!")
        }
    }
}

tasks.named("assemble") {
    dependsOn(checkSmileConfigFileTask)
}
