
import 'Tag.dart';
import 'User.dart';


class Audio {
  int id;
  String title;
  String description;
  int length;
  int audioQuality;
  int audioType;
  DateTime audioDateGiven;
  DateTime audioDateAdded;
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
        this.audioDateGiven,
        this.audioDateAdded,
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
    audioDateGiven = DateTime.parse(json['AudioDateGiven']);
    audioDateAdded = DateTime.parse(json['AudioDateAdded']);
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
    data['AudioDateGiven'] = data['AudioDateGiven'] == null ? null:this.audioDateGiven.toUtc().toIso8601String();
    data['AudioDateAdded'] = data['AudioDateAdded'] == null ? null:this.audioDateAdded.toUtc().toIso8601String();
    data['AudioPath'] = this.audioPath;
    if (this.user != null) {
      data['User'] = this.user.toJson();
    }
    if (this.tags != null) {
      data['Tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static String getAudioType (Audio a) {
    switch (a.audioType) {
      case 0:
        return "Khotba";
        break;
      case 1:
        return "Dars";
        break;
      default:
        return "Autre";
        break;
    }
  }
}