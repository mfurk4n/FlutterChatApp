class RoomModel {
  String? sId;
  String? from;
  String? to;
  String? message;
  String? createdAt;

  RoomModel({this.sId, this.from, this.to, this.message, this.createdAt});

  RoomModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    from = json['from'];
    to = json['to'];
    message = json['message'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['from'] = this.from;
    data['to'] = this.to;
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
