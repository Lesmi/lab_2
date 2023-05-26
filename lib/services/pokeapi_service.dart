import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/pokemon.dart';

class PokeApiService {
  Future<List<Pokemon>> fetchPokemons() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=10'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final results = json['results'] as List<dynamic>;
      final List<Pokemon> pokemons = [];

      for (var result in results) {
        final pokemonUrl = result['url'] as String;
        final pokemonResponse = await http.get(Uri.parse(pokemonUrl));
        if (pokemonResponse.statusCode == 200) {
          final pokemonJson = jsonDecode(pokemonResponse.body);
          final name = pokemonJson['name'] as String;
          final imageUrl = pokemonJson['sprites']['front_default'] as String;
          final types = pokemonJson['types'] as List<dynamic>;
          final type = types[0]['type']['name'] as String;
          pokemons.add(Pokemon(name: name, imageUrl: imageUrl, type: type));
        }
      }

      return pokemons;
    } else {
      throw Exception('Failed to fetch pokemons');
    }
  }

  Future<List<String>> getPokemonTypes() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/type'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final results = json['results'] as List<dynamic>;
      return results.map((result) => result['name'] as String).toList();
    } else {
      throw Exception('Error al obtener los tipos de Pokémon');
    }
  }
}
