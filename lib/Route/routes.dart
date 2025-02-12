mixin Routes {
  // root
  static const String root = '/';
  static const String emergency = '/emergency';
  static const String emergencyProgress = '/emergency/progress';
  static const String emergencyResult = '/emergency/result';
  static const String registerAddressInfo = '/register/address_info';
  static const String registerPhysicalInfo = '/register/physical_info';
  static const String registerUserInfo = '/register/user_info';
  static const String registerLocalAuth = '/register/local_auth';
  static const String videoCall = '/video_call';
  static const String signOut = '/sign_out';

  // home
  static const String home = '/home';
  static const String homeMedicineSetting = '/home/medicine/setting';

  // health_checkup
  static const String healthCheckup = '/health_checkup';
  static const String healthCheckupNormal = '/health_checkup/normal';
  static const String healthCheckupResults = '/health_checkup/results';
  static const String healthCheckupAi = '/health_checkup/ai';

  // chat
  static const String chat = '/chat';
  static const String chatDoctorInformation = '/chat/doctor/information';
  static const String chatDoctorTextChat = '/chat/doctor/text_chat';
  static const String chatDoctorSearch = '/chat/doctor/search';
  static const String chatAiTextChat = '/chat/ai/text_chat';
  static const String chatVoiceCallReserve = '/chat/voice_call/reserve';

  // profile
  static const String profile = '/profile';
  static const String profileRegisterAddressInfo =
      '/profile/register/address_info';
  static const String profileRegisterPhysicalInfo =
      '/profile/register/physical_info';
  static const String profileRegisterUserInfo = '/profile/register/user_info';
  static const String profileFamilyEmail = '/profile/family_email';
  static const String profileFamilyEmailRegister =
      '/profile/family_email/register';
  static const String profileFamilyEmailSyncContact =
      '/profile/family_email/sync_contact';
  static const String profileMedicine = '/profile/medicine';
  static const String profileMedicineSetting = '/profile/medicine/setting';
  static const String profileLocalAuth = '/profile/local_auth';
  static const String profileAppInformation = '/profile/app_information';
  static const String profileAppInformationLicense =
      '/profile/app_information/license';
  static const String profileNotificationSetting =
      '/profile/notification_setting';
  static const String profileChronicDisease = '/profile/chronic_disease';
  static const String profileChronicDiseaseSearch =
      '/profile/chronic_disease/search';
  static const String profileChronicDiseaseAiTextChat =
      '/profile/chronic_disease/ai/text_chat';
  static const String profileCallReservation = '/profile/call_reservation';
  static const String profileCallReservationDoctorTextChat =
      '/profile/call_reservation/doctor/text_chat';
}
