import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../themes/cubit/locale_cubit.dart';
import '../themes/cubit/theme_cubit.dart';
import '../../features/auth/ui/logic/forgot_password_cubit.dart';
import '../../features/booking/data/repos/booking_repo.dart';
import '../../features/booking/ui/logic/bookings_cubit.dart';
import '../../features/favorites/ui/logic/favorites_cubit.dart';
import '../../features/home/data/repos/destination_repo.dart';
import '../../features/home/ui/logic/home_cubit.dart';

import '../../features/auth/data/repos/auth_repo.dart';
import '../../features/auth/ui/logic/login_cubit.dart';
import '../../features/auth/ui/logic/register_cubit.dart';
import '../../features/profile/data/repos/profile_repo.dart';
import '../../features/profile/ui/logic/profile_cubit.dart';
import '../api/dio_factory.dart';

final sl = GetIt.instance;

Future<void> setupGetIt() async {
  //? Core
  final Dio dio = DioFactory.getDio();
  sl.registerSingleton<Dio>(dio);

  _initCore();
  _initAuth();
  _initHome();
  _initProfile();
  _initBookings();
  _initFavorites();
}

void external() {
  // Add external dependencies here if needed in the future
}

void _initCore() {
  sl.registerLazySingleton(() => LocaleCubit());
  sl.registerLazySingleton(() => ThemeCubit());
}

void _initAuth() {
  // AuthRepo
  sl.registerLazySingleton(() => AuthRepo(dio: sl()));
  // LoginCubit - Factory عشان كل مرة instance جديدة
  sl.registerFactory(() => LoginCubit(authRepo: sl()));
  // RegisterCubit - Factory عشان كل مرة instance جديدة
  sl.registerFactory(() => RegisterCubit(authRepo: sl()));
  // ForgotPasswordCubit - Factory عشان كل مرة instance جديدة
  sl.registerFactory(() => ForgotPasswordCubit(authRepo: sl()));
}

void _initHome() {
  // DestinationRepo
  if (!sl.isRegistered<DestinationRepo>()) {
    sl.registerLazySingleton(() => DestinationRepo(dio: sl()));
  }

  // HomeCubit
  if (!sl.isRegistered<HomeCubit>()) {
    sl.registerFactory(() => HomeCubit(destinationRepo: sl()));
  }
}

void _initProfile() {
  // ProfileRepo
  sl.registerLazySingleton(() => ProfileRepo(dio: sl()));

  // ProfileCubit - استخدم Singleton عشان نفس الـ instance يتشارك
  sl.registerLazySingleton(() => ProfileCubit(profileRepository: sl()));
}

void _initFavorites() {
  // FavoritesCubit - استخدم Singleton عشان نفس الـ instance يتشارك في كل التطبيق
  // وده مهم عشان الـ favorites تكون متسقة في كل مكان
  sl.registerLazySingleton(() => FavoritesCubit());
}

void _initBookings() {
  // BookingRepo - Repository for API calls
  sl.registerLazySingleton(() => BookingRepo(dio: sl()));

  // BookingsCubit - استخدم Singleton عشان نفس الـ instance يتشارك في كل التطبيق
  // وده مهم عشان الـ bookings تكون متسقة في كل مكان وتحافظ على البيانات
  sl.registerFactory(() => BookingsCubit(bookingRepo: sl()));
}

///! 1. `registerSingleton`
/// - Creates the object immediately during registration (Eager Initialization).
/// - Only one instance is created and shared across the entire application.
/// - Use Case: When you need the object to be available as soon as the app starts.
/// - Example: AppConfig, SessionManager.

///! 2. `registerLazySingleton`
/// - Creates the object only when it is first requested (Lazy Initialization).
/// - Only one instance is created and shared across the entire application.
/// - Use Case: To optimize performance by delaying object creation until needed.
/// - Example: DatabaseService, ApiClient.

///! 3. `registerFactory`
/// - Creates a new object instance every time it is requested.
/// - Use Case: When you need a new instance for every operation or request.
/// - Example: FormValidator, HttpRequest.

/// Comparison Table:
/// | Property            | `registerSingleton`  | `registerLazySingleton` | `registerFactory`       |
/// |---------------------|-----------------------|-------------------------|-------------------------|
/// | Creation Time       | Immediately          | On first request        | On every request        |
/// | Number of Instances | One                  | One                     | New instance every time |
/// | State Sharing       | Supported            | Supported               | Not supported           |
/// | Common Use Cases    | Settings, Sessions   | Heavy Services          | Temporary Objects       |
