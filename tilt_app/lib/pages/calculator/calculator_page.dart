import 'package:binary_music_tools/blocs/brew_db/bloc.dart';
import 'package:binary_music_tools/blocs/brew_db/brew_db_bloc.dart';
import 'package:binary_music_tools/models/brew.dart';
import 'package:binary_music_tools/pages/calculator/widgets/abv_card.dart';
import 'package:binary_music_tools/pages/calculator/widgets/fermentation_card.dart';
import 'package:binary_music_tools/pages/calculator/widgets/wort_card.dart';
import 'package:binary_music_tools/widgets/brew_detail_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../beer_calculator.dart';

class CalculatorPage extends StatefulWidget {
  final Function onSave;

  CalculatorPage({@required this.onSave});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final GlobalKey<FormState> wordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> restWortFormKey = GlobalKey<FormState>();

  double _wort;
  double _restWort;
  double _abv;
  double _apparantFerm;
  double _realFerm;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            Padding(
              padding: EdgeInsets.only(
                left: 4,
                right: 4,
                bottom: 8,
                top: 16,
              ),
              child: MaterialButton(
                child: Text("Save"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: Colors.white,
                onPressed: () => _showSaveDialog(),
              ),
            )
          ],
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
        _abv = BeerCalculator.calculateABV(_wort, _restWort);
        _apparantFerm =
            BeerCalculator.calculateApparantFermentation(_wort, _restWort);
        _realFerm = BeerCalculator.calculateRealFermentation(_wort, _restWort);
      } else if (_wort != null) {
        _abv = BeerCalculator.approximateABV(_wort);
        _apparantFerm = null;
        _realFerm = null;
      } else {
        _abv = null;
        _apparantFerm = null;
        _realFerm = null;
      }
    });
  }

  void _showSaveDialog() async {
    var _nameInputController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameInputController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        hintText: 'Please insert a name for your beer.',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: BrewDetailList(
                        brew: Brew(
                          name: "TMP",
                          wort: _wort,
                          restWort: _restWort,
                          apparantFerm: _apparantFerm,
                          realFerm: _realFerm,
                          abv: _abv,
                        ),
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        new TextButton(
                          child: new Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        new TextButton(
                          child: new Text("Save"),
                          onPressed: () {
                            _saveBrew(_nameInputController.text);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _saveBrew(String name) {
    if (name == null || name.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please insert a name for the beer.")));
    }

    context.read()<BrewDbBloc>().add(
          SaveBrew(
            Brew(
              name: name,
              wort: _wort,
              restWort: _restWort,
              apparantFerm: _apparantFerm,
              realFerm: _realFerm,
              abv: _abv,
            ),
          ),
        );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("$name was saved.")));
  }
}
