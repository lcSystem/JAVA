import '../../domain/entities/channel.dart';

class ChannelModel extends Channel {
  const ChannelModel({
    required super.id,
    required super.name,
    super.description,
    super.erpEntityId,
    super.erpEntityType,
    required super.createdAt,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      erpEntityId: json['erpEntityId'],
      erpEntityType: json['erpEntityType'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'erpEntityId': erpEntityId,
      'erpEntityType': erpEntityType,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
