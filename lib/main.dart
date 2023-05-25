// main.dart
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KindaCode.com',
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
        title: const Text('KindaCode.com'),
      ),
      // implement the masonry layout
      body: OrientationBuilder(
        builder: (context, orientation) {
          final int crossAxisCount = orientation == Orientation.portrait ? 3 : 6;

          return MasonryGridView.count(
            itemCount: _items.length,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            // the number of columns
            crossAxisCount: orientation == Orientation.portrait ? 3 : 6,
            // vertical gap between two items
            mainAxisSpacing: 4,
            // horizontal gap between two items
            crossAxisSpacing: 4,
            itemBuilder: (context, index) {
              // display each item with a card
              return Card(
                // Give each item a random background color
                color: Color.fromARGB(
                  Random().nextInt(256),
                  Random().nextInt(256),
                  Random().nextInt(256),
                  Random().nextInt(256),
                ),
                key: ValueKey(_items[index]['id']),
                child: SizedBox(
                  height: _items[index]['height'],
                  child: Center(
                    child: Text(_items[index]['title']),
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
