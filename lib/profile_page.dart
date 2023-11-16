import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GoogleSignIn googleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
    clientId:
        "500184100475-qt59ipm6ia5d0q0u1gn5ct1kbpse55os.apps.googleusercontent.com",
    scopes: [
      'email',
      'profile',
    ],
  );

  signIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await googleSignIn.signOut();
    googleSignIn.signIn().then((result) {
      result?.authentication.then((googleKey) async {
        // print(googleKey.accessToken);
        // print(googleKey.idToken);
        if (googleKey.idToken != null) {
          final dio = Dio();
          try {
            Response response = await dio.post(
                "https://evansw.website/api/auth/google/",
                data: {"access_token": googleKey.idToken});
            if (response.statusCode == 200 || response.statusCode == 201) {
              // print(response.data);
              prefs.setString("user", jsonEncode(response.data));
              await checkIfUserIsSignedIn();
            } else {
              if (!mounted) return;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Error! ${response.statusCode}"),
                  content: Text("${response.data}"),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"))
                  ],
                ),
              );
            }
          } catch (err) {
            if (!mounted) return;
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Error!"),
                content: Text("$err"),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"))
                ],
              ),
            );
          }
        }
      }).catchError((err) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error!"),
            content: Text("$err"),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"))
            ],
          ),
        );
        // print('Error $err');
      });
    }).catchError((err) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error!"),
          content: Text("$err"),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"))
          ],
        ),
      );
      // print('Error occurred outside $err');
    });
    await checkIfUserIsSignedIn();
  }

  signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await googleSignIn.signOut().then((value) {
      prefs.clear();
    });
    await checkIfUserIsSignedIn();
  }

  bool loggedIn = false;
  checkIfUserIsSignedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    bool googleSignedIn = await googleSignIn.isSignedIn();
    bool shared = prefs.containsKey("user");
    loggedIn = (googleSignedIn == true && shared == true);
    print("${googleSignedIn} - ${shared}");
    setState(() {});
  }

  @override
  void initState() {
    checkIfUserIsSignedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text("Is signed in: $loggedIn", textAlign: TextAlign.center),
        Builder(
          builder: (context) {
            if (loggedIn) {
              return ElevatedButton.icon(
                onPressed: () async => signOut(),
                label: const Text("Sign Out"),
                icon: const Icon(Icons.logout),
              );
            } else if (!loggedIn) {
              return ElevatedButton.icon(
                onPressed: () async => signIn(),
                label: const Text("Sign In"),
                icon: const Icon(Icons.login),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
