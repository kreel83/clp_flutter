import 'dart:convert';

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
  String? parcelle;
  String? coords;
  String? is_projet;
  String? projet;
  String? resume;
  int? depots;
  int? decisions;

  Mission({
    this.id,
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
    this.photos,
    this.parcelle,
    this.coords,
    this.is_projet,
    this.projet,
    this.depots,
    this.decisions,
  });

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
    parcelle = json['parcelle'];
    coords = json['coords'];
    is_projet = json['is_projet'];
    projet = json['projet'];
    depots = json['depots'];
    decisions = json['decisions'];
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
    // ignore: unrelated_type_equality_checks
    data['parcelle'] = parcelle;
    data['coords'] = coords;
    data['is_projet'] = is_projet;
    data['projet'] = projet;
    data['depots'] = 0;
    data['decisions'] = 0;
    return data;
  }
}
