// State Classes
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

class ShopChangeFavouriteState extends ShopStates {}

class ShopLoadingFavoritesState extends ShopStates {}

class ShopGetFavoritesSuccessState extends ShopStates {}

class ShopGetFavoritesErrorState extends ShopStates {
  final String error;
  ShopGetFavoritesErrorState(this.error);
}

class ShopProfilePictureLoadingState extends ShopStates {}

class ShopProfilePictureSelectedState extends ShopStates {}

class ShopProfilePictureUploadLoadingState extends ShopStates {}

class ShopProfilePictureUploadSuccessState extends ShopStates {}

class ShopProfilePictureUploadErrorState extends ShopStates {
  final String error;
  ShopProfilePictureUploadErrorState(this.error);
}

class ShopProfilePicturePermissionDeniedState extends ShopStates {
  final String? permission;
  ShopProfilePicturePermissionDeniedState([this.permission]);
}