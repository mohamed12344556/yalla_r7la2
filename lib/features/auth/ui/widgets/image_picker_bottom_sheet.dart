import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yalla_r7la2/generated/l10n.dart';

import '../logic/register_cubit.dart';
import 'image_picker_option.dart';

void showImagePickerBottomSheet(BuildContext context) {
  // Store the cubit reference before showing the bottom sheet
  final registerCubit = context.read<RegisterCubit>();

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (bottomSheetContext) {
      // Use BlocProvider.value to provide the existing cubit to the bottom sheet
      return BlocProvider<RegisterCubit>.value(
        value: registerCubit,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(context).Select_Profile_Picture,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ImagePickerOption(
                      icon: Icons.camera_alt,
                      label: S.of(context).Camera,
                      onTap: () {
                        Navigator.pop(bottomSheetContext);
                        registerCubit.pickImageFromCamera();
                      },
                    ),
                    ImagePickerOption(
                      icon: Icons.photo_library,
                      label: S.of(context).Gallery,
                      onTap: () {
                        Navigator.pop(bottomSheetContext);
                        registerCubit.pickImageFromGallery();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    },
  );
}
