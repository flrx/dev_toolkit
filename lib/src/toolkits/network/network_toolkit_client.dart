import 'dart:async';
import 'dart:io';

import 'package:dev_toolkit/src/toolkits/network/network_toolkit_client_request.dart';
import 'package:uuid/uuid.dart';

class NetworkToolkitClient implements HttpClient {
  final HttpClient? client;

  Uuid _uuid = Uuid();

  NetworkToolkitClient(this.client);

  @override
  Duration idleTimeout = const Duration(seconds: 15);

  @override
  Duration? connectionTimeout;

  @override
  int? maxConnectionsPerHost;

  @override
  bool autoUncompress = true;

  @override
  String? userAgent;

  @override
  Future<HttpClientRequest> open(
    String method,
    String host,
    int port,
    String path,
  ) =>
      withInterceptor(client!.open(method, host, port, path));

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) =>
      withInterceptor(client!.openUrl(method, url));

  @override
  Future<HttpClientRequest> get(String host, int port, String path) =>
      open('get', host, port, path);

  @override
  Future<HttpClientRequest> getUrl(Uri url) => openUrl('get', url);

  @override
  Future<HttpClientRequest> post(String host, int port, String path) =>
      open('post', host, port, path);

  @override
  Future<HttpClientRequest> postUrl(Uri url) => openUrl('post', url);

  @override
  Future<HttpClientRequest> put(String host, int port, String path) =>
      open('put', host, port, path);

  @override
  Future<HttpClientRequest> putUrl(Uri url) => openUrl('put', url);

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) =>
      open('delete', host, port, path);

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) => openUrl('delete', url);

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) =>
      open('patch', host, port, path);

  @override
  Future<HttpClientRequest> patchUrl(Uri url) => openUrl('patch', url);

  @override
  Future<HttpClientRequest> head(String host, int port, String path) =>
      open('head', host, port, path);

  @override
  Future<HttpClientRequest> headUrl(Uri url) => openUrl('head', url);

  @override
  set authenticate(
    Future<bool> f(Uri url, String scheme, String? realm)?,
  ) =>
      client!.authenticate = f;

  @override
  void addCredentials(
    Uri url,
    String realm,
    HttpClientCredentials credentials,
  ) =>
      client!.addCredentials(url, realm, credentials);

  @override
  set findProxy(String f(Uri url)?) => client!.findProxy = f;

  @override
  set authenticateProxy(
    Future<bool> f(String host, int port, String scheme, String? realm)?,
  ) =>
      client!.authenticateProxy = f;

  @override
  void addProxyCredentials(
    String host,
    int port,
    String realm,
    HttpClientCredentials credentials,
  ) =>
      client!.addProxyCredentials(host, port, realm, credentials);

  @override
  set badCertificateCallback(
    bool callback(X509Certificate cert, String host, int port)?,
  ) =>
      client!.badCertificateCallback = callback;

  @override
  void close({bool force = false}) => client!.close(force: force);

  Future<NetworkToolkitHttpClientRequest> withInterceptor(
    Future<HttpClientRequest> future,
  ) async {
    var request = await future;

    NetworkToolkitHttpClientRequest requestWithInterceptor =
        NetworkToolkitHttpClientRequest(_uuid.v4(), request);
    return requestWithInterceptor;
  }
}
