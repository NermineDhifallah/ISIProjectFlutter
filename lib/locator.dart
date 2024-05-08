import 'package:get_it/get_it.dart';
import 'package:isi_project/core/services/auth.dart';
import 'package:isi_project/core/services/data.dart';
import 'package:isi_project/core/services/db.dart';
import 'package:isi_project/core/services/storage.dart';

GetIt locator = GetIt.instance;
void setUpLocator(){
  locator.registerLazySingleton<DbService>(() => DbService() );
  locator.registerLazySingleton<AuthService>(() => AuthService() );
  locator.registerLazySingleton<StorageService>(() => StorageService() );
  locator.registerLazySingleton<DataService>(() => DataService() );
}