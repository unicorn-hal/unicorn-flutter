import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unicorn_flutter/Route/navigation_shell.dart';
import 'package:unicorn_flutter/View/Chat/chat_top_view.dart';
import 'package:unicorn_flutter/View/HealthCheckup/health_checkup_top_view.dart';
import 'package:unicorn_flutter/View/Home/home_view.dart';
import 'package:unicorn_flutter/View/Profile/FamilyEmail/family_email_edit_view.dart';
import 'package:unicorn_flutter/View/Profile/FamilyEmail/family_email_setting_view.dart';
import 'package:unicorn_flutter/View/Profile/profile_top_view.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';
import 'package:unicorn_flutter/View/top_loading_view.dart';
import 'routes.dart';

part 'router.g.dart';

/// NavigatorKey
final rootNavigatorKey = GlobalKey<NavigatorState>();
final homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: Routes.home);
final healthCheckupNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: Routes.healthCheckup);
final chatNavigatorKey = GlobalKey<NavigatorState>(debugLabel: Routes.chat);
final profileNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: Routes.profile);

/// GoRouterProvider
final routerProvider = Provider(
  (ref) => GoRouter(
    debugLogDiagnostics: true,
    routes: $appRoutes,
  ),
);

//////////////////////////////  Initialize  //////////////////////////////
@TypedStatefulShellRoute<AppShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<HomeBranch>(
      routes: [
        TypedGoRoute<HomeRoute>(
          path: Routes.home,
        ),
      ],
    ),
    TypedStatefulShellBranch<HealthCheckupBranch>(
      routes: [
        TypedGoRoute<HealthCheckupRoute>(
          path: Routes.healthCheckup,
        ),
      ],
    ),
    TypedStatefulShellBranch<ChatBranch>(
      routes: [
        TypedGoRoute<ChatRoute>(
          path: Routes.chat,
        ),
      ],
    ),
    TypedStatefulShellBranch<ProfileBranch>(
      routes: [
        TypedGoRoute<ProfileRoute>(
          path: Routes.profile,
        ),
        TypedGoRoute<ProfileFamilyEmailRoute>(
          path: Routes.profileFamilyEmail,
        ),
        TypedGoRoute<ProfileFamilyEmailRegisterRoute>(
          path: Routes.profileFamilyEmailRegister,
        ),
        TypedGoRoute<ProfileFamilyEmailSyncContactRoute>(
          path: Routes.profileFamilyEmailSyncContact,
        ),
      ],
    ),
  ],
)
class AppShellRouteData extends StatefulShellRouteData {
  const AppShellRouteData();

  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    /// navigationShellをシングルトンで保持
    NavigationShell().set(navigationShell);

    // ignore: prefer_const_constructors
    return BottomNavigationBarView();
  }
}
//////////////////////////////  Initialize  //////////////////////////////

//////////////////////////////  Branch  //////////////////////////////
/// home
class HomeBranch extends StatefulShellBranchData {
  const HomeBranch();

  static final GlobalKey<NavigatorState> $navigatorKey = homeNavigatorKey;
}

/// healthCheckup
class HealthCheckupBranch extends StatefulShellBranchData {
  const HealthCheckupBranch();

  static final GlobalKey<NavigatorState> $navigatorKey =
      healthCheckupNavigatorKey;
}

/// chat
class ChatBranch extends StatefulShellBranchData {
  const ChatBranch();

  static final GlobalKey<NavigatorState> $navigatorKey = chatNavigatorKey;
}

/// profile
class ProfileBranch extends StatefulShellBranchData {
  const ProfileBranch();

  static final GlobalKey<NavigatorState> $navigatorKey = profileNavigatorKey;
}
//////////////////////////////  Branch  //////////////////////////////

/////////////////////////////////  Root  //////////////////////////////
@TypedGoRoute<TopLoadingRoute>(
  path: Routes.root,
)
class TopLoadingRoute extends GoRouteData {
  TopLoadingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const TopLoadingView();
}
/////////////////////////////////  Root  //////////////////////////////

//////////////////////////////  Home  //////////////////////////////
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeView();
}
//////////////////////////////  Home  //////////////////////////////

//////////////////////////////  healthCheckup  //////////////////////////////
class HealthCheckupRoute extends GoRouteData {
  const HealthCheckupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const HealthCheckupTopView();
}
//////////////////////////////  healthCheckup  //////////////////////////////

//////////////////////////////  chat  //////////////////////////////
class ChatRoute extends GoRouteData {
  const ChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ChatTopView();
}
//////////////////////////////  chat  //////////////////////////////

//////////////////////////////  profile  //////////////////////////////
class ProfileRoute extends GoRouteData {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileTopView();
}

class ProfileFamilyEmailRoute extends GoRouteData {
  const ProfileFamilyEmailRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FamilyEmailSettingView();
}

class ProfileFamilyEmailRegisterRoute extends GoRouteData {
  const ProfileFamilyEmailRegisterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FamilyEmailEditView();
}

class ProfileFamilyEmailSyncContactRoute extends GoRouteData {
  const ProfileFamilyEmailSyncContactRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FamilyEmailSettingView();
}
//////////////////////////////  profile  //////////////////////////////