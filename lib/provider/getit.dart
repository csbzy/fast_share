import 'package:get_it/get_it.dart';
import 'package:just_share/model/homeVideModel.dart';
import 'package:just_share/service/navigation_service.dart';

GetIt getIt = GetIt.instance;
Future<void> setupLocator() async {
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<HomeScaffoldViewModel>(HomeScaffoldViewModel());
}
