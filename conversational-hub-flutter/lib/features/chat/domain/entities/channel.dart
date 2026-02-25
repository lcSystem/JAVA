import 'package:equatable/equatable.dart';

class Channel extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? erpEntityId;
  final String? erpEntityType;
  final DateTime createdAt;

  const Channel({
    required this.id,
    required this.name,
    this.description,
    this.erpEntityId,
    this.erpEntityType,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, description, erpEntityId, erpEntityType, createdAt];
}
