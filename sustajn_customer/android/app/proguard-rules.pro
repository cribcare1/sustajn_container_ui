#############################################
# Flutter Core
#############################################
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

#############################################
# Flutter Deferred Components (IMPORTANT)
#############################################
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

#############################################
# Play Core (FIX for your R8 error)
#############################################
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

#############################################
# App Package (CHANGE THIS TO YOUR PACKAGE)
#############################################
# ⚠️ Replace with your real package from AndroidManifest.xml
-keep class com.sustajn_restaurant.** { *; }

#############################################
# Firebase
#############################################
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

#############################################
# Gson (JSON parsing)
#############################################
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

#############################################
# Retrofit
#############################################
-keep class retrofit2.** { *; }
-dontwarn retrofit2.**

#############################################
# OkHttp (used by Dio internally sometimes)
#############################################
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**

#############################################
# Kotlin
#############################################
-keep class kotlin.** { *; }
-dontwarn kotlin.**

#############################################
# Prevent warnings from javax (optional safe)
#############################################
-dontwarn javax.annotation.**

#############################################
# Keep annotations (important for many libs)
#############################################
-keepattributes *Annotation*

#############################################
# Keep enum values (safe)
#############################################
-keepclassmembers enum * {
    public static **[] values();
#    public static ** valueOf(java.lang.String);
}