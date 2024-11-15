import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unicorn_flutter/Constants/Enum/progress_view_enum.dart';
import 'package:unicorn_flutter/Model/Entity/ChronicDisease/chronic_disease.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email.dart';
import 'package:unicorn_flutter/Model/Entity/User/physical_info.dart';
import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';
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
import 'package:unicorn_flutter/View/Component/Pages/Register/register_address_info_view.dart';
import 'package:unicorn_flutter/View/Profile/AppInformation/license_view.dart';
import 'package:unicorn_flutter/View/Profile/ChronicDisease/chronic_disease_view.dart';
import 'package:unicorn_flutter/View/Profile/ChronicDisease/disease_search_view.dart';
import 'package:unicorn_flutter/View/Profile/FamilyEmail/family_email_register_view.dart';
import 'package:unicorn_flutter/View/Profile/FamilyEmail/family_email_view.dart';
import 'package:unicorn_flutter/View/Profile/Medicine/medicine_setting_view.dart';
import 'package:unicorn_flutter/View/Profile/Medicine/medicine_view.dart';
import 'package:unicorn_flutter/View/Component/Pages/Register/register_physical_info_view.dart';
import 'package:unicorn_flutter/View/Profile/AppInformation/app_information_view.dart';
import 'package:unicorn_flutter/View/Profile/NotificationSetting/notification_setting_view.dart';
import 'package:unicorn_flutter/View/Profile/profile_top_view.dart';
import 'package:unicorn_flutter/View/Profile/LocalAuth/local_auth_view.dart';
import 'package:unicorn_flutter/View/Component/Pages/Register/register_user_info_view.dart';
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
        TypedGoRoute<ProfileRegisterPhysicalInfoRoute>(
          path: Routes.profileRegisterPhysicalInfo,
        ),
        TypedGoRoute<ProfileRegisterAddressInfoRoute>(
          path: Routes.profileRegisterAddressInfo,
        ),
        TypedGoRoute<ProfileRegisterUserInfoRoute>(
          path: Routes.profileRegisterUserInfo,
        ),
        TypedGoRoute<ProfileLocalAuthRoute>(
          path: Routes.profileLocalAuth,
        ),
        TypedGoRoute<ProfileAppInformationRoute>(
          path: Routes.profileAppInformation,
        ),
        TypedGoRoute<ProfileAppInformationLicenseRoute>(
          path: Routes.profileAppInformationLicense,
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

@TypedGoRoute<RegisterPhysicalInfoRoute>(
  path: Routes.registerPhysicalInfo,
)
class RegisterPhysicalInfoRoute extends GoRouteData {
  const RegisterPhysicalInfoRoute({
    required this.from,
  });
  final String from;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      // todo: View側でfromを受け取れるように変更
      const RegisterPhysicalInfoView();
}

@TypedGoRoute<RegisterAddressInfoRoute>(
  path: Routes.registerAddressInfo,
)
class RegisterAddressInfoRoute extends GoRouteData {
  const RegisterAddressInfoRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RegisterAddressInfoView();
}

@TypedGoRoute<RegisterUserInfoRoute>(
  path: Routes.registerUserInfo,
)
class RegisterUserInfoRoute extends GoRouteData {
  const RegisterUserInfoRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RegisterUserInfoView();
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
  const ChatDoctorInformationRoute(
    this.doctorId,
  );

  final String doctorId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      DoctorInformationView(
        doctorId: doctorId,
      );
}

class ChatDoctorTextChatRoute extends GoRouteData {
  ChatDoctorTextChatRoute(
    this.doctorId,
    this.doctorName,
  );
  String doctorId;
  String doctorName;

  @override
  Widget build(BuildContext context, GoRouterState state) => DoctorTextChatView(
        doctorId: doctorId,
        doctorName: doctorName,
      );
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

class ProfileRegisterPhysicalInfoRoute extends GoRouteData {
  const ProfileRegisterPhysicalInfoRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RegisterPhysicalInfoView();
}

class ProfileRegisterAddressInfoRoute extends GoRouteData {
  ProfileRegisterAddressInfoRoute({required this.$extra});
  PhysicalInfo $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RegisterAddressInfoView(
        physicalInfo: $extra,
      );
}

class ProfileRegisterUserInfoRoute extends GoRouteData {
  const ProfileRegisterUserInfoRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RegisterUserInfoView();
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

class ProfileAppInformationLicenseRoute extends GoRouteData {
  const ProfileAppInformationLicenseRoute({required this.appVersion});
  final String appVersion;

  @override
  Widget build(BuildContext context, GoRouterState state) => LicenseView(
        appVersion: appVersion,
      );
}

class ProfileNotificationSettingRoute extends GoRouteData {
  const ProfileNotificationSettingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NotificationSettingView();
}

class ProfileFamilyEmailRoute extends GoRouteData {
  const ProfileFamilyEmailRoute({required this.from});
  final String from;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      FamilyEmailView(from: from);
}

class ProfileFamilyEmailRegisterRoute extends GoRouteData {
  const ProfileFamilyEmailRegisterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FamilyEmailRegisterView();
}

class ProfileFamilyEmailSyncContactRoute extends GoRouteData {
  const ProfileFamilyEmailSyncContactRoute({
    required this.from,
    this.$extra,
  });
  final String from;
  final List<FamilyEmail>? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) => FamilyEmailView(
        from: from,
        registeredEmailList: $extra,
      );
}

class ProfileMedicineRoute extends GoRouteData {
  const ProfileMedicineRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const MedicineView();
}

class ProfileMedicineSettingRoute extends GoRouteData {
  const ProfileMedicineSettingRoute({
    this.$extra,
  });
  final Medicine? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MedicineSettingView(
        medicine: $extra,
      );
}

class ProfileChronicDiseaseRoute extends GoRouteData {
  const ProfileChronicDiseaseRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ChronicDiseaseView();
}

class ProfileChronicDiseaseSearchRoute extends GoRouteData {
  const ProfileChronicDiseaseSearchRoute({
    this.$extra,
  });
  final List<ChronicDisease>? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) => DiseaseSearchView(
        chronicDiseaseList: $extra,
      );
}
//////////////////////////////  profile  //////////////////////////////