// main.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

class Pokemon {
  final String name;
  final String imageUrl;

  Pokemon({required this.name, required this.imageUrl});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PokeDex',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Pokemon>> fetchPokemons() async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=150'));
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
          pokemons.add(Pokemon(name: name, imageUrl: imageUrl));
        }
      }

      return pokemons;
    } else {
      throw Exception('Failed to fetch pokemons');
    }
  }

  // Generate a list of dummy items
  final List<Map<String, dynamic>> _items = List.generate(
      200,
      (index) => {
            "id": index,
            "title": "Item $index",
            "height": Random().nextInt(150) + 50.5
          });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PokeDex'),
      ),
      // implement the masonry layout
      body: OrientationBuilder(
        builder: (context, orientation) {
          final int crossAxisCount =
              orientation == Orientation.portrait ? 3 : 6;

          return FutureBuilder<List<Pokemon>>(
            future: fetchPokemons(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final pokemons = snapshot.data!;
                return MasonryGridView.count(
                  itemCount: pokemons.length,
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  // the number of columns
                  crossAxisCount: crossAxisCount,
                  // vertical gap between two items
                  mainAxisSpacing: 4,
                  // horizontal gap between two items
                  crossAxisSpacing: 4,
                  itemBuilder: (context, index) {
                    final pokemon = pokemons[index];
                    return Card(
                      color:
                          Colors.transparent, // Remove random background color
                      child: Column(
                        children: [
                          Image.network(pokemon.imageUrl, height: Random().nextInt(150) + 50.5,),
                          Text(pokemon.name),
                        ],
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      ),
    );
  }
}
