import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruity/layout/Cubit/cubit.dart';
import 'package:fruity/layout/Cubit/states.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var cubit = ShopCubit.get(context);
        return const Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name'
                , style: TextStyle(fontSize: 20)),
                Divider(thickness: 1, color: Colors.black),
                SizedBox(
                  height: 20,
                ),
                Text('data'),
                Divider(thickness: 1, color: Colors.black),
                SizedBox(
                  height: 20,
                ),
                Text('data'),
                Divider(thickness: 1, color: Colors.black),
                SizedBox(
                  height: 20,
                ),
                Text('data'),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
