import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruity/layout/Cubit/states.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../network/local/cache helper.dart';
import '../views/cart_screen.dart';
import '../views/favourites_screen.dart';
import '../views/layout_screen.dart';
import '../views/settings_screen.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState()) {
    _init();
  }

  static ShopCubit get(context) => BlocProvider.of(context);

  // App State
  int currentIndex = 0;
  File? profileImageFile;
  final ImagePicker _imagePicker = ImagePicker();
  List<Map<String, dynamic>> favourites = [];

  // Navigation
  final List<Widget> bottomScreens = [
    const LayoutScreen(),
    const Favourites(),
    const CartScreen(),
    const SettingsScreen(),
  ];

  Future<void> _init() async {
    await loadFavorites();
  }

  void changeBottomNav(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      emit(ShopChangeBottomNavState());
    }
  }

  // Favorites Management
  Future<void> loadFavorites() async {
    emit(ShopLoadingFavoritesState());
    try {
      // Load from cache
      final favorites = CacheHelper.getData(key: 'favorites');
      if (favorites != null && favorites is List) {
        favourites = List<Map<String, dynamic>>.from(favorites);
        emit(ShopGetFavoritesSuccessState());
      }
    } catch (e) {
      _logError('loadFavorites', e);
      emit(ShopGetFavoritesErrorState('Failed to load favorites'));
    }
  }

  Future<void> _saveFavorites() async {
    try {
      await CacheHelper.saveData(key: 'favorites', value: favourites);
    } catch (e) {
      _logError('_saveFavorites', e);
    }
  }

  void toggleFavourite(Map<String, dynamic> product) {
    try {
      product['isFavorite'] = !(product['isFavorite'] as bool);

      if (product['isFavorite']) {
        if (!favourites.any((item) => item['id'] == product['id'])) {
          favourites.add(product);
        }
      } else {
        favourites.removeWhere((item) => item['id'] == product['id']);
      }

      _saveFavorites().then((_) {
        emit(ShopChangeFavouriteState());
      });
    } catch (e) {
      _logError('toggleFavourite', e);
    }
  }

  // Image Picking with Permission Handling
  Future<void> pickProfileImage(ImageSource source) async {
    try {
      emit(ShopProfilePictureLoadingState());

      // Platform-specific permission handling
      if (Platform.isAndroid) {
        await _handleAndroidPermissions(source);
      } else if (Platform.isIOS) {
        await _handleIosPermissions(source);
      }

      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        profileImageFile = File(pickedFile.path);
        emit(ShopProfilePictureSelectedState());
        await _uploadProfileImage();
      }
    } catch (e, stack) {
      _logError('pickProfileImage', e, stack);
      emit(
        ShopProfilePictureUploadErrorState(
          'Failed to pick image: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _handleAndroidPermissions(ImageSource source) async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;

    if (androidInfo.version.sdkInt >= 33) {
      // Android 13+
      final photosStatus = await Permission.photos.status;
      if (!photosStatus.isGranted) {
        final result = await Permission.photos.request();
        if (!result.isGranted) {
          throw Exception('Photos permission denied');
        }
      }
    } else {
      final storageStatus = await Permission.storage.status;
      if (!storageStatus.isGranted) {
        final result = await Permission.storage.request();
        if (!result.isGranted) {
          throw Exception('Storage permission denied');
        }
      }
    }

    if (source == ImageSource.camera) {
      final cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          throw Exception('Camera permission denied');
        }
      }
    }
  }

  Future<void> _handleIosPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      final cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          throw Exception('Camera permission denied');
        }
      }
    }

    final photosStatus = await Permission.photos.status;
    if (!photosStatus.isGranted) {
      final result = await Permission.photos.request();
      if (!result.isGranted) {
        throw Exception('Photos permission denied');
      }
    }
  }

  Future<void> _uploadProfileImage() async {
    if (profileImageFile == null || FirebaseAuth.instance.currentUser == null) {
      emit(ShopProfilePictureUploadErrorState('Invalid image or user'));
      return;
    }

    emit(ShopProfilePictureUploadLoadingState());

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${user.uid}.jpg');

      final uploadTask = storageRef.putFile(profileImageFile!);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      await user.updatePhotoURL(downloadUrl);
      await user.reload();

      emit(ShopProfilePictureUploadSuccessState());
    } catch (e, stack) {
      _logError('_uploadProfileImage', e, stack);
      emit(
        ShopProfilePictureUploadErrorState('Upload failed: ${e.toString()}'),
      );
    }
  }

  void _logError(String method, dynamic error, [StackTrace? stack]) {
    debugPrint('Error in $method: $error');
    if (stack != null) {
      debugPrint(stack.toString());
    }
  }
}
