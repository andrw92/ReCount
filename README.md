#  Re-Counter

Proyecto de prueba para ejemplificar el patron de Clean Swift.  Este proyecto se conecta a una api local en node, la api local no esta incluida en este repositorio. Consultar para mas detalles.

## Getting Started

### Requisitos
- Git
- Xcode, versión: 10 en adelante.
- Mac con macOS versión 10.14 en adelante.
- iPhone con iOS 12.0 en adelante.

### Instalación
Clonar y darle al botoncito de play de xcode
Nota: en mi emulador local de iPhone X el UICounterControl se queda como pegado con clicks consecutivos, pero este problema no ocurre en emuladores de iPhone 8 y iPhone SE.

## Patron de diseño

Re-Counter utiliza el patron de diseño Clean Swift un approach del patron VIPER, haciendo utilizando un flujo de dato unidireccional, este flujo se puede observar mejor en el siguiente diagrama:

[](https://rubygarage.s3.amazonaws.com/uploads/article_image/file/1797/clean-swift-1x.png)


### Porque Clean Swift

El patrón Clean Swift es recomendada para proyectos grandes y un proyecto de esta envergadura es mejor utilizar un patron más simple como MVP, MVC o MVVM, pero se escogió utilizar este patron ya que asegura el cumplimiento de los principios SOLID y permite un mayor orden de responsabilidades.
 
 En este proyecto no se utilizan los templates otorgados por [Clean-Swift](https://clean-swift.com/) en los modelos de la app para no añadirle más complejidad y rigidez de la que ya tiene. 

### Ventajas

- Independencia de componentes: Hay diversas entidades separadas que se encargan de un aspecto fundamental de la app. Cada una de estas entidades es independiente y no conoce como trabajan las demás.
- Testeable: Como las entidades se encuentran aisladas son mas faciles de testear, más aún que en otros patrones de diseño.

### Desventajas
- Complejo para proyectos pequeños: En este proyecto se trata de ejemplificar esta arquitectura, sin embargo si los requirimientos finales de esta app fueran los actuales, no seria la arquitectura más óptima.
- No tan intuitivo: Al existir tantos componentes esta arquitectura no es tan intuitiva como lo es MVC.

### Conclusión
- No existe arquitectura que sea efectiva en todos los proyectos, pero esta es una bastante escalable y sumamente mantenible.

## Capas de la aplicación

Podemos ejemplificar las capas de la aplicación en 3 capas:

### Capa de presentación

Esta capa es la capa visible para el usuario, la que representa la UI/UX. Esta capa es manejada por las entidades view y las entidades presenter. El presenter prepara la data que mostrará la view.

### Capa de negocio

El dominio de la lógica de negocio es manejada por las entidades interactor, que se encargan de procesar la data para cumplir con los requirimientos estipulados para la app.

#### Capa de conexion (network)

Capa encargada de acceder a la data de la nube, en nuestra app se conecta a una api local que utiliza un servidor de Node.JS, para el consumo de servicios se utiliza un `Loader` una interfaz generica que permite obtener la data desde distintas fuentes, por lo que es bastante reutilizable.

