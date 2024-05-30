// import 'package:boilerplate/screens/main/home/notification/notification_screen.dart';
import 'package:boilerplate/commons/enums/enums.dart';
import 'package:boilerplate/services/api_service/decoder.dart';

enum NotificationTab {
  system("Tin tức"),
  customer("Thông báo"),
  ;

  const NotificationTab(this.title);
  final String title;
}

class NotificationModel extends Decoder<NotificationModel>{

  NotificationType get notiType => NotificationType.values.where((element) => element.id == type).firstOrNull ?? NotificationType.system;

  int? createdBy;
  int? updatedBy;
  String? createdDate;
  String? updatedDate;
  int? systemNotificationId;
  String? title;
  String? content;
  dynamic jsonData;
  int? type;
  int? isDeleted;

  NotificationModel(
      {this.createdBy,
        this.updatedBy,
        this.createdDate,
        this.updatedDate,
        this.systemNotificationId,
        this.title,
        this.content,
        this.jsonData,
        this.type,
        this.isDeleted});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
    systemNotificationId = int.tryParse(json['systemNotificationId'].toString());
    title = json['title'];
    content = json['content'];
    jsonData = json['jsonData'];
    type = int.tryParse(json['type'].toString());
    isDeleted = int.tryParse(json['isDeleted'].toString());
  }

  @override
  NotificationModel decode(Map<String, dynamic> json) {
    return NotificationModel.fromJson(json);
  }
}