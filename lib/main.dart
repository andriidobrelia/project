import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:project/network/oauth_api.dart';
import 'package:project/utils/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: MainPage(title: 'Youtube'),
      );
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const clientId = '364526299251-vn7vb1ogbt8e3vigfiiofpncjav6bmem.apps.googleusercontent.com';
  static const scopes = ['https://www.googleapis.com/auth/youtube'];
  static const redirectUri = 'com.example.project:/oauth2redirect';
  static const customUriScheme = 'com.example.project';
  static const baseUrl = 'https://accounts.google.com/o/oauth2/v2/auth';

  Future<void> init() async {

    final url = buildAuthorizationUrl(
      clientId: clientId,
      redirectUri: redirectUri,
      scopes: scopes,
    );

    final authenticateResult = await FlutterWebAuth.authenticate(callbackUrlScheme: customUriScheme, url: url);

    final decodedAuthenticateResult = Uri.decodeFull(authenticateResult).replaceAll('#', '?');
    final uri = Uri.parse(decodedAuthenticateResult);
    final code = uri.queryParameters['code'];

    OauthApi api = OauthApi();
    final accessToken = await api.getAccessToken(clientId: clientId, code: code!, redirectUri: redirectUri);

    final channels = await api.getYouTubeList(accessToken: accessToken!);
    print('$channels');

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text('Youtube'),
      ),
    );
  }

  String buildAuthorizationUrl({
    required String clientId,
    String? redirectUri,
    List<String>? scopes,
  }) {
    final params = <String, dynamic>{
      'response_type': 'code',
      'client_id': clientId,
      'scope': scopes,
      'redirect_uri': redirectUri,
    };

    return OauthUtils.addParamsToUrl(baseUrl, params);
  }
}
