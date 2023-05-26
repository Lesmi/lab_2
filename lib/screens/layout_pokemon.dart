import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shaky_animated_listview/animators/grid_animator.dart';
import '../model/pokemon.dart';
import '../services/pokeapi_service.dart';

class LayoutPokemonScreen extends StatefulWidget {
  const LayoutPokemonScreen({Key? key}) : super(key: key);

  @override
  State<LayoutPokemonScreen> createState() => _LayoutPokemonScreen();
}

class _LayoutPokemonScreen extends State<LayoutPokemonScreen> {
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
            future: PokeApiService().fetchPokemons(),
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
                    return GridAnimatorWidget(
                        child: Card(
                      color:
                          Colors.transparent, // Remove random background color
                      child: Column(
                        children: [
                          Image.network(
                            pokemon.imageUrl,
                            height: Random().nextInt(150) + 50.5,
                          ),
                          Text(pokemon.name),
                        ],
                      ),
                    ));
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
