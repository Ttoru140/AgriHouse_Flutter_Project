class Fungicide {
  final String name;
  final String activeIngredient;
  final String usage;
  final String applicationTime;
  final String dosage;

  Fungicide(this.name, this.activeIngredient, this.usage, this.applicationTime,
      this.dosage);

  factory Fungicide.fromJson(Map<String, dynamic> json) {
    return Fungicide(
      json['name'],
      json['activeIngredient'],
      json['usage'],
      json['applicationTime'],
      json['dosage'],
    );
  }
}
