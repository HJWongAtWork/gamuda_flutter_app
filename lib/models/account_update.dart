class AccountUpdate {
  final String currentPassword;
  final String? newUsername;
  final String? newEmail;
  final String? newPassword;

  AccountUpdate({
    required this.currentPassword,
    this.newUsername,
    this.newEmail,
    this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_password': currentPassword,
      if (newUsername != null) 'new_username': newUsername,
      if (newEmail != null) 'new_email': newEmail,
      if (newPassword != null) 'new_password': newPassword,
    };
  }
}
