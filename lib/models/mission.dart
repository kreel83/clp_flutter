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
  late bool moreInfo;
  String? commune;

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
      required this.moreInfo,
      this.commune});

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
    moreInfo = false;
    commune = json['commune'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['statut'] = this.statut;
    data['created_at'] = this.createdAt;
    data['type_mission'] = this.typeMission;
    data['map'] = this.map;
    data['adresse'] = this.adresse;
    data['name'] = this.name;
    data['ville'] = this.ville;
    data['tarif'] = this.tarif;
    data['phase'] = this.phase;
    data['moreInfo'] = this.moreInfo;
    data['commune'] = this.commune;
    return data;
  }
}
