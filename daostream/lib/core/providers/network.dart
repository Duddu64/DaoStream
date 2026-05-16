import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dart_nostr/dart_nostr.dart';

import '../../data/datasources/nostr_data_source.dart';
import '../../data/services/auth.dart';
import '../../data/repositories/feed.dart';

final nostrInstanceProvider = Provider<Nostr>((ref) => Nostr.instance);

final authServiceProvider = Provider<AuthService>((ref) {
  final nostr = ref.read(nostrInstanceProvider);
  return AuthService(nostr);
});

final nostrDataSourceProvider = Provider<NostrDataSource>((ref) {
  final nostr = ref.read(nostrInstanceProvider);
  return NostrDataSource(nostr: nostr);
});

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  final nostrDataSource = ref.read(nostrDataSourceProvider);
  return FeedRepository(nostrDataSource);
});

