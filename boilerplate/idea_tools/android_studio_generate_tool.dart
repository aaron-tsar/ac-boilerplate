import 'package:boilerplate/commons/log/log.dart';

import 'commons.dart';
import 'package:boilerplate/flavor/flavor_enum.dart';

void main() async {
  try {
    for(final e in FlavorEnum.values) {
      await AndroidStudioEnvGenerator.createEnvConfigFile(e.name);
    }
  } on Exception catch (e) {
    DLog.error('Error: $e');
  }
}