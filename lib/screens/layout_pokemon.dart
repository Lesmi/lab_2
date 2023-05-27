import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shaky_animated_listview/animators/grid_animator.dart';
import '../model/pokemon.dart';
import '../services/pokeapi_service.dart';

class LayoutPokemonScreen extends StatefulWidget {
  const LayoutPokemonScreen({Key? key}) : super(key: key);

  @override
  State<LayoutPokemonScreen> createState() => StateLayoutPokemonScreen();
}

class StateLayoutPokemonScreen extends State<LayoutPokemonScreen> {
  List<String> pokemonTypes = [];
  String? selectedType;
  List<Pokemon> allPokemons = [];
  List<Pokemon> filteredPokemons = [];

  @override
  void initState() {
    super.initState();
    _fetchPokemonTypes();
  }

  Future<void> _fetchPokemonTypes() async {
    try {
      final pokemons = await PokeApiService().fetchPokemons();
      final types = pokemons.map((pokemon) => pokemon.type).toSet().toList();
      setState(() {
        allPokemons = pokemons;
        filteredPokemons = pokemons;
        pokemonTypes = types;
      });
    } catch (error) {
      print('Error al obtener los tipos de Pokémon: $error');
    }
  }

  void _applyFilter() {
    if (selectedType != null) {
      filteredPokemons =
          allPokemons.where((pokemon) => pokemon.type == selectedType).toList();
    } else {
      filteredPokemons = allPokemons;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('PokeDex'),
        actions: [
          DropdownButton<String>(
            value: selectedType,
            items: pokemonTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                selectedType = value;
                _applyFilter();
              });
            },
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final int crossAxisCount =
              orientation == Orientation.portrait ? 3 : 6;

          return MasonryGridView.count(
            itemCount: filteredPokemons.length,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemBuilder: (context, index) {
              final pokemon = filteredPokemons[index];
              return GridAnimatorWidget(
                child: Card(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Image.network(
                        pokemon.imageUrl,
                        height: Random().nextInt(150) + 50.5,
                      ),
                      Text(pokemon.name),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
