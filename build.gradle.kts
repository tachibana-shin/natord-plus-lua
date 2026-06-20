plugins {
    kotlin("jvm") version "1.9.20"
    `maven-publish`
    `java-library`
}

group = "dev.tachibana"
version = "1.0.0"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
}

tasks.test {
    useJUnitPlatform()
}

kotlin {
    jvmToolchain(11)
}

publishing {
    publications {
        create<MavenPublication>("maven") {
            groupId = "dev.tachibana"
            artifactId = "natord-plus"
            version = "1.0.0"
            from(components["java"])
            
            pom {
                name.set("NatordPlus")
                description.set("An advanced strnatcmp algorithm (natural order - natord) with fixed-point support")
                url.set("https://github.com/tachibana-shin/natord-plus-lua")
                licenses {
                    license {
                        name.set("GNU General Public License v3.0")
                        url.set("https://www.gnu.org/licenses/gpl-3.0.html")
                    }
                }
                developers {
                    developer {
                        id.set("tachibana-shin")
                        name.set("Tachibana Shin")
                        email.set("tachibshin@duck.com")
                    }
                }
                scm {
                    connection.set("scm:git:https://github.com/tachibana-shin/natord-plus-lua.git")
                    developerConnection.set("scm:git:https://github.com/tachibana-shin/natord-plus-lua.git")
                    url.set("https://github.com/tachibana-shin/natord-plus-lua")
                }
            }
        }
    }
}
