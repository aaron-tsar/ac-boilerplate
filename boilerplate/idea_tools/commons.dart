import 'dart:io';

const workspaceXmlPath = './.idea/runConfigurations';

const runConfigSkeletonXml =
'''<component name="ProjectRunConfigurationManager">
  <configuration default="CON_DEFAULT" name="CON_NAME" type="FlutterRunConfigurationType" factoryName="Flutter">
    <option name="additionalArgs" value="OP_ARGS" />
    <option name="filePath" value="\$PROJECT_DIR\$/lib/main.dart" />
  </configuration>
</component>''';

class AndroidStudioEnvGenerator {

  static Future<void> createEnvConfigFile(String name) async {
    final file = File('$workspaceXmlPath/$name.xml');
    file.createSync(recursive: true);
    file.writeAsString(runConfigSkeletonXml
        .replaceAll("CON_DEFAULT", "false")
        .replaceAll("CON_NAME", name.toUpperCase())
        .replaceAll("OP_ARGS", "--dart-define-from-file=.env/$name.json")
        .replaceAll("OP_NAME", name.toUpperCase())
    );
  }
}