// lib/data/repositories/feed_repository.dart

import '../../domain/entities/post.dart';
import '../models/post.dart';
import '../services/nostr.dart';

class FeedRepository {
  final NostrService _nostrService;

  FeedRepository(this._nostrService);

  Stream<PostEntity> listenToManhuaFeed() {
    
    final streamBruta = _nostrService.startManhuaSubscription();

    return streamBruta.map((nostrEvent) {
      return PostModel.fromNostrEvent(nostrEvent);
    });
  }
}