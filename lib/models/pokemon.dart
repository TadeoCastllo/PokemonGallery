// lib/models/pokemon.dart
// Este archivo define el modelo de datos para un Pokémon, representando la estructura de información que se obtiene de la API.
// Se utiliza para mapear los datos JSON de la API a objetos Dart, facilitando el manejo de datos en la aplicación.

class Pokemon {
  // Propiedad 'name': Almacena el nombre del Pokémon como una cadena de texto.
  // Es final porque no cambia después de la creación, asegurando inmutabilidad.
  final String name;

  // Propiedad 'abilities': Lista de habilidades del Pokémon, cada una como una cadena.
  // Es final para mantener la integridad de los datos una vez creados.
  final List<String> abilities;

  // Propiedad 'mainImageUrl': URL de la imagen principal del Pokémon (usualmente la imagen de sueño).
  // Es final, ya que la URL no se modifica después de la inicialización.
  final String mainImageUrl;

  // Propiedad 'galleryImages': Lista de URLs de imágenes adicionales (sprites) para la galería.
  // Es final para evitar modificaciones accidentales.
  final List<String> galleryImages;

  // Constructor de Pokemon: Inicializa todas las propiedades requeridas.
  // Usa 'required' para asegurar que todos los campos sean proporcionados al crear una instancia.
  Pokemon({
    required this.name,
    required this.abilities,
    required this.mainImageUrl,
    required this.galleryImages,
  });

  // Método factory 'fromJSON': Crea una instancia de Pokemon a partir de un mapa JSON.
  // Es un factory constructor porque realiza lógica adicional (parsing) antes de crear el objeto.
  // Parámetro 'json': Mapa que contiene los datos JSON de la API.
  factory Pokemon.fromJSON(Map<String, dynamic> json) {
    // Extrae la lista de habilidades del JSON.
    // json['abilities'] es una lista de mapas, cada uno con una clave 'ability' que contiene 'name'.
    // Se mapea cada item a la cadena del nombre de la habilidad y se convierte en una lista.
    final abilitiesList = (json['abilities'] as List)
        .map((item) => item['ability']['name'] as String)
        .toList();

    // Extrae la URL de la imagen principal desde el JSON.
    // Navega a 'sprites' -> 'other' -> 'dream_world' -> 'front_default'.
    // Usa ?? '' para proporcionar una cadena vacía si el valor es null.
    final mainImage =
        json['sprites']['other']['dream_world']['front_default'] ?? '';

    // Obtiene el mapa de sprites del JSON para procesar las imágenes de la galería.
    final sprites = json['sprites'];

    // Inicializa una lista vacía para las imágenes de la galería.
    final List<String> gallery = [];

    // Agrega la imagen frontal normal si existe (no es null).
    if (sprites['front_default'] != null) gallery.add(sprites['front_default']);

    // Agrega la imagen trasera normal si existe.
    if (sprites['back_default'] != null) gallery.add(sprites['back_default']);

    // Agrega la imagen frontal shiny si existe.
    if (sprites['front_shiny'] != null) gallery.add(sprites['front_shiny']);

    // Agrega la imagen trasera shiny si existe.
    if (sprites['back_shiny'] != null) gallery.add(sprites['back_shiny']);

    // Retorna una nueva instancia de Pokemon con los datos parseados.
    return Pokemon(
      name: json['name'], // Asigna el nombre directamente del JSON.
      abilities: abilitiesList, // Asigna la lista de habilidades procesada.
      mainImageUrl: mainImage, // Asigna la URL de la imagen principal.
      galleryImages: gallery, // Asigna la lista de imágenes de galería.
    );
  }
}
