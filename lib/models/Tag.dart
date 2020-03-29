
class Tag {
  int id;
  String tagName;

  Tag({this.id, this.tagName});

  Tag.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    tagName = json['TagName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['TagName'] = this.tagName;
    return data;
  }
}