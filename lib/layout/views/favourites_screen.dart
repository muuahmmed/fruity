import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruity/layout/Cubit/cubit.dart';
import 'package:fruity/layout/Cubit/states.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: cubit.favourites.isEmpty
                      ? const Center(child: Text('No favourites yet.'))
                      : ListView.builder(
                    itemCount: cubit.favourites.length,
                    itemBuilder: (context, index) {
                      final fruit = cubit.favourites[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[200],
                            child: const Center(child: Text("Img")),
                          ),
                          title: Text(fruit['name']),
                          subtitle: Text('\$${fruit['price']} / ${fruit['unit']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              cubit.toggleFavourite(fruit);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}