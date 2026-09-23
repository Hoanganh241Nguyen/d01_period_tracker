import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi kỳ kinh'**
  String get appTitle;

  /// No description provided for @commonToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get commonToday;

  /// No description provided for @commonSave.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get commonSave;

  /// No description provided for @commonBack.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get commonBack;

  /// No description provided for @commonClose.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get commonClose;

  /// No description provided for @commonContinue.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get commonContinue;

  /// No description provided for @commonCancel.
  ///
  /// In vi, this message translates to:
  /// **'Huỷ'**
  String get commonCancel;

  /// No description provided for @commonDays.
  ///
  /// In vi, this message translates to:
  /// **'{count} ngày'**
  String commonDays(int count);

  /// Month header. Pass month as "1".."12".
  ///
  /// In vi, this message translates to:
  /// **'Tháng {month}, {year}'**
  String commonMonthYear(String month, String year);

  /// No description provided for @commonDayMonth.
  ///
  /// In vi, this message translates to:
  /// **'{day}/{month}'**
  String commonDayMonth(String day, String month);

  /// No description provided for @weekdayShortMon.
  ///
  /// In vi, this message translates to:
  /// **'T2'**
  String get weekdayShortMon;

  /// No description provided for @weekdayShortTue.
  ///
  /// In vi, this message translates to:
  /// **'T3'**
  String get weekdayShortTue;

  /// No description provided for @weekdayShortWed.
  ///
  /// In vi, this message translates to:
  /// **'T4'**
  String get weekdayShortWed;

  /// No description provided for @weekdayShortThu.
  ///
  /// In vi, this message translates to:
  /// **'T5'**
  String get weekdayShortThu;

  /// No description provided for @weekdayShortFri.
  ///
  /// In vi, this message translates to:
  /// **'T6'**
  String get weekdayShortFri;

  /// No description provided for @weekdayShortSat.
  ///
  /// In vi, this message translates to:
  /// **'T7'**
  String get weekdayShortSat;

  /// No description provided for @weekdayShortSun.
  ///
  /// In vi, this message translates to:
  /// **'CN'**
  String get weekdayShortSun;

  /// No description provided for @weekdayLongMon.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Hai'**
  String get weekdayLongMon;

  /// No description provided for @weekdayLongTue.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Ba'**
  String get weekdayLongTue;

  /// No description provided for @weekdayLongWed.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Tư'**
  String get weekdayLongWed;

  /// No description provided for @weekdayLongThu.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Năm'**
  String get weekdayLongThu;

  /// No description provided for @weekdayLongFri.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Sáu'**
  String get weekdayLongFri;

  /// No description provided for @weekdayLongSat.
  ///
  /// In vi, this message translates to:
  /// **'Thứ Bảy'**
  String get weekdayLongSat;

  /// No description provided for @weekdayLongSun.
  ///
  /// In vi, this message translates to:
  /// **'Chủ Nhật'**
  String get weekdayLongSun;

  /// No description provided for @homeTabHome.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get homeTabHome;

  /// No description provided for @homeTabCalendar.
  ///
  /// In vi, this message translates to:
  /// **'Lịch'**
  String get homeTabCalendar;

  /// No description provided for @homeTabInsights.
  ///
  /// In vi, this message translates to:
  /// **'Insight'**
  String get homeTabInsights;

  /// No description provided for @homeTabSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get homeTabSettings;

  /// No description provided for @homeLogTodayTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhận hôm nay'**
  String get homeLogTodayTooltip;

  /// No description provided for @homeTodayWithWeekdayDate.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay, {weekday}, {date}'**
  String homeTodayWithWeekdayDate(String weekday, String date);

  /// No description provided for @homeGreetingMorning.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi sáng 🌸'**
  String get homeGreetingMorning;

  /// No description provided for @homeOpenCalendarTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Mở lịch'**
  String get homeOpenCalendarTooltip;

  /// No description provided for @homeCycleRemainingPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Còn'**
  String get homeCycleRemainingPrefix;

  /// No description provided for @homeCycleUntilNextPeriod.
  ///
  /// In vi, this message translates to:
  /// **'đến kỳ kinh tiếp theo'**
  String get homeCycleUntilNextPeriod;

  /// No description provided for @homeCycleExpectedDate.
  ///
  /// In vi, this message translates to:
  /// **'Dự kiến: {date}'**
  String homeCycleExpectedDate(String date);

  /// No description provided for @homeEncouragement.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đang\nlàm rất tốt!'**
  String get homeEncouragement;

  /// No description provided for @homeLogPeriodLate.
  ///
  /// In vi, this message translates to:
  /// **'Kinh đã đến? Ghi ngay'**
  String get homeLogPeriodLate;

  /// No description provided for @homeLogPeriodUpdate.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật kỳ kinh • Ngày {day}'**
  String homeLogPeriodUpdate(int day);

  /// No description provided for @homeLogPeriodEarly.
  ///
  /// In vi, this message translates to:
  /// **'Ra máu? Ghi lại'**
  String get homeLogPeriodEarly;

  /// No description provided for @homeLogPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Ghi kỳ kinh'**
  String get homeLogPeriod;

  /// No description provided for @homeActionCycleAnalysis.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích chu kỳ'**
  String get homeActionCycleAnalysis;

  /// No description provided for @homeActionAddSymptoms.
  ///
  /// In vi, this message translates to:
  /// **'Thêm triệu chứng'**
  String get homeActionAddSymptoms;

  /// No description provided for @homeSectionDailyLog.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhận'**
  String get homeSectionDailyLog;

  /// No description provided for @homeSectionSymptoms.
  ///
  /// In vi, this message translates to:
  /// **'Triệu chứng'**
  String get homeSectionSymptoms;

  /// Mini calendar header. Pass month as "1".."12".
  ///
  /// In vi, this message translates to:
  /// **'Lịch tháng {month}'**
  String homeCalendarMonthTitle(String month);

  /// No description provided for @homeCalendarTodayButton.
  ///
  /// In vi, this message translates to:
  /// **'Xem lịch ›'**
  String get homeCalendarTodayButton;

  /// No description provided for @homeLegendPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh'**
  String get homeLegendPeriod;

  /// No description provided for @homeLegendPredicted.
  ///
  /// In vi, this message translates to:
  /// **'Dự kiến'**
  String get homeLegendPredicted;

  /// No description provided for @homeLegendOvulation.
  ///
  /// In vi, this message translates to:
  /// **'Rụng trứng'**
  String get homeLegendOvulation;

  /// No description provided for @homeStatusCycleDay.
  ///
  /// In vi, this message translates to:
  /// **'Ngày {day} của chu kỳ'**
  String homeStatusCycleDay(int day);

  /// length is a formatted duration, e.g. commonDays(28).
  ///
  /// In vi, this message translates to:
  /// **'Chu kỳ trung bình: {length}'**
  String homeStatusAverageCycle(String length);

  /// No description provided for @homeTipTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mẹo hôm nay'**
  String get homeTipTitle;

  /// No description provided for @homeTipBody.
  ///
  /// In vi, this message translates to:
  /// **'Căng thẳng, thiếu ngủ hay thay đổi cân nặng có thể làm kinh đến muộn vài ngày.'**
  String get homeTipBody;

  /// No description provided for @homeTipSeeMore.
  ///
  /// In vi, this message translates to:
  /// **'Xem thêm'**
  String get homeTipSeeMore;

  /// No description provided for @insightTitle.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích chu kỳ'**
  String get insightTitle;

  /// No description provided for @insightSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi độ dài chu kỳ & thời gian kỳ kinh.'**
  String get insightSubtitle;

  /// No description provided for @insightTagline.
  ///
  /// In vi, this message translates to:
  /// **'Hiểu cơ thể\nyêu chính mình ♥'**
  String get insightTagline;

  /// No description provided for @insightBadgeNormal.
  ///
  /// In vi, this message translates to:
  /// **'Bình thường'**
  String get insightBadgeNormal;

  /// No description provided for @insightBadgeIrregular.
  ///
  /// In vi, this message translates to:
  /// **'Không đều'**
  String get insightBadgeIrregular;

  /// No description provided for @insightStatDays.
  ///
  /// In vi, this message translates to:
  /// **'{count} Ngày'**
  String insightStatDays(int count);

  /// No description provided for @insightAvgPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh trung bình'**
  String get insightAvgPeriod;

  /// No description provided for @insightAvgCycle.
  ///
  /// In vi, this message translates to:
  /// **'Chu kỳ trung bình'**
  String get insightAvgCycle;

  /// No description provided for @insightTrendTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xu hướng chu kỳ & kỳ kinh'**
  String get insightTrendTitle;

  /// No description provided for @insightLastCycles.
  ///
  /// In vi, this message translates to:
  /// **'{count} chu kỳ gần nhất'**
  String insightLastCycles(int count);

  /// No description provided for @insightLegendCycleLength.
  ///
  /// In vi, this message translates to:
  /// **'Độ dài chu kỳ (ngày)'**
  String get insightLegendCycleLength;

  /// No description provided for @insightLegendPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh (ngày)'**
  String get insightLegendPeriod;

  /// No description provided for @insightCurrentPhaseTitle.
  ///
  /// In vi, this message translates to:
  /// **'Phân tích giai đoạn hiện tại'**
  String get insightCurrentPhaseTitle;

  /// No description provided for @insightPatternsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mẫu thường gặp'**
  String get insightPatternsTitle;

  /// No description provided for @insightPatternPmsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'{days} ngày trước kỳ kinh'**
  String insightPatternPmsSubtitle(int days);

  /// No description provided for @insightPatternCrampsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngày {startDay} – {endDay} của kỳ kinh'**
  String insightPatternCrampsSubtitle(int startDay, int endDay);

  /// No description provided for @insightTipsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý cho bạn'**
  String get insightTipsTitle;

  /// No description provided for @onboardingSkip.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get onboardingSkip;

  /// No description provided for @onboardingStepProgress.
  ///
  /// In vi, this message translates to:
  /// **'Bước {current}/{total}'**
  String onboardingStepProgress(int current, int total);

  /// No description provided for @onboardingStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu dùng app'**
  String get onboardingStart;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi chu kỳ dễ hơn mỗi ngày'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'App giúp bạn ghi kỳ kinh, triệu chứng và nhắc nhở những việc quan trọng mà không làm mọi thứ trở nên rối.'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingWelcomePrivacyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Riêng tư là mặc định'**
  String get onboardingWelcomePrivacyTitle;

  /// No description provided for @onboardingWelcomePrivacyBody.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu sức khỏe được trình bày rõ ràng, không hiển thị quảng cáo trong luồng onboarding.'**
  String get onboardingWelcomePrivacyBody;

  /// No description provided for @onboardingGoalTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn dùng app để làm gì?'**
  String get onboardingGoalTitle;

  /// No description provided for @onboardingGoalSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn mục tiêu chính để app ưu tiên nội dung và nhắc nhở phù hợp.'**
  String get onboardingGoalSubtitle;

  /// No description provided for @onboardingGoalTrackCycle.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi chu kỳ'**
  String get onboardingGoalTrackCycle;

  /// No description provided for @onboardingGoalFertileWindow.
  ///
  /// In vi, this message translates to:
  /// **'Canh ngày dễ thụ thai'**
  String get onboardingGoalFertileWindow;

  /// No description provided for @onboardingGoalLogSymptoms.
  ///
  /// In vi, this message translates to:
  /// **'Ghi triệu chứng'**
  String get onboardingGoalLogSymptoms;

  /// No description provided for @onboardingGoalWaterReminder.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc uống nước'**
  String get onboardingGoalWaterReminder;

  /// No description provided for @onboardingLastPeriodTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh gần nhất bắt đầu khi nào?'**
  String get onboardingLastPeriodTitle;

  /// No description provided for @onboardingLastPeriodSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin này giúp dự đoán kỳ tới và các giai đoạn trong chu kỳ.'**
  String get onboardingLastPeriodSubtitle;

  /// No description provided for @onboardingDateTileTitle.
  ///
  /// In vi, this message translates to:
  /// **'{weekday}, {date}'**
  String onboardingDateTileTitle(String weekday, String date);

  /// No description provided for @onboardingDateTileSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngày bắt đầu kỳ kinh'**
  String get onboardingDateTileSubtitle;

  /// No description provided for @onboardingCycleTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thiết lập độ dài chu kỳ'**
  String get onboardingCycleTitle;

  /// No description provided for @onboardingCycleSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nếu chưa chắc chắn, bạn có thể giữ mặc định và chỉnh lại sau trong Cài đặt.'**
  String get onboardingCycleSubtitle;

  /// No description provided for @onboardingPeriodLengthLabel.
  ///
  /// In vi, this message translates to:
  /// **'Số ngày hành kinh'**
  String get onboardingPeriodLengthLabel;

  /// No description provided for @onboardingCycleLengthLabel.
  ///
  /// In vi, this message translates to:
  /// **'Độ dài chu kỳ'**
  String get onboardingCycleLengthLabel;

  /// No description provided for @onboardingSymptomsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn thường muốn ghi nhận gì?'**
  String get onboardingSymptomsTitle;

  /// No description provided for @onboardingSymptomsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn nhanh các triệu chứng hay gặp. Bạn vẫn có thể thêm hoặc bỏ sau này.'**
  String get onboardingSymptomsSubtitle;

  /// No description provided for @onboardingSymptomCramps.
  ///
  /// In vi, this message translates to:
  /// **'Đau bụng'**
  String get onboardingSymptomCramps;

  /// No description provided for @onboardingSymptomBackPain.
  ///
  /// In vi, this message translates to:
  /// **'Đau lưng'**
  String get onboardingSymptomBackPain;

  /// No description provided for @onboardingSymptomFatigue.
  ///
  /// In vi, this message translates to:
  /// **'Mệt mỏi'**
  String get onboardingSymptomFatigue;

  /// No description provided for @onboardingSymptomHeadache.
  ///
  /// In vi, this message translates to:
  /// **'Đau đầu'**
  String get onboardingSymptomHeadache;

  /// No description provided for @onboardingSymptomMoodSwings.
  ///
  /// In vi, this message translates to:
  /// **'Tâm trạng thất thường'**
  String get onboardingSymptomMoodSwings;

  /// No description provided for @onboardingSymptomAcne.
  ///
  /// In vi, this message translates to:
  /// **'Mụn'**
  String get onboardingSymptomAcne;

  /// No description provided for @onboardingReminderTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bật nhắc nhở nhẹ nhàng'**
  String get onboardingReminderTitle;

  /// No description provided for @onboardingReminderSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'App có thể nhắc ghi nhận hằng ngày, kỳ kinh dự kiến và uống nước theo cài đặt của bạn.'**
  String get onboardingReminderSubtitle;

  /// No description provided for @onboardingDailyReminderTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc ghi nhận hằng ngày'**
  String get onboardingDailyReminderTitle;

  /// No description provided for @onboardingDailyReminderSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay bạn thấy thế nào? Ghi lại chỉ mất 10 giây'**
  String get onboardingDailyReminderSubtitle;

  /// No description provided for @onboardingReminderInfoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Có thể đổi bất cứ lúc nào'**
  String get onboardingReminderInfoTitle;

  /// No description provided for @onboardingReminderInfoBody.
  ///
  /// In vi, this message translates to:
  /// **'Bạn kiểm soát toàn bộ thông báo trong phần Cài đặt thông báo.'**
  String get onboardingReminderInfoBody;

  /// No description provided for @splashTagline.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi chu kỳ nhẹ nhàng và riêng tư'**
  String get splashTagline;

  /// No description provided for @languageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể thay đổi lại trong phần Cài đặt sau.'**
  String get languageSubtitle;

  /// No description provided for @dailyLogFlowSpotting.
  ///
  /// In vi, this message translates to:
  /// **'Lấm tấm'**
  String get dailyLogFlowSpotting;

  /// No description provided for @dailyLogFlowLight.
  ///
  /// In vi, this message translates to:
  /// **'Nhẹ'**
  String get dailyLogFlowLight;

  /// No description provided for @dailyLogFlowMedium.
  ///
  /// In vi, this message translates to:
  /// **'Vừa'**
  String get dailyLogFlowMedium;

  /// No description provided for @dailyLogFlowHeavy.
  ///
  /// In vi, this message translates to:
  /// **'Nhiều'**
  String get dailyLogFlowHeavy;

  /// No description provided for @dailyLogFlowProlonged.
  ///
  /// In vi, this message translates to:
  /// **'Rong kinh'**
  String get dailyLogFlowProlonged;

  /// No description provided for @dailyLogMoodHappy.
  ///
  /// In vi, this message translates to:
  /// **'Vui vẻ'**
  String get dailyLogMoodHappy;

  /// No description provided for @dailyLogMoodNormal.
  ///
  /// In vi, this message translates to:
  /// **'Bình thường'**
  String get dailyLogMoodNormal;

  /// No description provided for @dailyLogMoodSad.
  ///
  /// In vi, this message translates to:
  /// **'Buồn'**
  String get dailyLogMoodSad;

  /// No description provided for @dailyLogMoodIrritable.
  ///
  /// In vi, this message translates to:
  /// **'Cáu gắt'**
  String get dailyLogMoodIrritable;

  /// No description provided for @dailyLogMoodAnxious.
  ///
  /// In vi, this message translates to:
  /// **'Lo lắng'**
  String get dailyLogMoodAnxious;

  /// No description provided for @dailyLogMoodTired.
  ///
  /// In vi, this message translates to:
  /// **'Mệt mỏi'**
  String get dailyLogMoodTired;

  /// No description provided for @dailyLogSymptomCramps.
  ///
  /// In vi, this message translates to:
  /// **'Đau bụng'**
  String get dailyLogSymptomCramps;

  /// No description provided for @dailyLogSymptomBackPain.
  ///
  /// In vi, this message translates to:
  /// **'Đau lưng'**
  String get dailyLogSymptomBackPain;

  /// No description provided for @dailyLogSymptomHeadache.
  ///
  /// In vi, this message translates to:
  /// **'Đau đầu'**
  String get dailyLogSymptomHeadache;

  /// No description provided for @dailyLogSymptomBloating.
  ///
  /// In vi, this message translates to:
  /// **'Đầy hơi'**
  String get dailyLogSymptomBloating;

  /// No description provided for @dailyLogSymptomBreastTenderness.
  ///
  /// In vi, this message translates to:
  /// **'Căng ngực'**
  String get dailyLogSymptomBreastTenderness;

  /// No description provided for @dailyLogSymptomAcne.
  ///
  /// In vi, this message translates to:
  /// **'Nổi mụn'**
  String get dailyLogSymptomAcne;

  /// No description provided for @dailyLogSymptomNausea.
  ///
  /// In vi, this message translates to:
  /// **'Buồn nôn'**
  String get dailyLogSymptomNausea;

  /// No description provided for @dailyLogSymptomCravings.
  ///
  /// In vi, this message translates to:
  /// **'Thèm ăn'**
  String get dailyLogSymptomCravings;

  /// No description provided for @dailyLogSymptomInsomnia.
  ///
  /// In vi, this message translates to:
  /// **'Mất ngủ'**
  String get dailyLogSymptomInsomnia;

  /// No description provided for @dailyLogSymptomDiarrhea.
  ///
  /// In vi, this message translates to:
  /// **'Tiêu chảy'**
  String get dailyLogSymptomDiarrhea;

  /// No description provided for @dailyLogMaxMoods.
  ///
  /// In vi, this message translates to:
  /// **'Chọn tối đa {count} tâm trạng.'**
  String dailyLogMaxMoods(int count);

  /// No description provided for @dailyLogAddSymptom.
  ///
  /// In vi, this message translates to:
  /// **'Thêm triệu chứng'**
  String get dailyLogAddSymptom;

  /// No description provided for @dailyLogSymptomNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Tên triệu chứng'**
  String get dailyLogSymptomNameHint;

  /// No description provided for @dailyLogAdd.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get dailyLogAdd;

  /// No description provided for @dailyLogSavedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu'**
  String get dailyLogSavedTitle;

  /// No description provided for @dailyLogSavedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu ghi nhận ngày {date}'**
  String dailyLogSavedMessage(String date);

  /// No description provided for @dailyLogFlow.
  ///
  /// In vi, this message translates to:
  /// **'Ra máu'**
  String get dailyLogFlow;

  /// No description provided for @dailyLogSpottingNotPeriod.
  ///
  /// In vi, this message translates to:
  /// **'\"Lấm tấm\" không tính là kỳ kinh.'**
  String get dailyLogSpottingNotPeriod;

  /// No description provided for @dailyLogMood.
  ///
  /// In vi, this message translates to:
  /// **'Tâm trạng'**
  String get dailyLogMood;

  /// No description provided for @dailyLogSymptoms.
  ///
  /// In vi, this message translates to:
  /// **'Triệu chứng'**
  String get dailyLogSymptoms;

  /// No description provided for @dailyLogNote.
  ///
  /// In vi, this message translates to:
  /// **'Ghi chú'**
  String get dailyLogNote;

  /// No description provided for @dailyLogNoteHint.
  ///
  /// In vi, this message translates to:
  /// **'Viết vài dòng cho hôm nay…'**
  String get dailyLogNoteHint;

  /// No description provided for @dailyLogClearDay.
  ///
  /// In vi, this message translates to:
  /// **'Xoá ngày này'**
  String get dailyLogClearDay;

  /// No description provided for @dailyLogPreviousDay.
  ///
  /// In vi, this message translates to:
  /// **'Lùi 1 ngày'**
  String get dailyLogPreviousDay;

  /// No description provided for @dailyLogNextDay.
  ///
  /// In vi, this message translates to:
  /// **'Tiến 1 ngày'**
  String get dailyLogNextDay;

  /// No description provided for @dailyLogTodayDate.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay, {date}'**
  String dailyLogTodayDate(String date);

  /// No description provided for @logPeriodHintAutoFilled.
  ///
  /// In vi, this message translates to:
  /// **'Đã tự điền {count} ngày theo độ dài kỳ kinh trung bình. Bỏ chọn nếu kinh kết thúc sớm hơn.'**
  String logPeriodHintAutoFilled(int count);

  /// No description provided for @logPeriodHintUntilToday.
  ///
  /// In vi, this message translates to:
  /// **'Đã đánh dấu tới hôm nay. Các ngày tiếp theo được dự đoán.'**
  String get logPeriodHintUntilToday;

  /// No description provided for @logPeriodHintMerged.
  ///
  /// In vi, this message translates to:
  /// **'Đã nối thành một kỳ kinh.'**
  String get logPeriodHintMerged;

  /// No description provided for @logPeriodHintGapFilled.
  ///
  /// In vi, this message translates to:
  /// **'Đã điền thêm {count} ngày bị bỏ trống ở giữa.'**
  String logPeriodHintGapFilled(int count);

  /// No description provided for @logPeriodHintRemoved.
  ///
  /// In vi, this message translates to:
  /// **'Đã bỏ {count} ngày, gồm cả những ngày tự điền.'**
  String logPeriodHintRemoved(int count);

  /// No description provided for @logPeriodSavedTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu'**
  String get logPeriodSavedTitle;

  /// No description provided for @logPeriodSavedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Lịch kỳ kinh và dự đoán đã được cập nhật.'**
  String get logPeriodSavedMessage;

  /// No description provided for @logPeriodDiscardTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ thay đổi?'**
  String get logPeriodDiscardTitle;

  /// No description provided for @logPeriodDiscardMessage.
  ///
  /// In vi, this message translates to:
  /// **'Những ngày bạn vừa chọn sẽ không được lưu.'**
  String get logPeriodDiscardMessage;

  /// No description provided for @logPeriodKeepEditing.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục sửa'**
  String get logPeriodKeepEditing;

  /// No description provided for @logPeriodDiscard.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ'**
  String get logPeriodDiscard;

  /// No description provided for @logPeriodTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ghi kỳ kinh'**
  String get logPeriodTitle;

  /// No description provided for @logPeriodSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chạm vào những ngày bạn có kinh'**
  String get logPeriodSubtitle;

  /// No description provided for @logPeriodLegendLogged.
  ///
  /// In vi, this message translates to:
  /// **'Đã ghi'**
  String get logPeriodLegendLogged;

  /// No description provided for @logPeriodLegendAutoFilled.
  ///
  /// In vi, this message translates to:
  /// **'Tự điền'**
  String get logPeriodLegendAutoFilled;

  /// No description provided for @logPeriodLegendPredicted.
  ///
  /// In vi, this message translates to:
  /// **'Dự đoán'**
  String get logPeriodLegendPredicted;

  /// Screen-reader label of a calendar day. status is 'logged', 'predicted' or 'none'.
  ///
  /// In vi, this message translates to:
  /// **'Ngày {day} tháng {month}{status, select, logged{, có kinh} midCycle{, ra máu giữa kỳ} predicted{, dự đoán} other{}}'**
  String logPeriodDaySemantics(int day, int month, String status);

  /// No description provided for @phaseMenstrualName.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh nguyệt'**
  String get phaseMenstrualName;

  /// No description provided for @phaseMenstrualShortName.
  ///
  /// In vi, this message translates to:
  /// **'Hành kinh'**
  String get phaseMenstrualShortName;

  /// No description provided for @phaseMenstrualDescription.
  ///
  /// In vi, this message translates to:
  /// **'Chu kỳ mới bắt đầu từ ngày đầu tiên ra máu. Do nồng độ hormone giảm, lớp niêm mạc tử cung dày lên ở chu kỳ trước bong ra và thoát ra ngoài qua âm đạo. Kỳ kinh thường kéo dài 2 – 7 ngày, tổng lượng máu mất khoảng 30 – 80 ml là trong mức bình thường.'**
  String get phaseMenstrualDescription;

  /// No description provided for @phaseMenstrualSymptomNote.
  ///
  /// In vi, this message translates to:
  /// **'Tử cung co bóp để đẩy niêm mạc ra ngoài nên đau bụng, đau lưng là thường gặp, nhất là 1 – 2 ngày đầu. Các triệu chứng sẽ giảm dần khi kỳ kinh kết thúc.'**
  String get phaseMenstrualSymptomNote;

  /// No description provided for @phaseMenstrualTip1Title.
  ///
  /// In vi, this message translates to:
  /// **'Chườm ấm bụng'**
  String get phaseMenstrualTip1Title;

  /// No description provided for @phaseMenstrualTip1Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Giúp cơ tử cung thư giãn, giảm co thắt.'**
  String get phaseMenstrualTip1Subtitle;

  /// No description provided for @phaseMenstrualTip2Title.
  ///
  /// In vi, this message translates to:
  /// **'Bổ sung sắt'**
  String get phaseMenstrualTip2Title;

  /// No description provided for @phaseMenstrualTip2Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Thịt đỏ, rau lá xanh đậm, đậu giúp bù lượng sắt đã mất.'**
  String get phaseMenstrualTip2Subtitle;

  /// No description provided for @phaseMenstrualTip3Title.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ ngơi nhiều hơn'**
  String get phaseMenstrualTip3Title;

  /// No description provided for @phaseMenstrualTip3Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Ưu tiên vận động nhẹ như đi bộ, giãn cơ.'**
  String get phaseMenstrualTip3Subtitle;

  /// No description provided for @phaseFollicularName.
  ///
  /// In vi, this message translates to:
  /// **'Giai đoạn nang trứng'**
  String get phaseFollicularName;

  /// No description provided for @phaseFollicularShortName.
  ///
  /// In vi, this message translates to:
  /// **'Nang trứng'**
  String get phaseFollicularShortName;

  /// No description provided for @phaseFollicularDescription.
  ///
  /// In vi, this message translates to:
  /// **'Hormone FSH kích thích các nang trứng trong buồng trứng phát triển, trong đó một nang trội sẽ tiếp tục trưởng thành. Estrogen tăng dần giúp niêm mạc tử cung dày lên trở lại. Khả năng thụ thai lúc này còn thấp nhưng sẽ tăng khi gần tới cửa sổ thụ thai.'**
  String get phaseFollicularDescription;

  /// No description provided for @phaseFollicularSymptomNote.
  ///
  /// In vi, this message translates to:
  /// **'Estrogen tăng thường giúp bạn tỉnh táo, vui vẻ và tràn đầy năng lượng hơn. Đây là lúc phù hợp để tập luyện cường độ cao hoặc bắt đầu việc mới.'**
  String get phaseFollicularSymptomNote;

  /// No description provided for @phaseFollicularTip1Title.
  ///
  /// In vi, this message translates to:
  /// **'Tập luyện mạnh'**
  String get phaseFollicularTip1Title;

  /// No description provided for @phaseFollicularTip1Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Cơ thể phục hồi tốt, phù hợp cardio và tập tạ.'**
  String get phaseFollicularTip1Subtitle;

  /// No description provided for @phaseFollicularTip2Title.
  ///
  /// In vi, this message translates to:
  /// **'Ăn nhiều rau xanh'**
  String get phaseFollicularTip2Title;

  /// No description provided for @phaseFollicularTip2Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chất xơ hỗ trợ cơ thể chuyển hóa estrogen.'**
  String get phaseFollicularTip2Subtitle;

  /// No description provided for @phaseFertileName.
  ///
  /// In vi, this message translates to:
  /// **'Cửa sổ thụ thai'**
  String get phaseFertileName;

  /// No description provided for @phaseFertileShortName.
  ///
  /// In vi, this message translates to:
  /// **'Dễ thụ thai'**
  String get phaseFertileShortName;

  /// No description provided for @phaseFertileDescription.
  ///
  /// In vi, this message translates to:
  /// **'Estrogen đạt mức cao, dịch nhầy cổ tử cung trở nên trong và dai giúp tinh trùng di chuyển dễ hơn. Tinh trùng có thể sống tới 5 ngày trong cơ thể, vì vậy quan hệ không bảo vệ trong những ngày này có thể dẫn tới mang thai.'**
  String get phaseFertileDescription;

  /// No description provided for @phaseFertileSymptomNote.
  ///
  /// In vi, this message translates to:
  /// **'Dịch nhầy giống lòng trắng trứng là dấu hiệu tự nhiên cho thấy cơ thể sắp rụng trứng. Theo dõi dấu hiệu này giúp xác định cửa sổ thụ thai chính xác hơn.'**
  String get phaseFertileSymptomNote;

  /// No description provided for @phaseFertileTip1Title.
  ///
  /// In vi, this message translates to:
  /// **'Chủ động bảo vệ'**
  String get phaseFertileTip1Title;

  /// No description provided for @phaseFertileTip1Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Dùng biện pháp tránh thai nếu chưa có kế hoạch mang thai.'**
  String get phaseFertileTip1Subtitle;

  /// No description provided for @phaseFertileTip2Title.
  ///
  /// In vi, this message translates to:
  /// **'Đo thân nhiệt buổi sáng'**
  String get phaseFertileTip2Title;

  /// No description provided for @phaseFertileTip2Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Giúp xác nhận ngày rụng trứng sau khi nó xảy ra.'**
  String get phaseFertileTip2Subtitle;

  /// No description provided for @phaseOvulationName.
  ///
  /// In vi, this message translates to:
  /// **'Ngày rụng trứng'**
  String get phaseOvulationName;

  /// No description provided for @phaseOvulationShortName.
  ///
  /// In vi, this message translates to:
  /// **'Rụng trứng'**
  String get phaseOvulationShortName;

  /// No description provided for @phaseOvulationDescription.
  ///
  /// In vi, this message translates to:
  /// **'Đỉnh LH kích hoạt nang trứng trội vỡ ra và phóng thích trứng vào ống dẫn trứng. Trứng chỉ sống khoảng 12 – 24 giờ, nên đây là thời điểm khả năng thụ thai cao nhất trong chu kỳ. Ngày rụng trứng là ước tính và có thể lệch vài ngày.'**
  String get phaseOvulationDescription;

  /// No description provided for @phaseOvulationSymptomNote.
  ///
  /// In vi, this message translates to:
  /// **'Một số người cảm thấy đau nhói nhẹ ở một bên bụng dưới khi trứng rụng. Cơn đau thường chỉ kéo dài vài phút đến vài giờ và là hiện tượng bình thường.'**
  String get phaseOvulationSymptomNote;

  /// No description provided for @phaseOvulationTip1Title.
  ///
  /// In vi, this message translates to:
  /// **'Thời điểm dễ thụ thai nhất'**
  String get phaseOvulationTip1Title;

  /// No description provided for @phaseOvulationTip1Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Hữu ích nếu bạn đang có kế hoạch mang thai.'**
  String get phaseOvulationTip1Subtitle;

  /// No description provided for @phaseOvulationTip2Title.
  ///
  /// In vi, this message translates to:
  /// **'Uống đủ nước'**
  String get phaseOvulationTip2Title;

  /// No description provided for @phaseOvulationTip2Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Giúp giảm đầy hơi và khó chịu quanh ngày rụng trứng.'**
  String get phaseOvulationTip2Subtitle;

  /// No description provided for @phaseLutealName.
  ///
  /// In vi, this message translates to:
  /// **'Giai đoạn hoàng thể'**
  String get phaseLutealName;

  /// No description provided for @phaseLutealShortName.
  ///
  /// In vi, this message translates to:
  /// **'Hoàng thể'**
  String get phaseLutealShortName;

  /// No description provided for @phaseLutealDescription.
  ///
  /// In vi, this message translates to:
  /// **'Sau khi trứng rụng, nang trứng chuyển thành thể vàng và tiết ra progesterone để chuẩn bị niêm mạc tử cung cho trứng làm tổ. Thân nhiệt tăng nhẹ khoảng 0,3 – 0,5°C. Khả năng thụ thai giảm nhanh sau ngày rụng trứng.'**
  String get phaseLutealDescription;

  /// No description provided for @phaseLutealSymptomNote.
  ///
  /// In vi, this message translates to:
  /// **'Progesterone tăng có thể khiến bạn thèm ăn và buồn ngủ hơn. Ăn nhiều bữa nhỏ và ngủ đủ giấc sẽ giúp cơ thể dễ chịu hơn.'**
  String get phaseLutealSymptomNote;

  /// No description provided for @phaseLutealTip1Title.
  ///
  /// In vi, this message translates to:
  /// **'Tập nhẹ nhàng'**
  String get phaseLutealTip1Title;

  /// No description provided for @phaseLutealTip1Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Yoga, đi bộ, bơi phù hợp khi năng lượng giảm dần.'**
  String get phaseLutealTip1Subtitle;

  /// No description provided for @phaseLutealTip2Title.
  ///
  /// In vi, this message translates to:
  /// **'Ăn nhiều bữa nhỏ'**
  String get phaseLutealTip2Title;

  /// No description provided for @phaseLutealTip2Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Giữ đường huyết ổn định, hạn chế thèm đồ ngọt.'**
  String get phaseLutealTip2Subtitle;

  /// No description provided for @phasePmsShortName.
  ///
  /// In vi, this message translates to:
  /// **'Tiền kinh'**
  String get phasePmsShortName;

  /// No description provided for @phasePmsDescription.
  ///
  /// In vi, this message translates to:
  /// **'Nếu trứng không được thụ tinh, thể vàng thoái hóa và nồng độ estrogen, progesterone giảm xuống. Sự sụt giảm này có thể gây ra hội chứng tiền kinh nguyệt (PMS). Kỳ kinh tiếp theo sẽ bắt đầu khi niêm mạc tử cung bong ra.'**
  String get phasePmsDescription;

  /// No description provided for @phasePmsSymptomNote.
  ///
  /// In vi, this message translates to:
  /// **'PMS thường xuất hiện trong khoảng 5 ngày trước kỳ kinh và hết sau khi kỳ kinh bắt đầu. Nếu triệu chứng ảnh hưởng nhiều tới sinh hoạt, hãy trao đổi với bác sĩ.'**
  String get phasePmsSymptomNote;

  /// No description provided for @phasePmsTip1Title.
  ///
  /// In vi, this message translates to:
  /// **'Giảm muối và caffeine'**
  String get phasePmsTip1Title;

  /// No description provided for @phasePmsTip1Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Giúp giảm đầy hơi, căng ngực và cáu gắt.'**
  String get phasePmsTip1Subtitle;

  /// No description provided for @phasePmsTip2Title.
  ///
  /// In vi, this message translates to:
  /// **'Chuẩn bị sẵn'**
  String get phasePmsTip2Title;

  /// No description provided for @phasePmsTip2Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Mang theo băng vệ sinh phòng khi kỳ kinh đến sớm.'**
  String get phasePmsTip2Subtitle;

  /// No description provided for @phaseLateName.
  ///
  /// In vi, this message translates to:
  /// **'Trễ kinh'**
  String get phaseLateName;

  /// No description provided for @phaseLateShortName.
  ///
  /// In vi, this message translates to:
  /// **'Trễ kinh'**
  String get phaseLateShortName;

  /// No description provided for @phaseLateDescription.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh đến muộn hơn dự kiến. Trễ vài ngày khá phổ biến và có thể do căng thẳng, thay đổi giấc ngủ, cân nặng hoặc lịch sinh hoạt. Nếu có quan hệ không bảo vệ, bạn có thể thử thai để yên tâm.'**
  String get phaseLateDescription;

  /// No description provided for @phaseLateSymptomNote.
  ///
  /// In vi, this message translates to:
  /// **'Những triệu chứng này có thể là PMS kéo dài hoặc dấu hiệu sớm của thai kỳ. Nếu trễ kinh trên 1 tuần hoặc lặp lại nhiều tháng, hãy gặp bác sĩ.'**
  String get phaseLateSymptomNote;

  /// No description provided for @phaseLateTip1Title.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra lại lịch'**
  String get phaseLateTip1Title;

  /// No description provided for @phaseLateTip1Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Có thể bạn đã quên ghi ngày bắt đầu kỳ kinh.'**
  String get phaseLateTip1Subtitle;

  /// No description provided for @phaseLateTip2Title.
  ///
  /// In vi, this message translates to:
  /// **'Cân nhắc thử thai'**
  String get phaseLateTip2Title;

  /// No description provided for @phaseLateTip2Subtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nếu có quan hệ không bảo vệ trong chu kỳ này.'**
  String get phaseLateTip2Subtitle;

  /// No description provided for @phaseSymptomCramps.
  ///
  /// In vi, this message translates to:
  /// **'Đau bụng dưới'**
  String get phaseSymptomCramps;

  /// No description provided for @phaseSymptomBackPain.
  ///
  /// In vi, this message translates to:
  /// **'Đau lưng'**
  String get phaseSymptomBackPain;

  /// No description provided for @phaseSymptomFatigue.
  ///
  /// In vi, this message translates to:
  /// **'Mệt mỏi'**
  String get phaseSymptomFatigue;

  /// No description provided for @phaseSymptomHeadache.
  ///
  /// In vi, this message translates to:
  /// **'Đau đầu'**
  String get phaseSymptomHeadache;

  /// No description provided for @phaseSymptomBloating.
  ///
  /// In vi, this message translates to:
  /// **'Đầy hơi'**
  String get phaseSymptomBloating;

  /// No description provided for @phaseSymptomMoodSwings.
  ///
  /// In vi, this message translates to:
  /// **'Tâm trạng thất thường'**
  String get phaseSymptomMoodSwings;

  /// No description provided for @phaseSymptomEnergetic.
  ///
  /// In vi, this message translates to:
  /// **'Nhiều năng lượng'**
  String get phaseSymptomEnergetic;

  /// No description provided for @phaseSymptomGoodMood.
  ///
  /// In vi, this message translates to:
  /// **'Tâm trạng tốt'**
  String get phaseSymptomGoodMood;

  /// No description provided for @phaseSymptomClearSkin.
  ///
  /// In vi, this message translates to:
  /// **'Da sáng hơn'**
  String get phaseSymptomClearSkin;

  /// No description provided for @phaseSymptomFocus.
  ///
  /// In vi, this message translates to:
  /// **'Dễ tập trung'**
  String get phaseSymptomFocus;

  /// No description provided for @phaseSymptomEggWhiteMucus.
  ///
  /// In vi, this message translates to:
  /// **'Dịch nhầy trong, dai'**
  String get phaseSymptomEggWhiteMucus;

  /// No description provided for @phaseSymptomHighLibido.
  ///
  /// In vi, this message translates to:
  /// **'Ham muốn tăng'**
  String get phaseSymptomHighLibido;

  /// No description provided for @phaseSymptomBreastTendernessMild.
  ///
  /// In vi, this message translates to:
  /// **'Căng ngực nhẹ'**
  String get phaseSymptomBreastTendernessMild;

  /// No description provided for @phaseSymptomBreastTenderness.
  ///
  /// In vi, this message translates to:
  /// **'Căng ngực'**
  String get phaseSymptomBreastTenderness;

  /// No description provided for @phaseSymptomOvulationPain.
  ///
  /// In vi, this message translates to:
  /// **'Đau nhẹ một bên bụng'**
  String get phaseSymptomOvulationPain;

  /// No description provided for @phaseSymptomCravings.
  ///
  /// In vi, this message translates to:
  /// **'Thèm ăn'**
  String get phaseSymptomCravings;

  /// No description provided for @phaseSymptomSleepy.
  ///
  /// In vi, this message translates to:
  /// **'Buồn ngủ'**
  String get phaseSymptomSleepy;

  /// No description provided for @phaseSymptomAcne.
  ///
  /// In vi, this message translates to:
  /// **'Nổi mụn'**
  String get phaseSymptomAcne;

  /// No description provided for @phaseSymptomIrritable.
  ///
  /// In vi, this message translates to:
  /// **'Dễ cáu gắt'**
  String get phaseSymptomIrritable;

  /// No description provided for @phaseSymptomNausea.
  ///
  /// In vi, this message translates to:
  /// **'Buồn nôn'**
  String get phaseSymptomNausea;

  /// No description provided for @phaseConceptionLowLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thấp'**
  String get phaseConceptionLowLabel;

  /// No description provided for @phaseConceptionLowMessage.
  ///
  /// In vi, this message translates to:
  /// **'Ngoài cửa sổ thụ thai, khả năng mang thai thấp nhưng không bằng 0 vì ngày rụng trứng có thể thay đổi.'**
  String get phaseConceptionLowMessage;

  /// No description provided for @phaseConceptionMediumLabel.
  ///
  /// In vi, this message translates to:
  /// **'Trung bình'**
  String get phaseConceptionMediumLabel;

  /// No description provided for @phaseConceptionMediumMessage.
  ///
  /// In vi, this message translates to:
  /// **'Ngày này nằm ở rìa cửa sổ thụ thai nên vẫn có khả năng mang thai, dù không cao bằng những ngày sát ngày rụng trứng.'**
  String get phaseConceptionMediumMessage;

  /// No description provided for @phaseConceptionHighLabel.
  ///
  /// In vi, this message translates to:
  /// **'Cao'**
  String get phaseConceptionHighLabel;

  /// No description provided for @phaseConceptionHighMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ còn 1 – 2 ngày tới ngày rụng trứng dự kiến, khả năng thụ thai đang ở mức cao.'**
  String get phaseConceptionHighMessage;

  /// No description provided for @phaseConceptionPeakLabel.
  ///
  /// In vi, this message translates to:
  /// **'Rất cao'**
  String get phaseConceptionPeakLabel;

  /// No description provided for @phaseConceptionPeakMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đây là ngày rụng trứng dự kiến, thời điểm dễ thụ thai nhất trong chu kỳ.'**
  String get phaseConceptionPeakMessage;

  /// No description provided for @phaseConceptionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khả năng thụ thai'**
  String get phaseConceptionTitle;

  /// No description provided for @phaseConceptionChartWindow.
  ///
  /// In vi, this message translates to:
  /// **'Cửa sổ thụ thai'**
  String get phaseConceptionChartWindow;

  /// No description provided for @phaseFooterDisclaimer.
  ///
  /// In vi, this message translates to:
  /// **'Dự đoán dựa trên độ dài chu kỳ trung bình {cycleLength} ngày và chỉ mang tính tham khảo, không thay thế cho chẩn đoán của bác sĩ.'**
  String phaseFooterDisclaimer(int cycleLength);

  /// No description provided for @phaseTopBarDate.
  ///
  /// In vi, this message translates to:
  /// **'{weekday}, {date}'**
  String phaseTopBarDate(String weekday, String date);

  /// No description provided for @phaseTopBarPreview.
  ///
  /// In vi, this message translates to:
  /// **'Xem trước'**
  String get phaseTopBarPreview;

  /// No description provided for @phaseBackToToday.
  ///
  /// In vi, this message translates to:
  /// **'Về hôm nay'**
  String get phaseBackToToday;

  /// No description provided for @phaseHeroStatusMenstrual.
  ///
  /// In vi, this message translates to:
  /// **'Ngày {day}/{periodLength} của kỳ kinh'**
  String phaseHeroStatusMenstrual(int day, int periodLength);

  /// No description provided for @phaseHeroStatusFollicular.
  ///
  /// In vi, this message translates to:
  /// **'Còn {count} ngày tới ngày rụng trứng'**
  String phaseHeroStatusFollicular(int count);

  /// No description provided for @phaseHeroStatusFertile.
  ///
  /// In vi, this message translates to:
  /// **'Còn {count} ngày tới ngày rụng trứng dự kiến'**
  String phaseHeroStatusFertile(int count);

  /// No description provided for @phaseHeroStatusOvulation.
  ///
  /// In vi, this message translates to:
  /// **'Ngày rụng trứng dự kiến'**
  String get phaseHeroStatusOvulation;

  /// No description provided for @phaseHeroStatusLuteal.
  ///
  /// In vi, this message translates to:
  /// **'Còn {count} ngày tới kỳ kinh tiếp theo'**
  String phaseHeroStatusLuteal(int count);

  /// No description provided for @phaseHeroStatusLate.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh đã trễ {count} ngày'**
  String phaseHeroStatusLate(int count);

  /// No description provided for @phaseHeroCycleLength.
  ///
  /// In vi, this message translates to:
  /// **'/ {count} ngày'**
  String phaseHeroCycleLength(int count);

  /// No description provided for @phaseDayLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày {day}'**
  String phaseDayLabel(int day);

  /// No description provided for @phaseTimelineTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hành trình chu kỳ'**
  String get phaseTimelineTitle;

  /// No description provided for @phaseTimelineHint.
  ///
  /// In vi, this message translates to:
  /// **'Chạm để xem ngày khác'**
  String get phaseTimelineHint;

  /// No description provided for @phaseTimelineTodayMark.
  ///
  /// In vi, this message translates to:
  /// **'Nay'**
  String get phaseTimelineTodayMark;

  /// No description provided for @phaseDescriptionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chuyện gì đang diễn ra?'**
  String get phaseDescriptionTitle;

  /// No description provided for @phaseHormonesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hormone'**
  String get phaseHormonesTitle;

  /// No description provided for @phaseHormoneLow.
  ///
  /// In vi, this message translates to:
  /// **'Thấp'**
  String get phaseHormoneLow;

  /// No description provided for @phaseHormoneRising.
  ///
  /// In vi, this message translates to:
  /// **'Đang tăng'**
  String get phaseHormoneRising;

  /// No description provided for @phaseHormoneHigh.
  ///
  /// In vi, this message translates to:
  /// **'Cao'**
  String get phaseHormoneHigh;

  /// No description provided for @phaseHormonePeak.
  ///
  /// In vi, this message translates to:
  /// **'Đạt đỉnh'**
  String get phaseHormonePeak;

  /// No description provided for @phaseHormoneFalling.
  ///
  /// In vi, this message translates to:
  /// **'Đang giảm'**
  String get phaseHormoneFalling;

  /// No description provided for @phaseSymptomsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Có thể bạn sẽ gặp'**
  String get phaseSymptomsTitle;

  /// No description provided for @phaseSymptomsHintToday.
  ///
  /// In vi, this message translates to:
  /// **'Chạm vào triệu chứng bạn đang có để lưu cho hôm nay.'**
  String get phaseSymptomsHintToday;

  /// No description provided for @phaseSymptomsHintPreview.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ có thể ghi nhận triệu chứng cho hôm nay.'**
  String get phaseSymptomsHintPreview;

  /// No description provided for @phaseSymptomsLoggedCount.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu {count} triệu chứng cho hôm nay'**
  String phaseSymptomsLoggedCount(int count);

  /// No description provided for @phaseTipsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chăm sóc bản thân'**
  String get phaseTipsTitle;

  /// No description provided for @emptyCycleTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu chu kỳ'**
  String get emptyCycleTitle;

  /// No description provided for @emptyCycleMessage.
  ///
  /// In vi, this message translates to:
  /// **'Ghi lại kỳ kinh gần nhất để xem dự đoán, giai đoạn chu kỳ và phân tích của riêng bạn.'**
  String get emptyCycleMessage;

  /// No description provided for @emptyCycleAction.
  ///
  /// In vi, this message translates to:
  /// **'Ghi kỳ kinh'**
  String get emptyCycleAction;

  /// No description provided for @homeLogFirstPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Ghi kỳ kinh đầu tiên'**
  String get homeLogFirstPeriod;

  /// No description provided for @homeRingEmptyTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có dữ liệu'**
  String get homeRingEmptyTitle;

  /// No description provided for @homeRingEmptySubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Ghi kỳ kinh để bắt đầu dự đoán'**
  String get homeRingEmptySubtitle;

  /// No description provided for @homeRingLatePrefix.
  ///
  /// In vi, this message translates to:
  /// **'Trễ kinh'**
  String get homeRingLatePrefix;

  /// No description provided for @homeRingLateHint.
  ///
  /// In vi, this message translates to:
  /// **'Ghi lại nếu kinh đã đến'**
  String get homeRingLateHint;

  /// No description provided for @homeRingPeriodPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh'**
  String get homeRingPeriodPrefix;

  /// No description provided for @homeRingDay.
  ///
  /// In vi, this message translates to:
  /// **'Ngày {day}'**
  String homeRingDay(int day);

  /// No description provided for @homeRingPeriodOf.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh thường kéo dài {count} ngày'**
  String homeRingPeriodOf(int count);

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi chiều 🌷'**
  String get homeGreetingAfternoon;

  /// No description provided for @homeGreetingEvening.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi tối 🌙'**
  String get homeGreetingEvening;

  /// No description provided for @onboardingPickDate.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày'**
  String get onboardingPickDate;

  /// No description provided for @onboardingDontRemember.
  ///
  /// In vi, this message translates to:
  /// **'Tôi không nhớ'**
  String get onboardingDontRemember;

  /// No description provided for @onboardingDontRememberHint.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể ghi lại kỳ kinh sau'**
  String get onboardingDontRememberHint;

  /// No description provided for @dailyLogSymptomOther.
  ///
  /// In vi, this message translates to:
  /// **'Triệu chứng khác'**
  String get dailyLogSymptomOther;

  /// No description provided for @dailyLogDayDate.
  ///
  /// In vi, this message translates to:
  /// **'{weekday}, {date}'**
  String dailyLogDayDate(String weekday, String date);

  /// No description provided for @insightSummaryC1P1.
  ///
  /// In vi, this message translates to:
  /// **'Trong {n} chu kỳ gần đây, mọi thứ khá đều đặn — kỳ kinh kéo dài khoảng {avgPeriod} ngày và chu kỳ khoảng {avgCycle} ngày.'**
  String insightSummaryC1P1(int n, int avgPeriod, int avgCycle);

  /// No description provided for @insightSummaryC1P2.
  ///
  /// In vi, this message translates to:
  /// **'Độ dài chu kỳ của bạn giữ ổn định ở khoảng {avgCycle} ngày, còn số ngày hành kinh có thay đổi nhẹ ({periodMin}–{periodMax} ngày).'**
  String insightSummaryC1P2(int avgCycle, int periodMin, int periodMax);

  /// No description provided for @insightSummaryC1P3.
  ///
  /// In vi, this message translates to:
  /// **'Một kỳ kinh gần đây kéo dài {periodValue} ngày, nằm ngoài khoảng thông thường, trong khi chu kỳ vẫn đều ở khoảng {avgCycle} ngày. Nếu điều này lặp lại trong vài chu kỳ tới, hãy nhắc đến khi bạn đi khám lần sau.'**
  String insightSummaryC1P3(int periodValue, int avgCycle);

  /// No description provided for @insightSummaryC1P4.
  ///
  /// In vi, this message translates to:
  /// **'Một kỳ kinh gần đây ({periodDetail}) lệch khá xa khoảng thông thường, dù chu kỳ vẫn ổn định ở khoảng {avgCycle} ngày. Bạn nên trao đổi với bác sĩ về điều này.'**
  String insightSummaryC1P4(String periodDetail, int avgCycle);

  /// No description provided for @insightSummaryC2P1.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh của bạn đều đặn ở khoảng {avgPeriod} ngày, còn độ dài chu kỳ có dao động nhẹ ({cycleMin}–{cycleMax} ngày).'**
  String insightSummaryC2P1(int avgPeriod, int cycleMin, int cycleMax);

  /// No description provided for @insightSummaryC2P2.
  ///
  /// In vi, this message translates to:
  /// **'Gần đây cả độ dài chu kỳ lẫn số ngày hành kinh đều dao động nhẹ. Những thay đổi nhỏ như vậy rất thường gặp.'**
  String get insightSummaryC2P2;

  /// No description provided for @insightSummaryC2P3.
  ///
  /// In vi, this message translates to:
  /// **'Một kỳ kinh gần đây kéo dài {periodValue} ngày, nằm ngoài khoảng thông thường, và độ dài chu kỳ cũng dao động nhẹ ({cycleMin}–{cycleMax} ngày). Nếu tình trạng này tiếp diễn trong vài chu kỳ tới, hãy nhắc đến khi bạn đi khám lần sau.'**
  String insightSummaryC2P3(int periodValue, int cycleMin, int cycleMax);

  /// No description provided for @insightSummaryC2P4.
  ///
  /// In vi, this message translates to:
  /// **'Một kỳ kinh gần đây ({periodDetail}) lệch khá xa khoảng thông thường, và độ dài chu kỳ cũng dao động nhẹ ({cycleMin}–{cycleMax} ngày). Bạn nên trao đổi với bác sĩ về điều này.'**
  String insightSummaryC2P4(String periodDetail, int cycleMin, int cycleMax);

  /// No description provided for @insightSummaryC3P1.
  ///
  /// In vi, this message translates to:
  /// **'Một chu kỳ gần đây dài {cycleValue} ngày, nằm ngoài khoảng thông thường, trong khi kỳ kinh vẫn đều ở khoảng {avgPeriod} ngày. Nếu điều này lặp lại trong vài chu kỳ tới, hãy nhắc đến khi bạn đi khám lần sau.'**
  String insightSummaryC3P1(int cycleValue, int avgPeriod);

  /// No description provided for @insightSummaryC3P2.
  ///
  /// In vi, this message translates to:
  /// **'Một chu kỳ gần đây dài {cycleValue} ngày, nằm ngoài khoảng thông thường, và số ngày hành kinh cũng dao động nhẹ ({periodMin}–{periodMax} ngày). Nếu tình trạng này tiếp diễn trong vài chu kỳ tới, hãy nhắc đến khi bạn đi khám lần sau.'**
  String insightSummaryC3P2(int cycleValue, int periodMin, int periodMax);

  /// No description provided for @insightSummaryC3P3.
  ///
  /// In vi, this message translates to:
  /// **'Gần đây cả độ dài chu kỳ và số ngày hành kinh đều vượt ra ngoài khoảng thông thường. Hãy tiếp tục ghi lại và theo dõi thêm trong 1–2 chu kỳ tới.'**
  String get insightSummaryC3P3;

  /// No description provided for @insightSummaryC3P4.
  ///
  /// In vi, this message translates to:
  /// **'Một kỳ kinh gần đây ({periodDetail}) lệch khá xa khoảng thông thường, và có một chu kỳ cũng nằm ngoài khoảng thường gặp ({cycleValue} ngày). Bạn nên trao đổi với bác sĩ về điều này.'**
  String insightSummaryC3P4(String periodDetail, int cycleValue);

  /// No description provided for @insightSummaryC4P1.
  ///
  /// In vi, this message translates to:
  /// **'Một chu kỳ gần đây ({cycleDetail}) lệch khá xa khoảng thông thường, trong khi kỳ kinh vẫn đều ở khoảng {avgPeriod} ngày. Bạn nên trao đổi với bác sĩ về điều này.'**
  String insightSummaryC4P1(String cycleDetail, int avgPeriod);

  /// No description provided for @insightSummaryC4P2.
  ///
  /// In vi, this message translates to:
  /// **'Một chu kỳ gần đây ({cycleDetail}) lệch khá xa khoảng thông thường, và số ngày hành kinh cũng dao động nhẹ ({periodMin}–{periodMax} ngày). Bạn nên trao đổi với bác sĩ về điều này.'**
  String insightSummaryC4P2(String cycleDetail, int periodMin, int periodMax);

  /// No description provided for @insightSummaryC4P3.
  ///
  /// In vi, this message translates to:
  /// **'Một chu kỳ gần đây ({cycleDetail}) lệch khá xa khoảng thông thường, và có một kỳ kinh cũng nằm ngoài khoảng thường gặp ({periodValue} ngày). Bạn nên trao đổi với bác sĩ về điều này.'**
  String insightSummaryC4P3(String cycleDetail, int periodValue);

  /// No description provided for @insightSummaryC4P4.
  ///
  /// In vi, this message translates to:
  /// **'Gần đây cả độ dài chu kỳ và số ngày hành kinh đều có giá trị lệch xa khoảng thông thường. Bạn nên sớm trao đổi với bác sĩ về tình trạng này.'**
  String get insightSummaryC4P4;

  /// No description provided for @insightSummaryNotEnough.
  ///
  /// In vi, this message translates to:
  /// **'Hãy ghi lại ít nhất 2 chu kỳ để xem độ dài chu kỳ và kỳ kinh của bạn thay đổi thế nào theo thời gian.'**
  String get insightSummaryNotEnough;

  /// No description provided for @insightBadgeAttention.
  ///
  /// In vi, this message translates to:
  /// **'Cần chú ý'**
  String get insightBadgeAttention;

  /// No description provided for @insightTrendEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Biểu đồ sẽ hiện khi bạn có ít nhất một chu kỳ hoàn chỉnh (ghi được hai kỳ kinh liên tiếp).'**
  String get insightTrendEmpty;

  /// No description provided for @insightPatternsEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Ghi triệu chứng trong ít nhất 2 chu kỳ để phát hiện những mẫu lặp lại.'**
  String get insightPatternsEmpty;

  /// No description provided for @insightPatternDuringDay.
  ///
  /// In vi, this message translates to:
  /// **'Ngày {day} của kỳ kinh'**
  String insightPatternDuringDay(int day);

  /// No description provided for @insightPatternCycleDay.
  ///
  /// In vi, this message translates to:
  /// **'Quanh ngày {day} của chu kỳ'**
  String insightPatternCycleDay(int day);

  /// No description provided for @logPeriodHintMidCycle.
  ///
  /// In vi, this message translates to:
  /// **'Ngày này là ngày {cycleDay} của chu kỳ; chu kỳ mới chỉ bắt đầu từ ngày {nextDay} (khi đủ {cycleLength} ngày), nên được ghi là ra máu giữa kỳ.'**
  String logPeriodHintMidCycle(int cycleDay, int nextDay, int cycleLength);

  /// No description provided for @logPeriodHintAbsorbed.
  ///
  /// In vi, this message translates to:
  /// **'Lưu ý: kỳ kinh ngày {date} không còn mở chu kỳ riêng — giờ được tính là ra máu giữa kỳ.'**
  String logPeriodHintAbsorbed(String date);

  /// No description provided for @logPeriodLegendMidCycle.
  ///
  /// In vi, this message translates to:
  /// **'Ra máu giữa kỳ'**
  String get logPeriodLegendMidCycle;

  /// No description provided for @homeRingMidCyclePrefix.
  ///
  /// In vi, this message translates to:
  /// **'Ra máu giữa kỳ'**
  String get homeRingMidCyclePrefix;

  /// No description provided for @homeRingNextPeriodOn.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ tới dự kiến {date}'**
  String homeRingNextPeriodOn(String date);

  /// No description provided for @homeLogPeriodUpdateToday.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật kỳ kinh'**
  String get homeLogPeriodUpdateToday;

  /// No description provided for @homeLegendMidCycle.
  ///
  /// In vi, this message translates to:
  /// **'Ra máu giữa kỳ'**
  String get homeLegendMidCycle;

  /// No description provided for @logPeriodCycleLengthChip.
  ///
  /// In vi, this message translates to:
  /// **'Chu kỳ {count} ngày'**
  String logPeriodCycleLengthChip(int count);

  /// No description provided for @logPeriodCycleLengthTitle.
  ///
  /// In vi, this message translates to:
  /// **'Độ dài chu kỳ'**
  String get logPeriodCycleLengthTitle;

  /// No description provided for @logPeriodCycleLengthHelp.
  ///
  /// In vi, this message translates to:
  /// **'Một ngày có kinh chỉ được tính là ngày 1 của chu kỳ mới khi đã đủ số ngày này kể từ ngày đầu của chu kỳ trước. Trước đó, ngày có kinh được tính là kéo dài kỳ kinh hoặc ra máu giữa kỳ.'**
  String get logPeriodCycleLengthHelp;

  /// No description provided for @cycleHistoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử chu kỳ'**
  String get cycleHistoryTitle;

  /// No description provided for @cycleHistoryLegendTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Cách đọc biểu đồ'**
  String get cycleHistoryLegendTooltip;

  /// No description provided for @cycleHistorySummary.
  ///
  /// In vi, this message translates to:
  /// **'{count} chu kỳ gần nhất · {range} · thường {typical} ngày'**
  String cycleHistorySummary(int count, String range, int typical);

  /// No description provided for @cycleHistorySummaryPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh {range}'**
  String cycleHistorySummaryPeriod(String range);

  /// No description provided for @cycleHistoryDayRange.
  ///
  /// In vi, this message translates to:
  /// **'{min}–{max} ngày'**
  String cycleHistoryDayRange(int min, int max);

  /// No description provided for @cycleHistoryNeedMore.
  ///
  /// In vi, this message translates to:
  /// **'Khi ghi thêm kỳ kinh, bạn sẽ thấy các chu kỳ của mình dài ngắn thế nào so với nhau.'**
  String get cycleHistoryNeedMore;

  /// No description provided for @cycleHistoryUpcoming.
  ///
  /// In vi, this message translates to:
  /// **'Sắp tới (ước tính)'**
  String get cycleHistoryUpcoming;

  /// No description provided for @cycleHistoryRange.
  ///
  /// In vi, this message translates to:
  /// **'{start} – {end}'**
  String cycleHistoryRange(String start, String end);

  /// No description provided for @cycleHistoryRangeNow.
  ///
  /// In vi, this message translates to:
  /// **'{start} – nay'**
  String cycleHistoryRangeNow(String start);

  /// No description provided for @cycleHistoryAround.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng {date}'**
  String cycleHistoryAround(String date);

  /// No description provided for @cycleHistoryCurrentDay.
  ///
  /// In vi, this message translates to:
  /// **'Ngày {day}'**
  String cycleHistoryCurrentDay(int day);

  /// No description provided for @cycleHistoryLate.
  ///
  /// In vi, this message translates to:
  /// **'Trễ {count} ngày'**
  String cycleHistoryLate(int count);

  /// No description provided for @cycleHistoryPredicted.
  ///
  /// In vi, this message translates to:
  /// **'Dự kiến'**
  String get cycleHistoryPredicted;

  /// No description provided for @cycleHistoryPeriodDays.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh {count} ngày'**
  String cycleHistoryPeriodDays(int count);

  /// No description provided for @cycleHistoryPredictedPeriodDays.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh khoảng {count} ngày'**
  String cycleHistoryPredictedPeriodDays(int count);

  /// No description provided for @cycleHistoryMidCycleDays.
  ///
  /// In vi, this message translates to:
  /// **'{count} ngày ra máu giữa kỳ'**
  String cycleHistoryMidCycleDays(int count);

  /// No description provided for @cycleHistoryMissing.
  ///
  /// In vi, this message translates to:
  /// **'Có thể bạn quên ghi một kỳ kinh'**
  String get cycleHistoryMissing;

  /// No description provided for @cycleHistoryMissingDetail.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng cách {count} ngày quá dài để là một chu kỳ, nên không được tính vào thống kê. Nếu bạn có kỳ kinh trong khoảng này, hãy ghi lại.'**
  String cycleHistoryMissingDetail(int count);

  /// No description provided for @cycleHistoryAddPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Thêm kỳ kinh'**
  String get cycleHistoryAddPeriod;

  /// No description provided for @cycleHistoryShowAll.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả ({count})'**
  String cycleHistoryShowAll(int count);

  /// No description provided for @cycleHistoryShowLess.
  ///
  /// In vi, this message translates to:
  /// **'Thu gọn'**
  String get cycleHistoryShowLess;

  /// No description provided for @cycleHistoryDiffLonger.
  ///
  /// In vi, this message translates to:
  /// **'Dài hơn thường lệ {count} ngày'**
  String cycleHistoryDiffLonger(int count);

  /// No description provided for @cycleHistoryDiffShorter.
  ///
  /// In vi, this message translates to:
  /// **'Ngắn hơn thường lệ {count} ngày'**
  String cycleHistoryDiffShorter(int count);

  /// No description provided for @cycleHistoryDiffSame.
  ///
  /// In vi, this message translates to:
  /// **'Bằng độ dài thường lệ'**
  String get cycleHistoryDiffSame;

  /// No description provided for @cycleHistoryOutsideRange.
  ///
  /// In vi, this message translates to:
  /// **'Nằm ngoài khoảng thường gặp (21–38 ngày). Một chu kỳ lệch thỉnh thoảng là bình thường; nếu lặp lại, bạn có thể trao đổi với bác sĩ.'**
  String get cycleHistoryOutsideRange;

  /// No description provided for @cycleHistoryDetailPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh'**
  String get cycleHistoryDetailPeriod;

  /// No description provided for @cycleHistoryDetailExpectedPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh dự kiến'**
  String get cycleHistoryDetailExpectedPeriod;

  /// No description provided for @cycleHistoryDetailOvulation.
  ///
  /// In vi, this message translates to:
  /// **'Rụng trứng ước tính'**
  String get cycleHistoryDetailOvulation;

  /// No description provided for @cycleHistoryNotConfirmed.
  ///
  /// In vi, this message translates to:
  /// **'{date} (chưa được xác nhận)'**
  String cycleHistoryNotConfirmed(String date);

  /// No description provided for @cycleHistoryDetailFertile.
  ///
  /// In vi, this message translates to:
  /// **'Có thể dễ thụ thai'**
  String get cycleHistoryDetailFertile;

  /// No description provided for @cycleHistoryCannotEstimate.
  ///
  /// In vi, this message translates to:
  /// **'Không ước tính được với chu kỳ này'**
  String get cycleHistoryCannotEstimate;

  /// No description provided for @cycleHistoryDetailSymptoms.
  ///
  /// In vi, this message translates to:
  /// **'Triệu chứng đã ghi'**
  String get cycleHistoryDetailSymptoms;

  /// No description provided for @cycleHistoryNoSymptoms.
  ///
  /// In vi, this message translates to:
  /// **'Chưa ghi triệu chứng'**
  String get cycleHistoryNoSymptoms;

  /// No description provided for @cycleHistoryLateDetail.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có kỳ kinh mới sau {count} ngày bạn đặt. Nếu kinh đã đến, hãy ghi lại.'**
  String cycleHistoryLateDetail(int count);

  /// No description provided for @cycleHistoryForecastNote.
  ///
  /// In vi, this message translates to:
  /// **'Dự đoán dựa trên độ dài chu kỳ {count} ngày bạn đặt và có thể lệch vài ngày.'**
  String cycleHistoryForecastNote(int count);

  /// No description provided for @cycleHistoryLegendPeriod.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh đã ghi'**
  String get cycleHistoryLegendPeriod;

  /// No description provided for @cycleHistoryLegendPredicted.
  ///
  /// In vi, this message translates to:
  /// **'Kỳ kinh dự đoán'**
  String get cycleHistoryLegendPredicted;

  /// No description provided for @cycleHistoryLegendMidCycle.
  ///
  /// In vi, this message translates to:
  /// **'Ra máu giữa kỳ'**
  String get cycleHistoryLegendMidCycle;

  /// No description provided for @cycleHistoryLegendFertile.
  ///
  /// In vi, this message translates to:
  /// **'Có thể dễ thụ thai (ước tính)'**
  String get cycleHistoryLegendFertile;

  /// No description provided for @cycleHistoryLegendOvulation.
  ///
  /// In vi, this message translates to:
  /// **'Rụng trứng ước tính'**
  String get cycleHistoryLegendOvulation;

  /// No description provided for @cycleHistoryLegendLate.
  ///
  /// In vi, this message translates to:
  /// **'Ngày trễ kinh'**
  String get cycleHistoryLegendLate;

  /// No description provided for @cycleHistoryLegendTypical.
  ///
  /// In vi, this message translates to:
  /// **'Độ dài thường lệ của bạn'**
  String get cycleHistoryLegendTypical;

  /// No description provided for @cycleHistoryDisclaimer.
  ///
  /// In vi, this message translates to:
  /// **'Ngày rụng trứng và những ngày có thể dễ thụ thai chỉ là ước tính theo lịch, có thể lệch vài ngày và không phải biện pháp tránh thai.'**
  String get cycleHistoryDisclaimer;

  /// No description provided for @cycleHistoryRowSemantics.
  ///
  /// In vi, this message translates to:
  /// **'Chu kỳ {range}. {length}. {details}'**
  String cycleHistoryRowSemantics(String range, String length, String details);

  /// No description provided for @settingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ chỉnh cách app dự đoán chu kỳ của bạn.'**
  String get settingsSubtitle;

  /// No description provided for @settingsCycleSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'CHU KỲ & KỲ KINH'**
  String get settingsCycleSectionTitle;

  /// No description provided for @settingsCycleLengthTitle.
  ///
  /// In vi, this message translates to:
  /// **'Độ dài chu kỳ'**
  String get settingsCycleLengthTitle;

  /// No description provided for @settingsCycleLengthSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Quyết định khi nào một chu kỳ mới bắt đầu'**
  String get settingsCycleLengthSubtitle;

  /// No description provided for @settingsPeriodLengthTitle.
  ///
  /// In vi, this message translates to:
  /// **'Độ dài kỳ kinh'**
  String get settingsPeriodLengthTitle;

  /// No description provided for @settingsPeriodLengthSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Dùng để tự điền và dự đoán; sẽ tự cập nhật khi bạn ghi thêm kỳ kinh'**
  String get settingsPeriodLengthSubtitle;

  /// No description provided for @settingsPeriodLengthHelp.
  ///
  /// In vi, this message translates to:
  /// **'Dùng để tự điền khi ghi kỳ kinh mới và để dự đoán các kỳ kinh sắp tới. Giá trị này sẽ tự cập nhật mỗi khi bạn ghi xong một kỳ kinh mới.'**
  String get settingsPeriodLengthHelp;

  /// No description provided for @logPeriodHintAutoFilledUntilToday.
  ///
  /// In vi, this message translates to:
  /// **'Đã tự điền {count} ngày, đánh dấu tới hôm nay. Các ngày tiếp theo được dự đoán.'**
  String logPeriodHintAutoFilledUntilToday(int count);

  /// No description provided for @logPeriodHintMergedWithFill.
  ///
  /// In vi, this message translates to:
  /// **'Đã điền {count} ngày để nối liền thành một kỳ kinh.'**
  String logPeriodHintMergedWithFill(int count);

  /// No description provided for @logPeriodHintNewCycleAt.
  ///
  /// In vi, this message translates to:
  /// **'{date} là ngày 1 của chu kỳ mới, vì đã đủ {cycleLength} ngày kể từ đầu chu kỳ trước.'**
  String logPeriodHintNewCycleAt(String date, int cycleLength);

  /// No description provided for @logPeriodHintAbsorbedMultiple.
  ///
  /// In vi, this message translates to:
  /// **'Lưu ý: {count} kỳ kinh trước đó không còn mở chu kỳ riêng — giờ được tính là ra máu giữa kỳ.'**
  String logPeriodHintAbsorbedMultiple(int count);

  /// No description provided for @calendarSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chạm vào một ngày để xem chi tiết'**
  String get calendarSubtitle;

  /// No description provided for @calendarLegendTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Chú thích'**
  String get calendarLegendTooltip;

  /// No description provided for @calendarJumpToToday.
  ///
  /// In vi, this message translates to:
  /// **'Về hôm nay'**
  String get calendarJumpToToday;

  /// No description provided for @calendarLegendLogged.
  ///
  /// In vi, this message translates to:
  /// **'Đã ghi nhận'**
  String get calendarLegendLogged;

  /// No description provided for @calendarDetailNoLog.
  ///
  /// In vi, this message translates to:
  /// **'Chưa ghi gì cho ngày này.'**
  String get calendarDetailNoLog;

  /// No description provided for @calendarLogButton.
  ///
  /// In vi, this message translates to:
  /// **'Ghi nhận'**
  String get calendarLogButton;

  /// No description provided for @settingsCycleSectionPreview.
  ///
  /// In vi, this message translates to:
  /// **'Chu kỳ {cycleLength} ngày · Kỳ kinh {periodLength} ngày'**
  String settingsCycleSectionPreview(int cycleLength, int periodLength);

  /// No description provided for @settingsThemeSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get settingsThemeSectionTitle;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In vi, this message translates to:
  /// **'Theo hệ thống'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguageSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get settingsLanguageSectionTitle;

  /// No description provided for @settingsReminderSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở'**
  String get settingsReminderSectionTitle;

  /// No description provided for @settingsReminderSectionPreviewOn.
  ///
  /// In vi, this message translates to:
  /// **'{count, plural, =1{1 nhắc nhở đang bật} other{{count} nhắc nhở đang bật}}'**
  String settingsReminderSectionPreviewOn(int count);

  /// No description provided for @settingsReminderSectionPreviewOff.
  ///
  /// In vi, this message translates to:
  /// **'Chưa bật nhắc nhở nào'**
  String get settingsReminderSectionPreviewOff;

  /// No description provided for @settingsReminderNote.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo sẽ khả dụng ở bản cập nhật sau. Bạn có thể chọn trước lựa chọn của mình ngay bây giờ.'**
  String get settingsReminderNote;

  /// No description provided for @settingsReminderDailyLogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc ghi nhật ký hằng ngày'**
  String get settingsReminderDailyLogTitle;

  /// No description provided for @settingsReminderDailyLogSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc bạn ghi triệu chứng, tâm trạng mỗi ngày'**
  String get settingsReminderDailyLogSubtitle;

  /// No description provided for @settingsReminderPeriodTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc trước kỳ kinh'**
  String get settingsReminderPeriodTitle;

  /// No description provided for @settingsReminderPeriodSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc trước {days} ngày'**
  String settingsReminderPeriodSubtitle(int days);

  /// No description provided for @settingsReminderOvulationTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc ngày rụng trứng'**
  String get settingsReminderOvulationTitle;

  /// No description provided for @settingsReminderOvulationSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc vào ngày rụng trứng ước tính'**
  String get settingsReminderOvulationSubtitle;

  /// No description provided for @settingsReminderDaysBeforeSheetTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc trước bao nhiêu ngày?'**
  String get settingsReminderDaysBeforeSheetTitle;

  /// No description provided for @settingsPrivacySectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quyền riêng tư & Dữ liệu'**
  String get settingsPrivacySectionTitle;

  /// No description provided for @settingsPrivacySectionPreview.
  ///
  /// In vi, this message translates to:
  /// **'Đã ghi {periods} kỳ kinh · {days} ngày nhật ký'**
  String settingsPrivacySectionPreview(int periods, int days);

  /// No description provided for @settingsDataLocalNote.
  ///
  /// In vi, this message translates to:
  /// **'Toàn bộ dữ liệu chỉ được lưu trên máy của bạn, không gửi lên máy chủ nào.'**
  String get settingsDataLocalNote;

  /// No description provided for @settingsClearDataTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá toàn bộ dữ liệu chu kỳ'**
  String get settingsClearDataTitle;

  /// No description provided for @settingsClearDataSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá vĩnh viễn kỳ kinh và nhật ký đã ghi'**
  String get settingsClearDataSubtitle;

  /// No description provided for @settingsClearDataConfirmTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xoá toàn bộ dữ liệu?'**
  String get settingsClearDataConfirmTitle;

  /// No description provided for @settingsClearDataConfirmMessage.
  ///
  /// In vi, this message translates to:
  /// **'Toàn bộ kỳ kinh và nhật ký đã ghi sẽ bị xoá vĩnh viễn. Không thể hoàn tác.'**
  String get settingsClearDataConfirmMessage;

  /// No description provided for @settingsClearDataConfirmAction.
  ///
  /// In vi, this message translates to:
  /// **'Xoá'**
  String get settingsClearDataConfirmAction;

  /// No description provided for @settingsClearDataDone.
  ///
  /// In vi, this message translates to:
  /// **'Đã xoá toàn bộ dữ liệu'**
  String get settingsClearDataDone;

  /// No description provided for @settingsPremiumSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Premium'**
  String get settingsPremiumSectionTitle;

  /// No description provided for @settingsPremiumSectionPreview.
  ///
  /// In vi, this message translates to:
  /// **'Sắp ra mắt'**
  String get settingsPremiumSectionPreview;

  /// No description provided for @settingsPremiumBody.
  ///
  /// In vi, this message translates to:
  /// **'Các tính năng Premium (dự đoán nâng cao, không quảng cáo, sao lưu đám mây...) sẽ sớm ra mắt.'**
  String get settingsPremiumBody;

  /// No description provided for @settingsHelpSectionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Trợ giúp & Thông tin'**
  String get settingsHelpSectionTitle;

  /// No description provided for @settingsHelpSectionPreview.
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi thường gặp, phiên bản ứng dụng'**
  String get settingsHelpSectionPreview;

  /// No description provided for @settingsFaqTitle.
  ///
  /// In vi, this message translates to:
  /// **'Câu hỏi thường gặp'**
  String get settingsFaqTitle;

  /// No description provided for @settingsFaqQ1.
  ///
  /// In vi, this message translates to:
  /// **'App tính ngày rụng trứng như thế nào?'**
  String get settingsFaqQ1;

  /// No description provided for @settingsFaqA1.
  ///
  /// In vi, this message translates to:
  /// **'Ngày rụng trứng được ước tính theo lịch (khoảng 14 ngày trước kỳ kinh tiếp theo), không phải đo lường thực tế nên có thể lệch vài ngày.'**
  String get settingsFaqA1;

  /// No description provided for @settingsFaqQ2.
  ///
  /// In vi, this message translates to:
  /// **'Vì sao ghi thêm ngày ra máu không đổi chu kỳ hiện tại?'**
  String get settingsFaqQ2;

  /// No description provided for @settingsFaqA2.
  ///
  /// In vi, this message translates to:
  /// **'Một chu kỳ mới chỉ bắt đầu khi đã đủ số ngày bạn đặt ở mục Chu kỳ & kỳ kinh. Ra máu trước mốc đó được tính là ra máu giữa kỳ.'**
  String get settingsFaqA2;

  /// No description provided for @settingsFaqQ3.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu của tôi có được lưu ở đâu?'**
  String get settingsFaqQ3;

  /// No description provided for @settingsFaqA3.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ lưu trên máy của bạn. App không gửi dữ liệu lên bất kỳ máy chủ nào.'**
  String get settingsFaqA3;

  /// No description provided for @settingsFaqQ4.
  ///
  /// In vi, this message translates to:
  /// **'Làm sao đổi độ dài chu kỳ mặc định?'**
  String get settingsFaqQ4;

  /// No description provided for @settingsFaqA4.
  ///
  /// In vi, this message translates to:
  /// **'Mở mục Chu kỳ & kỳ kinh ở đầu màn Cài đặt và chọn Độ dài chu kỳ.'**
  String get settingsFaqA4;

  /// No description provided for @settingsMedicalDisclaimerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Miễn trừ trách nhiệm y tế'**
  String get settingsMedicalDisclaimerTitle;

  /// No description provided for @settingsAppVersionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản ứng dụng'**
  String get settingsAppVersionTitle;
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
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
