class OauthUtils {

  static String params2qs(Map params) {
    final qsList = <String>[];

    params.forEach((k, v) {
      String val;
      if (v is List) {
        val = v.map((p) => p.trim()).join(' ');
      } else {
        val = v.trim();
      }
      qsList.add(k + '=' + Uri.encodeComponent(val));
      // qsList.add(k + '=' + val);
    });

    return qsList.join('&');
  }

  static String addParamsToUrl(String url, Map params) {
    var qs = params2qs(params);

    if (qs.isNotEmpty) url = '$url?$qs';

    return url;
  }
}
