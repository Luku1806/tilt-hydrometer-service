import 'package:binary_music_tools/beer_calculator.dart';
import 'package:flutter/material.dart';

class WortCard extends StatefulWidget {
  final String _name;
  final GlobalKey<FormState> _formKey;
  final Function? _onPlatoChanged;

  WortCard(
    String name, {
    Key? key,
    GlobalKey<FormState>? formKey,
    Function? onPlatoChanged,
  })  : _name = name,
        _formKey = formKey ?? GlobalKey<FormState>(),
        _onPlatoChanged = onPlatoChanged,
        super(key: key);

  @override
  _WortCardState createState() => _WortCardState();
}

class _WortCardState extends State<WortCard> {
  final _platoTextController = TextEditingController();

  final _tempTextController = TextEditingController(
    text: _initialTemp.toStringAsFixed(0),
  );

  final _calibratedTempTextController = TextEditingController(
    text: _initialTemp.toStringAsFixed(0),
  );

  static const _initialTemp = 20.0;
  double? _temp = _initialTemp;
  double? _calibratedTemp = _initialTemp;
  double? _plato;
  double? _correctedPlato;

  @override
  void initState() {
    super.initState();

    _platoTextController.addListener(() {
      _onPlatoChanged(_platoTextController.value.text);
    });

    _tempTextController.addListener(() {
      _onTempChanged(_tempTextController.value.text);
    });

    _calibratedTempTextController.addListener(() {
      _onCalibratedTempChanged(_calibratedTempTextController.value.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _platoTextController.dispose();
    _tempTextController.dispose();
    _calibratedTempTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                widget._name,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                "To be able to measure temperature independent, the temperature when measuring and the temperature the spindle is calibrated to have to be given.",
                overflow: TextOverflow.ellipsis,
                maxLines: 6,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Form(
                key: widget._formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _platoTextController,
                      decoration: InputDecoration(
                          labelText: "${widget._name} in °Plato",
                          hintText: "Insert ${widget._name}",
                          alignLabelWithHint: true),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (string) => null,
                    ),
                    TextFormField(
                      controller: _tempTextController,
                      decoration: InputDecoration(
                          labelText: "Measuring temperature in °C",
                          hintText: "Insert measuring temperature",
                          alignLabelWithHint: true),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    TextFormField(
                      controller: _calibratedTempTextController,
                      decoration: InputDecoration(
                          labelText: "Spindle calibrated to (°C)",
                          hintText:
                              "Insert temperature the spindle is calibrated to",
                          alignLabelWithHint: true),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              "Corrected value: ${_correctedPlato?.toStringAsFixed(2) ?? "---"}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPlatoChanged(String value) {
    if (widget._formKey.currentState!.validate()) {
      try {
        _plato = double.parse(value);
      } catch (e) {
        _plato = null;
      }
      _updateCorrectedPlato();
    }
  }

  void _onTempChanged(String value) {
    if (widget._formKey.currentState!.validate()) {
      try {
        _temp = double.parse(value);
      } catch (e) {
        _temp = null;
      }
      _updateCorrectedPlato();
    }
  }

  void _onCalibratedTempChanged(String value) {
    if (widget._formKey.currentState!.validate()) {
      try {
        _calibratedTemp = double.parse(value);
      } catch (e) {
        _calibratedTemp = null;
      }
      _updateCorrectedPlato();
    }
  }

  void _updateCorrectedPlato() {
    setState(() {
      if (_plato != null && _temp != null && _calibratedTemp != null) {
        _correctedPlato =
            BeerCalculator.correctWort(_plato!, _temp!, _calibratedTemp!);

        if (_correctedPlato! <= 0) {
          _correctedPlato = null;
        }
      } else {
        _correctedPlato = null;
      }

      widget._onPlatoChanged!(_correctedPlato);
    });
  }
}
