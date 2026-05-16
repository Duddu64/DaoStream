import 'package:dart_nostr/dart_nostr.dart';

/// Data source responsável por se comunicar com o Nostr.
///
/// Mantém somente detalhes de infra/protocolo: init de relays, subscribe e publish.
class NostrDataSource {
  final Nostr _nostr;

  NostrDataSource({Nostr? nostr}) : _nostr = nostr ?? Nostr.instance;

  Future<void> initRelays() async {
    await _nostr.services.relays.init(
      relaysUrl: const [
        'wss://relay.damus.io',
        'wss://nos.lol',
        'wss://relay.nostr.band',
      ],
    );
  }

  Stream<NostrEvent> subscribeManhuaContent() {
    final request = NostrRequest(
      filters: [
        NostrFilter(
          kinds: const [1],
          t: const ['manhua', 'manga', 'webtoon'],
          limit: 50,
        ),
      ],
    );

    final subscription = _nostr.services.relays.startEventsSubscription(
      request: request,
    );

    return subscription.stream;
  }

  Future<void> publishPost({
    required String content,
    required NostrKeyPairs userKeys,
  }) async {
    final event = NostrEvent.fromPartialData(
      kind: 1,
      content: content,
      keyPairs: userKeys,
      tags: [
        ['t', 'manhua'],
      ],
    );

    await _nostr.services.relays.sendEventToRelaysAsync(
      event,
      timeout: const Duration(seconds: 5),
    );
  }
}

