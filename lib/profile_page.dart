import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<Map<String, dynamic>>? future;
  Future<Map<String, dynamic>> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("user");
    Map<String, dynamic> data = jsonDecode(user ?? "") ?? {};
    return data;
  }

  @override
  void initState() {
    future = init();
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
        FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  // child: Text(
                  //   snapshot.error.toString(),
                  // ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Please Sign In"),
                      const SizedBox(height: 30),
                      const Text("ERROR:"),
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasData && snapshot.data != {}) {
                Map<String, dynamic>? data = snapshot.data;
                return ListView(
                  shrinkWrap: true,
                  children: [
                    ExpansionTile(
                      title: const Text("User"),
                      initiallyExpanded: true,
                      children: [
                        ListTile(
                          title: const Text("User Id"),
                          subtitle: Text("${data?["user"]["pk"]}"),
                          trailing: IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: "${data?["user"]["pk"]}"));
                              },
                              icon: const Icon(Icons.copy)),
                        ),
                        ListTile(
                          title: const Text("Username"),
                          subtitle: Text("${data?["user"]["username"]}"),
                          trailing: IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: "${data?["user"]["username"]}"));
                              },
                              icon: const Icon(Icons.copy)),
                        ),
                        ListTile(
                          title: const Text("Email"),
                          subtitle: Text("${data?["user"]["email"]}"),
                          trailing: IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: "${data?["user"]["email"]}"));
                              },
                              icon: const Icon(Icons.copy)),
                        ),
                        ListTile(
                          title: const Text("First Name"),
                          subtitle: Text("${data?["user"]["first_name"]}"),
                          trailing: IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: "${data?["user"]["first_name"]}"));
                              },
                              icon: const Icon(Icons.copy)),
                        ),
                        ListTile(
                          title: const Text("Last Name"),
                          subtitle: Text("${data?["user"]["last_name"]}"),
                          trailing: IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: "${data?["user"]["last_name"]}"));
                              },
                              icon: const Icon(Icons.copy)),
                        ),
                        ListTile(
                          title: const Text("Gold Coins"),
                          subtitle: Text("${data?["user"]["coins_gold"]}"),
                          trailing: IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: "${data?["user"]["coins_gold"]}"));
                              },
                              icon: const Icon(Icons.copy)),
                        ),
                        ListTile(
                          title: const Text("Silver Coins"),
                          subtitle: Text("${data?["user"]["coins_silver"]}"),
                          trailing: IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: "${data?["user"]["coins_silver"]}"));
                              },
                              icon: const Icon(Icons.copy)),
                        ),
                        ListTile(
                          title: const Text("Acess"),
                          subtitle: Text("${data?["access"]}"),
                          trailing: IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: "${data?["access"]}"));
                              },
                              icon: const Icon(Icons.copy)),
                        ),
                        ListTile(
                          title: const Text("Refresh"),
                          subtitle: Text("${data?["refresh"]}"),
                          trailing: IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: "${data?["refresh"]}"));
                              },
                              icon: const Icon(Icons.copy)),
                        ),
                        // ListTile(
                        //   title: Text("User Id"),
                        //   subtitle: ,
                        //   trailing: IconButton(onPressed: (){
                        //     Clipboard.setData(ClipboardData(text: ));
                        //   }, icon: Icon(Icons.copy)),
                        // ),
                      ],
                    ),
                  ],
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ],
    );
  }
}
