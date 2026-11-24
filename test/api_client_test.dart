import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

const sample = Project(
  id: 'server-id',
  title: 'Proyek belajar',
  projectType: 'Web',
  role: 'Developer',
  description: 'Deskripsi proyek',
  technologies: 'Django\nFlutter',
  liveUrl: 'https://example.com/',
  starCount: 4,
  isStarred: true,
);

void main() {
  test(
    'JSON matches the legacy serializer and excludes server-only metadata',
    () {
      final json = sample.toJson();
      expect(json['project_type'], 'Web');
      expect(json['technologies'], 'Django\nFlutter');
      for (final name in ['id', 'star_count', 'is_starred']) {
        expect(json.containsKey(name), isFalse);
      }
      final result = Project.fromJson({
        ...json,
        'id': 'read-id',
        'thumbnail_path': null,
        'source_url': null,
      });
      expect(result.id, 'read-id');
      expect(result.thumbnailPath, '');
      expect(result.sourceUrl, '');
    },
  );
  test('Public GET sends no token and decodes Unicode', () async {
    final api = ApiClient(
      baseUrl: 'https://example.com/',
      client: MockClient((r) async {
        expect(r.url.toString(), 'https://example.com/api/v1/projects/');
        expect(r.headers.containsKey('Authorization'), isFalse);
        return http.Response.bytes(
          utf8.encode(jsonEncode([sample.toJson()])),
          200,
        );
      }),
    );
    expect((await api.getProjects()).single.title, sample.title);
    api.close();
  });
  test('POST sends Token, JSON, and accepts only a 201 response', () async {
    final api = ApiClient(
      client: MockClient((r) async {
        expect(r.method, 'POST');
        expect(r.headers['Authorization'], 'Token unit-token');
        expect(jsonDecode(r.body)['title'], sample.title);
        expect(jsonDecode(r.body).containsKey('id'), isFalse);
        return http.Response(
          jsonEncode({...sample.toJson(), 'id': 'new-id'}),
          201,
        );
      }),
    );
    expect((await api.createProject(sample, token: 'unit-token')).id, 'new-id');
    api.close();
  });
  test('HTTP errors never surface server response bodies', () async {
    for (final code in [400, 401, 403, 500]) {
      final api = ApiClient(
        client: MockClient(
          (r) async => http.Response('<html>private stack trace</html>', code),
        ),
      );
      await expectLater(
        api.getProjects(),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'status', code)
              .having(
                (e) => e.message.contains('stack trace'),
                'safe message',
                false,
              ),
        ),
      );
      api.close();
    }
  });
  test(
    'Malformed JSON and incorrect list schemas become readable API errors',
    () async {
      for (final body in ['<html>not JSON</html>', '{}', '[{"title":3}]']) {
        final api = ApiClient(
          client: MockClient((r) async => http.Response(body, 200)),
        );
        await expectLater(api.getProjects(), throwsA(isA<ApiException>()));
        api.close();
      }
    },
  );
  test(
    'Network errors are mapped without leaking internal exceptions',
    () async {
      final api = ApiClient(
        client: MockClient(
          (r) async => throw http.ClientException('private address'),
        ),
      );
      await expectLater(
        api.getProjects(),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'offline', 0)),
      );
      api.close();
    },
  );
  test('Login preserves password whitespace; logout uses a token and no JSON decoding', () async {
    final api = ApiClient(
      client: MockClient((r) async {
        if (r.url.path.endsWith('token/')) {
          expect(jsonDecode(r.body)['password'], ' pass word ');
          return http.Response('{"token":"unit-token"}', 200);
        }
        expect(r.headers['Authorization'], 'Token unit-token');
        return http.Response('', 204);
      }),
    );
    expect(await api.obtainToken('user', ' pass word '), 'unit-token');
    await api.logout(token: 'unit-token');
    api.close();
  });
  test('Logout failure still clears memory state', () async {
    final api = ApiClient(
      client: MockClient((r) async => http.Response('unavailable', 500)),
    );
    final auth = AuthState(api, initialToken: 'unit-token');
    await expectLater(auth.logout(), throwsA(isA<ApiException>()));
    expect(auth.isLoggedIn, isFalse);
    auth.dispose();
    api.close();
  });
  test('A late login response cannot revive an invalidated session', () async {
    final response = Completer<http.Response>();
    final api = ApiClient(client: MockClient((r) => response.future));
    final auth = AuthState(api);
    final pending = auth.login('user', 'password');
    auth.invalidate();
    response.complete(http.Response('{"token":"late-token"}', 200));
    await pending;
    expect(auth.isLoggedIn, isFalse);
    auth.dispose();
    api.close();
  });
  test('Legacy static thumbnail paths resolve against Django; unsafe schemes are ignored', () {
    final api = ApiClient(baseUrl: 'https://api.example.com');
    Project image(String path) => Project(
      title: 'image',
      projectType: 'Web',
      role: 'Dev',
      description: 'desc',
      technologies: 'Flutter',
      liveUrl: 'https://example.com',
      thumbnailPath: path,
    );
    expect(
      api.imageUrl(image('img/preview.jpg')),
      'https://api.example.com/static/img/preview.jpg',
    );
    expect(
      api.imageUrl(image('https://cdn.example.com/image.jpg')),
      'https://cdn.example.com/image.jpg',
    );
    expect(api.imageUrl(image('javascript:alert(1)')), isNull);
    expect(api.imageUrl(image('')), isNull);
    api.close();
  });
}
