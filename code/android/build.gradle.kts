allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")

    project.plugins.whenPluginAdded {
        if (this is com.android.build.gradle.LibraryPlugin) {
            project.extensions.findByType<com.android.build.gradle.LibraryExtension>()?.apply {
                if (project.name == "flutter_naver_login" && namespace == null) {
                    namespace = "com.yoonjaepark.flutter_naver_login"
                }
            }
        }
        // Fix JVM target compatibility for Kotlin plugins (match Java target)
        if (this is org.jetbrains.kotlin.gradle.plugin.KotlinAndroidPluginWrapper) {
            project.tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
                compilerOptions {
                    jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11)
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
