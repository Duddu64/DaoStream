import '../../domain/entities/post.dart';
import '../../domain/entities/tag.dart';
import 'package:dart_nostr/dart_nostr.dart'; 

class PostModel extends PostEntity {
  PostModel({
    required super.id,
    required super.authorPubKey,
    required super.content,
    required super.createdAt,
    super.replyToEventId,
    super.referencedManhuaId,
    required super.tags,
  });

  factory PostModel.fromNostrEvent(NostrEvent event) {
    String? replyId;
    String? manhuaId;
    List<TagEntity> extractedTags = [];

    for (var tagList in event.tags!) {
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

    return PostModel(
      id: event.id!,
      authorPubKey: event.pubkey,
      content: event.content!,
      createdAt: event.createdAt!,
      replyToEventId: replyId,
      referencedManhuaId: manhuaId,
      tags: extractedTags,
    );
  }

  Map<String, dynamic> toLocalDatabase() {
    return {
      'id': id,
      'author_pubkey': authorPubKey,
      'content': content,
      'created_at': createdAt.millisecondsSinceEpoch,
      'reply_to_event_id': replyToEventId,
      'referenced_manhua_id': referencedManhuaId,
    };
  }
}