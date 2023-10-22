# kumuly_pocket

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Contributing

### Code generation

This project uses riverpod with code generation. To generate the code and keep watching for changes, run `dart run build_runner watch`.

### Internationalization

This project uses the [flutter_localizations](https://pub.dev/packages/flutter_localizations) package for internationalization. The internationalization files are located in `lib/l10n/`. This package also generates the `lib/l10n/l10n.dart` file which contains the `AppLocalizations` class. This class contains all the keys for the internationalization files. To generate the `l10n.dart` file, run `flutter pub run` from the project root directory.

### Workflow

#### Add new copy to the internationalization files

When implementing a new feature which involves new views with new copy, first add all the copy you see in the views to the internationalization files in `lib/l10n/`.

!Do not hardcode copy in the views!

In the end it is less work to directly add the copy to the internationalization files than to add it hardcoded to the views first and then later having to search for it again and replace it with the internationalization key.

Before adding a new label, check if it already exists in the internationalization files. If it does, use the existing key instead of creating a new one.

# Problems and solutions encountered during development

## (Xcode): Target release_ios_bundle_flutter_assets failed: Exception: Failed to codesign

### Solution

Run `xattr -cr assets` or `find assets -type f -exec xattr -c {} \;` from the project root directory.
