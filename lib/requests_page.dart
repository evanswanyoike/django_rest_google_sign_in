import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
              children: [
                ExpansionTile(
                  title: const Text("User"),
                  initiallyExpanded: false,
                  children: [
                    ListTile(
                      title: const Text("User Id"),
                      subtitle: Text("${data?["user"]["pk"]}"),
                      trailing: IconButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: "${data?["user"]["pk"]}"));
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
        });
  }
}
