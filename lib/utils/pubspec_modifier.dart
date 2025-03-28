import 'dart:io';

Future<void> addGoogleMapsPackage(String projectPath) async {
  final pubspecPath = '$projectPath/pubspec.yaml';
  final pubspecFile = File(pubspecPath);

  if (!pubspecFile.existsSync()) throw Exception('pubspec.yaml not found.');

  final content = await pubspecFile.readAsString();
  if (!content.contains('google_maps_flutter')) {
    final updatedContent = '$content\n  google_maps_flutter: ^2.5.0\n';
    await pubspecFile.writeAsString(updatedContent);

    // Automatically run flutter pub get
    await Process.run('flutter', ['pub', 'get'], workingDirectory: projectPath);
  }
}
