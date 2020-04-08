
class AudioInfo {
  Listening listening;
  bool isTbl;

  AudioInfo({this.listening, this.isTbl});

  AudioInfo.fromJson(Map<String, dynamic> json) {
    listening = json['Listening'] != null
        ? new Listening.fromJson(json['Listening'])
        : null;
    isTbl = json['IsTbl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listening != null) {
      data['Listening'] = this.listening.toJson();
    }
    data['IsTbl'] = this.isTbl;
    return data;
  }
}

class ListeningQueueItem {
  int userId;
  int audioId;

  ListeningQueueItem({this.userId, this.audioId});

  ListeningQueueItem.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    audioId = json['AudioId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['AudioId'] = this.audioId;
    return data;
  }
}

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