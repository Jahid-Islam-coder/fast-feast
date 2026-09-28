// Clear ANDROID_PREFS_ROOT if ANDROID_USER_HOME is also present to prevent AGP AndroidLocationsException
try {
    val processEnvClass = Class.forName("java.lang.ProcessEnvironment")

    val envField = processEnvClass.getDeclaredField("theEnvironment")
    envField.isAccessible = true
    val envMap = envField.get(null) as? MutableMap<*, *>
    envMap?.keys?.removeIf { it.toString() == "ANDROID_PREFS_ROOT" }

    val ciEnvField = processEnvClass.getDeclaredField("theCaseInsensitiveEnvironment")
    ciEnvField.isAccessible = true
    val ciMap = ciEnvField.get(null) as? MutableMap<*, *>
    ciMap?.keys?.removeIf { it.toString() == "ANDROID_PREFS_ROOT" }
} catch (e: Throwable) {
    // Ignore reflection errors if JDK environment differs
}

pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.0.1" apply false
    // START: FlutterFire Configuration
    id("com.google.gms.google-services") version("4.4.2") apply false
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
