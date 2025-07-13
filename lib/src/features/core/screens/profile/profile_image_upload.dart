import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutriscale/src/constants/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ProfileImagePickerUpload extends StatefulWidget {
  const ProfileImagePickerUpload({super.key});

  @override
  State<ProfileImagePickerUpload> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePickerUpload> {
  final _storage = GetStorage();
  List<String> _imagePaths = [];
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _loadStoredImages();
  }

  void _loadStoredImages() {
    final storedPaths = _storage.read<List>('profile_images')?.cast<String>() ?? [];
    final selectedPath = _storage.read<String>('selected_image_path');
    setState(() {
      _imagePaths = storedPaths;
      _selectedImagePath = selectedPath ?? (storedPaths.isNotEmpty ? storedPaths.first : null);
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Save to local directory
      final appDir = await getApplicationDocumentsDirectory();
      final filename = basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$filename');

      _imagePaths.add(savedImage.path);
      _selectedImagePath = savedImage.path;

      _storage.write('profile_images', _imagePaths);
      _storage.write('selected_image_path', _selectedImagePath);

      setState(() {});
    }
  }

  void _selectImage(String path) {
    setState(() {
      _selectedImagePath = path;
    });
    _storage.write('selected_image_path', path);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: _selectedImagePath != null
                  ? FileImage(File(_selectedImagePath!))
                  : const AssetImage('assets/images/man.png') as ImageProvider,
            ),
            IconButton(
              onPressed: _pickImage,
              icon: const Icon(Icons.edit, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: primaryAppColor,
                shape: const CircleBorder(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (_imagePaths.length > 1)
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imagePaths.length,
              itemBuilder: (context, index) {
                final path = _imagePaths[index];
                return GestureDetector(
                  onTap: () => _selectImage(path),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: EdgeInsets.all(path == _selectedImagePath ? 3 : 0),
                    decoration: BoxDecoration(
                      border: path == _selectedImagePath
                          ? Border.all(color: Colors.orange, width: 3)
                          : null,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: FileImage(File(path)),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
