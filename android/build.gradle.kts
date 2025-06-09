plugins {
    // Applied to all sub-modules
    alias(libs.plugins.ktlint)

    // Applied depending on sub-module
    alias(libs.plugins.android.library) apply false
    alias(libs.plugins.compose.compiler) apply false
    alias(libs.plugins.kotlin.android) apply false
}

tasks.create("clean", Delete::class.java) {
    delete(rootProject.layout.buildDirectory)
}

ktlint {
    android.set(true)
    filter {
        exclude { it.file.path.contains(".g.kt") }
    }
}