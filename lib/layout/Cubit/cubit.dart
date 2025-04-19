import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruity/layout/Cubit/states.dart';
import 'package:fruity/layout/views/settings_screen.dart';
import 'package:fruity/models/home%20model.dart';
import '../views/cart_screen.dart';
import '../views/layout_screen.dart';
import '../views/favourites_screen.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    const LayoutScreen(),
    const Favourites(),
    const CartScreen(),
    const SettingsScreen(),
  ];

  List<Map<String, dynamic>> favourites = [];

  void toggleFavourite(Map<String, dynamic> fruit) {
    fruit['isFavorite'] = !(fruit['isFavorite'] as bool);

    if (fruit['isFavorite'] == true) {
      favourites.add(fruit);
    } else {
      favourites.removeWhere((item) => item['name'] == fruit['name']);
    }

    emit(ShopChangeFavouriteState());
  }



  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
}
