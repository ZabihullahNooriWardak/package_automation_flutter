import 'dart:io';
import 'package:flutter/material.dart';
import 'map_screen.dart';
import '../utils/pubspec_modifier.dart';

class ApiKeyScreen extends StatefulWidget {
  final String projectPath;

  const ApiKeyScreen({super.key, required this.projectPath});

  @override
  State<ApiKeyScreen> createState() => _ApiKeyScreenState();
}

class _ApiKeyScreenState extends State<ApiKeyScreen> {
  final _apiKeyController = TextEditingController();

  Future<void> updateAndroid(String apiKey) async {
    final manifestPath =
        '${widget.projectPath}/android/app/src/main/AndroidManifest.xml';
    final manifestFile = File(manifestPath);

    if (manifestFile.existsSync()) {
      final content = await manifestFile.readAsString();
      if (!content.contains(apiKey)) {
        final updatedContent = content.replaceFirst(
          '</application>',
          '''
          <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="$apiKey"/>
          </application>
          ''',
        );
        await manifestFile.writeAsString(updatedContent);
      }
    }
  }

  Future<void> updateiOS(String apiKey) async {
    final plistPath = '${widget.projectPath}/ios/Runner/Info.plist';
    final plistFile = File(plistPath);

    if (plistFile.existsSync()) {
      final plistContent = await plistFile.readAsString();
      if (!plistContent.contains(apiKey)) {
        final updatedContent = plistContent.replaceFirst(
          '</dict>',
          '''
          <key>GMSApiKey</key>
          <string>$apiKey</string>
          </dict>
          ''',
        );
        await plistFile.writeAsString(updatedContent);
      }
    }
  }

  Future<void> configure() async {
    await addGoogleMapsPackage(widget.projectPath);
    final apiKey = _apiKeyController.text.trim();

    if (apiKey.isNotEmpty) {
      await updateAndroid(apiKey);
      await updateiOS(apiKey);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MapScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configure Google Maps')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _apiKeyController,
              decoration:
                  const InputDecoration(labelText: 'Enter Google Maps API Key'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: configure,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
