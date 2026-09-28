import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @aMessageForYourFutureSelf.
  ///
  /// In en, this message translates to:
  /// **'A message for your future self'**
  String get aMessageForYourFutureSelf;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @arrivesIn.
  ///
  /// In en, this message translates to:
  /// **'Arrives in'**
  String get arrivesIn;

  /// No description provided for @ayat.
  ///
  /// In en, this message translates to:
  /// **'Ayat'**
  String get ayat;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @chooseSomeoneToReceiveYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose someone to receive your message.'**
  String get chooseSomeoneToReceiveYourMessage;

  /// No description provided for @chooseTheDateItShouldArrive.
  ///
  /// In en, this message translates to:
  /// **'Choose the date it should arrive.'**
  String get chooseTheDateItShouldArrive;

  /// No description provided for @chooseTheTimeItShouldArrive.
  ///
  /// In en, this message translates to:
  /// **'Choose the time it should arrive.'**
  String get chooseTheTimeItShouldArrive;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @couldNotFindRandomUser.
  ///
  /// In en, this message translates to:
  /// **'Could not find a random user. Try again.'**
  String get couldNotFindRandomUser;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @datesjoin.
  ///
  /// In en, this message translates to:
  /// **'Date\'s Joined'**
  String get datesjoin;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @deliveryTime.
  ///
  /// In en, this message translates to:
  /// **'Delivery time'**
  String get deliveryTime;

  /// No description provided for @deliveryTimeDescription.
  ///
  /// In en, this message translates to:
  /// **'The delivery time is chosen randomly by the system. You will not know when your message will arrive.'**
  String get deliveryTimeDescription;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailCannotBeChanged.
  ///
  /// In en, this message translates to:
  /// **'Your email cannot be changed from here'**
  String get emailCannotBeChanged;

  /// No description provided for @emailPasswordNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'Email and password authentication is not enabled.'**
  String get emailPasswordNotEnabled;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emptyFavorites.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any favorite messages yet.'**
  String get emptyFavorites;

  /// No description provided for @emptyHistory.
  ///
  /// In en, this message translates to:
  /// **'Messages, quotes and ayat you view will appear here.'**
  String get emptyHistory;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address.'**
  String get enterEmail;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get enterUsername;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @faildlogin.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get faildlogin;

  /// No description provided for @failedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data.'**
  String get failedToLoad;

  /// No description provided for @failedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save changes.'**
  String get failedToSave;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get favorite;

  /// No description provided for @favoriteMessages.
  ///
  /// In en, this message translates to:
  /// **'Favorite Messages'**
  String get favoriteMessages;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @findingSomeone.
  ///
  /// In en, this message translates to:
  /// **'Finding someone...'**
  String get findingSomeone;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we will send you a link to reset your password.'**
  String get forgotPasswordMessage;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon, '**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening, '**
  String get goodEvening;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning, '**
  String get goodMorning;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @inAMonth.
  ///
  /// In en, this message translates to:
  /// **'In a month'**
  String get inAMonth;

  /// No description provided for @inAWeek.
  ///
  /// In en, this message translates to:
  /// **'In a week'**
  String get inAWeek;

  /// No description provided for @inAYear.
  ///
  /// In en, this message translates to:
  /// **'In a year'**
  String get inAYear;

  /// No description provided for @inbox.
  ///
  /// In en, this message translates to:
  /// **'Message box'**
  String get inbox;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get invalidCredentials;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get invalidEmail;

  /// No description provided for @invalidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid name'**
  String get invalidName;

  /// No description provided for @invalidUsername.
  ///
  /// In en, this message translates to:
  /// **'Username must be 3–20 characters and can only contain letters, numbers, and underscores.'**
  String get invalidUsername;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get lightMode;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @loginpMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your journey and explore everything we have prepared for you'**
  String get loginpMessage;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutFaild.
  ///
  /// In en, this message translates to:
  /// **'Failed logout'**
  String get logoutFaild;

  /// No description provided for @messageAddedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites.'**
  String get messageAddedToFavorites;

  /// No description provided for @messageDetails.
  ///
  /// In en, this message translates to:
  /// **'Message details'**
  String get messageDetails;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'What do you want your future self to read?'**
  String get messageHint;

  /// No description provided for @messageNotSaved.
  ///
  /// In en, this message translates to:
  /// **'The message was not saved. Try again.'**
  String get messageNotSaved;

  /// No description provided for @messageRemovedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites.'**
  String get messageRemovedFromFavorites;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @messageSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sent to your future self ✨'**
  String get messageSentSuccess;

  /// No description provided for @messageSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your message was sent successfully.'**
  String get messageSentSuccessfully;

  /// No description provided for @messageWasNotSavedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'The message was not saved. Try again.'**
  String get messageWasNotSavedTryAgain;

  /// No description provided for @messageWasNotSent.
  ///
  /// In en, this message translates to:
  /// **'The message was not sent. Try again.'**
  String get messageWasNotSent;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name is too short'**
  String get nameTooShort;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get networkError;

  /// No description provided for @newMessage.
  ///
  /// In en, this message translates to:
  /// **'A message for you'**
  String get newMessage;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t received any messages yet.'**
  String get noHistory;

  /// No description provided for @noInboxMessages.
  ///
  /// In en, this message translates to:
  /// **'Your message box is empty.'**
  String get noInboxMessages;

  /// No description provided for @noOtherUsersAvailable.
  ///
  /// In en, this message translates to:
  /// **'There are no other users available.'**
  String get noOtherUsersAvailable;

  /// No description provided for @noRecipientSelected.
  ///
  /// In en, this message translates to:
  /// **'No recipient selected'**
  String get noRecipientSelected;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @onlyYouWillReadIt.
  ///
  /// In en, this message translates to:
  /// **'Only you will read it.'**
  String get onlyYouWillReadIt;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get or;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain a number'**
  String get passwordNumber;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'A password reset link has been sent to your email.'**
  String get passwordResetEmailSent;

  /// No description provided for @passwordResetError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get passwordResetError;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain an uppercase letter'**
  String get passwordUppercase;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @personalMessage.
  ///
  /// In en, this message translates to:
  /// **'Your scheduled message'**
  String get personalMessage;

  /// No description provided for @pickAMomentInTheFuture.
  ///
  /// In en, this message translates to:
  /// **'Pick a moment in the future.'**
  String get pickAMomentInTheFuture;

  /// No description provided for @pickAnotherUser.
  ///
  /// In en, this message translates to:
  /// **'Pick Another User'**
  String get pickAnotherUser;

  /// No description provided for @pickARandomUserFirst.
  ///
  /// In en, this message translates to:
  /// **'Pick a random user first.'**
  String get pickARandomUserFirst;

  /// No description provided for @pickDateAndTimeToSeeCountdown.
  ///
  /// In en, this message translates to:
  /// **'Pick a date and time to see the countdown'**
  String get pickDateAndTimeToSeeCountdown;

  /// No description provided for @pickRandomUser.
  ///
  /// In en, this message translates to:
  /// **'Pick Random User'**
  String get pickRandomUser;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @privateMessage.
  ///
  /// In en, this message translates to:
  /// **'Private message'**
  String get privateMessage;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profile;

  /// No description provided for @profileMessage.
  ///
  /// In en, this message translates to:
  /// **'Keep spreading positivity '**
  String get profileMessage;

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your words can make someone\'s day'**
  String get profileSubtitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Spread kindness'**
  String get profileTitle;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your changes have been saved successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @quotes.
  ///
  /// In en, this message translates to:
  /// **'Qoutes'**
  String get quotes;

  /// No description provided for @randomMessage.
  ///
  /// In en, this message translates to:
  /// **'Random Message'**
  String get randomMessage;

  /// No description provided for @randomMessageDescription.
  ///
  /// In en, this message translates to:
  /// **'Just write it. We will choose a random moment within the next five years and deliver it to you.'**
  String get randomMessageDescription;

  /// No description provided for @randomRecipient.
  ///
  /// In en, this message translates to:
  /// **'Random recipient'**
  String get randomRecipient;

  /// No description provided for @randomTime.
  ///
  /// In en, this message translates to:
  /// **'Random time'**
  String get randomTime;

  /// No description provided for @randomUser.
  ///
  /// In en, this message translates to:
  /// **'Random Person'**
  String get randomUser;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @receiverLabel.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get receiverLabel;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @reminderMessage.
  ///
  /// In en, this message translates to:
  /// **'Congrats on your failures, most people don\'t even try. Note: they are not failures if you learned something from them'**
  String get reminderMessage;

  /// No description provided for @remmberMe.
  ///
  /// In en, this message translates to:
  /// **'Remmber me'**
  String get remmberMe;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @scheduledItWillReachYouOnTime.
  ///
  /// In en, this message translates to:
  /// **'Scheduled. It will reach you on time.'**
  String get scheduledItWillReachYouOnTime;

  /// No description provided for @scheduleMessage.
  ///
  /// In en, this message translates to:
  /// **'Schedule Message'**
  String get scheduleMessage;

  /// No description provided for @scheduleMessageButton.
  ///
  /// In en, this message translates to:
  /// **'Schedule message'**
  String get scheduleMessageButton;

  /// No description provided for @scheduling.
  ///
  /// In en, this message translates to:
  /// **'Scheduling'**
  String get scheduling;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @senderLabel.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get senderLabel;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// No description provided for @sendKindnessToSomeone.
  ///
  /// In en, this message translates to:
  /// **'Send a little kindness to someone'**
  String get sendKindnessToSomeone;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @sendToTheFuture.
  ///
  /// In en, this message translates to:
  /// **'Send to the future'**
  String get sendToTheFuture;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on the server.'**
  String get serverError;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get signUp;

  /// No description provided for @signUpMessage.
  ///
  /// In en, this message translates to:
  /// **'Join us today and start your journey with a personalized experience made for you'**
  String get signUpMessage;

  /// No description provided for @signUpWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get signUpWithGoogle;

  /// No description provided for @surpriseForFutureSelf.
  ///
  /// In en, this message translates to:
  /// **'A surprise for your future self'**
  String get surpriseForFutureSelf;

  /// No description provided for @surpriseIsWaiting.
  ///
  /// In en, this message translates to:
  /// **'A surprise is waiting'**
  String get surpriseIsWaiting;

  /// No description provided for @tapBelowToFindSomeone.
  ///
  /// In en, this message translates to:
  /// **'Tap below to find someone at random.'**
  String get tapBelowToFindSomeone;

  /// No description provided for @thatMomentHasAlreadyPassed.
  ///
  /// In en, this message translates to:
  /// **'That moment has already passed'**
  String get thatMomentHasAlreadyPassed;

  /// No description provided for @thatTimeHasPassedPickALaterOne.
  ///
  /// In en, this message translates to:
  /// **'That time has passed. Pick a later one.'**
  String get thatTimeHasPassedPickALaterOne;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @todayMessage.
  ///
  /// In en, this message translates to:
  /// **'Today\'s message'**
  String get todayMessage;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again later.'**
  String get tooManyRequests;

  /// No description provided for @unfavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get unfavorite;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get usernameHint;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @usernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Username is too short'**
  String get usernameTooShort;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account was found with this email address.'**
  String get userNotFound;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'A little kindness at the right time can make a big difference.'**
  String get welcomeMessage;

  /// No description provided for @whatDoYouWantToRemember.
  ///
  /// In en, this message translates to:
  /// **'What do you want to remember, or be reminded of?'**
  String get whatDoYouWantToRemember;

  /// No description provided for @writeAMessageAndLetUsFindSomeone.
  ///
  /// In en, this message translates to:
  /// **'Write a message and let us find someone to receive it.'**
  String get writeAMessageAndLetUsFindSomeone;

  /// No description provided for @writeItNowReceiveItExactlyWhenYouChoose.
  ///
  /// In en, this message translates to:
  /// **'Write it now, receive it exactly when you choose.'**
  String get writeItNowReceiveItExactlyWhenYouChoose;

  /// No description provided for @writeMessageFirst.
  ///
  /// In en, this message translates to:
  /// **'Write your message first.'**
  String get writeMessageFirst;

  /// No description provided for @writeSomethingForFutureSelf.
  ///
  /// In en, this message translates to:
  /// **'Write something for your future self.'**
  String get writeSomethingForFutureSelf;

  /// No description provided for @writeSomethingKind.
  ///
  /// In en, this message translates to:
  /// **'Write something kind for someone.'**
  String get writeSomethingKind;

  /// No description provided for @writeYourMessageFirst.
  ///
  /// In en, this message translates to:
  /// **'Write your message first.'**
  String get writeYourMessageFirst;

  /// No description provided for @writeYourRandomMessage.
  ///
  /// In en, this message translates to:
  /// **'Write your message here...'**
  String get writeYourRandomMessage;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get year;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @yourMessage.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get yourMessage;

  /// No description provided for @yourMessageWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your message will appear here.'**
  String get yourMessageWillAppearHere;

  /// No description provided for @yourMessageWillBeSentTo.
  ///
  /// In en, this message translates to:
  /// **'Your message will be sent to'**
  String get yourMessageWillBeSentTo;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
