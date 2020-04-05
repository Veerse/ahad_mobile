
class Tag {
  int id;
  String coverPath;
  String tagName;

  Tag({this.id, this.coverPath, this.tagName});

  Tag.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    coverPath = json['CoverPath'];
    tagName = json['TagName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['CoverPath'] = this.coverPath;
    data['TagName'] = this.tagName;
    return data;
  }
}