import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hu.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hu')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'NutriMom'**
  String get appName;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get alreadyHaveAccount;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your pregnancy & breastfeeding nutrition companion'**
  String get welcomeSubtitle;

  /// No description provided for @hiThere.
  ///
  /// In en, this message translates to:
  /// **'Hi there! 👋'**
  String get hiThere;

  /// No description provided for @whatShouldWeCallYou.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get whatShouldWeCallYou;

  /// No description provided for @yourFirstName.
  ///
  /// In en, this message translates to:
  /// **'Your first name'**
  String get yourFirstName;

  /// No description provided for @continue_btn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_btn;

  /// No description provided for @yourJourney.
  ///
  /// In en, this message translates to:
  /// **'Your journey 💙'**
  String get yourJourney;

  /// No description provided for @whichDescribesYou.
  ///
  /// In en, this message translates to:
  /// **'Which best describes you right now?'**
  String get whichDescribesYou;

  /// No description provided for @pregnant.
  ///
  /// In en, this message translates to:
  /// **'Pregnant'**
  String get pregnant;

  /// No description provided for @breastfeeding.
  ///
  /// In en, this message translates to:
  /// **'Breastfeeding'**
  String get breastfeeding;

  /// No description provided for @yourTrimester.
  ///
  /// In en, this message translates to:
  /// **'Your trimester 🌱'**
  String get yourTrimester;

  /// No description provided for @babyAge.
  ///
  /// In en, this message translates to:
  /// **'Baby\'s age 👶'**
  String get babyAge;

  /// No description provided for @whichTrimester.
  ///
  /// In en, this message translates to:
  /// **'Which trimester are you in?'**
  String get whichTrimester;

  /// No description provided for @howOldIsBaby.
  ///
  /// In en, this message translates to:
  /// **'How old is your baby?'**
  String get howOldIsBaby;

  /// No description provided for @firstTrimester.
  ///
  /// In en, this message translates to:
  /// **'First Trimester (Weeks 1–12)'**
  String get firstTrimester;

  /// No description provided for @secondTrimester.
  ///
  /// In en, this message translates to:
  /// **'Second Trimester (Weeks 13–26)'**
  String get secondTrimester;

  /// No description provided for @thirdTrimester.
  ///
  /// In en, this message translates to:
  /// **'Third Trimester (Weeks 27–40)'**
  String get thirdTrimester;

  /// No description provided for @under6Months.
  ///
  /// In en, this message translates to:
  /// **'Under 6 months'**
  String get under6Months;

  /// No description provided for @over6Months.
  ///
  /// In en, this message translates to:
  /// **'6 months or older'**
  String get over6Months;

  /// No description provided for @almostDone.
  ///
  /// In en, this message translates to:
  /// **'Almost done! ⚖️'**
  String get almostDone;

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'What is your current weight?'**
  String get currentWeight;

  /// No description provided for @weightHint.
  ///
  /// In en, this message translates to:
  /// **'Weight in kg'**
  String get weightHint;

  /// No description provided for @startTracking.
  ///
  /// In en, this message translates to:
  /// **'Start Tracking!'**
  String get startTracking;

  /// No description provided for @dailyCalories.
  ///
  /// In en, this message translates to:
  /// **'Daily Calories'**
  String get dailyCalories;

  /// No description provided for @kcalGoal.
  ///
  /// In en, this message translates to:
  /// **'kcal goal'**
  String get kcalGoal;

  /// No description provided for @kcalConsumed.
  ///
  /// In en, this message translates to:
  /// **'kcal consumed'**
  String get kcalConsumed;

  /// No description provided for @kcalRemaining.
  ///
  /// In en, this message translates to:
  /// **'kcal remaining'**
  String get kcalRemaining;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @glasses.
  ///
  /// In en, this message translates to:
  /// **'glasses'**
  String get glasses;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'current'**
  String get current;

  /// No description provided for @nutritionSummary.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Summary'**
  String get nutritionSummary;

  /// No description provided for @todaysMeals.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Meals'**
  String get todaysMeals;

  /// No description provided for @noMealsLogged.
  ///
  /// In en, this message translates to:
  /// **'No meals logged yet'**
  String get noMealsLogged;

  /// No description provided for @tapToLogFood.
  ///
  /// In en, this message translates to:
  /// **'Tap + Log Food to get started'**
  String get tapToLogFood;

  /// No description provided for @logFood.
  ///
  /// In en, this message translates to:
  /// **'Log Food'**
  String get logFood;

  /// No description provided for @searchFood.
  ///
  /// In en, this message translates to:
  /// **'Search Food'**
  String get searchFood;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a food...'**
  String get searchHint;

  /// No description provided for @commonFoods.
  ///
  /// In en, this message translates to:
  /// **'Common Foods'**
  String get commonFoods;

  /// No description provided for @noFoodsFound.
  ///
  /// In en, this message translates to:
  /// **'No foods found'**
  String get noFoodsFound;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @foodsToAvoid.
  ///
  /// In en, this message translates to:
  /// **'Foods to Avoid ⚠️'**
  String get foodsToAvoid;

  /// No description provided for @waterIntake.
  ///
  /// In en, this message translates to:
  /// **'Water Intake 💧'**
  String get waterIntake;

  /// No description provided for @stayHydrated.
  ///
  /// In en, this message translates to:
  /// **'Staying hydrated is essential during pregnancy & breastfeeding'**
  String get stayHydrated;

  /// No description provided for @addGlass.
  ///
  /// In en, this message translates to:
  /// **'Add Glass'**
  String get addGlass;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @waterGoalReached.
  ///
  /// In en, this message translates to:
  /// **'🎉 Great job! You reached your daily water goal!'**
  String get waterGoalReached;

  /// No description provided for @logWeight.
  ///
  /// In en, this message translates to:
  /// **'Log Weight ⚖️'**
  String get logWeight;

  /// No description provided for @trackWeight.
  ///
  /// In en, this message translates to:
  /// **'Track your weight over time'**
  String get trackWeight;

  /// No description provided for @recentEntries.
  ///
  /// In en, this message translates to:
  /// **'Recent entries'**
  String get recentEntries;

  /// No description provided for @newEntry.
  ///
  /// In en, this message translates to:
  /// **'New entry'**
  String get newEntry;

  /// No description provided for @enterWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter your weight'**
  String get enterWeight;

  /// No description provided for @saveWeight.
  ///
  /// In en, this message translates to:
  /// **'Save Weight'**
  String get saveWeight;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccount;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get noAccount;

  /// No description provided for @alreadyAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get alreadyAccount;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hu': return AppLocalizationsHu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
