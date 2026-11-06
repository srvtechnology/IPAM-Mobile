class AlumniNotification {
  final String id;
  final String type; // MESSAGE, INVITATION, NOTIFICATION
  final String? categoryType; // VERIFICATION, ID_CARD, JOB, EVENT, ALERT
  final String title;
  final String message;
  final List<String> channels;
  final DateTime date;
  final String priority; // NORMAL, URGENT, CRITICAL
  final String audienceLabel;
  final String? actionUrl;
  final bool isRead;
  final bool isPersonal;

  AlumniNotification({
    required this.id,
    required this.type,
    this.categoryType,
    required this.title,
    required this.message,
    required this.channels,
    required this.date,
    required this.priority,
    required this.audienceLabel,
    this.actionUrl,
    required this.isRead,
    required this.isPersonal,
  });

  bool get isUrgent => priority == 'URGENT' || priority == 'CRITICAL';

  factory AlumniNotification.fromJson(Map<String, dynamic> json) {
    return AlumniNotification(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'NOTIFICATION',
      categoryType: json['categoryType']?.toString(),
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      channels: json['channels'] is List
          ? List<String>.from((json['channels'] as List).map((e) => e.toString()))
          : <String>[],
      date: DateTime.tryParse(json['date']?.toString() ?? json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      priority: json['priority']?.toString().toUpperCase() ?? 'NORMAL',
      audienceLabel: json['audienceLabel']?.toString() ?? '',
      actionUrl: json['actionUrl']?.toString() ?? json['route']?.toString(),
      isRead: json['isRead'] == true,
      isPersonal: json['isPersonal'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'categoryType': categoryType,
      'title': title,
      'message': message,
      'channels': channels,
      'date': date.toIso8601String(),
      'priority': priority,
      'audienceLabel': audienceLabel,
      'actionUrl': actionUrl,
      'isRead': isRead,
      'isPersonal': isPersonal,
    };
  }

  AlumniNotification copyWith({
    String? id,
    String? type,
    String? categoryType,
    String? title,
    String? message,
    List<String>? channels,
    DateTime? date,
    String? priority,
    String? audienceLabel,
    String? actionUrl,
    bool? isRead,
    bool? isPersonal,
  }) {
    return AlumniNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      categoryType: categoryType ?? this.categoryType,
      title: title ?? this.title,
      message: message ?? this.message,
      channels: channels ?? this.channels,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      audienceLabel: audienceLabel ?? this.audienceLabel,
      actionUrl: actionUrl ?? this.actionUrl,
      isRead: isRead ?? this.isRead,
      isPersonal: isPersonal ?? this.isPersonal,
    );
  }
}

class UserDevice {
  final String id;
  final String platform;
  final String deviceName;
  final String appVersion;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? lastUsedAt;

  UserDevice({
    required this.id,
    required this.platform,
    required this.deviceName,
    required this.appVersion,
    this.isActive = true,
    this.createdAt,
    this.lastUsedAt,
  });

  factory UserDevice.fromJson(Map<String, dynamic> json) {
    return UserDevice(
      id: json['id']?.toString() ?? '',
      platform: json['platform']?.toString() ?? 'android',
      deviceName: json['deviceName']?.toString() ?? 'Mobile Device',
      appVersion: json['appVersion']?.toString() ?? '1.0.0',
      isActive: json['isActive'] == true,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      lastUsedAt: json['lastUsedAt'] != null ? DateTime.tryParse(json['lastUsedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'platform': platform,
      'deviceName': deviceName,
      'appVersion': appVersion,
      'isActive': isActive,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (lastUsedAt != null) 'lastUsedAt': lastUsedAt!.toIso8601String(),
    };
  }
}

