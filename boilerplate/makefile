FIREBASE_PROJECT=csm-logistics-vn
DEV_BUNDLE_ID=com.aarontech.boilerplate.dev
PRO_BUNDLE_ID=com.aarontech.boilerplate

DEV_SUFFIX=dev
PRO_SUFFIX=pro

SUBMIT_ACCOUNT=aaron.vu.tech@gmail.com
PASSWORD_ACCOUNT=<APPLE_PASSWORD>

FIREBASE_APP_ID=1:450787992763:android:4a351f3530459cfa9f759e

create_idea_configs:
	dart run idea_tools/android_studio_generate_tool.dart

gen_locale:
	fvm flutter pub get
	fvm flutter pub run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart
	fvm flutter pub run easy_localization:generate -S assets/translations

create_splash:
	fvm flutter pub run flutter_native_splash:create

create_icon:
	fvm flutter pub run flutter_launcher_icons
watch:
	cd watcher && fvm dart locale_watcher.dart

firebase_config:
	make firebase_beta_config
	make firebase_pro_config

run_dev:
	fvm flutter run -t lib/main.dart --dart-define-from-file=.env/dev.json

run_pro:
	fvm flutter run -t lib/main.dart --dart-define-from-file=.env/prodd.json

dev_ipa:
	fvm flutter build ipa -t lib/main.dart --dart-define-from-file=.env/dev.json

pro_ipa:
	fvm flutter build ipa -t lib/main.dart --dart-define-from-file=.env/pro.json

dev_apk:
	fvm flutter build apk -t lib/main.dart --dart-define-from-file=.env/dev.json

prod_apk:
	fvm flutter build apk -t lib/main.dart --dart-define-from-file=.env/pro.json

dev_aab:
	fvm flutter build appbundle -t lib/main.dart --dart-define-from-file=.env/dev.json

pro_aab:
	fvm flutter build appbundle -t lib/main.dart --dart-define-from-file=.env/pro.json

firebase_dev_config:
	flutterfire config \
      --project=$(FIREBASE_PROJECT) \
      --out=lib/flavor/flutterfire_options/firebase_options_$(DEV_SUFFIX).dart \
      --ios-bundle-id=$(DEV_BUNDLE_ID)\
      --android-app-id=$(DEV_BUNDLE_ID)

firebase_pro_config:
	flutterfire config \
      --project=$(FIREBASE_PROJECT) \
      --out=lib/flavor/flutterfire_options/firebase_options_$(PRO_SUFFIX).dart \
      --ios-bundle-id=$(PRO_BUNDLE_ID) \
      --android-app-id=$(PRO_BUNDLE_ID)

firebase_distribute_dev:
	firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk  \
		--app 1:450787992763:android:4a351f3530459cfa9f759e  \
		--release-notes ""

submit_ipa:
	xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --username $(SUBMIT_ACCOUNT) --password $(PASSWORD_ACCOUNT)


submit_dev:
	make dev_ipa && make submit_ipa
	make dev_apk && make firebase_distribute_dev

submit_pro:
	make pro_ipa && make submit_ipa
	make prod_apk && make pro_aab

clean:
	cd ios && pod deintegrate && fvm flutter clean && rm -rf ~/Library/betaeloper/Xcode/DerivedData && rm -rf Podfile.lock && rm -rf .symlinks && fvm flutter pub get

l:
	cd watcher && fvm dart locale_script.dart -S assets/translations -f keys -o locale_keys.g.dart
