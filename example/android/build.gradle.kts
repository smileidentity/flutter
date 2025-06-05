// set your desired versions here
//project.ext {
//    kotlinVersion = "1.9.24"
//    kotlinCompilerExtensionVersion = "1.5.14"
//}

plugins {
    alias(libs.plugins.flutter.plugin.loader)
    alias(libs.plugins.android.application) apply false
    alias(libs.plugins.kotlin.android) apply false
    alias(libs.plugins.ktlint) apply false
}

//allprojects {
//    repositories {
//        google()
//        mavenCentral()
////      uncomment for development to test snapshots
////      maven {
////          url = uri("https://central.sonatype.com/repository/maven-snapshots/")
////      }
//    }
//}

rootProject.layout.buildDirectory.set(file("../build"))

subprojects {
    project.layout.buildDirectory.set(file("${rootProject.layout.buildDirectory.get()}/${project.name}"))
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// this
