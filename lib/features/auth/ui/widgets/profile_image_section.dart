import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/register_cubit.dart';

class ProfileImageSection extends StatelessWidget {
  final VoidCallback onImagePickerTap;

  const ProfileImageSection({super.key, required this.onImagePickerTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();
        return Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                    ),
                    child:
                        cubit.selectedImage != null
                            ? ClipOval(
                              child: Image.file(
                                cubit.selectedImage!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            )
                            : const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap:
                          cubit.selectedImage != null
                              ? () => cubit.removeSelectedImage()
                              : onImagePickerTap,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              cubit.selectedImage != null
                                  ? Colors.red
                                  : Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          cubit.selectedImage != null
                              ? Icons.delete
                              : Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              cubit.selectedImage != null
                  ? 'Tap the red button to remove'
                  : 'Tap the camera icon to add photo',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
