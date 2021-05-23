import 'package:binary_music_tools/models/brew.dart';
import 'package:flutter/material.dart';

class BrewDetailList extends StatelessWidget {
  final Brew brew;

  BrewDetailList({required this.brew});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "ABV: ${brew.abv != null ? "${brew.abv!.toStringAsFixed(2)}%" : "--"}",
        ),
        Text(
          "Starting Gravity: ${brew.wort != null ? "${brew.wort!.toStringAsFixed(1)} °Plato" : "--"}",
        ),
        Text(
          "Final Gravity: ${brew.restWort != null ? "${brew.restWort!.toStringAsFixed(1)} °Plato" : "--"}",
        ),
        Text(
          "Apparent fermentation rate: ${brew.apparantFerm != null ? "${brew.apparantFerm!.toStringAsFixed(2)}%" : "--"}",
        ),
        Text(
          "Real fermentation rate: ${brew.realFerm != null ? "${brew.realFerm!.toStringAsFixed(2)}%" : "--"}",
        ),
      ],
    );
  }
}
