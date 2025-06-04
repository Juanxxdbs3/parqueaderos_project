plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.parqueaderos_app"
    // Usando valor explícito para compileSdk, pero deberías asegurarte de que
    // este valor sea igual o mayor que el proporcionado por Flutter
    // compileSdk = 35 // O flutter.compileSdkVersion si prefieres que Flutter lo gestione
    compileSdk = flutter.compileSdkVersion // Dejar que Flutter gestione esto es más seguro

    // ndkVersion = "27.0.12077973" // Línea original problemática
    ndkVersion = flutter.ndkVersion // Solución recomendada: Dejar que Flutter gestione el NDK

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Cambia esto por un ID de aplicación único para tu app
        applicationId = "com.example.parqueaderos_app"
        
        minSdk = flutter.minSdkVersion
        // Configuración de SDK mínimo explícito (puedes ajustar según necesidades)
        // Es mejor dejar que Flutter maneje el minSdk a menos que tengas una razón específica.
        // Si necesitas establecerlo explícitamente, asegúrate de que sea compatible.
        // El minSdk se define a menudo en el archivo local.properties o es gestionado por Flutter.
        // Si no está en local.properties, Flutter usará su valor por defecto.
        // Para este ejemplo, lo comentaré para que Flutter use su valor por defecto o el de local.properties
        // minSdk = flutter.minSdkVersion 

        // Configuración de SDK objetivo explícito
        // targetSdk = 34  // Android 14
        targetSdk = flutter.targetSdkVersion // Dejar que Flutter gestione esto es más seguro
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Agrega tu propia configuración de firma para la versión de lanzamiento.
            // Firmando con las claves de depuración por ahora, para que `flutter run --release` funcione.
            signingConfig = signingConfigs.getByName("debug")
            
            // Opcional: Habilitar ofuscación y optimización para versiones de producción
            isMinifyEnabled = true // Considera poner esto en false para builds de depuración si causa problemas
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

// Agrega esto al final del archivo si no existe, para asegurar que las dependencias de Kotlin se manejen bien
dependencies {
    implementation(kotlin("stdlib-jdk8"))
}
