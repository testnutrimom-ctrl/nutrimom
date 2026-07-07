import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isHungarian => locale.languageCode == 'hu';

  String get appName => 'NutriMom';
  String get getStarted => isHungarian ? 'Kezdés' : 'Get Started';
  String get alreadyHaveAccount => isHungarian ? 'Már van fiókom' : 'I already have an account';
  String get welcomeSubtitle => isHungarian ? 'A te terhességi és szoptatási táplálkozási kísérőd' : 'Your pregnancy & breastfeeding nutrition companion';
  String get hiThere => isHungarian ? 'Szia! 👋' : 'Hi there! 👋';
  String get whatShouldWeCallYou => isHungarian ? 'Hogy szólítsunk?' : 'What should we call you?';
  String get yourFirstName => isHungarian ? 'Keresztneved' : 'Your first name';
  String get continueBtn => isHungarian ? 'Tovább' : 'Continue';
  String get yourJourney => isHungarian ? 'Az utad 💙' : 'Your journey 💙';
  String get whichDescribesYou => isHungarian ? 'Melyik illik rád most?' : 'Which best describes you right now?';
  String get pregnant => isHungarian ? 'Terhes' : 'Pregnant';
  String get breastfeeding => isHungarian ? 'Szoptatós' : 'Breastfeeding';
  String get yourTrimester => isHungarian ? 'A trimesztered 🌱' : 'Your trimester 🌱';
  String get babyAge => isHungarian ? 'A baba kora 👶' : 'Baby\'s age 👶';
  String get whichTrimester => isHungarian ? 'Melyik trimeszterben vagy?' : 'Which trimester are you in?';
  String get howOldIsBaby => isHungarian ? 'Hány hónapos a babád?' : 'How old is your baby?';
  String get firstTrimester => isHungarian ? '1. trimeszter (1–12. hét)' : 'First Trimester (Weeks 1–12)';
  String get secondTrimester => isHungarian ? '2. trimeszter (13–26. hét)' : 'Second Trimester (Weeks 13–26)';
  String get thirdTrimester => isHungarian ? '3. trimeszter (27–40. hét)' : 'Third Trimester (Weeks 27–40)';
  String get under6Months => isHungarian ? '6 hónapnál fiatalabb' : 'Under 6 months';
  String get over6Months => isHungarian ? '6 hónapos vagy idősebb' : '6 months or older';
  String get almostDone => isHungarian ? 'Már majdnem kész! ⚖️' : 'Almost done! ⚖️';
  String get currentWeight => isHungarian ? 'Mi a jelenlegi súlyod?' : 'What is your current weight?';
  String get weightHint => isHungarian ? 'Súly kg-ban' : 'Weight in kg';
  String get startTracking => isHungarian ? 'Kezdjük el!' : 'Start Tracking!';
  String get dailyCalories => isHungarian ? 'Napi kalória' : 'Daily Calories';
  String get kcalGoal => isHungarian ? 'kcal cél' : 'kcal goal';
  String get kcalConsumed => isHungarian ? 'kcal elfogyasztva' : 'kcal consumed';
String get kcalRemaining => isHungarian ? 'kcal maradt' : 'kcal remaining';
  String get water => isHungarian ? 'Víz' : 'Water';
  String get glasses => isHungarian ? 'pohár' : 'glasses';
  String get weight => isHungarian ? 'Súly' : 'Weight';
  String get current => isHungarian ? 'jelenlegi' : 'current';
  String get nutritionSummary => isHungarian ? 'Táplálkozási összefoglaló' : 'Nutrition Summary';
  String get todaysMeals => isHungarian ? 'Mai étkezések' : 'Today\'s Meals';
  String get noMealsLogged => isHungarian ? 'Még nincs rögzített étkezés' : 'No meals logged yet';
  String get tapToLogFood => isHungarian ? 'Koppints a + Étel rögzítése gombra' : 'Tap + Log Food to get started';
  String get logFood => isHungarian ? 'Étel rögzítése' : 'Log Food';
  String get searchFood => isHungarian ? 'Étel keresése' : 'Search Food';
  String get searchHint => isHungarian ? 'Keress egy ételt...' : 'Search for a food...';
  String get commonFoods => isHungarian ? 'Gyakori ételek' : 'Common Foods';
  String get noFoodsFound => isHungarian ? 'Nem található étel' : 'No foods found';
  String get foodsToAvoid => isHungarian ? 'Kerülendő ételek ⚠️' : 'Foods to Avoid ⚠️';
  String get waterIntake => isHungarian ? 'Vízbevitel 💧' : 'Water Intake 💧';
  String get stayHydrated => isHungarian ? 'A megfelelő folyadékbevitel elengedhetetlen terhesség és szoptatás alatt' : 'Staying hydrated is essential during pregnancy & breastfeeding';
  String get addGlass => isHungarian ? 'Pohár hozzáadása' : 'Add Glass';
  String get remove => isHungarian ? 'Eltávolítás' : 'Remove';
  String get waterGoalReached => isHungarian ? '🎉 Szuper! Elérted a napi vízfogyasztási célodat!' : '🎉 Great job! You reached your daily water goal!';
  String get logWeight => isHungarian ? 'Súly rögzítése ⚖️' : 'Log Weight ⚖️';
  String get trackWeight => isHungarian ? 'Kövesd nyomon a súlyod változását' : 'Track your weight over time';
  String get recentEntries => isHungarian ? 'Legutóbbi bejegyzések' : 'Recent entries';
  String get newEntry => isHungarian ? 'Új bejegyzés' : 'New entry';
  String get enterWeight => isHungarian ? 'Add meg a súlyodat' : 'Enter your weight';
  String get saveWeight => isHungarian ? 'Súly mentése' : 'Save Weight';
  String get email => isHungarian ? 'E-mail cím' : 'Email address';
  String get password => isHungarian ? 'Jelszó' : 'Password';
  String get yourName => isHungarian ? 'Neved' : 'Your name';
  String get logIn => isHungarian ? 'Bejelentkezés' : 'Log In';
  String get createAccount => isHungarian ? 'Fiók létrehozása' : 'Create Account';
  String get welcomeBack => isHungarian ? 'Üdv újra!' : 'Welcome back!';
  String get createYourAccount => isHungarian ? 'Hozd létre a fiókodat' : 'Create your account';
  String get noAccount => isHungarian ? 'Még nincs fiókod? Regisztrálj' : 'Don\'t have an account? Sign up';
  String get alreadyAccount => isHungarian ? 'Már van fiókod? Jelentkezz be' : 'Already have an account? Log in';
  String hiName(String name) => isHungarian ? 'Szia, $name! 👋' : 'Hi, $name! 👋';
  String trimesterLabel(String stage) => isHungarian ? '$stage. trimeszter' : 'Trimester $stage';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'hu'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}