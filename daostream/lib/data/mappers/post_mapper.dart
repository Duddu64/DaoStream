import 'package:dart_nostr/dart_nostr.dart';

import '../../domain/entities/post.dart';
import '../../domain/entities/tag.dart';

class PostMapper {
  PostEntity fromNostrEvent(NostrEvent event) {
    String? replyId;
    String? manhuaId;
    final extractedTags = <TagEntity>[];

    final tags = event.tags ?? const [];
    for (final tagList in tags) {
      if (tagList.isEmpty) continue;

      final key = tagList[0];
      final value = tagList.length > 1 ? tagList[1] : '';

      if (key == 't') {
        extractedTags.add(TagEntity(id: value, name: value));
      } else if (key == 'e') {
        replyId = value;
      } else if (key == 'a') {
        if (value.startsWith('30000:')) {
          manhuaId = value.split(':').last;
        }
      }
    }

    return PostEntity(
      id: event.id!,
      authorPubKey: event.pubkey,
      content: event.content!,
      createdAt: event.createdAt!,
      replyToEventId: replyId,
      referencedManhuaId: manhuaId,
      tags: extractedTags,
    );
  }
}

