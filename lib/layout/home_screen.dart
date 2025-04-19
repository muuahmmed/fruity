import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruity/layout/Cubit/cubit.dart';
import 'package:fruity/layout/Cubit/states.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    // Fetch home data only once when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        var cubit = ShopCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: cubit.bottomScreens[cubit.currentIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            selectedItemColor: Colors.green[700],
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            selectedFontSize: 14,
            unselectedFontSize: 12,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      cubit.currentIndex == 0
                          ? const Icon(Icons.home, size: 30, key: ValueKey(1))
                          : const Icon(
                            Icons.home_outlined,
                            size: 25,
                            key: ValueKey(2),
                          ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      cubit.currentIndex == 1
                          ? const Icon(
                            Icons.favorite,
                            size: 30,
                            key: ValueKey(3),
                          )
                          : const Icon(
                            Icons.favorite_border,
                            size: 25,
                            key: ValueKey(4),
                          ),
                ),
                label: 'Card',
              ),
              BottomNavigationBarItem(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      cubit.currentIndex == 0
                          ? const Icon(
                            Icons.shopping_cart,
                            size: 30,
                            key: ValueKey(1),
                          )
                          : const Icon(
                            Icons.shopping_cart_outlined,
                            size: 25,
                            key: ValueKey(2),
                          ),
                ),
                label: 'Products',
              ),

              BottomNavigationBarItem(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      cubit.currentIndex == 2
                          ? const Icon(Icons.person, size: 30, key: ValueKey(5))
                          : const Icon(
                            Icons.person_2_outlined,
                            size: 25,
                            key: ValueKey(6),
                          ),
                ),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}
