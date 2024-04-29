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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['statut'] = this.statut;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['numero_collecte'] = this.numeroCollecte;
    data['total'] = this.total;
    return data;
  }
}
