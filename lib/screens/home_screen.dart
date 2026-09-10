import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/fake_user.dart';
import 'login_screen.dart';

/// Shows the name we pulled from Facebook. Nothing here talks to a backend —
/// logging out just clears the Facebook SDK session and drops us back to
/// the login screen.
class HomeScreen extends StatelessWidget {
  final FakeUser user;

  const HomeScreen({super.key, required this.user});

  Future<void> _logout(BuildContext context) async {
    await FacebookAuth.instance.logOut();
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  /// Abre o perfil do próprio usuário no Facebook, usando o "link"
  /// (user_link) que veio do getUserData lá no login.
  Future<void> _openProfile(BuildContext context) async {
    final url = user.profileUrl;
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não achei o link do seu perfil.')),
      );
      return;
    }

    final uri = Uri.parse(url);
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // abre no app do Facebook, se tiver
    );

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não consegui abrir o perfil.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conviva'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.blue.shade50,
              backgroundImage: user.pictureUrl != null
                  ? NetworkImage(user.pictureUrl!)
                  : null,
              child: user.pictureUrl == null
                  ? const Icon(Icons.person, size: 48, color: Colors.blueAccent)
                  : null,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome, ${user.name}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (user.email != null) ...[
              const SizedBox(height: 8),
              Text(
                user.email!,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed:
                  user.profileUrl != null ? () => _openProfile(context) : null,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Abrir meu perfil no Facebook'),
            ),
          ],
        ),
      ),
    );
  }
}
