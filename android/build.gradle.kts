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
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    // Check if NDK source.properties exists before evaluationDependsOn
    val ndkDir = File(System.getenv("ANDROID_NDK_HOME") ?: "${System.getenv("ANDROID_SDK_ROOT") ?: System.getenv("ANDROID_HOME")}/ndk/28.2.13676358")
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
