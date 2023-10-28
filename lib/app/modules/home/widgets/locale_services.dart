import 'dart:ui';

import 'package:diaclean_customer/app/constants/properties.dart';
import 'package:diaclean_customer/app/modules/main/main_store.dart';
import 'package:diaclean_customer/app/shared/color_theme.dart';
import 'package:diaclean_customer/app/shared/utilities.dart';
import 'package:diaclean_customer/app/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../home_store.dart';

class ServiceProtocol extends StatefulWidget {
  const ServiceProtocol({Key? key}) : super(key: key);

  @override
  State<ServiceProtocol> createState() => _ServiceProtocolState();
}

class _ServiceProtocolState extends State<ServiceProtocol> {
  final MainStore mainStore = Modular.get();
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    addListener();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  addListener() {
    scrollController.addListener(() {
      // if (scrollController.offset >
      //         (scrollController.position.maxScrollExtent - 200) &&
      //     lastExtent < scrollController.position.maxScrollExtent) {
      //   setState(() {
      //     limit += 6;
      //     lastExtent = scrollController.position.maxScrollExtent;
      //   });
      // }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        mainStore.setVisibleNav(false);
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        mainStore.setVisibleNav(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          SizedBox(height: viewPaddingTop(context)),
          GestureDetector(
            onTap: () {
              Modular.to.pushNamed("/was-invited");
            },
            child: ServiceTitle(
              "Protocolo de\natendimento",
              back: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: wXD(18, context),
              right: wXD(18, context),
              bottom: wXD(30, context),
            ),
            child: Text(
              "Veja as orientações para uma experiência inesquecível com nossa empresa",
              style: textFamily(
                context,
                color: Color(0xff3d3d3d),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Protocol(
            "1",
            "Tenha em sua residência ou escritório: detergente neutro, álcool vinagre branco, rodo, vassourinha pro vaso sanitário, pano de chão, pano de limpeza de microfibra ou flanela, álcool e saco de lixo;",
          ),
          Protocol(
            "2",
            "Favor evitar conversas paralelas e não relacionadas à solicitação com os prestadores, para que seja realizado o seu serviço em tempo hábil;",
          ),
          Protocol(
            "3",
            "Caso necessite adicionar mais uma hora, você adicionar acessando o app em ...",
          ),
          Protocol(
            "4",
            "Por favor preencha avaliação do cliente, no final da prestação de serviço e contribua no aprimoramento do nosso atendimento.",
          ),
          SizedBox(height: wXD(15, context)),
          PrimaryButton(
            title: "Avançar",
            onTap: () => Modular.to.pushNamed("/home/locale-services"),
          ),
          vSpace(300),
        ],
      ),
    );
  }
}

class Protocol extends StatelessWidget {
  final String number;
  final String content;

  Protocol(
    this.number,
    this.content,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: wXD(30, context),
        right: wXD(18, context),
        left: wXD(18, context),
      ),
      child: RichText(
        text: TextSpan(
          style: textFamily(
            context,
            color: getColors(context).primary,
            fontSize: 18,
          ),
          children: [
            TextSpan(text: number + ". "),
            TextSpan(
              text: content,
              style: textFamily(
                context,
                color: Colors.black,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LocaleServices extends StatelessWidget {
  const LocaleServices({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: viewPaddingTop(context)),
            ServiceTitle("Local e serviços"),
            StepByStep(0),
            AddressSelected(),
            ServiceLocale(),
            ServiceToProvide(),
            PrimaryButton(
              title: "Avançar",
              onTap: () {
                Modular.to.pushNamed("/home/service-time");
              },
            ),
            vSpace(30),
          ],
        ),
      ),
    );
  }
}

class ServiceTime extends StatelessWidget {
  const ServiceTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: viewPaddingTop(context)),
            ServiceTitle("Tempo de serviço"),
            StepByStep(1),
            AddressSelected(),
            TotalOfService(),
            HoursOfService(),
            PrimaryButton(
              title: "Avançar",
              onTap: () {
                Modular.to.pushNamed("/home/service-instructions");
              },
            ),
            vSpace(30),
          ],
        ),
      ),
    );
  }
}

class ServiceInstructions extends StatelessWidget {
  const ServiceInstructions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: viewPaddingTop(context)),
            ServiceTitle("Instruções"),
            StepByStep(2),
            AddressSelected(),
            TotalOfService(),
            InHome(),
            PrimaryButton(
              title: "Avançar",
              onTap: () {
                Modular.to.pushNamed("/home/service-confirmation");
              },
            ),
            vSpace(30),
          ],
        ),
      ),
    );
  }
}

class ServiceConfirmation extends StatelessWidget {
  const ServiceConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: viewPaddingTop(context)),
            ServiceTitle("Confirmação"),
            StepByStep(3),
            AddressSelected(),
            ServiceLocale(),
            ServiceToProvide(confirmation: true),
            HoursOfService(confirmation: true),
            InHome(confirmation: true),
            ServicePaymentMethod(),
            TotalOfService(confirmation: true),
            PrimaryButton(
              title: "Confirmar",
              onTap: () {
                Modular.to.pushNamed("/home/requesting-service");
              },
            ),
            SizedBox(height: wXD(40, context)),
          ],
        ),
      ),
    );
  }
}

class RequestingService extends StatefulWidget {
  RequestingService({Key? key}) : super(key: key);

  @override
  State<RequestingService> createState() => _RequestingServiceState();
}

class _RequestingServiceState extends State<RequestingService> {
  final HomeStore store = Modular.get();

  @override
  void initState() {
    store.startServiceTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: viewPaddingTop(context)),
            Observer(
              builder: (context) => ServiceTitle(
                "Solicitando atendimento em: ${store.timeToRequest}",
                requesting: true,
              ),
            ),
            StepByStep(4),
            ServiceCheck(
              child: AddressSelected(simple: true),
              centerCheck: true,
            ),
            ServiceCheck(
              title: "Local do serviço:",
              content: "Casa",
            ),
            ServiceCheck(
              title: "Tempo de serviço:",
              content: "${store.hours} ${store.hours > 1 ? "Horas" : "Hora"}",
            ),
            ServiceCheck(
              title: "Descrição do serviço:",
              content:
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean consequat, nunc ut suscipit placerat, risus diam vehicula ligula, consequat vehicula lacus enim eu libero.",
              longContent: true,
            ),
            ServiceCheck(
              title: "Instruções:",
              content:
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean consequat, nunc ut suscipit placerat, risus diam vehicula ligula, consequat vehicula lacus enim eu libero.",
              longContent: true,
            ),
            ServicePaymentMethod(confirmation: true),
            PrimaryButton(
              title: "Cancelar atendimento",
              onTap: () {
                if (store.orderTimer != null) {
                  store.orderTimer!.cancel();
                  store.timeToRequest = 5;
                }
                Modular.to.pop();
              },
            ),
            SizedBox(height: wXD(80, context)),
          ],
        ),
      ),
    );
  }
}

class ServiceTitle extends StatelessWidget {
  final String title;
  final bool requesting;
  final bool back;

  const ServiceTitle(this.title, {this.requesting = false, this.back = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: maxWidth(context),
          padding: EdgeInsets.symmetric(
            vertical: wXD(30, context),
            horizontal: wXD(18, context),
          ),
          alignment: requesting ? Alignment.centerLeft : Alignment.center,
          child: Text(
            title,
            style: textFamily(
              context,
              color: veryDarkPurple,
              fontSize: requesting ? 20 : 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (back && !requesting)
          Positioned(
            left: wXD(8, context),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                size: wXD(28, context),
                color: getColors(context).onSurface,
              ),
              onPressed: () => Modular.to.pop(),
            ),
          ),
      ],
    );
  }
}

class StepByStep extends StatelessWidget {
  final int step;
  const StepByStep(this.step);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: wXD(330, context),
            height: wXD(3, context),
            decoration: BoxDecoration(
              borderRadius: defBorderRadius(context),
              color: lightPurple,
            ),
          ),
          Container(
            width: (wXD(66, context) * step) + wXD(66, context),
            height: wXD(3, context),
            decoration: BoxDecoration(
              borderRadius: defBorderRadius(context),
              color: getColors(context).primary,
            ),
          ),
          Container(
            width: wXD(330, context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => Container(
                  height: wXD(7, context),
                  width: wXD(7, context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index <= step
                        ? getColors(context).primary
                        : lightPurple,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddressSelected extends StatelessWidget {
  final bool simple;
  AddressSelected({this.simple = false});

  @override
  Widget build(BuildContext context) {
    if (simple)
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(400),
            child: Container(
              width: wXD(67, context),
              height: wXD(67, context),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getColors(context).secondary,
                boxShadow: [defBoxShadow(context)],
              ),
              // child: SfMaps(
              //   layers: [
              //     MapTileLayer(
              //       controller: store.mapTileLayerController,
              //       urlTemplate:
              //           'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              //       zoomPanBehavior: store.zoomPanBehavior,
              //       markerBuilder:
              //           (BuildContext context, int index) {
              //         return store.marker[index];
              //       },
              //       initialMarkersCount: 1,
              //     ),
              //   ],
              // ),
            ),
          ),
          SizedBox(width: wXD(10, context)),
          Container(
            width: wXD(200, context),
            child: Text("""Rua 3c Chácara 26 Casa 25 
Vicente Pires, 25 - Brasília,
Brasília - DF""", style: textFamily(context, height: 1.4)),
          ),
        ],
      );

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            // height: wXD(108, context),
            width: wXD(339, context),
            margin: EdgeInsets.symmetric(vertical: wXD(30, context)),
            padding: EdgeInsets.fromLTRB(
              wXD(17, context),
              wXD(8, context),
              wXD(12, context),
              wXD(8, context),
            ),
            decoration: BoxDecoration(
              borderRadius: defBorderRadius(context),
              border: Border.all(color: getColors(context).primary),
              color: getColors(context).surface,
              boxShadow: [defBoxShadow(context)],
            ),
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Local do atendimento',
                    style: textFamily(
                      context,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: veryDarkPurple,
                    ),
                  ),
                  SizedBox(height: wXD(5, context)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(400),
                        child: Container(
                          width: wXD(67, context),
                          height: wXD(67, context),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: getColors(context).onSurface,
                          ),
                          // child: SfMaps(
                          //   layers: [
                          //     MapTileLayer(
                          //       controller: store.mapTileLayerController,
                          //       urlTemplate:
                          //           'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          //       zoomPanBehavior: store.zoomPanBehavior,
                          //       markerBuilder:
                          //           (BuildContext context, int index) {
                          //         return store.marker[index];
                          //       },
                          //       initialMarkersCount: 1,
                          //     ),
                          //   ],
                          // ),
                        ),
                      ),
                      SizedBox(width: wXD(10, context)),
                      Container(
                        width: wXD(200, context),
                        child: Text("""Rua 3c Chácara 26 Casa 25 
Vicente Pires, 25 - Brasília,
Brasília - DF""",
                            style: textFamily(context,
                                height: 1.4,
                                fontWeight: FontWeight.w600,
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.8))),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: wXD(12, context),
            child: Icon(
              Icons.arrow_forward,
              size: wXD(20, context),
              color: getColors(context).primary,
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceLocale extends StatefulWidget {
  const ServiceLocale({Key? key}) : super(key: key);

  @override
  State<ServiceLocale> createState() => _ServiceLocaleState();
}

class _ServiceLocaleState extends State<ServiceLocale> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.only(
        left: wXD(18, context),
        bottom: wXD(30, context),
        right: wXD(18, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Onde o serviço será prestado?",
            style: textFamily(
              context,
              color: veryDarkPurple,
              fontSize: 18,
            ),
          ),
          SizedBox(height: wXD(15, context)),
          Row(
            children: [
              getTile("Apartamento", false),
              getTile("Casa", true),
              getTile("Escritório", false),
            ],
          ),
        ],
      ),
    );
  }

  Widget getTile(String name, bool selected) => Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: wXD(7, context),
              horizontal: wXD(13, context),
            ),
            decoration: BoxDecoration(
              color: selected
                  ? getColors(context).primary
                  : getColors(context).surface,
              border: Border.all(
                color: selected
                    ? getColors(context).primary
                    : getColors(context).onBackground,
              ),
              borderRadius: defBorderRadius(context),
            ),
            alignment: Alignment.center,
            child: Text(
              name,
              style: textFamily(
                context,
                color: selected
                    ? getColors(context).onPrimary
                    : getColors(context).onBackground,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(width: wXD(8, context)),
        ],
      );
}

class ServiceToProvide extends StatelessWidget {
  final bool confirmation;
  ServiceToProvide({Key? key, this.confirmation = false}) : super(key: key);

  final HomeStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.only(
        left: wXD(18, context),
        bottom: wXD(30, context),
        right: wXD(18, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  confirmation
                      ? "Descrição do serviço"
                      : "Qual serviço será prestado?",
                  style: textFamily(
                    context,
                    color: veryDarkPurple,
                    fontSize: 18,
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(400),
                child: Container(
                  height: wXD(25, context),
                  width: wXD(25, context),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "./assets/svg/help.svg",
                    height: wXD(21, context),
                    width: wXD(21, context),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: wXD(15, context)),
          Container(
            width: double.infinity,
            height: wXD(106, context),
            padding: EdgeInsets.symmetric(
              vertical: wXD(12, context),
              horizontal: wXD(10, context),
            ),
            decoration: BoxDecoration(
              color: getColors(context).surface,
              border: Border.all(
                color: getColors(context).onBackground,
              ),
              borderRadius: defBorderRadius(context),
            ),
            child: TextField(
              maxLines: 15,
              style: textFamily(
                context,
                color: veryDarkPurple.withOpacity(.3),
              ),
              decoration: InputDecoration.collapsed(
                hintText:
                    "Descreva aqui o serviço que espera a ser solicitado!",
                hintStyle: textFamily(
                  context,
                  color: veryDarkPurple.withOpacity(.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceInstruction extends StatelessWidget {
  final bool confirmation;

  ServiceInstruction({Key? key, this.confirmation = false}) : super(key: key);

  final HomeStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.only(
        bottom: wXD(30, context),
        top: wXD(confirmation ? 0 : 30, context),
        right: wXD(18, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  confirmation
                      ? "Instruções"
                      : "Onde estará a chave do imóvel e instruções específicas.",
                  style: textFamily(
                    context,
                    color: veryDarkPurple,
                    fontSize: 18,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // print("show infor overlay");
                  store.infoOverlay = OverlayEntry(
                    builder: (context) => InfoOverlay(
                      onBack: () {
                        store.infoOverlay!.remove();
                        store.infoOverlay = null;
                      },
                      title:
                          "Onde estará a chave do imóvel e instruções específicas",
                      description:
                          "Informe à diarista se haverá alguém esperando por ela ou se a chave estará em algum local específico e forneça mais detalhes sobre os serviços a serem prestados.",
                    ),
                  );
                  Overlay.of(context)!.insert(store.infoOverlay!);
                },
                borderRadius: BorderRadius.circular(400),
                child: Container(
                  height: wXD(25, context),
                  width: wXD(25, context),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "./assets/svg/help.svg",
                    height: wXD(21, context),
                    width: wXD(21, context),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: wXD(15, context)),
          Container(
            width: double.infinity,
            height: wXD(106, context),
            padding: EdgeInsets.symmetric(
              vertical: wXD(12, context),
              horizontal: wXD(10, context),
            ),
            decoration: BoxDecoration(
              color: getColors(context).surface,
              border: Border.all(
                color: getColors(context).onBackground,
              ),
              borderRadius: defBorderRadius(context),
            ),
            child: TextField(
              maxLines: 15,
              style: textFamily(
                context,
                color: veryDarkPurple.withOpacity(.3),
              ),
              decoration: InputDecoration.collapsed(
                hintText:
                    "Informe ser você estará em casa ou se a chave estará com o porteiro ou zelador.",
                hintStyle: textFamily(
                  context,
                  color: veryDarkPurple.withOpacity(.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HoursOfService extends StatelessWidget {
  final bool confirmation;
  final HomeStore store = Modular.get();

  HoursOfService({this.confirmation = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.only(
        left: wXD(18, context),
        bottom: wXD(30, context),
        right: wXD(18, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            confirmation
                ? "Hora(s) de contratação"
                : "Quantas hora(s) pretende contratar?",
            style: textFamily(
              context,
              color: veryDarkPurple,
              fontSize: 18,
            ),
          ),
          Center(
            child: Container(
              width: wXD(300, context),
              padding: EdgeInsets.only(
                top: wXD(confirmation ? 15 : 57, context),
                bottom: wXD(confirmation ? 0 : 67, context),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  changeHoursButton(
                    context,
                    false,
                    () => store.changeHour(-1),
                  ),
                  Observer(
                    builder: (context) {
                      return Text(
                        store.hours > 1
                            ? "${store.hours} Horas"
                            : "${store.hours} Hora",
                        style: textFamily(
                          context,
                          color: veryDarkPurple,
                          fontWeight: FontWeight.w600,
                          fontSize: 27,
                        ),
                      );
                    },
                  ),
                  changeHoursButton(
                    context,
                    true,
                    () => store.changeHour(1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget changeHoursButton(context, bool add, void Function() onTap) {
    return Container(
      height: wXD(45, context),
      width: wXD(45, context),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: add ? getColors(context).primary : getColors(context).onPrimary,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(0, 3),
            color: getColors(context).shadow,
          )
        ],
      ),
      alignment: Alignment.center,
      child: Ink(
        height: wXD(45, context),
        width: wXD(45, context),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(5000),
            onTap: onTap,
            child: Icon(
              add ? Icons.add_rounded : Icons.remove_rounded,
              size: wXD(34, context),
              color: add
                  ? getColors(context).onPrimary
                  : getColors(context).primary,
            ),
          ),
        ),
      ),
    );
  }
}

class TotalOfService extends StatelessWidget {
  final bool confirmation;
  final bool small;

  TotalOfService({
    Key? key,
    this.confirmation = false,
    this.small = false,
  }) : super(key: key);

  final HomeStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.only(
        bottom: wXD(small ? 0 : 30, context),
        top: wXD(small ? 30 : 0, context),
        left: wXD(18, context),
        right: wXD(18, context),
      ),
      alignment: Alignment.centerLeft,
      child: Observer(builder: (context) {
        return Row(
          children: [
            Text(
              confirmation && !small ? "Preço do atendimento: " : "Total: ",
              style: textFamily(
                context,
                color: veryDarkPurple,
                fontSize: confirmation ? 18 : 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (small) Spacer(),
            Text(
              "R\$ ${25 * store.hours},00",
              style: textFamily(
                context,
                color: getColors(context).primary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class InHome extends StatelessWidget {
  final bool confirmation;

  InHome({Key? key, this.confirmation = false}) : super(key: key);

  final HomeStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: wXD(18, context)),
      child: Observer(
        builder: (context) {
          return Column(
            children: [
              if (!confirmation) ...[
                GestureDetector(
                  onTap: () => store.inHome = true,
                  child: Row(
                    children: [
                      Container(
                        height: wXD(20, context),
                        width: wXD(20, context),
                        margin: EdgeInsets.only(right: wXD(3, context)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(
                            color: getColors(context).onSurface.withOpacity(.7),
                          ),
                          color: store.inHome
                              ? getColors(context).primary
                              : Colors.transparent,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.check,
                          size: wXD(15, context),
                          color: getColors(context).surface,
                        ),
                      ),
                      Text(
                        'Estou em casa',
                        style: textFamily(
                          context,
                          fontSize: 13,
                          color: getColors(context).onSurface.withOpacity(.7),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: wXD(8, context)),
                GestureDetector(
                  onTap: () => store.inHome = false,
                  child: Row(
                    children: [
                      Container(
                        height: wXD(20, context),
                        width: wXD(20, context),
                        margin: EdgeInsets.only(right: wXD(3, context)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(
                            color: getColors(context).onSurface.withOpacity(.7),
                          ),
                          color: !store.inHome
                              ? getColors(context).primary
                              : Colors.transparent,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.check,
                          size: wXD(15, context),
                          color: getColors(context).surface,
                        ),
                      ),
                      Text(
                        'Não estou em casa',
                        style: textFamily(
                          context,
                          fontSize: 13,
                          color: getColors(context).onSurface.withOpacity(.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              !store.inHome || confirmation
                  ? ServiceInstruction(confirmation: confirmation)
                  : SizedBox(height: wXD(156, context)),
            ],
          );
        },
      ),
    );
  }
}

class ServicePaymentMethod extends StatelessWidget {
  final bool confirmation;

  const ServicePaymentMethod({Key? key, this.confirmation = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (confirmation)
      return Container(
        width: maxWidth(context),
        margin: EdgeInsets.only(bottom: wXD(45, context)),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: getColors(context).onSurface.withOpacity(.3))),
        ),
        child: Column(
          children: [
            TotalOfService(confirmation: true, small: true),
            Container(
              width: maxWidth(context),
              padding: EdgeInsets.only(
                  left: wXD(18, context),
                  right: wXD(18, context),
                  top: wXD(25, context),
                  bottom: wXD(30, context)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: wXD(11, context)),
                    child: Text(
                      "Método de pagamento:",
                      style: textFamily(
                        context,
                        color: veryDarkPurple,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Container(
                        width: wXD(132, context),
                        height: wXD(51, context),
                        padding: EdgeInsets.symmetric(
                          horizontal: wXD(20, context),
                          vertical: wXD(5.1, context),
                        ),
                        decoration: BoxDecoration(
                          color: getColors(context).primary.withOpacity(.3),
                          borderRadius: defBorderRadius(context),
                          border: Border.all(color: getColors(context).primary),
                        ),
                        child: SvgPicture.asset("./assets/svg/credit.svg"),
                      ),
                      SizedBox(height: wXD(5, context)),
                      Text(
                        "Crédito",
                        style: textFamily(
                          context,
                          color: veryDarkPurple,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.only(
        left: wXD(18, context),
        right: wXD(18, context),
        bottom: wXD(15, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Forma de pagamento:",
            style: textFamily(
              context,
              color: veryDarkPurple,
              fontSize: 18,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: wXD(10, context),
              vertical: wXD(15, context),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      width: wXD(132, context),
                      height: wXD(51, context),
                      padding: EdgeInsets.symmetric(
                        horizontal: wXD(8.6, context),
                        vertical: wXD(5.1, context),
                      ),
                      decoration: BoxDecoration(
                          color: getColors(context).surface,
                          borderRadius: defBorderRadius(context),
                          border:
                              Border.all(color: getColors(context).onSurface)),
                      child: SvgPicture.asset(
                        "./assets/svg/pix.svg",
                        width: wXD(114, context),
                        height: wXD(41, context),
                      ),
                    ),
                    SizedBox(height: wXD(5, context)),
                    Text(
                      "PIX",
                      style: textFamily(
                        context,
                        color: veryDarkPurple,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: wXD(132, context),
                      height: wXD(51, context),
                      padding: EdgeInsets.symmetric(
                        horizontal: wXD(20, context),
                        vertical: wXD(5.1, context),
                      ),
                      decoration: BoxDecoration(
                        color: getColors(context).primary.withOpacity(.3),
                        borderRadius: defBorderRadius(context),
                        border: Border.all(color: getColors(context).primary),
                      ),
                      child: SvgPicture.asset("./assets/svg/credit.svg"),
                    ),
                    SizedBox(height: wXD(5, context)),
                    Text(
                      "Crédito",
                      style: textFamily(
                        context,
                        color: veryDarkPurple,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceCheck extends StatelessWidget {
  final Widget? child;
  final String? title;
  final String? content;
  final bool longContent;
  final bool centerCheck;

  ServiceCheck({
    Key? key,
    this.child,
    this.title,
    this.content,
    this.longContent = false,
    this.centerCheck = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      padding: EdgeInsets.symmetric(
        horizontal: wXD(18, context),
        vertical: wXD(25, context),
      ),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: getColors(context).onSurface.withOpacity(.3))),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment:
            centerCheck ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_rounded,
            size: wXD(30, context),
            color: getColors(context).primary,
          ),
          SizedBox(width: wXD(10, context)),
          child ?? getBody(context),
        ],
      ),
    );
  }

  Widget getBody(context) => longContent
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? "",
              style: textFamily(
                context,
                color: veryDarkPurple,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: wXD(10, context)),
            SizedBox(
              width: wXD(298, context),
              child: Text(
                content ?? "",
                maxLines: 10,
                style: textFamily(
                  context,
                  color: getColors(context).onSurface.withOpacity(.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        )
      : Row(
          children: [
            Text(
              title ?? "",
              style: textFamily(
                context,
                color: veryDarkPurple,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: wXD(10, context)),
            Text(
              content ?? "",
              style: textFamily(
                context,
                color: veryDarkPurple,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
}

class InfoOverlay extends StatefulWidget {
  final void Function() onBack;
  final String title;
  final String description;
  const InfoOverlay({
    Key? key,
    required this.onBack,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  State<InfoOverlay> createState() => _InfoOverlayState();
}

class _InfoOverlayState extends State<InfoOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      value: 0,
    );
    animateTo(1);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> animateTo(double value) async {
    await _controller.animateTo(value, curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: maxHeight(context),
      width: maxWidth(context),
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double value = _controller.value;
            return Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: value * 2 + 0.001,
                    sigmaY: value * 2 + 0.001,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      await animateTo(0);
                      widget.onBack();
                    },
                    child: Container(
                      height: maxHeight(context),
                      width: maxWidth(context),
                      color: getColors(context).shadow.withOpacity(value * .3),
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                Positioned(
                  top: maxHeight(context) - (wXD(231, context) * value),
                  child: Container(
                    width: maxWidth(context),
                    height: wXD(231, context),
                    padding: EdgeInsets.all(wXD(30, context)),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(19)),
                      color: getColors(context).surface,
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "./assets/svg/help.svg",
                              height: wXD(21, context),
                              width: wXD(21, context),
                            ),
                            SizedBox(width: wXD(10, context)),
                            Expanded(
                              child: Text(
                                widget.title,
                                style: textFamily(
                                  context,
                                  fontSize: 17,
                                  color: veryDarkPurple,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: wXD(36, context)),
                        Text(
                          widget.description,
                          textAlign: TextAlign.center,
                          style: textFamily(
                            context,
                            fontSize: 12,
                            color: veryDarkPurple,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
