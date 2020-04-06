
class Listening {
  int userId;
  int audioId;
  int position;
  DateTime date;

  Listening({this.userId, this.audioId, this.position, this.date});

  Listening.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    audioId = json['AudioId'];
    position = json['Position'];
    date = DateTime.parse(json['Date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['AudioId'] = this.audioId;
    data['Position'] = this.position;
    data['Date'] = this.date == null ? null:this.date.toUtc().toIso8601String();
    return data;
  }
}