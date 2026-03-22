// main.dart
// Este archivo es el punto de entrada de la aplicación Flutter.
// Define la estructura principal de la app, incluyendo el cambio de tema y la pantalla de Pokémon.

import 'package:flutter/material.dart'; // Importa el paquete principal de Flutter para widgets y temas.
import 'package:flutter_svg/flutter_svg.dart'; // Importa flutter_svg para mostrar imágenes SVG desde la red.
import 'package:gallery_app/services/service_pokemon.dart'; // Importa el servicio para obtener datos de Pokémon.
import 'models/pokemon.dart'; // Importa el modelo de datos Pokemon.

// Función main: Punto de entrada de la aplicación.
// Llama a runApp para iniciar la app con el widget MyApp.
void main() {
  runApp(const MyApp());
}

// Clase MyApp: Widget raíz de la aplicación, es stateful para manejar el cambio de tema.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  }); // Constructor con clave opcional para identificación.

  @override
  State<MyApp> createState() => _MyAppState(); // Crea el estado asociado.
}

// Clase _MyAppState: Maneja el estado de MyApp, específicamente el modo de tema.
class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode
      .dark; // Variable de estado para el tema actual, inicia en oscuro.

  // Método _changeTheme: Cambia el modo de tema y actualiza la UI.
  // Parámetro themeMode: El nuevo modo de tema a aplicar.
  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      // Llama a setState para reconstruir el widget con el nuevo tema.
      _themeMode = themeMode; // Actualiza la variable de estado.
    });
  }

  @override
  Widget build(BuildContext context) {
    // Método build: Construye la UI del widget.
    return MaterialApp(
      // Retorna MaterialApp, el widget raíz de la app.
      title: 'Flutter Demo', // Título de la app, usado en el task manager.
      debugShowCheckedModeBanner:
          false, // Oculta la etiqueta de debug en la esquina superior derecha.
      theme: ThemeData(
        // Define el tema claro.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
        ), // Esquema de colores basado en rojo.
        useMaterial3: true, // Habilita Material Design 3.
      ),
      darkTheme: ThemeData(
        // Define el tema oscuro.
        colorScheme: ColorScheme.fromSeed(
          // Esquema de colores basado en índigo.
          seedColor: Colors.indigo,
          brightness: Brightness.dark, // Especifica que es para brillo oscuro.
        ),
      ),
      themeMode: _themeMode, // Aplica el modo de tema actual.
      home: PokemonScreen(
        changeTheme: _changeTheme,
      ), // Pantalla principal, pasa la función de cambio de tema.
    );
  }
}

// Clase PokemonScreen: Pantalla principal que muestra la búsqueda y detalles de Pokémon.
class PokemonScreen extends StatefulWidget {
  const PokemonScreen({
    super.key,
    required this.changeTheme,
  }); // Constructor con clave y función requerida.

  final void Function(ThemeMode themeMode)
  changeTheme; // Propiedad para la función de cambio de tema.
  @override
  State<PokemonScreen> createState() => _PokemonScreenState(); // Crea el estado.
}

// Clase _PokemonScreenState: Maneja el estado de PokemonScreen, incluyendo búsqueda y datos.
class _PokemonScreenState extends State<PokemonScreen> {
  final TextEditingController _controller =
      TextEditingController(); // Controlador para el campo de texto de búsqueda.
  final ServicePokemon _servicePokemon =
      ServicePokemon(); // Instancia del servicio para obtener Pokémon.

  Future<Pokemon>?
  _futurePokemon; // Futuro que contiene el Pokémon buscado, nullable para estado inicial.

  // Método _buscarPokemon: Inicia la búsqueda de un Pokémon cuando se presiona el botón.
  void _buscarPokemon() {
    if (_controller.text.trim().isNotEmpty) {
      // Verifica que el texto no esté vacío después de trim.
      setState(() {
        // Actualiza el estado para mostrar el FutureBuilder.
        _futurePokemon = _servicePokemon.fetchPokemon(
          _controller.text.trim(),
        ); // Llama al servicio con el nombre.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Método build: Construye la UI de la pantalla.
    return Scaffold(
      // Retorna Scaffold, estructura básica de pantalla.
      appBar: AppBar(
        // Barra superior con título.
        title: Text(
          // Texto del título.
          "Pokédex de Galería",
          style: TextStyle(fontWeight: FontWeight.bold), // Estilo en negrita.
        ),
        centerTitle: true, // Centra el título.
        backgroundColor: Theme.of(
          context,
        ).colorScheme.inversePrimary, // Color de fondo basado en el tema.
      ),
      body: Padding(
        // Cuerpo con padding.
        padding: const EdgeInsets.all(
          16.0,
        ), // Padding de 16 en todos los lados.
        child: Column(
          // Columna principal para organizar elementos verticalmente.
          children: [
            Row(
              // Fila para el campo de búsqueda y botón.
              children: [
                Expanded(
                  // Expande el TextField para ocupar espacio disponible.
                  child: TextField(
                    // Campo de texto para ingresar el nombre del Pokémon.
                    controller: _controller, // Asocia el controlador.
                    decoration: InputDecoration(
                      // Decoración del campo.
                      prefixIcon: Icon(
                        Icons.search,
                      ), // Ícono de búsqueda al inicio.
                      border: OutlineInputBorder(
                        // Borde con esquinas redondeadas.
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: "Nombre del Pokémon", // Etiqueta del campo.
                      filled: true, // Rellena el fondo.
                    ),
                  ),
                ),
                SizedBox(width: 12), // Espacio entre el campo y el botón.
                FilledButton(
                  // Botón relleno para buscar.
                  onPressed:
                      _buscarPokemon, // Acción al presionar: buscar Pokémon.
                  style: FilledButton.styleFrom(
                    // Estilo del botón.
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                    ), // Padding vertical.
                    shape: RoundedRectangleBorder(
                      // Forma con esquinas redondeadas.
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Buscar"), // Texto del botón.
                ),
              ],
            ),
            SizedBox(height: 20), // Espacio vertical.

            Expanded(
              // Expande para ocupar el resto del espacio.
              child:
                  _futurePokemon ==
                      null // Si no hay búsqueda, muestra mensaje inicial.
                  ? Center(
                      // Centra el contenido.
                      child: Text(
                        // Texto de instrucción.
                        "Ingresa un nombre para empezar a buscar",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ), // Estilo gris.
                      ),
                    )
                  : FutureBuilder<Pokemon>(
                      // Si hay búsqueda, usa FutureBuilder para manejar el futuro.
                      future: _futurePokemon, // El futuro a esperar.
                      builder: (context, snapshot) {
                        // Función constructora basada en el estado del snapshot.
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Si está esperando.
                          return Center(
                            child: CircularProgressIndicator(),
                          ); // Muestra indicador de carga.
                        } else if (snapshot.hasError) {
                          // Si hay error.
                          return Center(
                            child: Text("Ese Pokémon no existe"),
                          ); // Muestra mensaje de error.
                        }

                        final pokemon =
                            snapshot.data!; // Obtiene el Pokémon del snapshot.

                        return SingleChildScrollView(
                          // Permite scroll si el contenido es largo.
                          child: Card(
                            // Tarjeta para contener la información.
                            elevation: 4, // Elevación para sombra.
                            shape: RoundedRectangleBorder(
                              // Forma con esquinas redondeadas.
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              // Padding interno.
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                // Columna para organizar el contenido de la tarjeta.
                                children: [
                                  Text(
                                    // Nombre del Pokémon en mayúsculas.
                                    pokemon.name.toUpperCase(),
                                    style: TextStyle(
                                      // Estilo del texto.
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                  SizedBox(height: 15), // Espacio.

                                  if (pokemon
                                      .mainImageUrl
                                      .isNotEmpty) // Si hay imagen principal.
                                    SvgPicture.network(
                                      // Muestra la imagen SVG desde la red.
                                      pokemon.mainImageUrl,
                                      height: 140, // Altura fija.
                                    )
                                  else // Si no hay imagen.
                                    Icon(
                                      // Ícono de imagen no disponible.
                                      Icons.image_not_supported,
                                      size: 100,
                                      color: Colors.grey,
                                    ),

                                  SizedBox(height: 25), // Espacio.

                                  Text(
                                    // Título de habilidades.
                                    "Habilidades",
                                    style: TextStyle(
                                      // Estilo.
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 8), // Espacio.
                                  Wrap(
                                    // Wrap para chips en múltiples líneas.
                                    spacing: 8.0, // Espacio entre chips.
                                    children: pokemon
                                        .abilities // Mapea cada habilidad a un Chip.
                                        .map(
                                          (hab) => Chip(
                                            // Chip para cada habilidad.
                                            label: Text(
                                              hab,
                                            ), // Texto de la habilidad.
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer, // Color de fondo.
                                            side: BorderSide.none, // Sin borde.
                                            shape: RoundedRectangleBorder(
                                              // Forma redondeada.
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        )
                                        .toList(), // Convierte a lista.
                                  ),

                                  SizedBox(height: 20), // Espacio.
                                  Divider(), // Línea divisoria.
                                  SizedBox(height: 10), // Espacio.

                                  Text(
                                    // Título de la galería.
                                    "Galería de Sprites",
                                    style: TextStyle(
                                      // Estilo.
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 10), // Espacio.
                                  PokemonGallery(
                                    images: pokemon.galleryImages,
                                  ), // Widget de galería.
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        // Botones flotantes para cambiar tema.
        mainAxisAlignment: MainAxisAlignment.end, // Alinea a la derecha.
        children: [
          FloatingActionButton(
            // Botón para modo oscuro.
            onPressed: () =>
                widget.changeTheme(ThemeMode.dark), // Cambia a oscuro.
            tooltip: 'Modo oscuro', // Tooltip.
            child: Icon(Icons.dark_mode), // Ícono.
          ),
          SizedBox(width: 10), // Espacio.
          FloatingActionButton(
            // Botón para modo claro.
            onPressed: () =>
                widget.changeTheme(ThemeMode.light), // Cambia a claro.
            tooltip: 'Modo claro', // Tooltip.
            child: Icon(Icons.light_mode), // Ícono.
          ),
        ],
      ),
    );
  }
}

// --- WIDGET DE LA GALERÍA (Misma lógica, botones más limpios) ---
// Clase PokemonGallery: Widget para mostrar una galería de imágenes con navegación.
class PokemonGallery extends StatefulWidget {
  final List<String> images; // Lista de URLs de imágenes.

  const PokemonGallery({
    super.key,
    required this.images,
  }); // Constructor con imágenes requeridas.

  @override
  State<PokemonGallery> createState() => _PokemonGalleryState(); // Crea el estado.
}

// Clase _PokemonGalleryState: Maneja el estado de la galería, índice actual.
class _PokemonGalleryState extends State<PokemonGallery> {
  int _currentIndex = 0; // Índice de la imagen actual.

  // Método _nextImage: Avanza a la siguiente imagen.
  void _nextImage() {
    if (widget.images.isNotEmpty) {
      // Si hay imágenes.
      setState(
        // Actualiza el estado.
        () => _currentIndex =
            (_currentIndex + 1) % widget.images.length, // Cicla al siguiente.
      );
    }
  }

  // Método _prevImage: Retrocede a la imagen anterior.
  void _prevImage() {
    if (widget.images.isNotEmpty) {
      // Si hay imágenes.
      setState(
        // Actualiza el estado.
        () => _currentIndex =
            (_currentIndex - 1 + widget.images.length) %
            widget.images.length, // Cicla al anterior.
      );
    }
  }

  @override
  void didUpdateWidget(PokemonGallery oldWidget) {
    // Se llama cuando el widget se actualiza.
    super.didUpdateWidget(oldWidget); // Llama al método padre.
    if (widget.images != oldWidget.images) {
      // Si las imágenes cambiaron.
      _currentIndex = 0; // Reinicia el índice.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Método build: Construye la UI de la galería.
    if (widget.images.isEmpty)
      return Text(
        "No hay sprites extra.",
      ); // Si no hay imágenes, muestra texto.

    return Column(
      // Columna para imagen y controles.
      children: [
        Container(
          // Contenedor para la imagen.
          height: 120, // Altura fija.
          padding: EdgeInsets.all(8), // Padding interno.
          decoration: BoxDecoration(
            // Decoración con fondo gris y bordes redondeados.
            color: Colors.grey.withAlpha(100),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.network(
            // Imagen desde la red.
            widget.images[_currentIndex], // URL de la imagen actual.
            fit: BoxFit.contain, // Ajusta para contener.
          ),
        ),
        SizedBox(height: 10), // Espacio.
        Row(
          // Fila para botones de navegación.
          mainAxisAlignment: MainAxisAlignment.center, // Centra los botones.
          children: [
            IconButton.filledTonal(
              // Botón para imagen anterior.
              onPressed: _prevImage, // Acción: anterior.
              icon: Icon(Icons.arrow_back_ios_new, size: 18), // Ícono.
            ),
            Padding(
              // Padding para el contador.
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                // Texto del contador.
                "${_currentIndex + 1} / ${widget.images.length}", // Muestra índice actual y total.
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ), // Estilo en negrita.
              ),
            ),
            IconButton.filledTonal(
              // Botón para imagen siguiente.
              onPressed: _nextImage, // Acción: siguiente.
              icon: Icon(Icons.arrow_forward_ios, size: 18), // Ícono.
            ),
          ],
        ),
      ],
    );
  }
}
