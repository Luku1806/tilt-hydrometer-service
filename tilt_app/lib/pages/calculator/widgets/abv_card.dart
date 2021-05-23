import 'package:flutter/material.dart';

class AbvCard extends StatelessWidget {
  const AbvCard({
    Key? key,
    required double? abv,
    required double? restWort,
  })  : _abv = abv,
        _restWord = restWort,
        super(key: key);

  final double? _abv;
  final double? _restWord;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              title: Text(
                "ABV",
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                "Alcohol by volume calculated by starting gravity and final gravity if given. Without final gravity the calculation will be really inaccurate.",
                overflow: TextOverflow.ellipsis,
                maxLines: 6,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'ABV: ${_abv != null ? "${_abv!.toStringAsFixed(2)}%" : "---"}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            _restWord == null
                ? Text(
                    'Because no final gravity was given, the inaccurate estimation will be used.',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  )
                : null,
          ].whereType<Widget>().toList(),
        ),
      ),
    );
  }
}
