import 'package:greenbook/models/profile.dart'; // Replace with your actual import path for Profile class

class TempDBProfile {
  // Sample data for profiles
  static List<Profile> profiles = [
    Profile(
        profileId: 1,
        profileName: 'john.doe@example.com',
        profileMobile: '123-456-7890',
        profileEmail: 'john.doe@example.com',
        password: '123456'),
    Profile(
        profileId: 2,
        profileName: 'jane.smith@example.com',
        profileMobile: '987-654-3210',
        profileEmail: 'jane.smith@example.com',
        password: '123456'),
    // Add more profiles as needed
  ];
}
