class Profile {
  int? profileId;
  String? profileName;
  String? profileMobile;
  String? profileEmail;
  String? password;

  Profile(
      {this.profileId,
      required this.profileName,
      required this.profileMobile,
      required this.profileEmail,
      required this.password});
}
