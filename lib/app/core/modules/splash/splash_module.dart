import 'package:diaclean_customer/app/core/modules/splash/splash_Page.dart';
import 'package:diaclean_customer/app/core/modules/splash/splash_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

// class SplashModule extends Module {
//   @override
//   final List<Bind> binds = [
//     Bind.lazySingleton((i) => SplashStore()),
//   ];

//   @override
//   final List<ModularRoute> routes = [
//     ChildRoute('/', child: (_, args) => SplashPage()),
//   ];
// }

class SplashModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SplashStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SplashPage()),
  ];

  @override
  Widget get view => SplashPage();
}
