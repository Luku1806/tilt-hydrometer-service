import 'package:flutter/material.dart';

class FermentationCard extends StatelessWidget {
  const FermentationCard({
    Key? key,
    required double? apparentFermentation,
    required double? realFermentation,
  })  : _apparentFerm = apparentFermentation,
        _realFerm = realFermentation,
        super(key: key);

  final double? _apparentFerm;
  final double? _realFerm;

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
                "Real fermentation rate",
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                "Apparent fermentation rate.",
                overflow: TextOverflow.ellipsis,
                maxLines: 6,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Apparent:   ${_apparentFerm != null ? "${_apparentFerm!.toStringAsFixed(2)}%" : "---"}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Real: ${_realFerm != null ? "${_realFerm!.toStringAsFixed(2)}%" : "---"}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ].where((element) => element != null).toList(),
        ),
      ),
    );
  }
}
