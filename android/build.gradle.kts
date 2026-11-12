import java.io.File

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
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)

    // Check if NDK source.properties exists before evaluationDependsOn
    val ndkHome = System.getenv("ANDROID_NDK_HOME")
    val sdkRoot = System.getenv("ANDROID_SDK_ROOT") ?: System.getenv("ANDROID_HOME")
    val ndkDir = when {
        !ndkHome.isNullOrBlank() -> File(ndkHome)
        !sdkRoot.isNullOrBlank() -> File(sdkRoot, "ndk/28.2.13676358")
        else -> File(System.getProperty("user.home"), "Library/Android/sdk/ndk/28.2.13676358")
    }
    val ndkSourceProperties = File(ndkDir, "source.properties")
    if (ndkSourceProperties.exists()) {
        project.evaluationDependsOn(":app")
    } else {
        logger.warn("NDK source.properties not found at: ${ndkSourceProperties.absolutePath}. Skipping evaluationDependsOn for :app.")
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
