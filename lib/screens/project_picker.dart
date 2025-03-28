import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'api_key_screen.dart';

final projectPathProvider = StateProvider<String?>((ref) => null);

class ProjectPicker extends ConsumerWidget {
  const ProjectPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectPath = ref.watch(projectPathProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Flutter Project')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(projectPath ?? 'No project selected'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final path = await FilePicker.platform.getDirectoryPath();
                if (path != null && File('$path/pubspec.yaml').existsSync()) {
                  ref.read(projectPathProvider.notifier).state = path;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ApiKeyScreen(projectPath: path),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid Flutter project!')),
                  );
                }
              },
              child: const Text('Select Flutter Project'),
            ),
          ],
        ),
      ),
    );
  }
}
