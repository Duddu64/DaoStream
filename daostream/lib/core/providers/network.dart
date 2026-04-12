// lib/core/providers/network_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dart_nostr/dart_nostr.dart';
import '../../data/services/nostr.dart';
import '../../data/services/auth.dart';
import '../../data/repositories/feed.dart';

final nostrInstanceProvider = Provider<Nostr>((ref) {
  return Nostr.instance;
});

final authServiceProvider = Provider<AuthService>((ref) {
  final nostr = ref.read(nostrInstanceProvider);
  return AuthService(nostr);
});

final nostrServiceProvider = Provider<NostrService>((ref) {
  return NostrService(); 
});

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  final nostrService = ref.read(nostrServiceProvider);
  return FeedRepository(nostrService);
});