import 'package:project/network/network_service.dart';

abstract class OauthApi {
  factory OauthApi() => _OauthApiImpl();

  static const accessTokenPath = 'https://oauth2.googleapis.com/token';
  static const youTubeChannelsPath = 'https://www.googleapis.com/youtube/v3/channels';

  Future<Map<dynamic, dynamic>?> getYouTubeList({required String accessToken});

  Future<String?> getAccessToken(
      {required String clientId,
      required String code,
      String type = 'authorization_code',
      required String redirectUri});
}

class _OauthApiImpl implements OauthApi {
  _OauthApiImpl();

  final NetworkService _networkService = NetworkService();

  @override
  Future<Map<dynamic, dynamic>?> getYouTubeList({required String accessToken}) {
    return _networkService.getRequest(OauthApi.youTubeChannelsPath, headers: {
      'Authorization': 'Bearer $accessToken'
    }, queryParameters: {
      'mine': true,
      'part': 'snippet',
    }, onParse: (result) {
      return result.data;
    });
  }

  @override
  Future<String?> getAccessToken({
    required String clientId,
    required String code,
    String type = 'authorization_code',
    required String redirectUri,
  }) {
    return _networkService.postRequest(OauthApi.accessTokenPath, queryParameters: {
      'client_id': clientId,
      'code': code,
      'grant_type': type,
      'redirect_uri': redirectUri,
    }, onParse: (result) {
      return result.data['access_token'];
    });
  }
}
