enum InteractionType { like, repost, zap }

class InteractionEntity {
  final String eventId; 
  final String targetEventId; // O Post ou Capitulo que recebeu a reacao
  final String senderPubKey;
  final InteractionType type; 
  final int? zapAmountSats; 

  InteractionEntity({
    required this.eventId,
    required this.targetEventId,
    required this.senderPubKey,
    required this.type,
    this.zapAmountSats,
  });
}