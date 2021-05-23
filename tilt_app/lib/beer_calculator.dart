class BeerCalculator {
  static const List<List<double>> _densityTable = [
    //   0°C
    [1.0002, 1.0204, 1.0418, 1.0632, 1.0851, 1.1088, 1.1323, 1.1574, 1.1840],
    //  10°C
    [0.9997, 1.0196, 1.0402, 1.0614, 1.0835, 1.1064, 1.1301, 1.1547, 1.1802],
    //  20°C
    [0.9982, 1.0178, 1.0381, 1.0591, 1.0810, 1.1035, 1.1270, 1.1513, 1.1764],
    //  30°C
    [0.9957, 1.0151, 1.0353, 1.0561, 1.0777, 1.1000, 1.1232, 1.1473, 1.1723],
    //  40°C
    [0.9922, 1.0116, 1.0316, 1.0522, 1.0737, 1.0958, 1.1189, 1.1428, 1.1676],
    //  50°C
    [0.9881, 1.0072, 1.0271, 1.0477, 1.0690, 1.0910, 1.1140, 1.1377, 1.1624],
    //  60°C
    [0.9832, 1.0023, 1.0221, 1.0424, 1.0636, 1.0856, 1.1085, 1.1321, 1.1568],
    //  70°C
    [0.9778, 0.9968, 1.0165, 1.0368, 1.0579, 1.0798, 1.1026, 1.1262, 1.1507],
    //  80°C
    [0.9718, 0.9908, 1.0104, 1.0306, 1.0517, 1.0735, 1.0963, 1.1198, 1.1443],
    //  90°C
    [0.9653, 0.9842, 1.0038, 1.0240, 1.0450, 1.0669, 1.0896, 1.1130, 1.1375],
    //  99°C
    [0.9591, 0.9780, 0.9975, 1.0176, 1.0386, 1.0606, 1.0832, 1.1065, 1.1309],
    // 100°C
    [0.9584, 0.9773, 0.9968, 1.0169, 1.0379, 1.0599, 1.0825, 1.1058, 1.1301],
  ];

  static double _interpolate(double x1, double y1, double x2, double y2,
      double x3, double y3, double x4, double y4, double x) {
    return y1 *
            (((x - x2) * (x - x3) * (x - x4)) /
                ((x1 - x2) * (x1 - x3) * (x1 - x4))) +
        y2 *
            (((x - x1) * (x - x3) * (x - x4)) /
                ((x2 - x1) * (x2 - x3) * (x2 - x4))) +
        y3 *
            (((x - x1) * (x - x2) * (x - x4)) /
                ((x3 - x1) * (x3 - x2) * (x3 - x4))) +
        y4 *
            (((x - x1) * (x - x2) * (x - x3)) /
                ((x4 - x1) * (x4 - x2) * (x4 - x3)));
  }

  static List<double> _interpolateTemperature(double temperature) {
    var result = new List<double>();
    var lowest = ((temperature / 10) - 1).floor();

    if (0 > lowest) {
      lowest = 0;
    }

    if (lowest > _densityTable.length - 4) {
      lowest = _densityTable.length - 4;
    }

    var temp1 = lowest;
    var temp2 = lowest + 1;
    var temp3 = lowest + 2;
    var temp4 = lowest + 3;

    for (int i = 0; i < _densityTable[0].length; i++) {
      result.add(_interpolate(
          (temp1 * 10).toDouble(),
          _densityTable[temp1][i],
          (temp2 * 10).toDouble(),
          _densityTable[temp2][i],
          (temp3 * 10).toDouble(),
          _densityTable[temp3][i],
          (temp4 * 10).toDouble(),
          _densityTable[temp4][i],
          temperature));
    }

    return result;
  }

  static double _densityAtBaseTemp(base, plato) {
    var densityBase = _interpolateTemperature(base);

    var lowest = ((plato / 5) - 1).floor();
    if (0 > lowest) {
      lowest = 0;
    }
    if (lowest > densityBase.length - 4) {
      lowest = densityBase.length - 4;
    }

    int plato1 = lowest;
    int plato2 = lowest + 1;
    int plato3 = lowest + 2;
    int plato4 = lowest + 3;

    return _interpolate(
        (plato1 * 5).toDouble(),
        densityBase[plato1],
        (plato2 * 5).toDouble(),
        densityBase[plato2],
        (plato3 * 5).toDouble(),
        densityBase[plato3],
        (plato4 * 5).toDouble(),
        densityBase[plato4],
        plato);
  }

  static double _densityAtTemp(
      double platoMeasure, double temperature, double calibrationTemp) {
    double dAt20 = _densityAtBaseTemp(calibrationTemp, platoMeasure);
    List<double> temp = _interpolateTemperature(temperature);

    // find density interval
    double minimalIndex = 0;
    for (int i = 0; i < temp.length; i++) {
      if (dAt20 > temp[i]) {
        minimalIndex = i.toDouble();
      }
    }

    double lowest = minimalIndex - 1;
    if (0 > lowest) {
      lowest = 0;
    }

    if (lowest > temp.length - 4) {
      lowest = (temp.length - 4).toDouble();
    }

    int plato1 = lowest.toInt();
    int plato2 = (lowest + 1).toInt();
    int plato3 = (lowest + 2).toInt();
    int plato4 = (lowest + 3).toInt();

    return _interpolate(
        temp[plato1],
        (plato1 * 5).toDouble(),
        temp[plato2],
        (plato2 * 5).toDouble(),
        temp[plato3],
        (plato3 * 5).toDouble(),
        temp[plato4],
        (plato4 * 5).toDouble(),
        dAt20);
  }

  static double correctWort(
      double measuredWort, double temp, double calibratedTemp) {
    return _densityAtTemp(measuredWort, temp, calibratedTemp);
  }

  static double approximateABV(double originalWort) {
    return originalWort / 2.4;
  }

  static double calculateABV(double originalWort, double restWort) {
    var realExtract =
        (1 - (0.81 * (originalWort - restWort) / originalWort)) * originalWort;
    var alcWeight =
        (realExtract - originalWort) / ((1.0665 * originalWort / 100) - 2.0665);

    return alcWeight / 0.795;
  }

  static double calculateRealFermentation(double originalWort, double restWort) {
    return 81 * (1 - (restWort / originalWort));
  }

  static double calculateApparantFermentation(double originalWort, double restWort) {
    return 100 * (1 - (restWort / originalWort));
  }
}
