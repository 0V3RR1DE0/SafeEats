# ProGuard rules for SafeEats FOSS app
# Currently not used since minifyEnabled = false
# Keep this file for future reference if code shrinking is ever needed

# Basic Flutter rules (not currently applied)
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Mobile Scanner with bundled ML Kit (for future reference)
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# Exclude Google Play Services (we don't use them)
-dontwarn com.google.android.gms.**
-dontwarn com.google.android.play.core.**