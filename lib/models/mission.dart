class Mission {
  int? id;
  String? statut;
  String? createdAt;
  String? map;
  String? adresse;
  String? ville;
  String? name;
  String? typeMission;
  String? tarif;
  int? phase;
  late bool clp;
  late bool moreInfo;
  String? commune;
  String? passage;
  int? messages;
  int? photos;

  Mission(
      {this.id,
      this.statut,
      this.createdAt,
      this.typeMission,
      this.map,
      this.adresse,
      this.name,
      this.ville,
      this.tarif,
      this.phase,
      required this.clp,
      required this.moreInfo,
      this.commune,
      this.passage,
      this.messages,
      this.photos});

  Mission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statut = json['statut'];
    createdAt = json['created_at'];
    typeMission = json['type_mission'];
    map = json['map'];
    adresse = json['adresse'];
    name = json['name'];
    ville = json['ville'];
    tarif = json['tarif'];
    phase = json['phase'];
    clp = json['clp'];
    moreInfo = false;
    commune = json['commune'];
    passage = json['passage'];
    messages = json['messages'];
    photos = json['photos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['statut'] = statut;
    data['created_at'] = createdAt;
    data['type_mission'] = typeMission;
    data['map'] = map;
    data['adresse'] = adresse;
    data['name'] = name;
    data['ville'] = ville;
    data['tarif'] = tarif;
    data['phase'] = phase;
    data['moreInfo'] = moreInfo;
    data['commune'] = commune;
    data['clp'] = clp;
    data['passage'] = passage;
    data['messages'] = messages;
    data['photos'] = photos;
    return data;
  }
}
