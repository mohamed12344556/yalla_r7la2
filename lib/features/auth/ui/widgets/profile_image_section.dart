import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_r7la2/generated/l10n.dart';

import '../logic/register_cubit.dart';

class ProfileImageSection extends StatelessWidget {
  final VoidCallback onImagePickerTap;

  const ProfileImageSection({super.key, required this.onImagePickerTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                      color: colorScheme.surface,
                      border: Border.all(
                        color: colorScheme.outline.withOpacity(0.3),
                        width: 2,
                      ),
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
                            : Icon(
                              Icons.person,
                              size: 50,
                              color: colorScheme.onSurface.withOpacity(0.5),
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
                                  ? colorScheme.error
                                  : colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          cubit.selectedImage != null
                              ? Icons.delete
                              : Icons.camera_alt,
                          size: 20,
                          color:
                              cubit.selectedImage != null
                                  ? colorScheme.onError
                                  : colorScheme.onPrimary,
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
                  ? S.of(context).Tap_red_button_to_remove
                  : S.of(context).Tap_camera_icon_to_add,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
