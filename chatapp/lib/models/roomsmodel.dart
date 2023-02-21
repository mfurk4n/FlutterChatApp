class RoomsModel {
  String? sId;
  String? name;
  int? active;

  RoomsModel({this.sId, this.name, this.active});

  RoomsModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['active'] = this.active;
    return data;
  }
}
