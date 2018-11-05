import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorage {
  String pathStore;

  Future<void> initStorage() async {
    Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/store';
    Directory storage = await new Directory(dirPath).create(recursive: true);
    pathStore = storage.path;
    print("syncing app store");
  }

  dynamic getFromStore(String name, String value) {
    String storePath = '$pathStore/$name';
    if (File(storePath).existsSync()) {
      List<int> data = File(storePath).readAsBytesSync();
      String parsedData = utf8.decode(data);
      Map values = json.decode(parsedData);
      if (values.containsKey(value)) {
        return values[value];
      }
      throw 'invalid value, not exists in $name store';
    }
    throw 'invalid store, not exists';
  }

  saveToStore(String name, String key, dynamic value) {
    String storePath = '$pathStore/$name';
    if (File(storePath).existsSync()) {
      List<int> data = File(storePath).readAsBytesSync();
      String parsedData = utf8.decode(data);
      Map values = json.decode(parsedData);
      values[key] = value;
      String encodedState = json.encode(values);
      List<int> bytes = utf8.encode(encodedState);
      File f = File(storePath);
      f.writeAsBytesSync(bytes, flush: true);
      return;
    }
    throw 'invalid store, not exists';
  }

  createNewStore(String name, {Map userInitState}) {
    String finalStorePath = '$pathStore/$name';
    Map initState = {
      "_metadata": {
        "name": name,
        "created_at": DateTime.now().toString(),
      },
    };

    if (userInitState != null) {
      initState.addAll(userInitState);
    }
    String encodedState = json.encode(initState);
    List<int> bytes = utf8.encode(encodedState);
    File f = File(finalStorePath);
    f.createSync();
    f.writeAsBytesSync(bytes);
  }

  bool existsStore(String name) {
    String finalStorePath = '$pathStore/$name';
    return File(finalStorePath).existsSync();
  }
}

final localStorage = new LocalStorage();
