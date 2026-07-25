extension StringExtensions on String {
  String getFirstCharacterForAvatar() {
    return isEmpty ? '' : substring(0, 1).toUpperCase();
  }
}
