class Discussion {
  int? id;
  late String texte;
  bool? isSender;

  Discussion({
    this.id,
    required this.texte,
    this.isSender,
  });

  Discussion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    texte = json['texte'];
    isSender = json['isSender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['texte'] = texte;
    data['isSender'] = isSender;

    return data;
  }
}
