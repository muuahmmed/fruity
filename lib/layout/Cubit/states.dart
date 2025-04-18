abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangeBottomNavState extends ShopStates {}

class ShopLoadingState extends ShopStates {}

class ShopSuccessState extends ShopStates {
  final dynamic data;

  ShopSuccessState(this.data);
}

class ShopErrorState extends ShopStates {
  final String error;

  ShopErrorState(this.error);
}

class ShopSuccessCategoriesState extends ShopStates {
  final dynamic data;

  ShopSuccessCategoriesState(this.data);
}

class ShopErrorCategoriesState extends ShopStates {
  final String error;

  ShopErrorCategoriesState(this.error);
}