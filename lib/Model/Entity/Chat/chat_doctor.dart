class ChatDoctor {
  final String doctorId;
  final String? doctorIconUrl;
  final String firstName;
  final String lastName;

  ChatDoctor({
    required this.doctorId,
    required this.doctorIconUrl,
    required this.firstName,
    required this.lastName,
  });

  factory ChatDoctor.fromJson(Map<String, dynamic> json) {
    return ChatDoctor(
      doctorId: json['doctorID'],
      doctorIconUrl: json['doctorIconUrl'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorID': doctorId,
      'doctorIconUrl': doctorIconUrl,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
