import 'package:binary_music_tools/apis/tilt_repository.dart';
import 'package:binary_music_tools/beer_calculator.dart';
import 'package:binary_music_tools/blocs/signin_cubit.dart';
import 'package:binary_music_tools/blocs/tilt_update_cubit.dart';
import 'package:binary_music_tools/models/historyEntry.dart';
import 'package:binary_music_tools/models/tilt.dart';
import 'package:expandable/expandable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class TiltEntry extends StatelessWidget {
  const TiltEntry({
    Key? key,
    required this.tilt,
  }) : super(key: key);

  final Tilt tilt;

  @override
  Widget build(context) {
    return BlocProvider(
      create: (context) => TiltUpdateCubit(
        tiltRepository: context.read<TiltRepository>(),
        signinCubit: context.read<SigninCubit>(),
      ),
      child: BlocBuilder<TiltUpdateCubit, TiltUpdateState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading:
                    Icon(Icons.circle, color: NameParsing.byName(tilt.color)),
                title: Text(tilt.color),
                subtitle: Text(
                  timeago.format(tilt.lastUpdated, clock: DateTime.now()),
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
              ExpandablePanel(
                header: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Gravity: ${tilt.specificGravityPlato.toStringAsFixed(3)} °Plato",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "ABV: ${BeerCalculator.calculateABV(
                          tilt.startingGravityPlato,
                          tilt.specificGravityPlato,
                        ).toStringAsFixed(2)} %",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Temperature: ${tilt.temperature.celsius.toStringAsFixed(2)} °C",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                collapsed: Container(),
                expanded: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Starting Gravity: ${tilt.startingGravityPlato.toStringAsFixed(3)} °Plato",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    _tempChart(
                      context,
                      title: "Temperature",
                      color: Colors.red,
                      unit: "°C",
                      values: _toTimestampCelsiusMap(tilt.history),
                    ),
                    _tempChart(
                      context,
                      title: "Gravity",
                      color: Colors.green,
                      unit: "°Plato",
                      values: _toTimestampPlatoMap(tilt.history),
                    ),
                  ],
                ),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    child: Text('SET STARTING GRAVITY'),
                    onPressed: () => _showUpdateStartingGravityDialog(context),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Map<double, double> _toTimestampCelsiusMap(List<HistoryEntry> entries) {
    return entries.fold(Map<double, double>(), (result, current) {
      result[current.dateTime.millisecondsSinceEpoch.toDouble()] =
          BeerCalculator.fahrenheitToCelsius(
        current.value.temperatureFahrenheit,
      );
      return result;
    });
  }

  Map<double, double> _toTimestampPlatoMap(List<HistoryEntry> entries) {
    return entries.fold(Map<double, double>(), (result, current) {
      result[current.dateTime.millisecondsSinceEpoch.toDouble()] =
          BeerCalculator.sgToPlato(
        current.value.specificGravitySg,
      );
      return result;
    });
  }

  Widget _tempChart(
    BuildContext context, {
    required String title,
    required String unit,
    required Map<double, double> values,
    required Color color,
  }) {
    final locale = Localizations.localeOf(context).languageCode;
    final dateAndTimeFormat = DateFormat.Md(locale).add_Hms();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 400,
            margin: EdgeInsets.only(top: 8),
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    dotData: FlDotData(show: false),
                    colors: [color],
                    spots: values.entries
                        .map((entry) => FlSpot(entry.key, entry.value))
                        .toList(),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) => spots
                        .map(
                          (spot) => LineTooltipItem(
                            "${spot.y.toStringAsFixed(3)} $unit ${dateAndTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(spot.x.toInt()))}",
                            TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) => value.toStringAsPrecision(2),
                    interval: 3,
                    margin: 12,
                  ),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) => dateAndTimeFormat.format(
                      DateTime.fromMillisecondsSinceEpoch(value.toInt()),
                    ),
                    interval:
                        (tilt.history.last.dateTime.millisecondsSinceEpoch -
                                tilt.history.first.dateTime
                                    .millisecondsSinceEpoch) /
                            2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateStartingGravityDialog(BuildContext context) {
    final tiltUpdateCubit = context.read<TiltUpdateCubit>();

    showDialog(
      context: context,
      builder: (context) {
        final _formKey = GlobalKey<FormState>();
        TextEditingController _controller = TextEditingController(
          text: tilt.specificGravityPlato.toStringAsFixed(3),
        );

        return AlertDialog(
          title: Text("Set starting gravity"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Do you want to set the starting gravity to the current value?",
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                  ],
                  validator: (text) {
                    if (text == null || num.tryParse(text) == null) {
                      return "Please enter a valid number.";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Starting Gravity",
                    hintText: "Please enter your starting gravity.",
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Set"),
              onPressed: () {
                tiltUpdateCubit.update(startingGravity: tilt.specificGravitySg);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

extension NameParsing on Color {
  static const Map<String, Color> colors = {
    "black": Colors.black,
    "white": Colors.white,
    "grey": Colors.grey,
    "blue": Colors.blue,
    "green": Colors.green,
    "red": Colors.red,
    "orange": Colors.orange,
    "puple": Colors.purple,
    "pink": Colors.pink,
  };

  static Color byName(String colorName, {Color defaultColor = Colors.grey}) {
    return NameParsing.colors[colorName.toLowerCase()] ?? defaultColor;
  }
}
