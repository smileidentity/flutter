val kotlinVersion = findProperty("kotlinVersion") as String? ?: "2.1.0"
//val smileVersion = findProperty("smileVersion") as String? ?: "11.0.1-SNAPSHOT" // Uncomment this line to use the latest snapshot version also uncomment the snapshot repository
val smileVersion = findProperty("smileVersion") as String? ?: "11.0.1"
val kotlinCompilerExtension = findProperty("kotlinCompilerExtensionVersion") as String? ?: "1.5.14"

extra.apply {
    set("kotlinVersion", kotlinVersion)
    set("smileVersion", smileVersion)
    set("kotlinCompilerExtension", kotlinCompilerExtension)
}

buildscript {
    val kotlinVersionBuildScript = rootProject.findProperty("kotlinVersion") as String? ?: "2.1.0"

    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://plugins.gradle.org/m2/") }
//      uncomment for development to test snapshots
//      maven {
//          url = uri("https://central.sonatype.com/repository/maven-snapshots/")
//      }
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.7.3")
        if (kotlinVersionBuildScript.startsWith("2")) {
            classpath("org.jetbrains.kotlin:compose-compiler-gradle-plugin:$kotlinVersionBuildScript")
        } else {
            classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersionBuildScript")
        }
        classpath("org.jlleitschuh.gradle:ktlint-gradle:12.2.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
//      uncomment for development to test snapshots
//      maven {
//          url = uri("https://central.sonatype.com/repository/maven-snapshots/")
//      }
    }
}

plugins {
    id("com.android.library")
    id("kotlin-android")
    id("org.jlleitschuh.gradle.ktlint")
}

// Apply compose plugin conditionally for Kotlin 2.x
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
        val versionRegex = Regex("""version:\s*(.+)""")
        val versionMatch = versionRegex.find(pubspecText)
        val version = if (versionMatch != null) {
            pubspecText.split(Regex("""version:\s*"""))[1].split("\n")[0].trim()
        } else {
            "11.0.0"
        }
        buildConfigField("String", "SMILE_ID_VERSION", "\"$version\"")
    }

    buildFeatures {
        buildConfig = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
        freeCompilerArgs += listOf("-Xskip-metadata-version-check") // metadata version check skip flag
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
        getByName("test").java.srcDirs("src/test/kotlin")
    }

    lint {
        disable.add("NullSafeMutableLiveData")
    }

    tasks.withType<Test> {
        useJUnitPlatform()

        testLogging {
            events("passed", "skipped", "failed", "standardOut", "standardError")
            outputs.upToDateWhen { false }
            showStandardStreams = true
        }
    }


    buildFeatures.compose = true
    if (!kotlinVersion.startsWith("2")) {
        composeOptions {
            kotlinCompilerExtensionVersion = kotlinCompilerExtension
        }
    }
}

dependencies {
    implementation("com.smileidentity:android-sdk:$smileVersion")
    implementation("androidx.core:core-ktx")
    implementation("androidx.compose.ui:ui")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.fragment:fragment-ktx")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core")
    implementation("org.jetbrains.kotlinx:kotlinx-collections-immutable:0.3.8")
    implementation("com.google.mlkit:object-detection:17.0.2")

    testImplementation("org.jetbrains.kotlin:kotlin-test")
    testImplementation("io.mockk:mockk:1.13.13")
}

ktlint {
    android.set(true)
    filter {
        exclude { it.file.path.contains(".g.kt") }
    }
}
