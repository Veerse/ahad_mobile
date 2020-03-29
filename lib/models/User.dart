
class User {
  int id;
  String firstName;
  String lastName;
  DateTime birth;
  String email;
  bool isMale;
  String pwd;
  String city;
  String country;
  String avatarPath;
  int personType;

  User(
      {this.id,
        this.firstName,
        this.lastName,
        this.birth,
        this.email,
        this.isMale,
        this.pwd,
        this.city,
        this.country,
        this.avatarPath,
        this.personType});

  User.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    birth = DateTime.parse(json['Birth']);
    email = json['Email'];
    isMale = json['IsMale'];
    pwd = json['Pwd'];
    city = json['City'];
    country = json['Country'];
    avatarPath = json['AvatarPath'];
    personType = json['PersonType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['Birth'] = data['Birth'] == null ? null:this.birth.toUtc().toIso8601String();
    data['Email'] = this.email;
    data['IsMale'] = this.isMale;
    data['Pwd'] = this.pwd;
    data['City'] = this.city;
    data['Country'] = this.country;
    data['AvatarPath'] = this.avatarPath;
    data['PersonType'] = this.personType;
    return data;
  }
}
