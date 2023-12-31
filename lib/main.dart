import 'package:bottom_blur_bar/bottom_blur_bar.dart';
import 'package:django_google/profile_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Google Sign In",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        primaryColor: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        primaryColor: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  PageController pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Sign In"),
      ),
      bottomNavigationBar: BlurNavbar(
        currentIndex: currentIndex,
        selectedColor: Colors.indigo,
        borderRadius: 10.0,
        fontSize: 1.0,
        onTap: (page) {
          setState(() {
            currentIndex = page;
            pageController.jumpToPage(currentIndex);
          });
          print(currentIndex);
        },
        style: BlurEffectStyle.auto,
        items: [
          BlurNavbarItem(icon: const Icon(Icons.messenger), title: ""),
          BlurNavbarItem(icon: const Icon(Icons.image_sharp), title: ""),
          BlurNavbarItem(icon: const Icon(Icons.video_collection), title: ""),
          BlurNavbarItem(icon: const Icon(Icons.person), title: "Account"),
        ],
      ),
      // body: Center(child: Text("-$currentIndex")),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Center(child: Text("-$currentIndex")),
          Center(child: Text("-$currentIndex")),
          Center(child: Text("-$currentIndex")),
          const ProfilePage(),
        ],
      ),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   Map<String, dynamic> data = {};
//   signIn() async {
//     GoogleSignIn googleSignIn = GoogleSignIn(
//       signInOption: SignInOption.standard,
//       clientId:
//           "500184100475-qt59ipm6ia5d0q0u1gn5ct1kbpse55os.apps.googleusercontent.com",
//       scopes: [
//         'email',
//         'profile',
//       ],
//     );
//     googleSignIn.signIn().then((result) {
//       result?.authentication.then((googleKey) async {
//         // print(googleKey.accessToken);
//         print(googleKey.idToken);
//         if (googleKey.idToken != null) {
//           final dio = Dio();
//           Response response = await dio.post(
//               "https://evansw.website/api/auth/google/",
//               data: {"access_token": googleKey.idToken});
//           print(response.data);
//           setState(() {
//             data = response.data;
//           });
//         }
//       }).catchError((err) {
//         print('Error $err');
//       });
//     }).catchError((err) {
//       print('Error occurred outside $err');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Google Sign In"),
//       ),
//       body: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton.icon(
//               onPressed: () async => signIn(),
//               label: const Text("Google"),
//               icon: const Icon(Icons.login),
//             ),
//           ),
//           data.isNotEmpty
//               ? Column(
//                   children: [
//                     // Text("${data}"),
//                     Text("${data["user"]["pk"]}"),
//                     Text("${data["user"]["username"]}"),
//                     Text("${data["user"]["email"]}"),
//                     Text("${data["user"]["first_name"]}"),
//                     Text("${data["user"]["last_name"]}"),
//                     Text("${data["user"]["coins_gold"]}"),
//                     Text("${data["user"]["coins_silver"]}"),
//                     Text("ACCESS: ${data["access"]}"),
//                     Text("REFRESH: ${data["refresh"]}"),
//                   ],
//                 )
//               : const SizedBox.shrink(),
//         ],
//       ),
//     );
//   }
// }

/// ./gradlew signingReport
/// keytool -keystore path-to-debug-or-production-keystore -list -v
/// keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
