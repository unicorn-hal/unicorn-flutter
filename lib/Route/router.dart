import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unicorn_flutter/Constants/Enum/progress_view_enum.dart';
import 'package:unicorn_flutter/Route/navigation_shell.dart';
import 'package:unicorn_flutter/View/Chat/Ai/TextChat/ai_text_chat_view.dart';
import 'package:unicorn_flutter/View/Chat/Doctor/TextChat/doctor_text_chat_view.dart';
import 'package:unicorn_flutter/View/Chat/Doctor/Information/doctor_information_view.dart';
import 'package:unicorn_flutter/View/Chat/Doctor/VoiceCall/Reserve/voice_call_reserve_view.dart';
import 'package:unicorn_flutter/View/Chat/Doctor/Search/doctor_search_view.dart';
import 'package:unicorn_flutter/View/Chat/chat_top_view.dart';
import 'package:unicorn_flutter/View/Component/Pages/progress_view.dart';
import 'package:unicorn_flutter/View/HealthCheckup/Checkup/ai_checkup_view.dart';
import 'package:unicorn_flutter/View/HealthCheckup/Checkup/normal_checkup_view.dart';
import 'package:unicorn_flutter/View/HealthCheckup/Results/health_checkup_results_view.dart';
import 'package:unicorn_flutter/View/HealthCheckup/health_checkup_top_view.dart';
import 'package:unicorn_flutter/View/Home/home_view.dart';
import 'package:unicorn_flutter/View/Component/Pages/address_information.dart';
import 'package:unicorn_flutter/View/Profile/ChronicDisease/chronic_disease_view.dart';
import 'package:unicorn_flutter/View/Profile/ChronicDisease/disease_search_view.dart';
import 'package:unicorn_flutter/View/Profile/FamilyEmail/family_email_edit_view.dart';
import 'package:unicorn_flutter/View/Profile/FamilyEmail/family_email_setting_view.dart';
import 'package:unicorn_flutter/View/Profile/Medicine/medicine_setting_view.dart';
import 'package:unicorn_flutter/View/Profile/Medicine/medicine_view.dart';
import 'package:unicorn_flutter/View/Component/Pages/physical_infomation_view.dart';
import 'package:unicorn_flutter/View/Profile/AppInformation/app_information_view.dart';
import 'package:unicorn_flutter/View/Profile/NotificationSetting/notification_setting_view.dart';
import 'package:unicorn_flutter/View/Profile/profile_top_view.dart';
import 'package:unicorn_flutter/View/Profile/LocalAuth/local_auth_view.dart';
import 'package:unicorn_flutter/View/Component/Pages/user_information.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';
import 'package:unicorn_flutter/View/emergency_view.dart';
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
        TypedGoRoute<AiCheckupRoute>(
          path: Routes.healthCheckupAi,
        ),
        TypedGoRoute<NormalCheckupRoute>(
          path: Routes.healthCheckupNormal,
        ),
        TypedGoRoute<CheckupProgressRoute>(
          path: Routes.healthCheckupProgress,
        ),
        TypedGoRoute<CheckupResultRoute>(
          path: Routes.healthCheckupResults,
        ),
      ],
    ),
    TypedStatefulShellBranch<ChatBranch>(
      routes: [
        TypedGoRoute<ChatRoute>(
          path: Routes.chat,
        ),
        TypedGoRoute<ChatDoctorInformationRoute>(
          path: Routes.chatDoctorInformation,
        ),
        TypedGoRoute<ChatDoctorTextChatRoute>(
          path: Routes.chatDoctorTextChat,
        ),
        TypedGoRoute<ChatDoctorVoiceCallReserveRoute>(
          path: Routes.chatVoiceCallReserve,
        ),
        TypedGoRoute<ChatDoctorSearchRoute>(
          path: Routes.chatDoctorSearch,
        ),
        TypedGoRoute<ChatAiTextChatRoute>(
          path: Routes.chatAiTextChat,
        ),
      ],
    ),
    TypedStatefulShellBranch<ProfileBranch>(
      routes: [
        TypedGoRoute<ProfileRoute>(
          path: Routes.profile,
        ),
        TypedGoRoute<ProfilePhysicalInformationRoute>(
          path: Routes.profilePhysicalInformation,
        ),
        TypedGoRoute<ProfileAddressInformationRoute>(
          path: Routes.profileAddressInformation,
        ),
        TypedGoRoute<ProfileUserInformationRoute>(
          path: Routes.profileUserInformation,
        ),
        TypedGoRoute<ProfileLocalAuthRoute>(
          path: Routes.profileLocalAuth,
        ),
        TypedGoRoute<ProfileAppInformationRoute>(
          path: Routes.profileAppInformation,
        ),
        TypedGoRoute<ProfileNotificationSettingRoute>(
          path: Routes.profileNotificationSetting,
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
        TypedGoRoute<ProfileMedicineRoute>(
          path: Routes.profileMedicine,
        ),
        TypedGoRoute<ProfileMedicineSettingRoute>(
          path: Routes.profileMedicineSetting,
        ),
        TypedGoRoute<ProfileChronicDiseaseRoute>(
          path: Routes.profileChronicDisease,
        ),
        TypedGoRoute<ProfileChronicDiseaseSearchRoute>(
          path: Routes.profileChronicDiseaseSearch,
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

@TypedGoRoute<EmergencyRoute>(
  path: Routes.emergency,
)
class EmergencyRoute extends GoRouteData {
  const EmergencyRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const EmergencyView();
}

@TypedGoRoute<EmergencyProgressRoute>(
  path: Routes.emergencyProgress,
)
class EmergencyProgressRoute extends GoRouteData {
  const EmergencyProgressRoute({
    required this.$extra,
  });

  final ProgressViewEnum $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) => ProgressView(
        progressType: $extra,
      );
}

@TypedGoRoute<PhysicalInformationRoute>(
  path: Routes.physicalInformation,
)
class PhysicalInformationRoute extends GoRouteData {
  const PhysicalInformationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PhysicalInfomationView();
}

@TypedGoRoute<AddressInformationRoute>(
  path: Routes.addressInformation,
)
class AddressInformationRoute extends GoRouteData {
  const AddressInformationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AddressInfomationView();
}

@TypedGoRoute<UserInformationRoute>(
  path: Routes.userInformation,
)
class UserInformationRoute extends GoRouteData {
  const UserInformationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const UserInfomationView();
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

class AiCheckupRoute extends GoRouteData {
  const AiCheckupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AiCheckupView();
}

class NormalCheckupRoute extends GoRouteData {
  const NormalCheckupRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NormalCheckupView();
}

class CheckupProgressRoute extends GoRouteData {
  CheckupProgressRoute({
    required this.$extra,
  });

  final ProgressViewEnum $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) => ProgressView(
        progressType: $extra,
      );
}

class CheckupResultRoute extends GoRouteData {
  const CheckupResultRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      HealthCheckupResultsView();
}
//////////////////////////////  healthCheckup  //////////////////////////////

//////////////////////////////  chat  //////////////////////////////
class ChatRoute extends GoRouteData {
  const ChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => ChatTopView();
}

class ChatDoctorInformationRoute extends GoRouteData {
  const ChatDoctorInformationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      DoctorInformationView();
}

class ChatDoctorTextChatRoute extends GoRouteData {
  const ChatDoctorTextChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      DoctorTextChatView();
}

class ChatDoctorVoiceCallReserveRoute extends GoRouteData {
  const ChatDoctorVoiceCallReserveRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      VoiceCallReserveView();
}

class ChatDoctorSearchRoute extends GoRouteData {
  const ChatDoctorSearchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => DoctorSearchView();
}

class ChatAiTextChatRoute extends GoRouteData {
  const ChatAiTextChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => AiTextChatView();
}
//////////////////////////////  chat  //////////////////////////////

//////////////////////////////  profile  //////////////////////////////
class ProfileRoute extends GoRouteData {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileTopView();
}

class ProfilePhysicalInformationRoute extends GoRouteData {
  const ProfilePhysicalInformationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PhysicalInfomationView();
}

class ProfileAddressInformationRoute extends GoRouteData {
  const ProfileAddressInformationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AddressInfomationView();
}

class ProfileUserInformationRoute extends GoRouteData {
  const ProfileUserInformationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const UserInfomationView();
}

class ProfileLocalAuthRoute extends GoRouteData {
  const ProfileLocalAuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LocalAuthView();
}

class ProfileAppInformationRoute extends GoRouteData {
  const ProfileAppInformationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AppInformationView();
}

class ProfileNotificationSettingRoute extends GoRouteData {
  const ProfileNotificationSettingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NotificationSettingView();
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

class ProfileMedicineRoute extends GoRouteData {
  const ProfileMedicineRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const MedicineView();
}

class ProfileMedicineSettingRoute extends GoRouteData {
  const ProfileMedicineSettingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const MedicineSettingView();
}

class ProfileChronicDiseaseRoute extends GoRouteData {
  const ProfileChronicDiseaseRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ChronicDiseaseView();
}

class ProfileChronicDiseaseSearchRoute extends GoRouteData {
  const ProfileChronicDiseaseSearchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DiseaseSearchView();
}
//////////////////////////////  profile  //////////////////////////////