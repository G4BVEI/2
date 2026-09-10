import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../models/fake_user.dart';
import 'home_screen.dart';

/// "Fake" login screen.
///
/// There is no backend: we call the Facebook SDK directly from the client,
/// pull the user's name (and picture/email if granted) from the Facebook
/// Graph API response, and hold it in memory for the rest of the session.
/// Nothing is stored or transmitted to any server of ours.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  Future<void> _loginWithFacebook() async {
    setState(() => _isLoading = true);

    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: const ['public_profile', 'email', 'user_link'],
      );

      if (!mounted) return;

      switch (result.status) {
        case LoginStatus.success:
          // Pull just the profile fields we need — name, email, picture,
          // and "link" (the URL to the user's own Facebook profile).
          final userData = await FacebookAuth.instance.getUserData(
            fields: "id,name,email,picture.width(200),link",
          );

          final id = userData['id'] as String? ?? '';
          final profileUrl = userData['link'] as String?;

          final fakeUser = FakeUser(
            id: id,
            name: userData['name'] as String? ?? 'Facebook User',
            email: userData['email'] as String?,
            pictureUrl: userData['picture']?['data']?['url'] as String?,
            profileUrl: profileUrl,
          );

          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => HomeScreen(user: fakeUser),
            ),
          );
          break;

        case LoginStatus.cancelled:
          _showMessage('Login cancelled.');
          break;

        case LoginStatus.failed:
          _showMessage('Login failed: ${result.message ?? 'unknown error'}');
          break;

        default:
          _showMessage('Something went wrong. Please try again.');
      }
    } catch (e) {
      _showMessage('Error logging in: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_people, size: 96, color: Colors.blueAccent),
                const SizedBox(height: 24),
                const Text(
                  'Conviva',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _loginWithFacebook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1877F2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.facebook),
                    label: Text(
                      _isLoading ? 'Signing in...' : 'Continue with Facebook',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No account is created on any server —\nwe just read your name from Facebook.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
