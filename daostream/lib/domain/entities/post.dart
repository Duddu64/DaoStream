import 'package:daostream/domain/entities/tag.dart';

class PostEntity {
  final String id; // Hash SHA-256 do evento
  final String authorPubKey;
  final String content;
  final DateTime createdAt;
  final String? replyToEventId;
  final String? referencedManhuaId; 
  final List<TagEntity> tags; // Relacionamento mapeado no dominio

  PostEntity({
    required this.id,
    required this.authorPubKey,
    required this.content,
    required this.createdAt,
    this.replyToEventId,
    this.referencedManhuaId,
    required this.tags,
  });
}