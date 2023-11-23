import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class AuthResult {
  final bool isAuthenticated;
  final String? username;

  AuthResult({required this.isAuthenticated, this.username});
}

class SuccessPage extends StatelessWidget {
  Future<AuthResult> _checkAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('authToken');
    String? username = prefs.getString('username');
    return AuthResult(isAuthenticated: token != null, username: username);
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthResult>(
      future: _checkAuthentication(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData || !snapshot.data!.isAuthenticated) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            _logout(context);
          });
          return SizedBox.shrink();
        }

        String welcomeMessage = snapshot.data!.username != null ? 'Bienvenue, ${snapshot.data!.username}' : 'Bienvenue';

        return Scaffold(
          appBar: AppBar(
            title: Text(welcomeMessage),
            backgroundColor: Colors.green,
            actions: [
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () => _logout(context),
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check_circle_outline,
                  size: 100.0,
                  color: Colors.green,
                ),
                Text(
                  'Connexion Réussie!',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
