# Currency Exchange Calculator

Aplicación móvil desarrollada en Flutter para la conversión de divisas fiat y criptomonedas en tiempo real. El proyecto implementa una arquitectura limpia con separación de responsabilidades y gestión de estado reactiva.

## Tabla de Contenidos

- [Tecnologías Utilizadas](#tecnologías-utilizadas)
- [Arquitectura del Proyecto](#arquitectura-del-proyecto)
- [Gestión de Estado](#gestión-de-estado)
- [Estructura de Directorios](#estructura-de-directorios)
- [Características Implementadas](#características-implementadas)
- [Instalación y Configuración](#instalación-y-configuración)
- [Compilación](#compilación)
- [Testing](#testing)

## Tecnologías Utilizadas

### Framework y Lenguaje
- **Flutter 3.8.1**: Framework de desarrollo multiplataforma que permite construir aplicaciones nativas para iOS y Android desde una única base de código.
- **Dart**: Lenguaje de programación optimizado para desarrollo de interfaces de usuario.

### Dependencias Principales

#### Gestión de Estado
- **provider (^6.1.1)**: Solución de gestión de estado recomendada por el equipo de Flutter. Se seleccionó por su simplicidad, bajo acoplamiento y rendimiento eficiente mediante el patrón de notificación selectiva.

#### Comunicación HTTP
- **http (^1.2.0)**: Cliente HTTP para consumir APIs REST. Proporciona una interfaz simple y robusta para realizar peticiones de red.

#### Conectividad
- **connectivity_plus (^6.0.5)**: Plugin multiplataforma para detectar el estado de la conexión de red. Permite validar la disponibilidad de internet antes de realizar peticiones HTTP, mejorando la experiencia del usuario al proporcionar feedback inmediato ante problemas de conectividad.

#### Formateo y Localización
- **intl (^0.19.0)**: Paquete de internacionalización que facilita el formateo de números, fechas y monedas según estándares locales.

#### UI/UX
- **shimmer (^3.0.0)**: Implementa el patrón de carga Shimmer, proporcionando una experiencia visual más fluida durante la carga de datos al mostrar placeholders animados en lugar de spinners tradicionales.

### Herramientas de Desarrollo
- **flutter_test**: Framework de testing integrado para pruebas unitarias y de widgets.
- **integration_test**: Herramienta para pruebas de integración end-to-end.
- **flutter_lints (^5.0.0)**: Conjunto de reglas de linting recomendadas por Flutter para mantener código limpio y consistente.

## Arquitectura del Proyecto

La aplicación sigue una arquitectura en capas con separación clara de responsabilidades:

### Capas de la Arquitectura

#### 1. Presentation Layer (Capa de Presentación)
Contiene todos los elementos visuales y la lógica de presentación:
- **Screens**: Pantallas completas de la aplicación
- **Widgets**: Componentes reutilizables de UI
- **Providers**: Gestores de estado que conectan la UI con la lógica de negocio

#### 2. Data Layer (Capa de Datos)
Maneja el acceso y transformación de datos:
- **Services**: Servicios para comunicación con APIs externas
- **Models**: Modelos de datos que representan las entidades del dominio

#### 3. Core Layer (Capa Central)
Elementos transversales utilizados en toda la aplicación:
- **Constants**: Valores constantes (colores, estilos, configuraciones)
- **Errors**: Manejo centralizado de excepciones y errores

### Flujo de Datos

```
UI (Widgets)
    ↓
Provider (ExchangeProvider)
    ↓
Service (ExchangeApiService)
    ↓
API Externa
```

## Gestión de Estado

El proyecto utiliza el patrón **Provider** con **ChangeNotifier** para la gestión de estado reactiva:

### ExchangeProvider

Centraliza toda la lógica de negocio relacionada con el intercambio de divisas:

- **Estado Interno**:
  - Moneda origen y destino
  - Monto a convertir
  - Tasa de cambio actual
  - Estado de carga y errores

- **Funcionalidades**:
  - Debouncing de peticiones para optimizar llamadas API (500ms)
  - Intercambio automático de monedas cuando se selecciona el mismo tipo
  - Cálculo bidireccional (crypto → fiat y fiat → crypto)
  - Manejo de errores con mensajes descriptivos

### Ventajas del Enfoque Utilizado

1. **Reactividad**: La UI se actualiza automáticamente cuando cambia el estado
2. **Testabilidad**: La lógica de negocio está aislada y es fácil de probar
3. **Mantenibilidad**: Separación clara entre lógica y presentación
4. **Rendimiento**: Notificaciones selectivas solo a widgets que escuchan cambios

## Estructura de Directorios

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart         # Paleta de colores
│   │   ├── app_text_styles.dart    # Estilos de texto
│   │   └── currencies.dart         # Catálogo de monedas soportadas
│   └── errors/
│       └── api_exception.dart      # Excepciones personalizadas
│
├── data/
│   ├── models/
│   │   ├── currency.dart           # Modelo de moneda
│   │   └── exchange_rate_response.dart  # Modelo de respuesta API
│   └── services/
│       └── exchange_api_service.dart    # Servicio HTTP para API
│
├── presentation/
│   ├── providers/
│   │   └── exchange_provider.dart  # Gestor de estado principal
│   ├── screens/
│   │   └── exchange_screen.dart    # Pantalla principal
│   └── widgets/
│       ├── amount_input_field.dart      # Campo de entrada numérica
│       ├── currency_button.dart         # Botón selector de moneda
│       ├── currency_selector.dart       # Diálogo de selección
│       ├── currency_switcher.dart       # Botón de intercambio
│       ├── info_row.dart                # Fila de información
│       ├── info_state_widget.dart       # Widget de estados
│       ├── primary_button.dart          # Botón primario
│       ├── shimmer_loading.dart         # Efecto de carga
│       └── widgets.dart                 # Exportaciones
│
└── main.dart                       # Punto de entrada
```

## Características Implementadas

### Manejo de Errores
- Detección de conexión a internet
- Sistema de reintentos automáticos
- Timeouts configurados
- Mensajes de error descriptivos para el usuario
- Fallback automático para pares de monedas sin datos directos

### Testing
- Tests unitarios para modelos y servicios
- Tests de widgets para componentes de UI
- Tests de integración end-to-end
- Cobertura de casos de error y edge cases

## Instalación y Configuración

### Requisitos Previos

- Flutter SDK 3.8.1 o superior
- Dart SDK 3.0 o superior
- Android Studio / Xcode (según plataforma objetivo)
- Git

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone <repository-url>
cd currency_exchange
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Verificar configuración de Flutter**
```bash
flutter doctor
```

4. **Verificar dispositivos disponibles**
```bash
flutter devices
```

## Compilación

### Modo Desarrollo

#### Android
```bash
flutter run
```

#### iOS
```bash
flutter run -d ios
```
