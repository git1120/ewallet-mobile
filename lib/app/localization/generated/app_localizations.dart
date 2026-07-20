import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_ps.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
    Locale('ps'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'IBA E-Wallet'**
  String get appName;

  /// No description provided for @foundationReady.
  ///
  /// In en, this message translates to:
  /// **'Your secure wallet foundation is ready.'**
  String get foundationReady;

  /// No description provided for @galleryTitle.
  ///
  /// In en, this message translates to:
  /// **'Component gallery'**
  String get galleryTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageDari.
  ///
  /// In en, this message translates to:
  /// **'Dari'**
  String get languageDari;

  /// No description provided for @languagePashto.
  ///
  /// In en, this message translates to:
  /// **'Pashto'**
  String get languagePashto;

  /// No description provided for @textSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get textSize;

  /// No description provided for @branding.
  ///
  /// In en, this message translates to:
  /// **'Branding'**
  String get branding;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// No description provided for @buttons.
  ///
  /// In en, this message translates to:
  /// **'Buttons'**
  String get buttons;

  /// No description provided for @inputs.
  ///
  /// In en, this message translates to:
  /// **'Inputs'**
  String get inputs;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback and states'**
  String get feedback;

  /// No description provided for @financial.
  ///
  /// In en, this message translates to:
  /// **'Financial components'**
  String get financial;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @secondaryAction.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get secondaryAction;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pin;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'One-time password'**
  String get otp;

  /// No description provided for @optionalNote.
  ///
  /// In en, this message translates to:
  /// **'Optional note'**
  String get optionalNote;

  /// No description provided for @informationMessage.
  ///
  /// In en, this message translates to:
  /// **'Review the details before continuing.'**
  String get informationMessage;

  /// No description provided for @successMessage.
  ///
  /// In en, this message translates to:
  /// **'Your request was completed.'**
  String get successMessage;

  /// No description provided for @warningMessage.
  ///
  /// In en, this message translates to:
  /// **'Some details need your attention.'**
  String get warningMessage;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'We could not complete your request.'**
  String get errorMessage;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyTitle;

  /// No description provided for @emptyMessage.
  ///
  /// In en, this message translates to:
  /// **'New items will appear here.'**
  String get emptyMessage;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Everyday account'**
  String get account;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available balance'**
  String get availableBalance;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transaction;

  /// No description provided for @fee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get fee;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm action'**
  String get confirmationTitle;

  /// No description provided for @confirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Please confirm that you want to continue.'**
  String get confirmationMessage;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @readOnly.
  ///
  /// In en, this message translates to:
  /// **'Read only'**
  String get readOnly;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @showSheet.
  ///
  /// In en, this message translates to:
  /// **'Show bottom sheet'**
  String get showSheet;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'The component gallery is not available in production.'**
  String get notAvailable;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'The credentials are incorrect.'**
  String get invalidCredentials;

  /// No description provided for @accountLocked.
  ///
  /// In en, this message translates to:
  /// **'This account is locked. Contact support.'**
  String get accountLocked;

  /// No description provided for @sessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Your session ended. Sign in again.'**
  String get sessionEnded;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Sign in again.'**
  String get sessionExpired;

  /// No description provided for @accountRestricted.
  ///
  /// In en, this message translates to:
  /// **'This account is restricted. Contact support.'**
  String get accountRestricted;

  /// No description provided for @accountClosed.
  ///
  /// In en, this message translates to:
  /// **'This account is closed. Contact support.'**
  String get accountClosed;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get genericError;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get networkError;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Check the information and try again.'**
  String get validationError;

  /// No description provided for @serverUnavailable.
  ///
  /// In en, this message translates to:
  /// **'We cannot sign you in right now. Try again later.'**
  String get serverUnavailable;

  /// No description provided for @authLoginScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authLoginScreenTitle;

  /// No description provided for @authLoginScreenSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Sign in to IBA E-Wallet'**
  String get authLoginScreenSemanticLabel;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login with your mobile number'**
  String get authLoginSubtitle;

  /// No description provided for @authMobileLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get authMobileLabel;

  /// No description provided for @authMobileHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered mobile number'**
  String get authMobileHint;

  /// No description provided for @authMobileRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number.'**
  String get authMobileRequired;

  /// No description provided for @authMobileInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit mobile number.'**
  String get authMobileInvalid;

  /// No description provided for @authContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get authContinue;

  /// No description provided for @authPinScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get authPinScreenTitle;

  /// No description provided for @authPinInstruction.
  ///
  /// In en, this message translates to:
  /// **'Enter your 6-digit PIN to continue'**
  String get authPinInstruction;

  /// No description provided for @authPinFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Secure 6-digit PIN keypad'**
  String get authPinFieldLabel;

  /// No description provided for @authDeletePinDigit.
  ///
  /// In en, this message translates to:
  /// **'Delete PIN digit'**
  String get authDeletePinDigit;

  /// No description provided for @authChangeMobile.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get authChangeMobile;

  /// No description provided for @authSigningIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get authSigningIn;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'The mobile number or PIN is incorrect. Try again.'**
  String get authInvalidCredentials;

  /// No description provided for @authAccountTemporarilyLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'PIN temporarily locked'**
  String get authAccountTemporarilyLockedTitle;

  /// No description provided for @authAccountTemporarilyLockedMessage.
  ///
  /// In en, this message translates to:
  /// **'For your security, PIN login is temporarily unavailable. Try again later.'**
  String get authAccountTemporarilyLockedMessage;

  /// No description provided for @authAccountSuspendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account suspended'**
  String get authAccountSuspendedTitle;

  /// No description provided for @authAccountSuspendedMessage.
  ///
  /// In en, this message translates to:
  /// **'You cannot sign in to this account right now.'**
  String get authAccountSuspendedMessage;

  /// No description provided for @authAccountLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account restricted'**
  String get authAccountLockedTitle;

  /// No description provided for @authAccountLockedMessage.
  ///
  /// In en, this message translates to:
  /// **'You cannot sign in to this account right now.'**
  String get authAccountLockedMessage;

  /// No description provided for @authAccountClosedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account closed'**
  String get authAccountClosedTitle;

  /// No description provided for @authAccountClosedMessage.
  ///
  /// In en, this message translates to:
  /// **'This account is closed and cannot be used to sign in.'**
  String get authAccountClosedMessage;

  /// No description provided for @authSessionExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get authSessionExpiredTitle;

  /// No description provided for @authSessionExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'For your security, sign in again to continue.'**
  String get authSessionExpiredMessage;

  /// No description provided for @authSessionEndedTitle.
  ///
  /// In en, this message translates to:
  /// **'Session ended'**
  String get authSessionEndedTitle;

  /// No description provided for @authSessionEndedMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in again to continue.'**
  String get authSessionEndedMessage;

  /// No description provided for @authLoginAgain.
  ///
  /// In en, this message translates to:
  /// **'Sign in again'**
  String get authLoginAgain;

  /// No description provided for @authCheckingSession.
  ///
  /// In en, this message translates to:
  /// **'Checking your secure session…'**
  String get authCheckingSession;

  /// No description provided for @authOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get authOfflineTitle;

  /// No description provided for @authOfflineMessage.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get authOfflineMessage;

  /// No description provided for @authServerUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Service unavailable'**
  String get authServerUnavailableTitle;

  /// No description provided for @authServerUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'We cannot sign you in right now. Try again later.'**
  String get authServerUnavailableMessage;

  /// No description provided for @authRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get authRetry;

  /// No description provided for @authLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get authLogout;

  /// No description provided for @authLoggingOut.
  ///
  /// In en, this message translates to:
  /// **'Logging out…'**
  String get authLoggingOut;

  /// No description provided for @authPrivacyPinMessage.
  ///
  /// In en, this message translates to:
  /// **'Never share your PIN. IBA staff will never ask for it.'**
  String get authPrivacyPinMessage;

  /// No description provided for @authGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get authGenericError;

  /// No description provided for @authSessionActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Your secure session is active'**
  String get authSessionActiveTitle;

  /// No description provided for @authSessionActiveMessage.
  ///
  /// In en, this message translates to:
  /// **'This temporary destination confirms that protected access is working.'**
  String get authSessionActiveMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa', 'ps'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'ps':
      return AppLocalizationsPs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
