mixin Routes {
  static const String root = '/';
  static const String emergency = '/emergency';
  static const String emergencyProgress = '/emergency/progress';
  static const String home = '/home';
  static const String healthCheckup = '/health_checkup';
  static const String healthCheckupNormal = '/health_checkup/normal';
  static const String healthCheckupProgress = '/health_checkup/progress';
  static const String healthCheckupResults = '/health_checkup/results';
  static const String chat = '/chat';
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
  static const String healthCheckupAi = '/health_checkup/ai';
  static const String profileLocalAuth = '/profile/local_auth';
  static const String profileAppInformation = '/profile/app_information';
  static const String profileNotificationSetting =
      '/profile/notification_setting';
  static const String profileChronicDisease = '/profile/chronic_disease';
  static const String profileChronicDiseaseSearch =
      '/profile/chronic_disease/search';
  static const String chatDoctorPage = '/chat/doctor_page';
  static const String chatDoctorPageChat = '/chat/doctor_page/chat';

  static const String chatDoctorPageReserve = '/chat/doctor_page/reserve';
  static const String chatDoctorSearch = '/chat/doctor_search';
  static const String chatAi = '/chat/ai';
}
