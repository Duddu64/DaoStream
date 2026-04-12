// lib/data/models/manhua_model.dart

import '../../domain/entities/book.dart';
import '../../domain/entities/genre.dart';
import 'package:dart_nostr/dart_nostr.dart';

class ManhuaModel extends ManhuaEntity {
  ManhuaModel({
    required super.id,
    required super.creatorPubKey,
    required super.title,
    required super.description,
    required super.coverUrl,
    required super.status,
    required super.updatedAt,
    required super.genres,
  });

  factory ManhuaModel.fromNostrEvent(NostrEvent event) {
    String title = 'Desconhecido';
    String description = '';
    String coverUrl = '';
    String status = 'ongoing';
    String identifier = '';
    List<GenreEntity> extractedGenres = [];

    for (var tagList in event.tags!) {
      if (tagList.isEmpty) continue;
      
      final key = tagList[0];
      final value = tagList.length > 1 ? tagList[1] : '';

      switch (key) {
        case 'd': identifier = value; break; // ID único da obra
        case 'title': title = value; break;
        case 'summary': description = value; break;
        case 'image': coverUrl = value; break;
        case 'status': status = value; break;
        case 't': 
          extractedGenres.add(GenreEntity(id: value, name: value));
          break;
      }
    }

    return ManhuaModel(
      id: identifier.isNotEmpty ? identifier : event.id!,
      creatorPubKey: event.pubkey,
      title: title,
      description: description.isEmpty ? event.content! : description,
      coverUrl: coverUrl,
      status: status,
      updatedAt: event.createdAt!,
      genres: extractedGenres,
    );
  }

  Map<String, dynamic> toLocalDatabase() {
    return {
      'id': id,
      'creator_pubkey': creatorPubKey,
      'title': title,
      'description': description,
      'cover_url': coverUrl,
      'status': status,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }
}