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

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'MindMessage'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'A little message at the right time.'**
  String get appTagline;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

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

  /// No description provided for @signUpMessage.
  ///
  /// In en, this message translates to:
  /// **'Join us today and start your journey with a personalized experience made for you'**
  String get signUpMessage;

  /// No description provided for @loginpMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your journey and explore everything we have prepared for you'**
  String get loginpMessage;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get signUp;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get or;

  /// No description provided for @signUpWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get signUpWithGoogle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createAccount;

  /// No description provided for @logoutFaild.
  ///
  /// In en, this message translates to:
  /// **'Failed logout'**
  String get logoutFaild;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @invalidUsername.
  ///
  /// In en, this message translates to:
  /// **'Username must be 3–20 characters and can only contain letters, numbers, and underscores.'**
  String get invalidUsername;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address.'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get enterUsername;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get invalidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain an uppercase letter'**
  String get passwordUppercase;

  /// No description provided for @passwordNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain a number'**
  String get passwordNumber;

  /// No description provided for @weakpassword.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak'**
  String get weakpassword;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @invalidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid name'**
  String get invalidName;

  /// No description provided for @remmberMe.
  ///
  /// In en, this message translates to:
  /// **'Remmber me'**
  String get remmberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otp;

  /// No description provided for @resetPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit verification code that was sent to your email address.'**
  String get resetPasswordMessage;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resendMessage.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code?'**
  String get resendMessage;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account was found with this email address.'**
  String get userNotFound;

  /// No description provided for @faildlogin.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get faildlogin;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get requiredField;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get invalidCredentials;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use.'**
  String get emailAlreadyInUse;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Your account has been created.'**
  String get accountCreated;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent.'**
  String get passwordResetSent;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning, '**
  String get goodMorning;

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

  /// No description provided for @todayMessage.
  ///
  /// In en, this message translates to:
  /// **'Today\'s message'**
  String get todayMessage;

  /// No description provided for @yourMessage.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get yourMessage;

  /// No description provided for @messageForYou.
  ///
  /// In en, this message translates to:
  /// **'A message for you'**
  String get messageForYou;

  /// No description provided for @messageFromYourself.
  ///
  /// In en, this message translates to:
  /// **'A message from yourself'**
  String get messageFromYourself;

  /// No description provided for @nextMessage.
  ///
  /// In en, this message translates to:
  /// **'Next message'**
  String get nextMessage;

  /// No description provided for @noUpcomingMessage.
  ///
  /// In en, this message translates to:
  /// **'No upcoming messages.'**
  String get noUpcomingMessage;

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any messages yet.'**
  String get noMessagesYet;

  /// No description provided for @createMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a message'**
  String get createMessage;

  /// No description provided for @writeToYourself.
  ///
  /// In en, this message translates to:
  /// **'Write a message to yourself'**
  String get writeToYourself;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get viewHistory;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @appMessages.
  ///
  /// In en, this message translates to:
  /// **'App messages'**
  String get appMessages;

  /// No description provided for @myMessages.
  ///
  /// In en, this message translates to:
  /// **'My messages'**
  String get myMessages;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @datesjoin.
  ///
  /// In en, this message translates to:
  /// **'Date\'s Joined'**
  String get datesjoin;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @motivation.
  ///
  /// In en, this message translates to:
  /// **'Motivation'**
  String get motivation;

  /// No description provided for @calm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get calm;

  /// No description provided for @selfLove.
  ///
  /// In en, this message translates to:
  /// **'Self-love'**
  String get selfLove;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @hope.
  ///
  /// In en, this message translates to:
  /// **'Hope'**
  String get hope;

  /// No description provided for @gratitude.
  ///
  /// In en, this message translates to:
  /// **'Gratitude'**
  String get gratitude;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @ayat.
  ///
  /// In en, this message translates to:
  /// **'Ayat'**
  String get ayat;

  /// No description provided for @quotes.
  ///
  /// In en, this message translates to:
  /// **'Qoutes'**
  String get quotes;

  /// No description provided for @addMessage.
  ///
  /// In en, this message translates to:
  /// **'Add message'**
  String get addMessage;

  /// No description provided for @editMessage.
  ///
  /// In en, this message translates to:
  /// **'Edit message'**
  String get editMessage;

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete message'**
  String get deleteMessage;

  /// No description provided for @messageText.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageText;

  /// No description provided for @writeMessage.
  ///
  /// In en, this message translates to:
  /// **'Write your message...'**
  String get writeMessage;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'What do you want your future self to read?'**
  String get messageHint;

  /// No description provided for @emptyMessages.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any personal messages yet.'**
  String get emptyMessages;

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

  /// No description provided for @favoriteMessages.
  ///
  /// In en, this message translates to:
  /// **'Favorite Messages'**
  String get favoriteMessages;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get favorite;

  /// No description provided for @unfavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get unfavorite;

  /// No description provided for @messageSaved.
  ///
  /// In en, this message translates to:
  /// **'Message saved.'**
  String get messageSaved;

  /// No description provided for @messageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Message updated.'**
  String get messageUpdated;

  /// No description provided for @messageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Message deleted.'**
  String get messageDeleted;

  /// No description provided for @messageAddedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Added to favorites.'**
  String get messageAddedToFavorites;

  /// No description provided for @messageRemovedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites.'**
  String get messageRemovedFromFavorites;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @scheduleMessage.
  ///
  /// In en, this message translates to:
  /// **'Schedule Message'**
  String get scheduleMessage;

  /// No description provided for @when.
  ///
  /// In en, this message translates to:
  /// **'When would you like to receive it?'**
  String get when;

  /// No description provided for @specificTime.
  ///
  /// In en, this message translates to:
  /// **'Specific date & time'**
  String get specificTime;

  /// No description provided for @randomTime.
  ///
  /// In en, this message translates to:
  /// **'Random time'**
  String get randomTime;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get endTime;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get chooseDate;

  /// No description provided for @chooseTime.
  ///
  /// In en, this message translates to:
  /// **'Choose a time'**
  String get chooseTime;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @doesNotRepeat.
  ///
  /// In en, this message translates to:
  /// **'Does not repeat'**
  String get doesNotRepeat;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @once.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get once;

  /// No description provided for @everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyDay;

  /// No description provided for @everyWeek.
  ///
  /// In en, this message translates to:
  /// **'Every week'**
  String get everyWeek;

  /// No description provided for @randomUser.
  ///
  /// In en, this message translates to:
  /// **'Random Person'**
  String get randomUser;

  /// No description provided for @randomUserTitle.
  ///
  /// In en, this message translates to:
  /// **'Send an Anonymous Message'**
  String get randomUserTitle;

  /// No description provided for @randomUserDescription.
  ///
  /// In en, this message translates to:
  /// **'Send a message to a random person without revealing your identity.'**
  String get randomUserDescription;

  /// No description provided for @findRandomPerson.
  ///
  /// In en, this message translates to:
  /// **'Find Someone'**
  String get findRandomPerson;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @randomPersonFound.
  ///
  /// In en, this message translates to:
  /// **'Someone was found!'**
  String get randomPersonFound;

  /// No description provided for @tryAnother.
  ///
  /// In en, this message translates to:
  /// **'Try Another'**
  String get tryAnother;

  /// No description provided for @randomPersonLoading.
  ///
  /// In en, this message translates to:
  /// **'Finding someone...'**
  String get randomPersonLoading;

  /// No description provided for @messageSent.
  ///
  /// In en, this message translates to:
  /// **'Your message was sent anonymously!'**
  String get messageSent;

  /// No description provided for @randomSchedule.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get randomSchedule;

  /// No description provided for @randomScheduleDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ll choose a random time within your selected time range.'**
  String get randomScheduleDescription;

  /// No description provided for @scheduleSaved.
  ///
  /// In en, this message translates to:
  /// **'Schedule saved.'**
  String get scheduleSaved;

  /// No description provided for @scheduleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Schedule updated.'**
  String get scheduleUpdated;

  /// No description provided for @scheduleDeleted.
  ///
  /// In en, this message translates to:
  /// **'Schedule deleted.'**
  String get scheduleDeleted;

  /// No description provided for @scheduledFor.
  ///
  /// In en, this message translates to:
  /// **'Scheduled for'**
  String get scheduledFor;

  /// No description provided for @scheduledAt.
  ///
  /// In en, this message translates to:
  /// **'Scheduled at'**
  String get scheduledAt;

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

  /// No description provided for @nextReminder.
  ///
  /// In en, this message translates to:
  /// **'Next reminder'**
  String get nextReminder;

  /// No description provided for @enableReminder.
  ///
  /// In en, this message translates to:
  /// **'Enable reminder'**
  String get enableReminder;

  /// No description provided for @disableReminder.
  ///
  /// In en, this message translates to:
  /// **'Disable reminder'**
  String get disableReminder;

  /// No description provided for @futureMe.
  ///
  /// In en, this message translates to:
  /// **'Future Me'**
  String get futureMe;

  /// No description provided for @futureMeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send a message to your future self.'**
  String get futureMeSubtitle;

  /// No description provided for @sendToFutureSelf.
  ///
  /// In en, this message translates to:
  /// **'Send to my future self'**
  String get sendToFutureSelf;

  /// No description provided for @afterOneWeek.
  ///
  /// In en, this message translates to:
  /// **'After one week'**
  String get afterOneWeek;

  /// No description provided for @afterOneMonth.
  ///
  /// In en, this message translates to:
  /// **'After one month'**
  String get afterOneMonth;

  /// No description provided for @afterThreeMonths.
  ///
  /// In en, this message translates to:
  /// **'After three months'**
  String get afterThreeMonths;

  /// No description provided for @afterOneYear.
  ///
  /// In en, this message translates to:
  /// **'After one year'**
  String get afterOneYear;

  /// No description provided for @customDate.
  ///
  /// In en, this message translates to:
  /// **'Custom date'**
  String get customDate;

  /// No description provided for @futureMessageCreated.
  ///
  /// In en, this message translates to:
  /// **'Your message to the future has been scheduled.'**
  String get futureMessageCreated;

  /// No description provided for @futureMessage.
  ///
  /// In en, this message translates to:
  /// **'A message from your past self'**
  String get futureMessage;

  /// No description provided for @mood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get mood;

  /// No description provided for @howAreYouFeeling.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get howAreYouFeeling;

  /// No description provided for @chooseYourMood.
  ///
  /// In en, this message translates to:
  /// **'Choose your mood'**
  String get chooseYourMood;

  /// No description provided for @happy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get happy;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @sad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get sad;

  /// No description provided for @anxious.
  ///
  /// In en, this message translates to:
  /// **'Anxious'**
  String get anxious;

  /// No description provided for @tired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get tired;

  /// No description provided for @angry.
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get angry;

  /// No description provided for @overwhelmed.
  ///
  /// In en, this message translates to:
  /// **'Overwhelmed'**
  String get overwhelmed;

  /// No description provided for @hopeful.
  ///
  /// In en, this message translates to:
  /// **'Hopeful'**
  String get hopeful;

  /// No description provided for @moodSaved.
  ///
  /// In en, this message translates to:
  /// **'Your mood has been saved.'**
  String get moodSaved;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @older.
  ///
  /// In en, this message translates to:
  /// **'Older'**
  String get older;

  /// No description provided for @receivedAt.
  ///
  /// In en, this message translates to:
  /// **'Received at'**
  String get receivedAt;

  /// No description provided for @opened.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get opened;

  /// No description provided for @notOpened.
  ///
  /// In en, this message translates to:
  /// **'Not opened yet'**
  String get notOpened;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t received any messages yet.'**
  String get noHistory;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications are enabled.'**
  String get notificationsEnabled;

  /// No description provided for @notificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications are disabled.'**
  String get notificationsDisabled;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get enableNotifications;

  /// No description provided for @notificationPermission.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications to receive your messages at the right time.'**
  String get notificationPermission;

  /// No description provided for @newMessage.
  ///
  /// In en, this message translates to:
  /// **'A message for you'**
  String get newMessage;

  /// No description provided for @messageFromApp.
  ///
  /// In en, this message translates to:
  /// **'A message from MindMessage'**
  String get messageFromApp;

  /// No description provided for @messageFromYou.
  ///
  /// In en, this message translates to:
  /// **'A message from yourself'**
  String get messageFromYou;

  /// No description provided for @notificationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Notification permission is required.'**
  String get notificationPermissionRequired;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are currently disabled.'**
  String get notificationPermissionDenied;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

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

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Spread kindness'**
  String get profileTitle;

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your words can make someone\'s day'**
  String get profileSubtitle;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get lightMode;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @defaultTimeRange.
  ///
  /// In en, this message translates to:
  /// **'Default time range'**
  String get defaultTimeRange;

  /// No description provided for @defaultStartTime.
  ///
  /// In en, this message translates to:
  /// **'Default start time'**
  String get defaultStartTime;

  /// No description provided for @defaultEndTime.
  ///
  /// In en, this message translates to:
  /// **'Default end time'**
  String get defaultEndTime;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete message?'**
  String get deleteMessageTitle;

  /// No description provided for @deleteMessageMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message?'**
  String get deleteMessageMessage;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete your account and your personal data. This action cannot be undone.'**
  String get deleteAccountMessage;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutTitle;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutMessage;

  /// No description provided for @unsavedChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get unsavedChangesTitle;

  /// No description provided for @unsavedChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to leave?'**
  String get unsavedChangesMessage;

  /// No description provided for @keep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get keep;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get noInternet;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on the server.'**
  String get serverError;

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

  /// No description provided for @failedToDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete.'**
  String get failedToDelete;

  /// No description provided for @failedToSchedule.
  ///
  /// In en, this message translates to:
  /// **'Failed to schedule the message.'**
  String get failedToSchedule;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again.'**
  String get tryAgain;

  /// No description provided for @noMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet.'**
  String get noMessages;

  /// No description provided for @noFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorite messages yet.'**
  String get noFavorites;

  /// No description provided for @noScheduledMessages.
  ///
  /// In en, this message translates to:
  /// **'No scheduled messages yet.'**
  String get noScheduledMessages;

  /// No description provided for @startWriting.
  ///
  /// In en, this message translates to:
  /// **'Write your first message to yourself.'**
  String get startWriting;

  /// No description provided for @startReceiving.
  ///
  /// In en, this message translates to:
  /// **'Set up your first reminder and let us send you something meaningful.'**
  String get startReceiving;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to MindMessage'**
  String get onboardingWelcome;

  /// No description provided for @onboardingWelcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Small reminders can make a big difference.'**
  String get onboardingWelcomeDescription;

  /// No description provided for @personalMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Write to yourself'**
  String get personalMessagesTitle;

  /// No description provided for @personalMessagesDescription.
  ///
  /// In en, this message translates to:
  /// **'Create messages that you would like to receive later.'**
  String get personalMessagesDescription;

  /// No description provided for @randomMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Let it be a surprise'**
  String get randomMessagesTitle;

  /// No description provided for @randomMessagesDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose a time range and let us surprise you with a message.'**
  String get randomMessagesDescription;

  /// No description provided for @futureSelfTitle.
  ///
  /// In en, this message translates to:
  /// **'Message your future self'**
  String get futureSelfTitle;

  /// No description provided for @futureSelfDescription.
  ///
  /// In en, this message translates to:
  /// **'Write something today that you want to hear in the future.'**
  String get futureSelfDescription;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

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

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @forgotPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we will send you a link to reset your password.'**
  String get forgotPasswordMessage;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'A password reset link has been sent to your email.'**
  String get passwordResetEmailSent;

  /// No description provided for @tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again later.'**
  String get tooManyRequests;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get networkError;

  /// No description provided for @emailPasswordNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'Email and password authentication is not enabled.'**
  String get emailPasswordNotEnabled;

  /// No description provided for @passwordResetError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get passwordResetError;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @randomMessage.
  ///
  /// In en, this message translates to:
  /// **'Random Message'**
  String get randomMessage;

  /// No description provided for @surpriseForFutureSelf.
  ///
  /// In en, this message translates to:
  /// **'A surprise for your future self'**
  String get surpriseForFutureSelf;

  /// No description provided for @randomMessageDescription.
  ///
  /// In en, this message translates to:
  /// **'Just write it. We will choose a random moment within the next five years and deliver it to you.'**
  String get randomMessageDescription;

  /// No description provided for @writeSomethingForFutureSelf.
  ///
  /// In en, this message translates to:
  /// **'Write something for your future self.'**
  String get writeSomethingForFutureSelf;

  /// No description provided for @surpriseIsWaiting.
  ///
  /// In en, this message translates to:
  /// **'A surprise is waiting'**
  String get surpriseIsWaiting;

  /// No description provided for @deliveryTimeDescription.
  ///
  /// In en, this message translates to:
  /// **'The delivery time is chosen randomly by the system. You will not know when your message will arrive.'**
  String get deliveryTimeDescription;

  /// No description provided for @sendToTheFuture.
  ///
  /// In en, this message translates to:
  /// **'Send to the future'**
  String get sendToTheFuture;

  /// No description provided for @writeMessageFirst.
  ///
  /// In en, this message translates to:
  /// **'Write your message first.'**
  String get writeMessageFirst;

  /// No description provided for @messageSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sent to your future self ✨'**
  String get messageSentSuccess;

  /// No description provided for @messageNotSaved.
  ///
  /// In en, this message translates to:
  /// **'The message was not saved. Try again.'**
  String get messageNotSaved;

  /// No description provided for @onlyYouWillReadIt.
  ///
  /// In en, this message translates to:
  /// **'Only you will read it.'**
  String get onlyYouWillReadIt;

  /// No description provided for @deliveryTime.
  ///
  /// In en, this message translates to:
  /// **'Delivery time'**
  String get deliveryTime;

  /// No description provided for @pickAMomentInTheFuture.
  ///
  /// In en, this message translates to:
  /// **'Pick a moment in the future.'**
  String get pickAMomentInTheFuture;

  /// No description provided for @aMessageForYourFutureSelf.
  ///
  /// In en, this message translates to:
  /// **'A message for your future self'**
  String get aMessageForYourFutureSelf;

  /// No description provided for @writeItNowReceiveItExactlyWhenYouChoose.
  ///
  /// In en, this message translates to:
  /// **'Write it now, receive it exactly when you choose.'**
  String get writeItNowReceiveItExactlyWhenYouChoose;

  /// No description provided for @whatDoYouWantToRemember.
  ///
  /// In en, this message translates to:
  /// **'What do you want to remember, or be reminded of?'**
  String get whatDoYouWantToRemember;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @inAWeek.
  ///
  /// In en, this message translates to:
  /// **'In a week'**
  String get inAWeek;

  /// No description provided for @inAMonth.
  ///
  /// In en, this message translates to:
  /// **'In a month'**
  String get inAMonth;

  /// No description provided for @inAYear.
  ///
  /// In en, this message translates to:
  /// **'In a year'**
  String get inAYear;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @yourMessageWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your message will appear here.'**
  String get yourMessageWillAppearHere;

  /// No description provided for @pickDateAndTimeToSeeCountdown.
  ///
  /// In en, this message translates to:
  /// **'Pick a date and time to see the countdown'**
  String get pickDateAndTimeToSeeCountdown;

  /// No description provided for @thatMomentHasAlreadyPassed.
  ///
  /// In en, this message translates to:
  /// **'That moment has already passed'**
  String get thatMomentHasAlreadyPassed;

  /// No description provided for @arrivesIn.
  ///
  /// In en, this message translates to:
  /// **'Arrives in'**
  String get arrivesIn;

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

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @writeYourMessageFirst.
  ///
  /// In en, this message translates to:
  /// **'Write your message first.'**
  String get writeYourMessageFirst;

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

  /// No description provided for @thatTimeHasPassedPickALaterOne.
  ///
  /// In en, this message translates to:
  /// **'That time has passed. Pick a later one.'**
  String get thatTimeHasPassedPickALaterOne;

  /// No description provided for @scheduledItWillReachYouOnTime.
  ///
  /// In en, this message translates to:
  /// **'Scheduled. It will reach you on time.'**
  String get scheduledItWillReachYouOnTime;

  /// No description provided for @messageWasNotSavedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'The message was not saved. Try again.'**
  String get messageWasNotSavedTryAgain;

  /// No description provided for @scheduling.
  ///
  /// In en, this message translates to:
  /// **'Scheduling'**
  String get scheduling;

  /// No description provided for @scheduleMessageButton.
  ///
  /// In en, this message translates to:
  /// **'Schedule message'**
  String get scheduleMessageButton;

  /// No description provided for @sendKindnessToSomeone.
  ///
  /// In en, this message translates to:
  /// **'Send a little kindness to someone'**
  String get sendKindnessToSomeone;

  /// No description provided for @writeAMessageAndLetUsFindSomeone.
  ///
  /// In en, this message translates to:
  /// **'Write a message and let us find someone to receive it.'**
  String get writeAMessageAndLetUsFindSomeone;

  /// No description provided for @writeSomethingKind.
  ///
  /// In en, this message translates to:
  /// **'Write something kind for someone.'**
  String get writeSomethingKind;

  /// No description provided for @writeYourRandomMessage.
  ///
  /// In en, this message translates to:
  /// **'Write your message here...'**
  String get writeYourRandomMessage;

  /// No description provided for @randomRecipient.
  ///
  /// In en, this message translates to:
  /// **'Random recipient'**
  String get randomRecipient;

  /// No description provided for @chooseSomeoneToReceiveYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose someone to receive your message.'**
  String get chooseSomeoneToReceiveYourMessage;

  /// No description provided for @pickRandomUser.
  ///
  /// In en, this message translates to:
  /// **'Pick Random User'**
  String get pickRandomUser;

  /// No description provided for @pickAnotherUser.
  ///
  /// In en, this message translates to:
  /// **'Pick Another User'**
  String get pickAnotherUser;

  /// No description provided for @findingSomeone.
  ///
  /// In en, this message translates to:
  /// **'Finding someone...'**
  String get findingSomeone;

  /// No description provided for @noRecipientSelected.
  ///
  /// In en, this message translates to:
  /// **'No recipient selected'**
  String get noRecipientSelected;

  /// No description provided for @tapBelowToFindSomeone.
  ///
  /// In en, this message translates to:
  /// **'Tap below to find someone at random.'**
  String get tapBelowToFindSomeone;

  /// No description provided for @yourMessageWillBeSentTo.
  ///
  /// In en, this message translates to:
  /// **'Your message will be sent to'**
  String get yourMessageWillBeSentTo;

  /// No description provided for @pickARandomUserFirst.
  ///
  /// In en, this message translates to:
  /// **'Pick a random user first.'**
  String get pickARandomUserFirst;

  /// No description provided for @noOtherUsersAvailable.
  ///
  /// In en, this message translates to:
  /// **'There are no other users available.'**
  String get noOtherUsersAvailable;

  /// No description provided for @couldNotFindRandomUser.
  ///
  /// In en, this message translates to:
  /// **'Could not find a random user. Try again.'**
  String get couldNotFindRandomUser;

  /// No description provided for @messageSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your message was sent successfully.'**
  String get messageSentSuccessfully;

  /// No description provided for @messageWasNotSent.
  ///
  /// In en, this message translates to:
  /// **'The message was not sent. Try again.'**
  String get messageWasNotSent;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @profilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profilePhoto;

  /// No description provided for @changeProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'You can change your profile photo here'**
  String get changeProfilePhoto;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name is too short'**
  String get nameTooShort;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get usernameHint;

  /// No description provided for @usernameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Username is too short'**
  String get usernameTooShort;

  /// No description provided for @usernameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Only English letters, numbers, . and _ are allowed'**
  String get usernameInvalid;

  /// No description provided for @emailCannotBeChanged.
  ///
  /// In en, this message translates to:
  /// **'Your email cannot be changed from here'**
  String get emailCannotBeChanged;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your changes have been saved successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @usernameAlreadyTaken.
  ///
  /// In en, this message translates to:
  /// **'This username is already taken. Try another one'**
  String get usernameAlreadyTaken;

  /// No description provided for @profileUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while saving. Please try again'**
  String get profileUpdateError;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takePhoto;

  /// No description provided for @deletePhoto.
  ///
  /// In en, this message translates to:
  /// **'Delete Photo'**
  String get deletePhoto;
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
