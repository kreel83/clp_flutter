class Collecte {
  int? id;
  int? statut;
  String? status;
  String? createdAt;
  int? numeroCollecte;
  String? total;

  Collecte(
      {this.id,
      this.statut,
      this.status,
      this.createdAt,
      this.numeroCollecte,
      this.total});

  Collecte.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statut = json['statut'];
    status = json['status'];
    createdAt = json['created_at'];
    numeroCollecte = json['numero_collecte'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['statut'] = statut;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['numero_collecte'] = numeroCollecte;
    data['total'] = total;
    return data;
  }
}
