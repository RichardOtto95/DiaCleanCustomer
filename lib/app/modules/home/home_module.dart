import 'package:diaclean_customer/app/modules/home/home_store.dart';
import 'package:diaclean_customer/app/modules/home/widgets/locale_services.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => HomeStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/locale-services', child: (_, args) => LocaleServices()),
    ChildRoute('/service-time', child: (_, args) => ServiceTime()),
    ChildRoute('/service-instructions',
        child: (_, args) => ServiceInstructions()),
    ChildRoute('/service-confirmation',
        child: (_, args) => ServiceConfirmation()),
    ChildRoute('/requesting-service', child: (_, args) => RequestingService()),
  ];

  @override
  Widget get view => ServiceProtocol();
}
