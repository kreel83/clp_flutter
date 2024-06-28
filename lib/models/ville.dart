// ignore_for_file: non_constant_identifier_names

class Ville {
  String? CodeCom;
  String? Vconame;
  String? CodePostal;

  Ville({this.CodeCom, this.Vconame, this.CodePostal});

  Ville.fromJson(Map<String, dynamic> json) {
    CodeCom = json['CODE_COM'];
    Vconame = json['VCO_NAME'];
    CodePostal = json['Code_postal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CODE_COM'] = CodeCom;
    data['VCO_NAME'] = Vconame;
    data['Code_postal'] = CodePostal;
    return data;
  }
}
