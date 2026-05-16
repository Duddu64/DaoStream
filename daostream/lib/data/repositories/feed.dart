import '../../domain/entities/post.dart';
import '../datasources/nostr_data_source.dart';
import '../mappers/post_mapper.dart';

class FeedRepository {
  final NostrDataSource _nostrDataSource;
  final PostMapper _postMapper;

  FeedRepository(
    this._nostrDataSource, {
    PostMapper? postMapper,
  }) : _postMapper = postMapper ?? PostMapper();

  Stream<PostEntity> listenToManhuaFeed() {
    final streamRaw = _nostrDataSource.subscribeManhuaContent();
    return streamRaw.map(_postMapper.fromNostrEvent);
  }
}

