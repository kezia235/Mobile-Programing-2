import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

void main() => runApp(MyApp());

class User {
  final String username;
  final String password;

  User(this.username, this.password);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // Koneksi internet tersedia, lanjut ke halaman login
      navigateToLogin();
    } else {
      // Tidak ada koneksi internet, tampilkan dialog
      showNoConnectionDialog();
    }
  }

  void navigateToLogin() {
    // Pindah ke halaman login
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  void showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bad Connection'),
          content: Text('Try again later when you have a stable connection.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                checkConnectivity();
              },
              child: Text('Retry'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splash Screen Example'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final User _validUser = User('user123', 'password123');
  int _loginAttempts = 0;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _login() {
    String enteredUsername = _usernameController.text;
    String enteredPassword = _passwordController.text;

    if (enteredUsername == _validUser.username &&
        enteredPassword == _validUser.password) {
      // Login berhasil, pindah ke halaman utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Login gagal, tampilkan pesan kesalahan
      _loginAttempts++;

      if (_loginAttempts < 3) {
        // Masih ada kesempatan login, tampilkan pesan kesalahan
        _showErrorDialog('Wrong username or password. Please try again.');
      } else {
        // Melebihi batas maksimal percobaan login, tampilkan dialog reset password
        _showResetPasswordDialog();
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showResetPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Password'),
          content: Text(
              'You have exceeded the maximum login attempts. Would you like to reset your password?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Logika reset password dapat ditambahkan di sini
                _resetPassword();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearLoginAttempts();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _resetPassword() {
    // Logika reset password dapat ditambahkan di sini
    // Contoh: Navigasi ke halaman reset password
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResetPasswordPage()),
    );
  }

  void _clearLoginAttempts() {
    setState(() {
      _loginAttempts = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}

class ResetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password Page'),
      ),
      body: Center(
        child: Text('Welcome to the Reset Password Page!'),
      ),
    );
  }
}
