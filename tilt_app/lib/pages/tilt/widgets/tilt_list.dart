import 'package:binary_music_tools/models/tilt.dart';
import 'package:binary_music_tools/pages/tilt/widgets/tilt_entry.dart';
import 'package:flutter/material.dart';


class TiltList extends StatelessWidget {
  final List<Tilt> tilts;

  TiltList({Key? key, required this.tilts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: tilts.length,
      itemBuilder: (context, index) {
        final tilt = tilts[index];
        return Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: TiltEntry(tilt: tilt),
          ),
        );
      },
    );
  }
}
