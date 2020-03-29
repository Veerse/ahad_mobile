
import 'Tag.dart';
import 'User.dart';

class Audio {
  int id;
  String title;
  String description;
  int length;
  int audioQuality;
  int audioType;
  DateTime audioDate;
  String audioPath;
  User user;
  List<Tag> tags;

  Audio(
      {this.id,
        this.title,
        this.description,
        this.length,
        this.audioQuality,
        this.audioType,
        this.audioDate,
        this.audioPath,
        this.user,
        this.tags});

  Audio.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    description = json['Description'];
    length = json['Length'];
    audioQuality = json['AudioQuality'];
    audioType = json['AudioType'];
    audioDate = DateTime.parse(json['AudioDate']);
    audioPath = json['AudioPath'];
    user = json['User'] != null ? new User.fromJson(json['User']) : null;
    if (json['Tags'] != null) {
      tags = new List<Tag>();
      json['Tags'].forEach((v) {
        tags.add(new Tag.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Title'] = this.title;
    data['Description'] = this.description;
    data['Length'] = this.length;
    data['AudioQuality'] = this.audioQuality;
    data['AudioType'] = this.audioType;
    data['AudioDate'] = data['Birth'] == null ? null:this.audioDate.toUtc().toIso8601String();
    data['AudioPath'] = this.audioPath;
    if (this.user != null) {
      data['User'] = this.user.toJson();
    }
    if (this.tags != null) {
      data['Tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    return data;
  }
}