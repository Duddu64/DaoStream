class UserProfileEntity {
  final String pubKey; 
  final String name;
  final String? displayName;
  final String? about;
  final String? pictureUrl; 
  final String? bannerUrl;
  final String? nip05; 

  UserProfileEntity({
    required this.pubKey,
    required this.name,
    this.displayName,
    this.about,
    this.pictureUrl,
    this.bannerUrl,
    this.nip05,
  });
}