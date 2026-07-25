abstract class EnvironmentConfigurable {
  String getBaseUrl();
  String getBrandName();
}

class AppEnvironment extends EnvironmentConfigurable {
  final String apiBaseUrl;
  final String brandName;

  AppEnvironment({
    required this.apiBaseUrl,
    required this.brandName,
  });

  static AppEnvironment dev = AppEnvironment(
    apiBaseUrl: 'https://d5dd9cdf-7b43-476a-96fc-c95e405bc449.mock.pstmn.io/api',
    brandName: 'E-Learning',
  );

  static AppEnvironment prod = AppEnvironment(
    apiBaseUrl: 'https://d5dd9cdf-7b43-476a-96fc-c95e405bc449.mock.pstmn.io/api',
    brandName: 'E-Learning',
  );

  @override
  String getBaseUrl() {
    return apiBaseUrl;
  }

  @override
  String getBrandName() {
    return brandName;
  }
}
