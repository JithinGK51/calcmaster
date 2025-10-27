# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep Hive classes
-keep class hive_flutter.** { *; }
-keep class **$HiveFieldAdapter { *; }

# Keep encryption classes
-keep class encrypt.** { *; }

# Keep TTS classes
-keep class flutter_tts.** { *; }

# Keep chart classes
-keep class fl_chart.** { *; }
-keep class syncfusion_flutter_charts.** { *; }

# Keep PDF classes
-keep class pdf.** { *; }
-keep class printing.** { *; }

# Keep sharing classes
-keep class share_plus.** { *; }

# Keep notification classes
-keep class flutter_local_notifications.** { *; }

# Keep biometric classes
-keep class local_auth.** { *; }

# Keep file picker classes
-keep class file_picker.** { *; }
-keep class image_picker.** { *; }

# Keep permission handler classes
-keep class permission_handler.** { *; }

# Keep path provider classes
-keep class path_provider.** { *; }

# Keep secure storage classes
-keep class flutter_secure_storage.** { *; }

# Keep speech to text classes
-keep class speech_to_text.** { *; }

# Keep screen lock classes
-keep class flutter_screen_lock.** { *; }

# Keep math expressions classes
-keep class math_expressions.** { *; }

# Keep Riverpod classes
-keep class flutter_riverpod.** { *; }

# Keep shared preferences classes
-keep class shared_preferences.** { *; }

# Keep crypto classes
-keep class crypto.** { *; }

# Keep intl classes
-keep class intl.** { *; }

# Keep lottie classes
-keep class lottie.** { *; }

# Keep glassmorphism classes
-keep class glassmorphism.** { *; }

# Keep neumorphic classes
-keep class flutter_neumorphic.** { *; }

# Keep animate classes
-keep class flutter_animate.** { *; }

# Keep theme switcher classes
-keep class animated_theme_switcher.** { *; }

# Keep font awesome classes
-keep class font_awesome_flutter.** { *; }

# Google Play Core rules (for release builds)
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
-keep class com.google.android.play.core.** { *; }
