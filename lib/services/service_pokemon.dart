// lib/services/service_pokemon.dart
// Este archivo define el servicio para obtener datos de Pokémon desde la API de PokeAPI.
// Se utiliza para encapsular la lógica de red y conversión de datos.

import 'dart:convert'; // Importa la biblioteca 'dart:convert' para decodificar JSON, necesaria para convertir la respuesta de la API en un mapa de Dart.
import 'package:http/http.dart'
    as http; // Importa el paquete 'http' para realizar solicitudes HTTP, usado para hacer llamadas a la API externa.
import '../models/pokemon.dart'; // Importa el modelo Pokemon desde el directorio models, para crear instancias de Pokemon a partir de los datos JSON.

// Define la clase ServicePokemon, que actúa como un servicio para interactuar con la API de Pokémon.
// Esta clase encapsula la lógica de obtención de datos de un Pokémon específico.
class ServicePokemon {
  // Método fetchPokemon: Obtiene un Pokémon por nombre desde la API.
  // Retorna un Future<Pokemon> porque es asíncrono, permitiendo que la UI no se bloquee mientras espera la respuesta.
  // Parámetro 'name': El nombre del Pokémon a buscar, convertido a minúsculas para evitar errores de mayúsculas.
  Future<Pokemon> fetchPokemon(String name) async {
    // Construye la URL de la API usando el nombre del Pokémon.
    // Uri.parse crea un objeto URI a partir de la cadena, asegurando que sea una URL válida.
    // name.toLowerCase() convierte el nombre a minúsculas, ya que la API es case-insensitive pero consistente.
    final url = Uri.parse(
      'https://pokeapi.co/api/v2/pokemon/${name.toLowerCase()}',
    );

    // Realiza una solicitud HTTP GET a la URL construida.
    // await pausa la ejecución hasta que la respuesta llegue, permitiendo operaciones asíncronas.
    // resp contiene la respuesta completa de la API, incluyendo código de estado y cuerpo.
    final resp = await http.get(url);

    // Verifica si la solicitud fue exitosa (código 200 significa OK).
    // Si el código no es 200, significa que el Pokémon no fue encontrado o hubo un error.
    if (resp.statusCode == 200) {
      // Decodifica el cuerpo de la respuesta JSON en un mapa de Dart.
      // json.decode convierte la cadena JSON en un Map<String, dynamic>, que se puede usar para acceder a los datos.
      final data = json.decode(resp.body);
      // Crea una instancia de Pokemon usando el método factory fromJSON, que parsea el mapa en un objeto Pokemon.
      // Retorna el objeto Pokemon creado.
      return Pokemon.fromJSON(data);
    } else {
      // Si el código de estado no es 200, lanza una excepción con un mensaje descriptivo.
      // Esto permite que el código que llama a este método maneje el error apropiadamente.
      throw Exception("No se encontró");
    }
  }
}
