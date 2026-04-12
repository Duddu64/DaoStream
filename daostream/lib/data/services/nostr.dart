
import 'package:dart_nostr/dart_nostr.dart';

class NostrService {
  final Nostr _nostr = Nostr.instance;

  Future<void> initRelays() async {
    await _nostr.services.relays.init(  
      relaysUrl: const [
        'wss://relay.damus.io',
        'wss://nos.lol',
        'wss://relay.nostr.band',
      ],
    );
  }

  Stream<NostrEvent> startManhuaSubscription() {
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

  Future<void> publishPost(String content, NostrKeyPairs userKeys) async {
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