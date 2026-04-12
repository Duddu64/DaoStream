// lib/data/services/auth_service.dart

import 'package:dart_nostr/dart_nostr.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  
  final Nostr _nostr; 

  AuthService(this._nostr);

  Future<NostrKeyPairs> generateAndSaveAccount() async {
    final keyPair = _nostr.services.keys.generateKeyPair();
    
    await _storage.write(key: 'private_key', value: keyPair.private);
    
    return keyPair;
  }

  Future<NostrKeyPairs?> getLoggedUser() async {
    final privateKey = await _storage.read(key: 'private_key');
    if (privateKey == null) return null;
    
    return _nostr.services.keys.generateKeyPairFromExistingPrivateKey(privateKey);
  }

  Future<void> logout() async {
    await _storage.delete(key: 'private_key');
  }
}