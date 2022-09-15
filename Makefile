.PHONY: set-assets-home
set-assets-home:
	@rm -f ./assets/images/default
	@ln -s default-home ./assets/images/default

.PHONY: set-assets-appstore
set-assets-appstore:
	@rm -f ./assets/images/default
	@ln -s default-appstore ./assets/images/default

.PHONY: test
test: set-assets-home
	@flutter test lib

.PHONY: run-home
run-home: set-assets-home
	@flutter run

.PHONY: run-appstore
run-appstore: set-assets-appstore
	@flutter run

.PHONY: build-home
build-home: set-assets-home
	@flutter build apk --split-per-abi
	@flutter build appbundle

.PHONY: build-appstore
build-appstore: set-assets-appstore
	@flutter build apk --split-per-abi
	@flutter build appbundle

.PHONY: profile
profile:
# then run DevTools
	@flutter run --profile

.PHONY: install
install:
	@flutter install

.PHONY: uninstall
uninstall:
	@flutter install --uninstall-only

.PHONY: icons
icons:
# config in pubspec.yaml
	@flutter pub run flutter_launcher_icons:main 
