// ignore: camel_case_types
class Depot {
  String? documentName;
  String? date;
  String? rep;
  int? w;
  int? h;
  String? url;
  String? mainurl;
  String? folder;
  String? type;
  bool? deletable;
  String? ext;
  int? missionId;

  Depot(
      {this.documentName,
      this.date,
      this.rep,
      this.w,
      this.h,
      this.url,
      this.mainurl,
      this.folder,
      this.type,
      this.deletable,
      this.ext,
      this.missionId});

  Depot.fromJson(Map<String, dynamic> json) {
    documentName = json['document_name'];
    date = json['date'];
    rep = json['rep'];
    w = json['w'];
    h = json['h'];
    url = json['url'];
    mainurl = json['mainurl'];
    folder = json['folder'];
    type = json['type'];
    deletable = json['deletable'];
    ext = json['ext'];
    missionId = json['mission_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['document_name'] = documentName;
    data['date'] = date;
    data['rep'] = rep;
    data['w'] = w;
    data['h'] = h;
    data['url'] = url;
    data['mainurl'] = mainurl;
    data['folder'] = folder;
    data['type'] = type;
    data['deletable'] = deletable;
    data['ext'] = ext;
    data['mission_id'] = missionId;
    return data;
  }
}
