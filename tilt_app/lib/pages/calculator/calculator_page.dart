import 'package:binary_music_tools/pages/calculator/widgets/abv_card.dart';
import 'package:binary_music_tools/pages/calculator/widgets/fermentation_card.dart';
import 'package:binary_music_tools/pages/calculator/widgets/wort_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../beer_calculator.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final GlobalKey<FormState> wordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> restWortFormKey = GlobalKey<FormState>();

  double? _wort;
  double? _restWort;
  double? _abv;
  double? _apparantFerm;
  double? _realFerm;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 480),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              WortCard(
                "Starting Gravity",
                formKey: wordFormKey,
                onPlatoChanged: _onWortChanged,
              ),
              WortCard(
                "Final Gravity",
                formKey: restWortFormKey,
                onPlatoChanged: _onRestWortChanged,
              ),
              AbvCard(
                abv: _abv,
                restWort: _restWort,
              ),
              FermentationCard(
                apparentFermentation: _apparantFerm,
                realFermentation: _realFerm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onWortChanged(double word) {
    _wort = word;
    updateValues();
  }

  void _onRestWortChanged(double word) {
    _restWort = word;
    updateValues();
  }

  void updateValues() {
    setState(() {
      if (_wort != null && _restWort != null) {
        _abv = BeerCalculator.calculateABV(_wort!, _restWort!);
        _apparantFerm =
            BeerCalculator.calculateApparantFermentation(_wort!, _restWort!);
        _realFerm =
            BeerCalculator.calculateRealFermentation(_wort!, _restWort!);
      } else if (_wort != null) {
        _abv = BeerCalculator.approximateABV(_wort!);
        _apparantFerm = null;
        _realFerm = null;
      } else {
        _abv = null;
        _apparantFerm = null;
        _realFerm = null;
      }
    });
  }
}
