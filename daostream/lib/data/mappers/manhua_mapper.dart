import 'package:dart_nostr/dart_nostr.dart';

import '../../domain/entities/genre.dart';
import '../../domain/entities/book.dart';

class ManhuaMapper {
  ManhuaEntity fromNostrEvent(NostrEvent event) {
    String title = 'Desconhecido';
    String description = '';
    String coverUrl = '';
    String status = 'ongoing';
    String identifier = '';

    final extractedGenres = <GenreEntity>[];

    final tags = event.tags ?? const [];
    for (final tagList in tags) {
      if (tagList.isEmpty) continue;

      final key = tagList[0];
      final value = tagList.length > 1 ? tagList[1] : '';

      switch (key) {
        case 'd':
          identifier = value;
          break;
        case 'title':
          title = value;
          break;
        case 'summary':
          description = value;
          break;
        case 'image':
          coverUrl = value;
          break;
        case 'status':
          status = value;
          break;
        case 't':
          extractedGenres.add(GenreEntity(id: value, name: value));
          break;
      }
    }

    return ManhuaEntity(
      id: identifier.isNotEmpty ? identifier : event.id!,
      creatorPubKey: event.pubkey,
      title: title,
      description: description.isEmpty ? (event.content ?? '') : description,
      coverUrl: coverUrl,
      status: status,
      updatedAt: event.createdAt!,
      genres: extractedGenres,
    );
  }
}

