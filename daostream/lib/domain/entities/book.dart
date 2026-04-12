import 'package:daostream/domain/entities/genre.dart';

class ManhuaEntity {
  final String id; 
  final String creatorPubKey;
  final String title;
  final String description;
  final String coverUrl;
  final String status; // 'ongoing', 'completed', 'hiatus'
  final DateTime updatedAt;
  final List<GenreEntity> genres; // Relacionamento mapeado no dominio

  ManhuaEntity({
    required this.id,
    required this.creatorPubKey,
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.status,
    required this.updatedAt,
    required this.genres,
  });
}