mixin Routes {
  // root
  static const String root = '/';
  static const String emergency = '/emergency';
  static const String emergencyProgress = '/emergency/progress';
  static const String addressInformation = '/address_information';
  static const String physicalInformation = '/physical_information';
  static const String userInformation = '/user_information';

  // home
  static const String home = '/home';

  // health_checkup
  static const String healthCheckup = '/health_checkup';
  static const String healthCheckupNormal = '/health_checkup/normal';
  static const String healthCheckupProgress = '/health_checkup/progress';
  static const String healthCheckupResults = '/health_checkup/results';
  static const String healthCheckupAi = '/health_checkup/ai';

  // chat
  static const String chat = '/chat';
  static const String chatDoctorInformation = '/chat/doctor/information';
  static const String chatDoctorTextChat = '/chat/doctor/text_chat';
  static const String chatDoctorSearch = '/chat/doctor/search';
  static const String chatAiTextChat = '/chat/ai/text_chat';
  static const String chatVoiceCall = '/chat/voice_call';
  static const String chatVoiceCallReserve = '/chat/voice_call/reserve';

  // profile
  static const String profile = '/profile';
  static const String profileAddressInformation =
      '/profile/address_information';
  static const String profilePhysicalInformation =
      '/profile/physical_information';
  static const String profileUserInformation = '/profile/user_information';
  static const String profileFamilyEmail = '/profile/family_email';
  static const String profileFamilyEmailRegister =
      '/profile/family_email/register';
  static const String profileFamilyEmailSyncContact =
      '/profile/family_email/sync_contact';
  static const String profileMedicine = '/profile/medicine';
  static const String profileMedicineSetting = '/profile/medicine/setting';
  static const String profileLocalAuth = '/profile/local_auth';
  static const String profileAppInformation = '/profile/app_information';
  static const String profileNotificationSetting =
      '/profile/notification_setting';
  static const String profileChronicDisease = '/profile/chronic_disease';
  static const String profileChronicDiseaseSearch =
      '/profile/chronic_disease/search';
}
