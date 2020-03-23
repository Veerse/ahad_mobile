
class Announcement {
  int id;
  String announcementTitle;
  String announcementBody;
  DateTime announcementStartDate;
  DateTime announcementEndDate;

  Announcement(
      {this.id,
        this.announcementTitle,
        this.announcementBody,
        this.announcementStartDate,
        this.announcementEndDate});

  Announcement.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    announcementTitle = json['AnnouncementTitle'];
    announcementBody = json['AnnouncementBody'];
    announcementStartDate = DateTime.parse(json['AnnouncementStartDate']);
    announcementEndDate = DateTime.parse(json['AnnouncementEndDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['AnnouncementTitle'] = this.announcementTitle;
    data['AnnouncementBody'] = this.announcementBody;
    data['AnnouncementStartDate'] = this.announcementStartDate == null ? null:this.announcementStartDate.toUtc().toIso8601String();
    data['AnnouncementEndDate'] = this.announcementEndDate == null ? null:this.announcementEndDate.toUtc().toIso8601String();
    return data;
  }
}