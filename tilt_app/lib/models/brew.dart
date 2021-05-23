class Brew {
  int? _id;
  final String name;
  final double? wort;
  final double? restWort;
  final double? apparantFerm;
  final double? realFerm;
  final double? abv;

  Brew({
    id,
    required this.name,
    this.wort,
    this.restWort,
    this.apparantFerm,
    this.realFerm,
    this.abv,
  }) : this._id = id;

  int? get id => _id;

  Brew.fromMap(Map<String, dynamic> brew)
      : _id = brew["id"],
        name = brew["name"],
        wort = brew["wort"],
        restWort = brew["rest_wort"],
        apparantFerm = brew["apparant_ferm"],
        realFerm = brew["real_ferm"],
        abv = brew["abv"];

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': name,
      'wort': wort,
      'rest_wort': restWort,
      'apparant_ferm': apparantFerm,
      'real_ferm': realFerm,
      'abv': abv,
    };
  }
}
