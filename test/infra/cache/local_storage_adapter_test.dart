import 'package:faker/faker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalStorageAdapter {
  final LocalStorage localStorage;

  LocalStorageAdapter({@required this.localStorage});

  Future<void> save({@required String key, @required dynamic value}) async {
    await localStorage.setItem(key, value);
  }
}

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  LocalStorageAdapter sut;
  LocalStorageSpy localStorage;
  String key;
  dynamic value;

  setUp(() {
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
  });

  test('Should call LocalStorage with correct values', () async {
    await sut.save(key: key, value: value);

    verify(localStorage.setItem(key, value)).called(1);
  });
}
