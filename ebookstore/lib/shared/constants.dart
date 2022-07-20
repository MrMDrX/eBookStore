class Constants {
  //TODO replace values with your own
  static const BASE_URL =
      'yourFirebaseProjectUrl';

  //Firebase auth api
  static const SIGN_UP_AUTH_URL =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=yourGoogleApiKey';
  static const LOG_IN_AUTH_URL =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=yourGoogleApiKey';

  //Products
  static const USERS = 'users';
  static const PRODUCTS = 'produits';
  static const USER_FAVORITES = 'userFavorites';
  static const ORDERS = 'commandes';

  //Firebase Storage
  static const FIREBASE_STORAGE_FOLDER = '[add_folder_name]/';

  // DB name
  static const USER_PRODUCTS_TABLE = 'user_products';
}
