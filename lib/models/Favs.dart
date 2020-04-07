
class FavTag {
  int userId;
  int tagId;
  bool isFaved;

  FavTag({this.userId, this.tagId, this.isFaved});

  FavTag.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    tagId = json['TagId'];
    isFaved = json['IsFaved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['TagId'] = this.tagId;
    data['IsFaved'] = this.isFaved;
    return data;
  }
}

class FavImam {
  int userId;
  int imamId;
  bool isFaved;

  FavImam({this.userId, this.imamId, this.isFaved});

  FavImam.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    imamId = json['ImamId'];
    isFaved = json['IsFaved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['ImamId'] = this.imamId;
    data['IsFaved'] = this.isFaved;
    return data;
  }
}