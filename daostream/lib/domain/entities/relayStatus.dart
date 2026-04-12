enum RelayStatus { connected, disconnected, connecting, error }

class RelayEntity {
  final String url; 
  final bool isReadEnabled; 
  final bool isWriteEnabled; 
  final RelayStatus status;

  RelayEntity({
    required this.url,
    this.isReadEnabled = true,
    this.isWriteEnabled = true,
    required this.status,
  });
}