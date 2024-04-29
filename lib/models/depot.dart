class depots {
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

  depots(
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

  depots.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['document_name'] = this.documentName;
    data['date'] = this.date;
    data['rep'] = this.rep;
    data['w'] = this.w;
    data['h'] = this.h;
    data['url'] = this.url;
    data['mainurl'] = this.mainurl;
    data['folder'] = this.folder;
    data['type'] = this.type;
    data['deletable'] = this.deletable;
    data['ext'] = this.ext;
    data['mission_id'] = this.missionId;
    return data;
  }
}
