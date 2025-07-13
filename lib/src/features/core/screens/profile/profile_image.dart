import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nutriscale/src/constants/colors.dart';

class ProfileImagePicker extends StatefulWidget {
  const ProfileImagePicker({super.key});

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  final _storage = GetStorage();
final List<String> _predefinedAssets = [
  'assets/images/profile_image/man.png',
  'assets/images/profile_image/boy.png',
  'assets/images/profile_image/girl.png',
  'assets/images/profile_image/girl3.png',
  'assets/images/profile_image/girll2.png',
  'assets/images/profile_image/man2.png',
  'assets/images/profile_image/man3.png',
  'assets/images/profile_image/woman2.png',
  'assets/images/profile_image/woman3.png',
  'assets/images/profile_image/women1.png',
];


  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _loadSelectedImage();
  }

  void _loadSelectedImage() {
    final selectedPath = _storage.read<String>('selected_image_path');
    setState(() {
      _selectedImagePath = selectedPath ?? _predefinedAssets.first;
    });
  }

  void _selectImage(String assetPath) {
    setState(() {
      _selectedImagePath = assetPath;
    });
    _storage.write('selected_image_path', assetPath);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Image
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(_selectedImagePath ?? _predefinedAssets.first),
            ),
            const Padding(
              padding: EdgeInsets.all(6.0),
              child: Icon(Icons.check_circle, color: primaryAppColor),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Scrollable Predefined Options
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _predefinedAssets.length,
            itemBuilder: (context, index) {
              final asset = _predefinedAssets[index];
              return GestureDetector(
                onTap: () => _selectImage(asset),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: EdgeInsets.all(asset == _selectedImagePath ? 3 : 0),
                  decoration: BoxDecoration(
                    border: asset == _selectedImagePath
                        ? Border.all(color: Colors.orange, width: 3)
                        : null,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(asset),
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
