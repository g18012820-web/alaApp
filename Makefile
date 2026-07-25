create_splash:
	flutter pub run flutter_native_splash:create

remove_splash:
	flutter pub run flutter_native_splash:remove

splash: remove_splash create_splash

run_lang:
	dart run intl_utils:generate

open:
	open ios/Runner.xcworkspace

build_android_prod:
	flutter build apk --flavor prod --release --target=lib/main_prod.dart

build_android_aab_prod:
	flutter build appbundle --flavor prod --release --target=lib/main_prod.dart