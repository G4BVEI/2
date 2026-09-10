/// A purely local representation of the "logged in" user.
///
/// There is no backend involved anywhere in this app — this object just
/// holds whatever Facebook handed back to the client after login so we can
/// display it. Nothing here is persisted or sent anywhere.
class FakeUser {
  final String id;
  final String name;
  final String? email;
  final String? pictureUrl;

  /// O "link" que o Facebook devolve no getUserData — aponta para o
  /// perfil público do usuário (ex: facebook.com/1234567890).
  final String? profileUrl;

  const FakeUser({
    required this.id,
    required this.name,
    this.email,
    this.pictureUrl,
    this.profileUrl,
  });
}
