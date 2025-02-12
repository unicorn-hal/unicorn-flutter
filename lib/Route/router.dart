import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Constants/Enum/progress_view_enum.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call_standby.dart';
import 'package:unicorn_flutter/Model/Entity/ChronicDisease/chronic_disease.dart';
import 'package:unicorn_flutter/Model/Entity/User/physical_info.dart';
import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/Model/Entity/ChronicDisease/chronic_disease.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_notification.dart';
import 'package:unicorn_flutter/Route/navigation_shell.dart';
import 'package:unicorn_flutter/View/Chat/Ai/TextChat/ai_text_chat_view.dart';
import 'package:unicorn_flutter/View/Chat/Doctor/TextChat/doctor_text_chat_view.dart';
import 'package:unicorn_flutter/View/Chat/Doctor/Information/doctor_information_view.dart';
import 'package:unicorn_flutter/View/Chat/Doctor/VoiceCall/Reserve/voice_call_reserve_view.dart';
import 'package:unicorn_flutter/View/Chat/Doctor/Search/doctor_search_view.dart';
import 'package:unicorn_flutter/View/Chat/Doctor/VoiceCall/voice_call_view.dart';
import 'package:unicorn_flutter/View/Chat/chat_top_view.dart';
import 'package:unicorn_flutter/View/Component/Pages/progress_view.dart';
import 'package:unicorn_flutter/View/HealthCheckup/Checkup/ai_checkup_view.dart';
import 'package:unicorn_flutter/View/HealthCheckup/Checkup/normal_checkup_view.dart';
import 'package:unicorn_flutter/View/HealthCheckup/Results/health_checkup_results_view.dart';
import 'package:unicorn_flutter/View/HealthCheckup/health_checkup_top_view.dart';
import 'package:unicorn_flutter/View/Home/home_view.dart';
import 'package:unicorn_flutter/View/Component/Pages/Register/register_address_info_view.dart';
import 'package:unicorn_flutter/View/Profile/AppInformation/license_view.dart';
import 'package:unicorn_flutter/View/Profile/CallReservation/call_reservation_view.dart';
import 'package:unicorn_flutter/View/Profile/ChronicDisease/chronic_disease_view.dart';
import 'package:unicorn_flutter/View/Profile/ChronicDisease/disease_search_view.dart';
import 'package:unicorn_flutter/View/Profile/FamilyEmail/family_email_register_view.dart';
import 'package:unicorn_flutter/View/Profile/FamilyEmail/family_email_sync_contact_view.dart';
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
import 'package:unicorn_flutter/View/emergency_result_view.dart';
import 'package:unicorn_flutter/View/emergency_view.dart';
import 'package:unicorn_flutter/View/sign_out_view.dart';
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
        TypedGoRoute<HomeMedicineSettingRoute>(
          path: Routes.homeMedicineSetting,
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
        TypedGoRoute<ProfileChronicDiseaseAiTextChatRoute>(
          path: Routes.profileChronicDiseaseAiTextChat,
        ),
        TypedGoRoute<ProfileCallReservationRoute>(
          path: Routes.profileCallReservation,
        ),
        TypedGoRoute<ProfileCallReservationDoctorTextChatRoute>(
          path: Routes.profileCallReservationDoctorTextChat,
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

@TypedGoRoute<EmergencyResultRoute>(
  path: Routes.emergencyResult,
)
class EmergencyResultRoute extends GoRouteData {
  const EmergencyResultRoute({
    required this.bodyTemperature,
    required this.bloodPressure,
  });

  final double bodyTemperature;
  final String bloodPressure;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EmergencyResultView(
        bodyTemperature: bodyTemperature,
        bloodPressure: bloodPressure,
      );
}

@TypedGoRoute<ProgressRoute>(
  path: Routes.emergencyProgress,
)
class ProgressRoute extends GoRouteData {
  const ProgressRoute({
    required this.from,
    this.diseaseType = HealthCheckupDiseaseEnum.badFeel,
    this.healthPoint = 0,
  });

  final String from;
  final int healthPoint;
  final HealthCheckupDiseaseEnum diseaseType;

  @override
  Widget build(BuildContext context, GoRouterState state) => ProgressView(
        from: from,
        healthPoint: healthPoint,
        diseaseType: diseaseType,
      );
}

@TypedGoRoute<RegisterPhysicalInfoRoute>(
  path: Routes.registerPhysicalInfo,
)
class RegisterPhysicalInfoRoute extends GoRouteData {
  const RegisterPhysicalInfoRoute({
    required this.from,
    required this.$extra,
  });
  final String from;
  final UserRequest $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      // todo: View側でfromを受け取れるように変更
      RegisterPhysicalInfoView(
        from: from,
        userRequest: $extra,
      );
}

@TypedGoRoute<RegisterAddressInfoRoute>(
  path: Routes.registerAddressInfo,
)
class RegisterAddressInfoRoute extends GoRouteData {
  const RegisterAddressInfoRoute({
    this.$extra,
  });

  final UserRequest? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RegisterAddressInfoView(
        userRequest: $extra,
        from: Routes.registerPhysicalInfo,
      );
}

@TypedGoRoute<RegisterUserInfoRoute>(
  path: Routes.registerUserInfo,
)
class RegisterUserInfoRoute extends GoRouteData {
  RegisterUserInfoRoute({
    this.$extra,
  });

  final UserRequest? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RegisterUserInfoView(
        userRequest: $extra,
        from: Routes.registerAddressInfo,
      );
}

@TypedGoRoute<RegisterLocalAuthRoute>(
  path: Routes.registerLocalAuth,
)
class RegisterLocalAuthRoute extends GoRouteData {
  const RegisterLocalAuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LocalAuthView(
        from: Routes.registerUserInfo,
      );
}

@TypedGoRoute<VideoCallRoute>(
  path: Routes.videoCall,
)
class VideoCallRoute extends GoRouteData {
  VideoCallRoute({
    required this.$extra,
  });
  final CallStandby $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) => VoiceCallView(
        callStandby: $extra,
      );
}

@TypedGoRoute<SignOutRoute>(
  path: Routes.signOut,
)
class SignOutRoute extends GoRouteData {
  const SignOutRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SignOutView();
}

/////////////////////////////////  Root  //////////////////////////////

//////////////////////////////  Home  //////////////////////////////
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeView();
}

class HomeMedicineSettingRoute extends GoRouteData {
  const HomeMedicineSettingRoute({
    this.$extra,
  });
  final Medicine? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MedicineSettingView(
        medicine: $extra,
      );
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

class CheckupResultRoute extends GoRouteData {
  const CheckupResultRoute({
    required this.$extra,
    required this.healthPoint,
    required this.bodyTemperature,
    required this.bloodPressure,
  });

  final HealthCheckupDiseaseEnum $extra;
  final int healthPoint;
  final String bodyTemperature;
  final String bloodPressure;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      HealthCheckupResultsView(
        diseaseType: $extra,
        healthPoint: healthPoint,
        bodyTemperature: bodyTemperature,
        bloodPressure: bloodPressure,
      );
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
  ChatDoctorTextChatRoute({
    required this.$extra,
    this.reserveMessage,
  });
  Doctor $extra;
  String? reserveMessage;

  @override
  Widget build(BuildContext context, GoRouterState state) => DoctorTextChatView(
        doctor: $extra,
        reserveMessage: reserveMessage,
      );
}

class ChatDoctorVoiceCallReserveRoute extends GoRouteData {
  const ChatDoctorVoiceCallReserveRoute(
    this.$extra,
  );

  final Doctor $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      VoiceCallReserveView(
        doctor: $extra,
      );
}

class ChatDoctorSearchRoute extends GoRouteData {
  ChatDoctorSearchRoute({this.departmentId});

  String? departmentId;

  @override
  Widget build(BuildContext context, GoRouterState state) => DoctorSearchView(
        departmentId: departmentId,
      );
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
  ProfileRegisterPhysicalInfoRoute({required this.$extra});
  UserRequest $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RegisterPhysicalInfoView(
        from: Routes.profile,
        userRequest: $extra,
      );
}

class ProfileRegisterAddressInfoRoute extends GoRouteData {
  ProfileRegisterAddressInfoRoute({this.$extra});
  UserRequest? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RegisterAddressInfoView(
        userRequest: $extra,
        from: Routes.profile,
      );
}

class ProfileRegisterUserInfoRoute extends GoRouteData {
  ProfileRegisterUserInfoRoute({this.$extra});
  UserRequest? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      RegisterUserInfoView(
        userRequest: $extra,
        from: Routes.profile,
      );
}

class ProfileLocalAuthRoute extends GoRouteData {
  const ProfileLocalAuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LocalAuthView(
        from: Routes.profile,
      );
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
  const ProfileNotificationSettingRoute({
    required this.$extra,
  });
  final UserNotification $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      NotificationSettingView(
        userNotification: $extra,
      );
}

class ProfileFamilyEmailRoute extends GoRouteData {
  const ProfileFamilyEmailRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FamilyEmailView();
}

class ProfileFamilyEmailRegisterRoute extends GoRouteData {
  const ProfileFamilyEmailRegisterRoute({
    this.$extra,
  });
  final FamilyEmail? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      FamilyEmailRegisterView(
        familyEmail: $extra,
      );
}

class ProfileFamilyEmailSyncContactRoute extends GoRouteData {
  const ProfileFamilyEmailSyncContactRoute({
    this.$extra,
  });
  final List<FamilyEmail>? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      FamilyEmailSyncContactView(
        familyEmailList: $extra,
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

class ProfileChronicDiseaseAiTextChatRoute extends GoRouteData {
  const ProfileChronicDiseaseAiTextChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const AiTextChatView();
}

class ProfileCallReservationRoute extends GoRouteData {
  const ProfileCallReservationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CallReservationView();
}

class ProfileCallReservationDoctorTextChatRoute extends GoRouteData {
  const ProfileCallReservationDoctorTextChatRoute(this.$extra);
  final Doctor $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) => DoctorTextChatView(
        doctor: $extra,
      );
}
//////////////////////////////  profile  //////////////////////////////