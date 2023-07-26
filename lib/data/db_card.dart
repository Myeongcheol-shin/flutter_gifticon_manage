class DbCard {
  int? id;
  final String name, info;
  final String? couponNumber;
  final String? file;
  final int color;

  DbCard(
      {this.id,
      required this.name,
      required this.info,
      required this.couponNumber,
      required this.file,
      required this.color});

  factory DbCard.fromMap(Map<String, dynamic> json) => DbCard(
      id: json['id'],
      color: json['color'],
      name: json['name'],
      info: json['info'],
      couponNumber: json['couponNumber'],
      file: json['file']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'info': info,
      'couponNumber': couponNumber,
      'file': file,
      'color': color
    };
  }
}
