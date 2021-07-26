import 'package:binary_music_tools/beer_calculator.dart';
import 'package:binary_music_tools/models/historyEntry.dart';
import 'package:binary_music_tools/models/temperature.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tilt.g.dart';

@JsonSerializable()
class Tilt {
  final String color;
  final Temperature temperature;
  final DateTime lastUpdated;
  final List<HistoryEntry> history;

  @JsonKey(name: "startingGravity")
  final double startingGravitySg;

  @JsonKey(name: "specificGravity")
  final double specificGravitySg;

  double get startingGravityPlato =>
      BeerCalculator.sgToPlato(startingGravitySg);

  double get specificGravityPlato =>
      BeerCalculator.sgToPlato(specificGravitySg);

  Tilt({
    required this.color,
    required this.lastUpdated,
    required this.temperature,
    required this.startingGravitySg,
    required this.specificGravitySg,
    required this.history,
  });

  factory Tilt.fromDto(
    String color,
    String timestamp,
    Map<String, dynamic> dto,
  ) =>
      Tilt(
        color: color,
        temperature: Temperature.fromJson(dto["temperature"]),
        lastUpdated: DateTime.parse(timestamp),
        specificGravitySg: dto["specificGravity"]?.toDouble(),
        startingGravitySg: dto["startingGravity"]?.toDouble() ??
            dto["specificGravity"]?.toDouble(),
        history: dto["history"]
            .map<HistoryEntry>(
              (jsonObject) => HistoryEntry.fromJson(jsonObject),
            )
            .toList(),
      );

  factory Tilt.fromJson(Map<String, dynamic> json) => _$TiltFromJson(json);

  Map<String, dynamic> toJson() => _$TiltToJson(this);
}
