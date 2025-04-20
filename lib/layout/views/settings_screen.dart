import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fruity/layout/Cubit/cubit.dart';
import 'package:fruity/layout/Cubit/states.dart';
import '../../compoents/components.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopProfilePictureUploadSuccessState) {
          showToast(
            text: 'Profile picture updated successfully',
            state: ToastStates.SUCCESS,
          );
        }
        if (state is ShopProfilePictureUploadErrorState) {
          showToast(
            text: 'Failed to update profile picture: ${state.error}',
            state: ToastStates.ERROR,
          );
        }
      },
      builder: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        final cubit = ShopCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Account Settings'),
            centerTitle: true,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                user == null
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Section
                          _buildProfileHeader(context, user, cubit, state),
                          const SizedBox(height: 30),

                          // Account Info Section
                          _buildAccountInfoSection(user),

                          // Additional Settings
                          _buildAdditionalSettings(),

                          // Sign Out Button
                          _buildSignOutButton(context),
                        ],
                      ),
                    ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    User user,
    ShopCubit cubit,
    ShopStates state,
  ) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _getProfileImage(user, cubit),
                child:
                    cubit.profileImageFile != null
                        ? null
                        : user.photoURL == null
                        ? const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        )
                        : null,
              ),
              if (state is ShopProfilePictureUploadLoadingState)
                const Positioned.fill(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                    onPressed: () => _showImagePickerDialog(context, cubit),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            user.displayName ?? 'User',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            user.email ?? '',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  ImageProvider? _getProfileImage(User user, ShopCubit cubit) {
    if (cubit.profileImageFile != null) {
      return FileImage(cubit.profileImageFile!);
    } else if (user.photoURL != null) {
      return NetworkImage(user.photoURL!);
    }
    return const AssetImage('assets/images/default_profile.png');
  }

  Future<void> _showImagePickerDialog(
    BuildContext context,
    ShopCubit cubit,
  ) async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Update Profile Picture'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Take a photo'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from gallery'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
          ),
    );

    if (source != null) {
      try {
        await cubit.pickProfileImage(source);
      } catch (e) {
        showToast(text: 'Failed to pick image: $e', state: ToastStates.ERROR);
      }
    }
  }

  Widget _buildAccountInfoSection(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildInfoItem(Icons.person, 'Name', user.displayName),
                _buildInfoItem(Icons.email, 'Email', user.email),
                _buildInfoItem(Icons.phone, 'Phone', user.phoneNumber),
                _buildInfoItem(
                  Icons.verified_user,
                  'Email Verified',
                  user.emailVerified ? 'Verified' : 'Not Verified',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value ?? 'Not provided',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Text(
          'Preferences',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              _buildSettingSwitch('Dark Mode', false, (value) {}),
              _buildSettingSwitch('Notifications', true, (value) {}),
              _buildSettingAction(Icons.language, 'Language', () {}),
              _buildSettingAction(Icons.help, 'Help & Support', () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingSwitch(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingAction(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () => signOut(context),
          icon: const Icon(Icons.logout),
          label: const Text('Sign Out'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
