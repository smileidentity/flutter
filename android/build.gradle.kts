val kotlinVersion = findProperty("kotlinVersion") as String? ?: "2.1.21"
val kotlinCompilerExtension = findProperty("kotlinCompilerExtensionVersion") as String? ?: "1.5.14"

extra.apply {
    set("kotlinVersion", kotlinVersion)
    set("kotlinCompilerExtension", kotlinCompilerExtension)
}

buildscript {
    val kotlinVersion = rootProject.findProperty("kotlinVersion") as String? ?: "2.1.21"

    dependencies {
        if (kotlinVersion.startsWith("2")) {
            classpath("org.jetbrains.kotlin:compose-compiler-gradle-plugin:$kotlinVersion")
        } else {
            classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
        }
    }
}

allprojects {
    repositories {
        maven {
            url = uri("https://central.sonatype.com/repository/maven-snapshots/")
        }
    }
}

plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
    alias(libs.plugins.ktlint)
}

if (kotlinVersion.startsWith("2")) {
    apply(plugin = "org.jetbrains.kotlin.plugin.compose")
}

android {
    namespace = "com.smileidentity.flutter"
    compileSdk = 35

    defaultConfig {
        minSdk = 21

        // Read version from pubspec.yaml for setWrapperInfo
        val pubspecYaml = File("../pubspec.yaml")
        val pubspecText = pubspecYaml.readText()
        val versionLine = Regex("""version:\s*(.+)""").find(pubspecText)
        val version = if (versionLine != null) {
            pubspecText.split(Regex("""version:\s*"""))[1].split("\n")[0].trim()
        } else {
            "11.0.0"
        }
        buildConfigField("String", "SMILE_ID_VERSION", "\"$version\"")
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
        freeCompilerArgs += listOf(
            "-Xskip-metadata-version-check",
        ) // metadata version check skip flag
    }

    sourceSets {
        sourceSets["main"].java.srcDirs("src/main/kotlin")
        sourceSets["test"].java.srcDirs("src/test/kotlin")
    }

    lint {
        disable.add("NullSafeMutableLiveData")
    }

    buildFeatures {
        buildConfig = true
        compose = true
    }
    if (!kotlinVersion.startsWith("2")) {
        composeOptions {
            kotlinCompilerExtensionVersion = kotlinCompilerExtension
        }
    }
}

dependencies {
    implementation(libs.smileid)
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.activity.compose)
    implementation(libs.androidx.compose.ui)
    implementation(libs.androidx.compose.viewmodel)
    implementation(libs.androidx.compose.material3)
    implementation(libs.androidx.fragment)
    implementation(libs.kotlin.coroutines)
    implementation(libs.kotlin.immutable.collections)
    implementation(libs.mlkit)

    testImplementation(libs.kotlin.test)
    testImplementation(libs.mockk)
}

ktlint {
    android.set(true)
    filter {
        exclude { it.file.path.contains(".g.kt") }
    }
}
