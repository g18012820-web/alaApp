class LoadAppConfigEntity {
  final bool isFirstLaunchApp;
  final bool isDarkMode;
  final bool isLoggedIn;

  LoadAppConfigEntity({
    required this.isFirstLaunchApp,
    required this.isDarkMode,
    required this.isLoggedIn,
  });

  @override
  String toString() {
    return 'LoadAppConfigEntity(isFirstLaunchApp: $isFirstLaunchApp, isDarkMode: $isDarkMode, isLoggedIn: $isLoggedIn)';
  }
}
