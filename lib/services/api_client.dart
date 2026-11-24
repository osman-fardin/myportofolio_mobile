import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);
  final int statusCode;
  final String message;
  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({http.Client? client, String baseUrl = apiBaseUrl})
    : _client = client ?? http.Client(),
      baseUrl = baseUrl.replaceFirst(RegExp(r'/+$'), '');
  final http.Client _client;
  final String baseUrl;
  void close() => _client.close();

  Future<http.Response> _request(
    String path, {
    Map<String, dynamic>? body,
    String? token,
    bool post = false,
  }) async {
    final headers = {
      'Accept': 'application/json',
      if (post) 'Content-Type': 'application/json; charset=UTF-8',
      if (token != null) 'Authorization': 'Token $token',
    };
    try {
      final uri = Uri.parse('$baseUrl$path');
      final response =
          await (post
                  ? _client.post(
                      uri,
                      headers: headers,
                      body: body == null ? null : jsonEncode(body),
                    )
                  : _client.get(uri, headers: headers))
              .timeout(const Duration(seconds: 20));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = switch (response.statusCode) {
          400 => 'Input tidak valid. Periksa kembali isian atau kredensial.',
          401 => 'Sesi tidak valid. Silakan login kembali.',
          403 => 'Akun ini tidak memiliki izin untuk aksi tersebut.',
          _ => 'Server belum dapat memproses permintaan. Coba lagi.',
        };
        throw ApiException(response.statusCode, message);
      }
      return response;
    } on TimeoutException {
      throw const ApiException(0, 'Koneksi terlalu lama. Coba lagi.');
    } on http.ClientException {
      throw const ApiException(
        0,
        'Tidak dapat terhubung ke server. Periksa koneksi dan URL API.',
      );
    }
  }

  dynamic _decode(http.Response response) {
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw const ApiException(0, 'Respons server tidak dapat dibaca.');
    }
  }

  Future<List<Project>> getProjects() async {
    final decoded = _decode(await _request('/api/v1/projects/'));
    try {
      return (decoded as List)
          .map((item) => Project.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const ApiException(0, 'Format daftar proyek tidak sesuai API.');
    }
  }

  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    final response = await _request(
      '/api/v1/projects/',
      post: true,
      token: token,
      body: project.toJson(),
    );
    if (response.statusCode != 201) {
      throw const ApiException(
        0,
        'Server belum mengonfirmasi pembuatan proyek.',
      );
    }
    try {
      return Project.fromJson(_decode(response) as Map<String, dynamic>);
    } catch (_) {
      throw const ApiException(
        0,
        'Format proyek dari server tidak sesuai API.',
      );
    }
  }

  Future<String> obtainToken(String username, String password) async {
    final decoded = _decode(
      await _request(
        '/api/v1/auth/token/',
        post: true,
        body: {'username': username, 'password': password},
      ),
    );
    if (decoded is! Map ||
        decoded['token'] is! String ||
        (decoded['token'] as String).isEmpty) {
      throw const ApiException(0, 'Respons login tidak valid.');
    }
    return decoded['token'] as String;
  }

  Future<void> logout({required String token}) async {
    await _request('/api/v1/auth/logout/', post: true, token: token);
  }

  /// Legacy thumbnail_path contains a backend static path, not a client asset.
  String? imageUrl(Project project) {
    final path = project.thumbnailPath.trim();
    if (path.isEmpty) return null;
    final uri = Uri.tryParse(path);
    if (uri == null) return null;
    if (uri.hasScheme) {
      return ['http', 'https'].contains(uri.scheme) ? uri.toString() : null;
    }
    if (path.startsWith('//')) return null;
    return Uri.parse('$baseUrl/')
        .resolve(
          path.startsWith('/static/')
              ? path
              : 'static/${path.replaceFirst(RegExp(r"^/+"), "")}',
        )
        .toString();
  }
}
