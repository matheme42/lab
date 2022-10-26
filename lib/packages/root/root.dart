import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'context.dart';
import 'undefined.dart';

/// la class ce-dessous [RootObserver] correspond a la partie [StatefulWidget]
/// de la class [Root]
/// Tous ce qui nécessite un [StatefulWidget] pour etre réalisé est réalisé ici
class RootObserver extends StatefulWidget {
  /// [child] correspond au [Navigator] de l'application
  /// le widget [RootObserver] sera par concéquent placé avant le [Navigator]
  /// et vice-et-versa
  final Widget child;

  /// [onTurnBackground] est la fonction présente dans [RootContext]
  /// cette fonction sera appelé ici à chaque que le widget via l'implémentation
  /// du mixin [WidgetsBindingObserver] détectera un passage en arrière-plan
  /// de l'application
  final Function onTurnBackground;

  /// [onTurnForeground] est la fonction présente dans [RootContext]
  /// cette fonction sera appelé ici à chaque que le widget via l'implémentation
  /// du mixin [WidgetsBindingObserver] détectera un passage en arrière-plan
  /// de l'application
  final Function onTurnForeground;

  /// [hasLoading] est un boolean amené au moment de la déclaration de [Root]
  ///   false --> pas de loading à gérer
  ///   true  --> un loading à gérer
  final bool hasLoading;

  /// [loading] est la fonction présente dans [RootContext]
  /// cette fonction sera appelé ici pour lancer le chargement avec une vue ou
  /// non de l'application. Cette fonction va de paire avec un [Widget] overlay
  /// qui porte le nom de [loadingOverlay]
  final Future<void> Function() loading;

  /// [loadingOverlay] est une vue qui se met à la place de la vue de base
  /// le temps de la fonction [loading] et du temps [loadingMinDuration]
  final Widget? loadingOverlay;

  /// [loadingMinDuration] permet de donnée un temps minimal d'affichage de
  /// l'overlay de chargement
  /// utile au cas ou le chargement serait très rapide
  final Duration? loadingMinDuration;

  /// [scrollController] permet de controller la scrollView principale
  /// de l'application.
  final ScrollController scrollController;

  const RootObserver(
      {Key? key,
      required this.child,
      required this.scrollController,
      required this.onTurnBackground,
      required this.onTurnForeground,
      required this.hasLoading,
      required this.loading,
      this.loadingOverlay,
      this.loadingMinDuration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => RootObserveState();
}

/// la class ci-dessous [RootObserveState] correspond a la définition
/// d'un état de [RootObserver]
/// cette class embarque avec ell [WidgetsBindingObserver] ce qui lui permettra
/// de savoir quand l'application sera en arrière plan / avant plan
class RootObserveState extends State<RootObserver> with WidgetsBindingObserver {
  /// variable local [_loading] permet de savoir si l'application est en
  /// chargement de départ.
  /// Duplication de la variable [widget.hasLoading]
  /// false --> ne pas affiche [widget.loadingOverlay]
  /// true  --> affiche [widget.loadingOverlay]
  bool _loading = false;

  /// la fonction ci-dessous [_onLoading]
  /// appel la fonction [widget.loading] et vérifie que le temps
  /// [widget.loadingMinDuration] est passé dans le cas contraire
  /// elle attends par tranche de 100 [milliseconds]
  /// puis repasse la variable [_loading] afin de retirer
  /// l'overlay
  Future<void> _onLoading() async {
    DateTime startLoading = DateTime.now().toUtc();
    await widget.loading();
    int delay = widget.loadingMinDuration!.inSeconds;
    while (DateTime.now().toUtc().difference(startLoading).inSeconds < delay) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    setState(() => _loading = false);
  }

  /// la fonction [initState] est appelé 1 fois lors du démarrage du programme
  /// declare une instance [WidgetsBinding]
  /// retire la barre d'état pour plus d'immersion [setEnabledSystemUIMode]
  /// retire le [FlutterNativeSplash] mis au préalable lors du démarrage de la
  /// class [Root]
  /// et lance le chargement [_onLoading] si [widget.hasLoading] il y a un chargement
  ///
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    FlutterNativeSplash.remove();
    if (widget.hasLoading == false) return;
    _loading = true;
    _onLoading();
  }

  ///la fonction [didChangeDependencies] ajoute un [listener] sur le
  /// [FocusManager]. Ce qui permet par la suite de réagir au changement de
  /// focus.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FocusManager.instance.addListener(_onFocusChange);
  }

  /// Permet de garder a l'écran l'élement selectionné
  Future <void>keepFocusInScreen(double y) async {
    double h = MediaQuery.of(context).size.height;
    double must = (y + widget.scrollController.offset) - (h / 3);
    await Future.delayed(const Duration(milliseconds: 300));
    widget.scrollController.animateTo(must,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear);
  }

  void _onFocusChange() {
    if (FocusManager.instance.primaryFocus?.context == null) return;
    if (FocusManager.instance.primaryFocus! is FocusScopeNode) return;
    keepFocusInScreen(FocusManager.instance.primaryFocus!.offset.dy);
  }

  /// supprime une l'instance [WidgetsBinding]
  /// NE DOIT ARRIVER QU'A LA MORT DE L'APPLICATION
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// [didChangeAppLifecycleState] est une fonction override du mixin
  /// [WidgetsBindingObserver] ce qui permet de connaître l'état de
  /// l'application.
  /// en cas de changement cet fonction sera appelé
  /// et l'information sera renvoyé au context via [widget.onTurnBackground] et
  /// [widget.onTurnForeground]
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        widget.onTurnBackground();
        break;
      case AppLifecycleState.resumed:
        widget.onTurnForeground();
        break;
      case AppLifecycleState.paused:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _loading ? widget.loadingOverlay : const SizedBox.shrink(),
      ),
      _loading ? const SizedBox.shrink() : widget.child
    ]);
  }
}

/// la class [Root]  correspond a la racine de l'application
/// C'est elle qui contient la [MaterialApp] nécessaire à l'application
/// Lors de l'instanciation de cette class, elle doit être associé à un context
/// context qui doit être une extension de [RootContext]
class Root<T extends RootContext> extends StatelessWidget {
  /// le titre [title] correspond au nom du processus résultant du lancement de
  /// l'application.
  /// Pour plus d'informations voir [title] dans [MaterialApp]
  final String title;

  /// Correspond au theme Dark [darkTheme] de l'application
  final ThemeData? darkTheme;

  /// Correspond au theme [theme] par default de l'application
  final ThemeData? theme;

  /// les routes [routes] correspondent au différente vue qu'a a offrir
  /// l'application. Elle vont de paire avec le [Navigator]
  /// pour controller l'animation de changement de page voir [onGenerateRoute]
  final Map<String, Widget Function(BuildContext)>? routes;

  /// [initialRoute] Définie la route dans [routes] qui sera utilisé au moment
  /// du lancement de l'application. Par default elle choisira la route '/'
  final String initialRoute;

  /// [onUnknownRoute] correspond à la route par default vers laquel se tourner
  /// lorqu'une route n'est pas connu. Typiquement l'erreur 404 sur les
  /// navigateur. Par default [Root] redirigera vers [UndefinedView]
  final RouteFactory? onUnknownRoute;

  /// [onGenerateRoute] permet de controller la façon dont chaque route
  /// au sein de [routes] sera initialises.
  /// Permet de controller l'animation ou les parametres.
  final RouteFactory? onGenerateRoute;

  /// [locale] Permet de donnée la langue à utiliser pour l'application.
  /// Cette variable [locale] facilite internationalization.
  /// va de paire avec le getter [setLocale]. Lors du changement sur la variable
  /// [locale] toute l'application [MaterialApp] est rebuild.
  final ValueNotifier<Locale?> locale = ValueNotifier(null);

  /// [hasLoading] est un boolean pour définir si il y a un travail de loading
  /// à éffectuer ou non.
  /// false --> pas d'overlay à mettre et pas de fonction à appeler
  /// true  --> overlay et fonction à appeler
  final bool hasLoading;

  /// [loadingOverlay] et le widget a mettre pendant que la fonction de loading
  /// ou que le temps [loadingMinDuration] soit éffectuer. Arrive apres le
  /// Splash Screen et avant le widget associé à la route initial [initialRoute]
  final Widget? loadingOverlay;

  /// définie le temps minimal d'affichage du widget [loadingOverlay]. Peut
  /// être plus long au cas ou las fonction [appContext.loading] mettes du temps
  final Duration loadingMinDuration;

  /// [debugShowCheckedModeBanner] défini si l'affichage de la banniere de debug
  /// Pour plus d'info voir les commentaires sur [MaterialApp]
  final bool debugShowCheckedModeBanner;

  /// [debugShowCheckedModeBanner] défini si l'overlay des performance doivent
  /// être affichés. Pour plus d'info voir les commentaires sur [MaterialApp]
  final bool showPerformanceOverlay;

  /// [showSemanticsDebugger] défini si le débuggage des semantics doivent être
  /// affichés. Pour plus d'info voir les commentaires sur [MaterialApp]
  final bool showSemanticsDebugger;

  /// [debugShowMaterialGrid] défini si la grille materiel doit être affichés.
  /// Pour plus d'info voir les commentaires sur [MaterialApp]
  final bool debugShowMaterialGrid;

  /// Correspond au context [appContext] dans laquel l'application va tourner
  /// ce champs est de type [T] est doit être un héritage du type [RootContext]
  /// Pour plus d'informations sur son contenu voir [RootContext].
  ///
  /// [appContext] est mis à disposition a l'aide d'un [Provider] avant même
  /// le [Navigator] ce qui le rend accessible sur toute les views [Widget] de
  /// l'application.
  final T appContext;

  Root({
    Key? key,
    this.title = "",
    this.initialRoute = "/",
    this.routes,
    this.theme,
    this.darkTheme,
    this.loadingOverlay,
    this.loadingMinDuration = const Duration(seconds: 0),
    this.debugShowCheckedModeBanner = false,
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowMaterialGrid = false,
    this.onUnknownRoute,
    required context,
    this.onGenerateRoute,
    this.hasLoading = false,
  }) : assert(onGenerateRoute != null || routes != null), appContext = context,
    super(key: key) {
    run();
  }

  ///Singleton [_root] de la class [Root]
  ///permet de retrouver l'instance de n'importe ou
  static late Root _root;

  /// Permet de récuperer l'instance [Root]
  /// A n'utiliser que pour changer la [locale]
  static Root get ofContext => _root;

  /// [setLocale] Permet de changer la langue [locale] de l'application
  /// recharge toute l'application [MaterialApp]
  void setLocale(Locale value) => locale.value = value;

  /// [_started] donne l'information sur le faite qu'une instance [Root] à déjà
  /// été lancé, et par consequent ne peut pas être relancé.
  /// false --> aucune instance n'as été démarré.
  /// true  --> une instance est déjà en cours d'execution
  static bool _started = false;

  /// la fonction [run] permet de lancer l'application. Elle est appelé par le
  /// constructeur et donc lors de l'instanciation de [Root].
  /// ne peut être appelé qu'une fois par application.
  /// [run] contient la fonction [runApp]
  /// elle défini [_root] et appel [appContext.configure].
  /// Met également en place le splash screen [FlutterNativeSplash]
  Future<void> run() async {
    if (_started == true) return;
    _started = true;

    _root = this;
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    await Future.delayed(const Duration(milliseconds: 500));
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await appContext.configure();
    runApp(this);
  }

  /// le premier context qui sera build [_firstContext] par l'application
  /// il est necessaire [defaultOnGenerateRoute] pour [defaultOnUnknownRoute]
  final ValueNotifier<BuildContext?> _firstContext = ValueNotifier(null);

  /// la [defaultOnGenerateRoute] utilisé quand [onGenerateRoute] n'est pas
  /// défini
  Route<dynamic>? defaultOnGenerateRoute(RouteSettings settings) {
    if (!routes!.containsKey(settings.name)) {
      return null;
    }
    return PageTransition(
        child: routes![settings.name]!(_firstContext.value!),
        type: PageTransitionType.fade,
        settings: settings);
  }

  /// la [defaultOnUnknownRoute] utilisé quand [onUnknownRoute] n'est pas défini
  Route<dynamic>? defaultOnUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) {
      return UndefinedView(name: settings.name);
    });
  }

  /// permet de fermer le clavier [closeKeyboard] en ce servant du [Focus]
  /// a besoin du [BuildContext]
  void closeKeyboard(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChrome.restoreSystemUIOverlays();
  }

  @override
  Widget build(BuildContext context) {
    _firstContext.value = context;
    return ValueListenableBuilder<Locale?>(
        valueListenable: locale,
        builder: (context, locale, _) {
          return MaterialApp(
            title: title,
            routes: routes ?? const {},
            theme: theme,
            darkTheme: darkTheme,
            showPerformanceOverlay: showPerformanceOverlay,
            showSemanticsDebugger: showSemanticsDebugger,
            debugShowMaterialGrid: debugShowMaterialGrid,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            initialRoute: initialRoute,
            locale: locale,
            onGenerateRoute: onGenerateRoute ?? defaultOnGenerateRoute,
            onUnknownRoute: onUnknownRoute ?? defaultOnUnknownRoute,
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
            builder: navigatorBuilder,
          );
        });
  }

  /// le [ScrollController] de la [SingleChildScrollView] principal de
  /// l'application. Le controller [_scrollController] est liée avec
  /// la [SingleChildScrollView] ci-dessous.
  final ScrollController _scrollController = ScrollController();

  /// [_globalVisible] permet de garder l'ancien status en memoire
  final ValueNotifier<bool> _globalVisible = ValueNotifier(false);

  Widget navigatorBuilder(BuildContext context, Widget? navigator) {
    MediaQueryData q = MediaQuery.of(context);
    return SafeArea(
        child: GestureDetector(
      onTapDown: (_) => closeKeyboard(context),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        controller: _scrollController,
        child: SizedBox(
            height: q.viewInsets.bottom + q.size.height - q.padding.top,
            child: ChangeNotifierProvider(
                create: (context) => appContext,
                child: KeyboardVisibilityBuilder(builder: (context, visible) {
                  if (visible != _globalVisible.value) {
                    if (!visible) closeKeyboard(context);
                    appContext.onKeyboardChange.add(visible);
                    _globalVisible.value = visible;
                  }
                  return RootObserver(
                    onTurnBackground: appContext.onTurnBackground,
                    onTurnForeground: appContext.onTurnForeground,
                    loading: appContext.loading,
                    hasLoading: hasLoading,
                    loadingOverlay: loadingOverlay,
                    loadingMinDuration: loadingMinDuration,
                    scrollController: _scrollController,
                    child: navigator!,
                  );
                }))),
      ),
    ));
  }
}
