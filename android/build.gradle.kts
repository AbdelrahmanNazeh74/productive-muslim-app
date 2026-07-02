plugins {
    id("com.google.gms.google-services") version "4.4.2" apply false
    id("com.google.firebase.crashlytics") version "3.0.2" apply false
}

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
}

// AGP 8.0+ requires an explicit `namespace` in every Android library module.
// Older pub packages (e.g. isar_flutter_libs 3.1.0+1) still rely on the
// `package` attribute in AndroidManifest.xml which is no longer accepted.
// We set the namespace at plugin-apply time (inside plugins.withId), which
// fires BEFORE AGP reads the namespace during its own afterEvaluate —
// "during evaluation", not after, which is what AGP requires.
subprojects {
    plugins.withId("com.android.library") {
        val lib = extensions.findByType(com.android.build.gradle.LibraryExtension::class.java)
        if (lib != null && lib.namespace == null) {
            val mf = lib.sourceSets.getByName("main").manifest.srcFile
            if (mf.exists()) {
                Regex("""package\s*=\s*"([^"]+)"""")
                    .find(mf.readText())?.groupValues?.get(1)
                    ?.let { lib.namespace = it }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
