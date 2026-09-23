// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Theo dõi kỳ kinh';

  @override
  String get commonToday => 'Hôm nay';

  @override
  String get commonSave => 'Lưu';

  @override
  String get commonBack => 'Quay lại';

  @override
  String get commonClose => 'Đóng';

  @override
  String get commonContinue => 'Tiếp tục';

  @override
  String get commonCancel => 'Huỷ';

  @override
  String commonDays(int count) {
    return '$count ngày';
  }

  @override
  String commonMonthYear(String month, String year) {
    return 'Tháng $month, $year';
  }

  @override
  String commonDayMonth(String day, String month) {
    return '$day/$month';
  }

  @override
  String get weekdayShortMon => 'T2';

  @override
  String get weekdayShortTue => 'T3';

  @override
  String get weekdayShortWed => 'T4';

  @override
  String get weekdayShortThu => 'T5';

  @override
  String get weekdayShortFri => 'T6';

  @override
  String get weekdayShortSat => 'T7';

  @override
  String get weekdayShortSun => 'CN';

  @override
  String get weekdayLongMon => 'Thứ Hai';

  @override
  String get weekdayLongTue => 'Thứ Ba';

  @override
  String get weekdayLongWed => 'Thứ Tư';

  @override
  String get weekdayLongThu => 'Thứ Năm';

  @override
  String get weekdayLongFri => 'Thứ Sáu';

  @override
  String get weekdayLongSat => 'Thứ Bảy';

  @override
  String get weekdayLongSun => 'Chủ Nhật';

  @override
  String get homeTabHome => 'Trang chủ';

  @override
  String get homeTabCalendar => 'Lịch';

  @override
  String get homeTabInsights => 'Insight';

  @override
  String get homeTabSettings => 'Cài đặt';

  @override
  String get homeLogTodayTooltip => 'Ghi nhận hôm nay';

  @override
  String homeTodayWithWeekdayDate(String weekday, String date) {
    return 'Hôm nay, $weekday, $date';
  }

  @override
  String get homeGreetingMorning => 'Chào buổi sáng 🌸';

  @override
  String get homeOpenCalendarTooltip => 'Mở lịch';

  @override
  String get homeCycleRemainingPrefix => 'Còn';

  @override
  String get homeCycleUntilNextPeriod => 'đến kỳ kinh tiếp theo';

  @override
  String homeCycleExpectedDate(String date) {
    return 'Dự kiến: $date';
  }

  @override
  String get homeEncouragement => 'Bạn đang\nlàm rất tốt!';

  @override
  String get homeLogPeriodLate => 'Kinh đã đến? Ghi ngay';

  @override
  String homeLogPeriodUpdate(int day) {
    return 'Cập nhật kỳ kinh • Ngày $day';
  }

  @override
  String get homeLogPeriodEarly => 'Ra máu? Ghi lại';

  @override
  String get homeLogPeriod => 'Ghi kỳ kinh';

  @override
  String get homeActionCycleAnalysis => 'Phân tích chu kỳ';

  @override
  String get homeActionAddSymptoms => 'Thêm triệu chứng';

  @override
  String get homeSectionDailyLog => 'Ghi nhận';

  @override
  String get homeSectionSymptoms => 'Triệu chứng';

  @override
  String homeCalendarMonthTitle(String month) {
    return 'Lịch tháng $month';
  }

  @override
  String get homeCalendarTodayButton => 'Xem lịch ›';

  @override
  String get homeLegendPeriod => 'Kỳ kinh';

  @override
  String get homeLegendPredicted => 'Dự kiến';

  @override
  String get homeLegendOvulation => 'Rụng trứng';

  @override
  String homeStatusCycleDay(int day) {
    return 'Ngày $day của chu kỳ';
  }

  @override
  String homeStatusAverageCycle(String length) {
    return 'Chu kỳ trung bình: $length';
  }

  @override
  String get homeTipTitle => 'Mẹo hôm nay';

  @override
  String get homeTipBody =>
      'Căng thẳng, thiếu ngủ hay thay đổi cân nặng có thể làm kinh đến muộn vài ngày.';

  @override
  String get homeTipSeeMore => 'Xem thêm';

  @override
  String get insightTitle => 'Phân tích chu kỳ';

  @override
  String get insightSubtitle => 'Theo dõi độ dài chu kỳ & thời gian kỳ kinh.';

  @override
  String get insightTagline => 'Hiểu cơ thể\nyêu chính mình ♥';

  @override
  String get insightBadgeNormal => 'Bình thường';

  @override
  String get insightBadgeIrregular => 'Không đều';

  @override
  String insightStatDays(int count) {
    return '$count Ngày';
  }

  @override
  String get insightAvgPeriod => 'Kỳ kinh trung bình';

  @override
  String get insightAvgCycle => 'Chu kỳ trung bình';

  @override
  String get insightTrendTitle => 'Xu hướng chu kỳ & kỳ kinh';

  @override
  String insightLastCycles(int count) {
    return '$count chu kỳ gần nhất';
  }

  @override
  String get insightLegendCycleLength => 'Độ dài chu kỳ (ngày)';

  @override
  String get insightLegendPeriod => 'Kỳ kinh (ngày)';

  @override
  String get insightCurrentPhaseTitle => 'Phân tích giai đoạn hiện tại';

  @override
  String get insightPatternsTitle => 'Mẫu thường gặp';

  @override
  String insightPatternPmsSubtitle(int days) {
    return '$days ngày trước kỳ kinh';
  }

  @override
  String insightPatternCrampsSubtitle(int startDay, int endDay) {
    return 'Ngày $startDay – $endDay của kỳ kinh';
  }

  @override
  String get insightTipsTitle => 'Gợi ý cho bạn';

  @override
  String get onboardingSkip => 'Bỏ qua';

  @override
  String onboardingStepProgress(int current, int total) {
    return 'Bước $current/$total';
  }

  @override
  String get onboardingStart => 'Bắt đầu dùng app';

  @override
  String get onboardingWelcomeTitle => 'Theo dõi chu kỳ dễ hơn mỗi ngày';

  @override
  String get onboardingWelcomeSubtitle =>
      'App giúp bạn ghi kỳ kinh, triệu chứng và nhắc nhở những việc quan trọng mà không làm mọi thứ trở nên rối.';

  @override
  String get onboardingWelcomePrivacyTitle => 'Riêng tư là mặc định';

  @override
  String get onboardingWelcomePrivacyBody =>
      'Dữ liệu sức khỏe được trình bày rõ ràng, không hiển thị quảng cáo trong luồng onboarding.';

  @override
  String get onboardingGoalTitle => 'Bạn muốn dùng app để làm gì?';

  @override
  String get onboardingGoalSubtitle =>
      'Chọn mục tiêu chính để app ưu tiên nội dung và nhắc nhở phù hợp.';

  @override
  String get onboardingGoalTrackCycle => 'Theo dõi chu kỳ';

  @override
  String get onboardingGoalFertileWindow => 'Canh ngày dễ thụ thai';

  @override
  String get onboardingGoalLogSymptoms => 'Ghi triệu chứng';

  @override
  String get onboardingGoalWaterReminder => 'Nhắc uống nước';

  @override
  String get onboardingLastPeriodTitle => 'Kỳ kinh gần nhất bắt đầu khi nào?';

  @override
  String get onboardingLastPeriodSubtitle =>
      'Thông tin này giúp dự đoán kỳ tới và các giai đoạn trong chu kỳ.';

  @override
  String onboardingDateTileTitle(String weekday, String date) {
    return '$weekday, $date';
  }

  @override
  String get onboardingDateTileSubtitle => 'Ngày bắt đầu kỳ kinh';

  @override
  String get onboardingCycleTitle => 'Thiết lập độ dài chu kỳ';

  @override
  String get onboardingCycleSubtitle =>
      'Nếu chưa chắc chắn, bạn có thể giữ mặc định và chỉnh lại sau trong Cài đặt.';

  @override
  String get onboardingPeriodLengthLabel => 'Số ngày hành kinh';

  @override
  String get onboardingCycleLengthLabel => 'Độ dài chu kỳ';

  @override
  String get onboardingSymptomsTitle => 'Bạn thường muốn ghi nhận gì?';

  @override
  String get onboardingSymptomsSubtitle =>
      'Chọn nhanh các triệu chứng hay gặp. Bạn vẫn có thể thêm hoặc bỏ sau này.';

  @override
  String get onboardingSymptomCramps => 'Đau bụng';

  @override
  String get onboardingSymptomBackPain => 'Đau lưng';

  @override
  String get onboardingSymptomFatigue => 'Mệt mỏi';

  @override
  String get onboardingSymptomHeadache => 'Đau đầu';

  @override
  String get onboardingSymptomMoodSwings => 'Tâm trạng thất thường';

  @override
  String get onboardingSymptomAcne => 'Mụn';

  @override
  String get onboardingReminderTitle => 'Bật nhắc nhở nhẹ nhàng';

  @override
  String get onboardingReminderSubtitle =>
      'App có thể nhắc ghi nhận hằng ngày, kỳ kinh dự kiến và uống nước theo cài đặt của bạn.';

  @override
  String get onboardingDailyReminderTitle => 'Nhắc ghi nhận hằng ngày';

  @override
  String get onboardingDailyReminderSubtitle =>
      'Hôm nay bạn thấy thế nào? Ghi lại chỉ mất 10 giây';

  @override
  String get onboardingReminderInfoTitle => 'Có thể đổi bất cứ lúc nào';

  @override
  String get onboardingReminderInfoBody =>
      'Bạn kiểm soát toàn bộ thông báo trong phần Cài đặt thông báo.';

  @override
  String get splashTagline => 'Theo dõi chu kỳ nhẹ nhàng và riêng tư';

  @override
  String get languageTitle => 'Chọn ngôn ngữ';

  @override
  String get languageSubtitle =>
      'Bạn có thể thay đổi lại trong phần Cài đặt sau.';

  @override
  String get dailyLogFlowSpotting => 'Lấm tấm';

  @override
  String get dailyLogFlowLight => 'Nhẹ';

  @override
  String get dailyLogFlowMedium => 'Vừa';

  @override
  String get dailyLogFlowHeavy => 'Nhiều';

  @override
  String get dailyLogFlowProlonged => 'Rong kinh';

  @override
  String get dailyLogMoodHappy => 'Vui vẻ';

  @override
  String get dailyLogMoodNormal => 'Bình thường';

  @override
  String get dailyLogMoodSad => 'Buồn';

  @override
  String get dailyLogMoodIrritable => 'Cáu gắt';

  @override
  String get dailyLogMoodAnxious => 'Lo lắng';

  @override
  String get dailyLogMoodTired => 'Mệt mỏi';

  @override
  String get dailyLogSymptomCramps => 'Đau bụng';

  @override
  String get dailyLogSymptomBackPain => 'Đau lưng';

  @override
  String get dailyLogSymptomHeadache => 'Đau đầu';

  @override
  String get dailyLogSymptomBloating => 'Đầy hơi';

  @override
  String get dailyLogSymptomBreastTenderness => 'Căng ngực';

  @override
  String get dailyLogSymptomAcne => 'Nổi mụn';

  @override
  String get dailyLogSymptomNausea => 'Buồn nôn';

  @override
  String get dailyLogSymptomCravings => 'Thèm ăn';

  @override
  String get dailyLogSymptomInsomnia => 'Mất ngủ';

  @override
  String get dailyLogSymptomDiarrhea => 'Tiêu chảy';

  @override
  String dailyLogMaxMoods(int count) {
    return 'Chọn tối đa $count tâm trạng.';
  }

  @override
  String get dailyLogAddSymptom => 'Thêm triệu chứng';

  @override
  String get dailyLogSymptomNameHint => 'Tên triệu chứng';

  @override
  String get dailyLogAdd => 'Thêm';

  @override
  String get dailyLogSavedTitle => 'Đã lưu';

  @override
  String dailyLogSavedMessage(String date) {
    return 'Đã lưu ghi nhận ngày $date';
  }

  @override
  String get dailyLogFlow => 'Ra máu';

  @override
  String get dailyLogSpottingNotPeriod => '\"Lấm tấm\" không tính là kỳ kinh.';

  @override
  String get dailyLogMood => 'Tâm trạng';

  @override
  String get dailyLogSymptoms => 'Triệu chứng';

  @override
  String get dailyLogNote => 'Ghi chú';

  @override
  String get dailyLogNoteHint => 'Viết vài dòng cho hôm nay…';

  @override
  String get dailyLogClearDay => 'Xoá ngày này';

  @override
  String get dailyLogPreviousDay => 'Lùi 1 ngày';

  @override
  String get dailyLogNextDay => 'Tiến 1 ngày';

  @override
  String dailyLogTodayDate(String date) {
    return 'Hôm nay, $date';
  }

  @override
  String logPeriodHintAutoFilled(int count) {
    return 'Đã tự điền $count ngày theo độ dài kỳ kinh trung bình. Bỏ chọn nếu kinh kết thúc sớm hơn.';
  }

  @override
  String get logPeriodHintUntilToday =>
      'Đã đánh dấu tới hôm nay. Các ngày tiếp theo được dự đoán.';

  @override
  String get logPeriodHintMerged => 'Đã nối thành một kỳ kinh.';

  @override
  String logPeriodHintGapFilled(int count) {
    return 'Đã điền thêm $count ngày bị bỏ trống ở giữa.';
  }

  @override
  String logPeriodHintRemoved(int count) {
    return 'Đã bỏ $count ngày, gồm cả những ngày tự điền.';
  }

  @override
  String get logPeriodSavedTitle => 'Đã lưu';

  @override
  String get logPeriodSavedMessage =>
      'Lịch kỳ kinh và dự đoán đã được cập nhật.';

  @override
  String get logPeriodDiscardTitle => 'Bỏ thay đổi?';

  @override
  String get logPeriodDiscardMessage =>
      'Những ngày bạn vừa chọn sẽ không được lưu.';

  @override
  String get logPeriodKeepEditing => 'Tiếp tục sửa';

  @override
  String get logPeriodDiscard => 'Bỏ';

  @override
  String get logPeriodTitle => 'Ghi kỳ kinh';

  @override
  String get logPeriodSubtitle => 'Chạm vào những ngày bạn có kinh';

  @override
  String get logPeriodLegendLogged => 'Đã ghi';

  @override
  String get logPeriodLegendAutoFilled => 'Tự điền';

  @override
  String get logPeriodLegendPredicted => 'Dự đoán';

  @override
  String logPeriodDaySemantics(int day, int month, String status) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'logged': ', có kinh',
      'midCycle': ', ra máu giữa kỳ',
      'predicted': ', dự đoán',
      'other': '',
    });
    return 'Ngày $day tháng $month$_temp0';
  }

  @override
  String get phaseMenstrualName => 'Kỳ kinh nguyệt';

  @override
  String get phaseMenstrualShortName => 'Hành kinh';

  @override
  String get phaseMenstrualDescription =>
      'Chu kỳ mới bắt đầu từ ngày đầu tiên ra máu. Do nồng độ hormone giảm, lớp niêm mạc tử cung dày lên ở chu kỳ trước bong ra và thoát ra ngoài qua âm đạo. Kỳ kinh thường kéo dài 2 – 7 ngày, tổng lượng máu mất khoảng 30 – 80 ml là trong mức bình thường.';

  @override
  String get phaseMenstrualSymptomNote =>
      'Tử cung co bóp để đẩy niêm mạc ra ngoài nên đau bụng, đau lưng là thường gặp, nhất là 1 – 2 ngày đầu. Các triệu chứng sẽ giảm dần khi kỳ kinh kết thúc.';

  @override
  String get phaseMenstrualTip1Title => 'Chườm ấm bụng';

  @override
  String get phaseMenstrualTip1Subtitle =>
      'Giúp cơ tử cung thư giãn, giảm co thắt.';

  @override
  String get phaseMenstrualTip2Title => 'Bổ sung sắt';

  @override
  String get phaseMenstrualTip2Subtitle =>
      'Thịt đỏ, rau lá xanh đậm, đậu giúp bù lượng sắt đã mất.';

  @override
  String get phaseMenstrualTip3Title => 'Nghỉ ngơi nhiều hơn';

  @override
  String get phaseMenstrualTip3Subtitle =>
      'Ưu tiên vận động nhẹ như đi bộ, giãn cơ.';

  @override
  String get phaseFollicularName => 'Giai đoạn nang trứng';

  @override
  String get phaseFollicularShortName => 'Nang trứng';

  @override
  String get phaseFollicularDescription =>
      'Hormone FSH kích thích các nang trứng trong buồng trứng phát triển, trong đó một nang trội sẽ tiếp tục trưởng thành. Estrogen tăng dần giúp niêm mạc tử cung dày lên trở lại. Khả năng thụ thai lúc này còn thấp nhưng sẽ tăng khi gần tới cửa sổ thụ thai.';

  @override
  String get phaseFollicularSymptomNote =>
      'Estrogen tăng thường giúp bạn tỉnh táo, vui vẻ và tràn đầy năng lượng hơn. Đây là lúc phù hợp để tập luyện cường độ cao hoặc bắt đầu việc mới.';

  @override
  String get phaseFollicularTip1Title => 'Tập luyện mạnh';

  @override
  String get phaseFollicularTip1Subtitle =>
      'Cơ thể phục hồi tốt, phù hợp cardio và tập tạ.';

  @override
  String get phaseFollicularTip2Title => 'Ăn nhiều rau xanh';

  @override
  String get phaseFollicularTip2Subtitle =>
      'Chất xơ hỗ trợ cơ thể chuyển hóa estrogen.';

  @override
  String get phaseFertileName => 'Cửa sổ thụ thai';

  @override
  String get phaseFertileShortName => 'Dễ thụ thai';

  @override
  String get phaseFertileDescription =>
      'Estrogen đạt mức cao, dịch nhầy cổ tử cung trở nên trong và dai giúp tinh trùng di chuyển dễ hơn. Tinh trùng có thể sống tới 5 ngày trong cơ thể, vì vậy quan hệ không bảo vệ trong những ngày này có thể dẫn tới mang thai.';

  @override
  String get phaseFertileSymptomNote =>
      'Dịch nhầy giống lòng trắng trứng là dấu hiệu tự nhiên cho thấy cơ thể sắp rụng trứng. Theo dõi dấu hiệu này giúp xác định cửa sổ thụ thai chính xác hơn.';

  @override
  String get phaseFertileTip1Title => 'Chủ động bảo vệ';

  @override
  String get phaseFertileTip1Subtitle =>
      'Dùng biện pháp tránh thai nếu chưa có kế hoạch mang thai.';

  @override
  String get phaseFertileTip2Title => 'Đo thân nhiệt buổi sáng';

  @override
  String get phaseFertileTip2Subtitle =>
      'Giúp xác nhận ngày rụng trứng sau khi nó xảy ra.';

  @override
  String get phaseOvulationName => 'Ngày rụng trứng';

  @override
  String get phaseOvulationShortName => 'Rụng trứng';

  @override
  String get phaseOvulationDescription =>
      'Đỉnh LH kích hoạt nang trứng trội vỡ ra và phóng thích trứng vào ống dẫn trứng. Trứng chỉ sống khoảng 12 – 24 giờ, nên đây là thời điểm khả năng thụ thai cao nhất trong chu kỳ. Ngày rụng trứng là ước tính và có thể lệch vài ngày.';

  @override
  String get phaseOvulationSymptomNote =>
      'Một số người cảm thấy đau nhói nhẹ ở một bên bụng dưới khi trứng rụng. Cơn đau thường chỉ kéo dài vài phút đến vài giờ và là hiện tượng bình thường.';

  @override
  String get phaseOvulationTip1Title => 'Thời điểm dễ thụ thai nhất';

  @override
  String get phaseOvulationTip1Subtitle =>
      'Hữu ích nếu bạn đang có kế hoạch mang thai.';

  @override
  String get phaseOvulationTip2Title => 'Uống đủ nước';

  @override
  String get phaseOvulationTip2Subtitle =>
      'Giúp giảm đầy hơi và khó chịu quanh ngày rụng trứng.';

  @override
  String get phaseLutealName => 'Giai đoạn hoàng thể';

  @override
  String get phaseLutealShortName => 'Hoàng thể';

  @override
  String get phaseLutealDescription =>
      'Sau khi trứng rụng, nang trứng chuyển thành thể vàng và tiết ra progesterone để chuẩn bị niêm mạc tử cung cho trứng làm tổ. Thân nhiệt tăng nhẹ khoảng 0,3 – 0,5°C. Khả năng thụ thai giảm nhanh sau ngày rụng trứng.';

  @override
  String get phaseLutealSymptomNote =>
      'Progesterone tăng có thể khiến bạn thèm ăn và buồn ngủ hơn. Ăn nhiều bữa nhỏ và ngủ đủ giấc sẽ giúp cơ thể dễ chịu hơn.';

  @override
  String get phaseLutealTip1Title => 'Tập nhẹ nhàng';

  @override
  String get phaseLutealTip1Subtitle =>
      'Yoga, đi bộ, bơi phù hợp khi năng lượng giảm dần.';

  @override
  String get phaseLutealTip2Title => 'Ăn nhiều bữa nhỏ';

  @override
  String get phaseLutealTip2Subtitle =>
      'Giữ đường huyết ổn định, hạn chế thèm đồ ngọt.';

  @override
  String get phasePmsShortName => 'Tiền kinh';

  @override
  String get phasePmsDescription =>
      'Nếu trứng không được thụ tinh, thể vàng thoái hóa và nồng độ estrogen, progesterone giảm xuống. Sự sụt giảm này có thể gây ra hội chứng tiền kinh nguyệt (PMS). Kỳ kinh tiếp theo sẽ bắt đầu khi niêm mạc tử cung bong ra.';

  @override
  String get phasePmsSymptomNote =>
      'PMS thường xuất hiện trong khoảng 5 ngày trước kỳ kinh và hết sau khi kỳ kinh bắt đầu. Nếu triệu chứng ảnh hưởng nhiều tới sinh hoạt, hãy trao đổi với bác sĩ.';

  @override
  String get phasePmsTip1Title => 'Giảm muối và caffeine';

  @override
  String get phasePmsTip1Subtitle => 'Giúp giảm đầy hơi, căng ngực và cáu gắt.';

  @override
  String get phasePmsTip2Title => 'Chuẩn bị sẵn';

  @override
  String get phasePmsTip2Subtitle =>
      'Mang theo băng vệ sinh phòng khi kỳ kinh đến sớm.';

  @override
  String get phaseLateName => 'Trễ kinh';

  @override
  String get phaseLateShortName => 'Trễ kinh';

  @override
  String get phaseLateDescription =>
      'Kỳ kinh đến muộn hơn dự kiến. Trễ vài ngày khá phổ biến và có thể do căng thẳng, thay đổi giấc ngủ, cân nặng hoặc lịch sinh hoạt. Nếu có quan hệ không bảo vệ, bạn có thể thử thai để yên tâm.';

  @override
  String get phaseLateSymptomNote =>
      'Những triệu chứng này có thể là PMS kéo dài hoặc dấu hiệu sớm của thai kỳ. Nếu trễ kinh trên 1 tuần hoặc lặp lại nhiều tháng, hãy gặp bác sĩ.';

  @override
  String get phaseLateTip1Title => 'Kiểm tra lại lịch';

  @override
  String get phaseLateTip1Subtitle =>
      'Có thể bạn đã quên ghi ngày bắt đầu kỳ kinh.';

  @override
  String get phaseLateTip2Title => 'Cân nhắc thử thai';

  @override
  String get phaseLateTip2Subtitle =>
      'Nếu có quan hệ không bảo vệ trong chu kỳ này.';

  @override
  String get phaseSymptomCramps => 'Đau bụng dưới';

  @override
  String get phaseSymptomBackPain => 'Đau lưng';

  @override
  String get phaseSymptomFatigue => 'Mệt mỏi';

  @override
  String get phaseSymptomHeadache => 'Đau đầu';

  @override
  String get phaseSymptomBloating => 'Đầy hơi';

  @override
  String get phaseSymptomMoodSwings => 'Tâm trạng thất thường';

  @override
  String get phaseSymptomEnergetic => 'Nhiều năng lượng';

  @override
  String get phaseSymptomGoodMood => 'Tâm trạng tốt';

  @override
  String get phaseSymptomClearSkin => 'Da sáng hơn';

  @override
  String get phaseSymptomFocus => 'Dễ tập trung';

  @override
  String get phaseSymptomEggWhiteMucus => 'Dịch nhầy trong, dai';

  @override
  String get phaseSymptomHighLibido => 'Ham muốn tăng';

  @override
  String get phaseSymptomBreastTendernessMild => 'Căng ngực nhẹ';

  @override
  String get phaseSymptomBreastTenderness => 'Căng ngực';

  @override
  String get phaseSymptomOvulationPain => 'Đau nhẹ một bên bụng';

  @override
  String get phaseSymptomCravings => 'Thèm ăn';

  @override
  String get phaseSymptomSleepy => 'Buồn ngủ';

  @override
  String get phaseSymptomAcne => 'Nổi mụn';

  @override
  String get phaseSymptomIrritable => 'Dễ cáu gắt';

  @override
  String get phaseSymptomNausea => 'Buồn nôn';

  @override
  String get phaseConceptionLowLabel => 'Thấp';

  @override
  String get phaseConceptionLowMessage =>
      'Ngoài cửa sổ thụ thai, khả năng mang thai thấp nhưng không bằng 0 vì ngày rụng trứng có thể thay đổi.';

  @override
  String get phaseConceptionMediumLabel => 'Trung bình';

  @override
  String get phaseConceptionMediumMessage =>
      'Ngày này nằm ở rìa cửa sổ thụ thai nên vẫn có khả năng mang thai, dù không cao bằng những ngày sát ngày rụng trứng.';

  @override
  String get phaseConceptionHighLabel => 'Cao';

  @override
  String get phaseConceptionHighMessage =>
      'Chỉ còn 1 – 2 ngày tới ngày rụng trứng dự kiến, khả năng thụ thai đang ở mức cao.';

  @override
  String get phaseConceptionPeakLabel => 'Rất cao';

  @override
  String get phaseConceptionPeakMessage =>
      'Đây là ngày rụng trứng dự kiến, thời điểm dễ thụ thai nhất trong chu kỳ.';

  @override
  String get phaseConceptionTitle => 'Khả năng thụ thai';

  @override
  String get phaseConceptionChartWindow => 'Cửa sổ thụ thai';

  @override
  String phaseFooterDisclaimer(int cycleLength) {
    return 'Dự đoán dựa trên độ dài chu kỳ trung bình $cycleLength ngày và chỉ mang tính tham khảo, không thay thế cho chẩn đoán của bác sĩ.';
  }

  @override
  String phaseTopBarDate(String weekday, String date) {
    return '$weekday, $date';
  }

  @override
  String get phaseTopBarPreview => 'Xem trước';

  @override
  String get phaseBackToToday => 'Về hôm nay';

  @override
  String phaseHeroStatusMenstrual(int day, int periodLength) {
    return 'Ngày $day/$periodLength của kỳ kinh';
  }

  @override
  String phaseHeroStatusFollicular(int count) {
    return 'Còn $count ngày tới ngày rụng trứng';
  }

  @override
  String phaseHeroStatusFertile(int count) {
    return 'Còn $count ngày tới ngày rụng trứng dự kiến';
  }

  @override
  String get phaseHeroStatusOvulation => 'Ngày rụng trứng dự kiến';

  @override
  String phaseHeroStatusLuteal(int count) {
    return 'Còn $count ngày tới kỳ kinh tiếp theo';
  }

  @override
  String phaseHeroStatusLate(int count) {
    return 'Kỳ kinh đã trễ $count ngày';
  }

  @override
  String phaseHeroCycleLength(int count) {
    return '/ $count ngày';
  }

  @override
  String phaseDayLabel(int day) {
    return 'Ngày $day';
  }

  @override
  String get phaseTimelineTitle => 'Hành trình chu kỳ';

  @override
  String get phaseTimelineHint => 'Chạm để xem ngày khác';

  @override
  String get phaseTimelineTodayMark => 'Nay';

  @override
  String get phaseDescriptionTitle => 'Chuyện gì đang diễn ra?';

  @override
  String get phaseHormonesTitle => 'Hormone';

  @override
  String get phaseHormoneLow => 'Thấp';

  @override
  String get phaseHormoneRising => 'Đang tăng';

  @override
  String get phaseHormoneHigh => 'Cao';

  @override
  String get phaseHormonePeak => 'Đạt đỉnh';

  @override
  String get phaseHormoneFalling => 'Đang giảm';

  @override
  String get phaseSymptomsTitle => 'Có thể bạn sẽ gặp';

  @override
  String get phaseSymptomsHintToday =>
      'Chạm vào triệu chứng bạn đang có để lưu cho hôm nay.';

  @override
  String get phaseSymptomsHintPreview =>
      'Chỉ có thể ghi nhận triệu chứng cho hôm nay.';

  @override
  String phaseSymptomsLoggedCount(int count) {
    return 'Đã lưu $count triệu chứng cho hôm nay';
  }

  @override
  String get phaseTipsTitle => 'Chăm sóc bản thân';

  @override
  String get emptyCycleTitle => 'Chưa có dữ liệu chu kỳ';

  @override
  String get emptyCycleMessage =>
      'Ghi lại kỳ kinh gần nhất để xem dự đoán, giai đoạn chu kỳ và phân tích của riêng bạn.';

  @override
  String get emptyCycleAction => 'Ghi kỳ kinh';

  @override
  String get homeLogFirstPeriod => 'Ghi kỳ kinh đầu tiên';

  @override
  String get homeRingEmptyTitle => 'Chưa có dữ liệu';

  @override
  String get homeRingEmptySubtitle => 'Ghi kỳ kinh để bắt đầu dự đoán';

  @override
  String get homeRingLatePrefix => 'Trễ kinh';

  @override
  String get homeRingLateHint => 'Ghi lại nếu kinh đã đến';

  @override
  String get homeRingPeriodPrefix => 'Kỳ kinh';

  @override
  String homeRingDay(int day) {
    return 'Ngày $day';
  }

  @override
  String homeRingPeriodOf(int count) {
    return 'Kỳ kinh thường kéo dài $count ngày';
  }

  @override
  String get homeGreetingAfternoon => 'Chào buổi chiều 🌷';

  @override
  String get homeGreetingEvening => 'Chào buổi tối 🌙';

  @override
  String get onboardingPickDate => 'Chọn ngày';

  @override
  String get onboardingDontRemember => 'Tôi không nhớ';

  @override
  String get onboardingDontRememberHint => 'Bạn có thể ghi lại kỳ kinh sau';

  @override
  String get dailyLogSymptomOther => 'Triệu chứng khác';

  @override
  String dailyLogDayDate(String weekday, String date) {
    return '$weekday, $date';
  }

  @override
  String insightSummaryC1P1(int n, int avgPeriod, int avgCycle) {
    return 'Trong $n chu kỳ gần đây, mọi thứ khá đều đặn — kỳ kinh kéo dài khoảng $avgPeriod ngày và chu kỳ khoảng $avgCycle ngày.';
  }

  @override
  String insightSummaryC1P2(int avgCycle, int periodMin, int periodMax) {
    return 'Độ dài chu kỳ của bạn giữ ổn định ở khoảng $avgCycle ngày, còn số ngày hành kinh có thay đổi nhẹ ($periodMin–$periodMax ngày).';
  }

  @override
  String insightSummaryC1P3(int periodValue, int avgCycle) {
    return 'Một kỳ kinh gần đây kéo dài $periodValue ngày, nằm ngoài khoảng thông thường, trong khi chu kỳ vẫn đều ở khoảng $avgCycle ngày. Nếu điều này lặp lại trong vài chu kỳ tới, hãy nhắc đến khi bạn đi khám lần sau.';
  }

  @override
  String insightSummaryC1P4(String periodDetail, int avgCycle) {
    return 'Một kỳ kinh gần đây ($periodDetail) lệch khá xa khoảng thông thường, dù chu kỳ vẫn ổn định ở khoảng $avgCycle ngày. Bạn nên trao đổi với bác sĩ về điều này.';
  }

  @override
  String insightSummaryC2P1(int avgPeriod, int cycleMin, int cycleMax) {
    return 'Kỳ kinh của bạn đều đặn ở khoảng $avgPeriod ngày, còn độ dài chu kỳ có dao động nhẹ ($cycleMin–$cycleMax ngày).';
  }

  @override
  String get insightSummaryC2P2 =>
      'Gần đây cả độ dài chu kỳ lẫn số ngày hành kinh đều dao động nhẹ. Những thay đổi nhỏ như vậy rất thường gặp.';

  @override
  String insightSummaryC2P3(int periodValue, int cycleMin, int cycleMax) {
    return 'Một kỳ kinh gần đây kéo dài $periodValue ngày, nằm ngoài khoảng thông thường, và độ dài chu kỳ cũng dao động nhẹ ($cycleMin–$cycleMax ngày). Nếu tình trạng này tiếp diễn trong vài chu kỳ tới, hãy nhắc đến khi bạn đi khám lần sau.';
  }

  @override
  String insightSummaryC2P4(String periodDetail, int cycleMin, int cycleMax) {
    return 'Một kỳ kinh gần đây ($periodDetail) lệch khá xa khoảng thông thường, và độ dài chu kỳ cũng dao động nhẹ ($cycleMin–$cycleMax ngày). Bạn nên trao đổi với bác sĩ về điều này.';
  }

  @override
  String insightSummaryC3P1(int cycleValue, int avgPeriod) {
    return 'Một chu kỳ gần đây dài $cycleValue ngày, nằm ngoài khoảng thông thường, trong khi kỳ kinh vẫn đều ở khoảng $avgPeriod ngày. Nếu điều này lặp lại trong vài chu kỳ tới, hãy nhắc đến khi bạn đi khám lần sau.';
  }

  @override
  String insightSummaryC3P2(int cycleValue, int periodMin, int periodMax) {
    return 'Một chu kỳ gần đây dài $cycleValue ngày, nằm ngoài khoảng thông thường, và số ngày hành kinh cũng dao động nhẹ ($periodMin–$periodMax ngày). Nếu tình trạng này tiếp diễn trong vài chu kỳ tới, hãy nhắc đến khi bạn đi khám lần sau.';
  }

  @override
  String get insightSummaryC3P3 =>
      'Gần đây cả độ dài chu kỳ và số ngày hành kinh đều vượt ra ngoài khoảng thông thường. Hãy tiếp tục ghi lại và theo dõi thêm trong 1–2 chu kỳ tới.';

  @override
  String insightSummaryC3P4(String periodDetail, int cycleValue) {
    return 'Một kỳ kinh gần đây ($periodDetail) lệch khá xa khoảng thông thường, và có một chu kỳ cũng nằm ngoài khoảng thường gặp ($cycleValue ngày). Bạn nên trao đổi với bác sĩ về điều này.';
  }

  @override
  String insightSummaryC4P1(String cycleDetail, int avgPeriod) {
    return 'Một chu kỳ gần đây ($cycleDetail) lệch khá xa khoảng thông thường, trong khi kỳ kinh vẫn đều ở khoảng $avgPeriod ngày. Bạn nên trao đổi với bác sĩ về điều này.';
  }

  @override
  String insightSummaryC4P2(String cycleDetail, int periodMin, int periodMax) {
    return 'Một chu kỳ gần đây ($cycleDetail) lệch khá xa khoảng thông thường, và số ngày hành kinh cũng dao động nhẹ ($periodMin–$periodMax ngày). Bạn nên trao đổi với bác sĩ về điều này.';
  }

  @override
  String insightSummaryC4P3(String cycleDetail, int periodValue) {
    return 'Một chu kỳ gần đây ($cycleDetail) lệch khá xa khoảng thông thường, và có một kỳ kinh cũng nằm ngoài khoảng thường gặp ($periodValue ngày). Bạn nên trao đổi với bác sĩ về điều này.';
  }

  @override
  String get insightSummaryC4P4 =>
      'Gần đây cả độ dài chu kỳ và số ngày hành kinh đều có giá trị lệch xa khoảng thông thường. Bạn nên sớm trao đổi với bác sĩ về tình trạng này.';

  @override
  String get insightSummaryNotEnough =>
      'Hãy ghi lại ít nhất 2 chu kỳ để xem độ dài chu kỳ và kỳ kinh của bạn thay đổi thế nào theo thời gian.';

  @override
  String get insightBadgeAttention => 'Cần chú ý';

  @override
  String get insightTrendEmpty =>
      'Biểu đồ sẽ hiện khi bạn có ít nhất một chu kỳ hoàn chỉnh (ghi được hai kỳ kinh liên tiếp).';

  @override
  String get insightPatternsEmpty =>
      'Ghi triệu chứng trong ít nhất 2 chu kỳ để phát hiện những mẫu lặp lại.';

  @override
  String insightPatternDuringDay(int day) {
    return 'Ngày $day của kỳ kinh';
  }

  @override
  String insightPatternCycleDay(int day) {
    return 'Quanh ngày $day của chu kỳ';
  }

  @override
  String logPeriodHintMidCycle(int cycleDay, int nextDay, int cycleLength) {
    return 'Ngày này là ngày $cycleDay của chu kỳ; chu kỳ mới chỉ bắt đầu từ ngày $nextDay (khi đủ $cycleLength ngày), nên được ghi là ra máu giữa kỳ.';
  }

  @override
  String logPeriodHintAbsorbed(String date) {
    return 'Lưu ý: kỳ kinh ngày $date không còn mở chu kỳ riêng — giờ được tính là ra máu giữa kỳ.';
  }

  @override
  String get logPeriodLegendMidCycle => 'Ra máu giữa kỳ';

  @override
  String get homeRingMidCyclePrefix => 'Ra máu giữa kỳ';

  @override
  String homeRingNextPeriodOn(String date) {
    return 'Kỳ tới dự kiến $date';
  }

  @override
  String get homeLogPeriodUpdateToday => 'Cập nhật kỳ kinh';

  @override
  String get homeLegendMidCycle => 'Ra máu giữa kỳ';

  @override
  String logPeriodCycleLengthChip(int count) {
    return 'Chu kỳ $count ngày';
  }

  @override
  String get logPeriodCycleLengthTitle => 'Độ dài chu kỳ';

  @override
  String get logPeriodCycleLengthHelp =>
      'Một ngày có kinh chỉ được tính là ngày 1 của chu kỳ mới khi đã đủ số ngày này kể từ ngày đầu của chu kỳ trước. Trước đó, ngày có kinh được tính là kéo dài kỳ kinh hoặc ra máu giữa kỳ.';

  @override
  String get cycleHistoryTitle => 'Lịch sử chu kỳ';

  @override
  String get cycleHistoryLegendTooltip => 'Cách đọc biểu đồ';

  @override
  String cycleHistorySummary(int count, String range, int typical) {
    return '$count chu kỳ gần nhất · $range · thường $typical ngày';
  }

  @override
  String cycleHistorySummaryPeriod(String range) {
    return 'Kỳ kinh $range';
  }

  @override
  String cycleHistoryDayRange(int min, int max) {
    return '$min–$max ngày';
  }

  @override
  String get cycleHistoryNeedMore =>
      'Khi ghi thêm kỳ kinh, bạn sẽ thấy các chu kỳ của mình dài ngắn thế nào so với nhau.';

  @override
  String get cycleHistoryUpcoming => 'Sắp tới (ước tính)';

  @override
  String cycleHistoryRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String cycleHistoryRangeNow(String start) {
    return '$start – nay';
  }

  @override
  String cycleHistoryAround(String date) {
    return 'Khoảng $date';
  }

  @override
  String cycleHistoryCurrentDay(int day) {
    return 'Ngày $day';
  }

  @override
  String cycleHistoryLate(int count) {
    return 'Trễ $count ngày';
  }

  @override
  String get cycleHistoryPredicted => 'Dự kiến';

  @override
  String cycleHistoryPeriodDays(int count) {
    return 'Kỳ kinh $count ngày';
  }

  @override
  String cycleHistoryPredictedPeriodDays(int count) {
    return 'Kỳ kinh khoảng $count ngày';
  }

  @override
  String cycleHistoryMidCycleDays(int count) {
    return '$count ngày ra máu giữa kỳ';
  }

  @override
  String get cycleHistoryMissing => 'Có thể bạn quên ghi một kỳ kinh';

  @override
  String cycleHistoryMissingDetail(int count) {
    return 'Khoảng cách $count ngày quá dài để là một chu kỳ, nên không được tính vào thống kê. Nếu bạn có kỳ kinh trong khoảng này, hãy ghi lại.';
  }

  @override
  String get cycleHistoryAddPeriod => 'Thêm kỳ kinh';

  @override
  String cycleHistoryShowAll(int count) {
    return 'Xem tất cả ($count)';
  }

  @override
  String get cycleHistoryShowLess => 'Thu gọn';

  @override
  String cycleHistoryDiffLonger(int count) {
    return 'Dài hơn thường lệ $count ngày';
  }

  @override
  String cycleHistoryDiffShorter(int count) {
    return 'Ngắn hơn thường lệ $count ngày';
  }

  @override
  String get cycleHistoryDiffSame => 'Bằng độ dài thường lệ';

  @override
  String get cycleHistoryOutsideRange =>
      'Nằm ngoài khoảng thường gặp (21–38 ngày). Một chu kỳ lệch thỉnh thoảng là bình thường; nếu lặp lại, bạn có thể trao đổi với bác sĩ.';

  @override
  String get cycleHistoryDetailPeriod => 'Kỳ kinh';

  @override
  String get cycleHistoryDetailExpectedPeriod => 'Kỳ kinh dự kiến';

  @override
  String get cycleHistoryDetailOvulation => 'Rụng trứng ước tính';

  @override
  String cycleHistoryNotConfirmed(String date) {
    return '$date (chưa được xác nhận)';
  }

  @override
  String get cycleHistoryDetailFertile => 'Có thể dễ thụ thai';

  @override
  String get cycleHistoryCannotEstimate => 'Không ước tính được với chu kỳ này';

  @override
  String get cycleHistoryDetailSymptoms => 'Triệu chứng đã ghi';

  @override
  String get cycleHistoryNoSymptoms => 'Chưa ghi triệu chứng';

  @override
  String cycleHistoryLateDetail(int count) {
    return 'Chưa có kỳ kinh mới sau $count ngày bạn đặt. Nếu kinh đã đến, hãy ghi lại.';
  }

  @override
  String cycleHistoryForecastNote(int count) {
    return 'Dự đoán dựa trên độ dài chu kỳ $count ngày bạn đặt và có thể lệch vài ngày.';
  }

  @override
  String get cycleHistoryLegendPeriod => 'Kỳ kinh đã ghi';

  @override
  String get cycleHistoryLegendPredicted => 'Kỳ kinh dự đoán';

  @override
  String get cycleHistoryLegendMidCycle => 'Ra máu giữa kỳ';

  @override
  String get cycleHistoryLegendFertile => 'Có thể dễ thụ thai (ước tính)';

  @override
  String get cycleHistoryLegendOvulation => 'Rụng trứng ước tính';

  @override
  String get cycleHistoryLegendLate => 'Ngày trễ kinh';

  @override
  String get cycleHistoryLegendTypical => 'Độ dài thường lệ của bạn';

  @override
  String get cycleHistoryDisclaimer =>
      'Ngày rụng trứng và những ngày có thể dễ thụ thai chỉ là ước tính theo lịch, có thể lệch vài ngày và không phải biện pháp tránh thai.';

  @override
  String cycleHistoryRowSemantics(String range, String length, String details) {
    return 'Chu kỳ $range. $length. $details';
  }

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsSubtitle => 'Tuỳ chỉnh cách app dự đoán chu kỳ của bạn.';

  @override
  String get settingsCycleSectionTitle => 'CHU KỲ & KỲ KINH';

  @override
  String get settingsCycleLengthTitle => 'Độ dài chu kỳ';

  @override
  String get settingsCycleLengthSubtitle =>
      'Quyết định khi nào một chu kỳ mới bắt đầu';

  @override
  String get settingsPeriodLengthTitle => 'Độ dài kỳ kinh';

  @override
  String get settingsPeriodLengthSubtitle =>
      'Dùng để tự điền và dự đoán; sẽ tự cập nhật khi bạn ghi thêm kỳ kinh';

  @override
  String get settingsPeriodLengthHelp =>
      'Dùng để tự điền khi ghi kỳ kinh mới và để dự đoán các kỳ kinh sắp tới. Giá trị này sẽ tự cập nhật mỗi khi bạn ghi xong một kỳ kinh mới.';

  @override
  String logPeriodHintAutoFilledUntilToday(int count) {
    return 'Đã tự điền $count ngày, đánh dấu tới hôm nay. Các ngày tiếp theo được dự đoán.';
  }

  @override
  String logPeriodHintMergedWithFill(int count) {
    return 'Đã điền $count ngày để nối liền thành một kỳ kinh.';
  }

  @override
  String logPeriodHintNewCycleAt(String date, int cycleLength) {
    return '$date là ngày 1 của chu kỳ mới, vì đã đủ $cycleLength ngày kể từ đầu chu kỳ trước.';
  }

  @override
  String logPeriodHintAbsorbedMultiple(int count) {
    return 'Lưu ý: $count kỳ kinh trước đó không còn mở chu kỳ riêng — giờ được tính là ra máu giữa kỳ.';
  }

  @override
  String get calendarSubtitle => 'Chạm vào một ngày để xem chi tiết';

  @override
  String get calendarLegendTooltip => 'Chú thích';

  @override
  String get calendarJumpToToday => 'Về hôm nay';

  @override
  String get calendarLegendLogged => 'Đã ghi nhận';

  @override
  String get calendarDetailNoLog => 'Chưa ghi gì cho ngày này.';

  @override
  String get calendarLogButton => 'Ghi nhận';

  @override
  String settingsCycleSectionPreview(int cycleLength, int periodLength) {
    return 'Chu kỳ $cycleLength ngày · Kỳ kinh $periodLength ngày';
  }

  @override
  String get settingsThemeSectionTitle => 'Giao diện';

  @override
  String get settingsThemeSystem => 'Theo hệ thống';

  @override
  String get settingsThemeLight => 'Sáng';

  @override
  String get settingsThemeDark => 'Tối';

  @override
  String get settingsLanguageSectionTitle => 'Ngôn ngữ';

  @override
  String get settingsReminderSectionTitle => 'Nhắc nhở';

  @override
  String settingsReminderSectionPreviewOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nhắc nhở đang bật',
      one: '1 nhắc nhở đang bật',
    );
    return '$_temp0';
  }

  @override
  String get settingsReminderSectionPreviewOff => 'Chưa bật nhắc nhở nào';

  @override
  String get settingsReminderNote =>
      'Thông báo sẽ khả dụng ở bản cập nhật sau. Bạn có thể chọn trước lựa chọn của mình ngay bây giờ.';

  @override
  String get settingsReminderDailyLogTitle => 'Nhắc ghi nhật ký hằng ngày';

  @override
  String get settingsReminderDailyLogSubtitle =>
      'Nhắc bạn ghi triệu chứng, tâm trạng mỗi ngày';

  @override
  String get settingsReminderPeriodTitle => 'Nhắc trước kỳ kinh';

  @override
  String settingsReminderPeriodSubtitle(int days) {
    return 'Nhắc trước $days ngày';
  }

  @override
  String get settingsReminderOvulationTitle => 'Nhắc ngày rụng trứng';

  @override
  String get settingsReminderOvulationSubtitle =>
      'Nhắc vào ngày rụng trứng ước tính';

  @override
  String get settingsReminderDaysBeforeSheetTitle =>
      'Nhắc trước bao nhiêu ngày?';

  @override
  String get settingsPrivacySectionTitle => 'Quyền riêng tư & Dữ liệu';

  @override
  String settingsPrivacySectionPreview(int periods, int days) {
    return 'Đã ghi $periods kỳ kinh · $days ngày nhật ký';
  }

  @override
  String get settingsDataLocalNote =>
      'Toàn bộ dữ liệu chỉ được lưu trên máy của bạn, không gửi lên máy chủ nào.';

  @override
  String get settingsClearDataTitle => 'Xoá toàn bộ dữ liệu chu kỳ';

  @override
  String get settingsClearDataSubtitle =>
      'Xoá vĩnh viễn kỳ kinh và nhật ký đã ghi';

  @override
  String get settingsClearDataConfirmTitle => 'Xoá toàn bộ dữ liệu?';

  @override
  String get settingsClearDataConfirmMessage =>
      'Toàn bộ kỳ kinh và nhật ký đã ghi sẽ bị xoá vĩnh viễn. Không thể hoàn tác.';

  @override
  String get settingsClearDataConfirmAction => 'Xoá';

  @override
  String get settingsClearDataDone => 'Đã xoá toàn bộ dữ liệu';

  @override
  String get settingsPremiumSectionTitle => 'Premium';

  @override
  String get settingsPremiumSectionPreview => 'Sắp ra mắt';

  @override
  String get settingsPremiumBody =>
      'Các tính năng Premium (dự đoán nâng cao, không quảng cáo, sao lưu đám mây...) sẽ sớm ra mắt.';

  @override
  String get settingsHelpSectionTitle => 'Trợ giúp & Thông tin';

  @override
  String get settingsHelpSectionPreview =>
      'Câu hỏi thường gặp, phiên bản ứng dụng';

  @override
  String get settingsFaqTitle => 'Câu hỏi thường gặp';

  @override
  String get settingsFaqQ1 => 'App tính ngày rụng trứng như thế nào?';

  @override
  String get settingsFaqA1 =>
      'Ngày rụng trứng được ước tính theo lịch (khoảng 14 ngày trước kỳ kinh tiếp theo), không phải đo lường thực tế nên có thể lệch vài ngày.';

  @override
  String get settingsFaqQ2 =>
      'Vì sao ghi thêm ngày ra máu không đổi chu kỳ hiện tại?';

  @override
  String get settingsFaqA2 =>
      'Một chu kỳ mới chỉ bắt đầu khi đã đủ số ngày bạn đặt ở mục Chu kỳ & kỳ kinh. Ra máu trước mốc đó được tính là ra máu giữa kỳ.';

  @override
  String get settingsFaqQ3 => 'Dữ liệu của tôi có được lưu ở đâu?';

  @override
  String get settingsFaqA3 =>
      'Chỉ lưu trên máy của bạn. App không gửi dữ liệu lên bất kỳ máy chủ nào.';

  @override
  String get settingsFaqQ4 => 'Làm sao đổi độ dài chu kỳ mặc định?';

  @override
  String get settingsFaqA4 =>
      'Mở mục Chu kỳ & kỳ kinh ở đầu màn Cài đặt và chọn Độ dài chu kỳ.';

  @override
  String get settingsMedicalDisclaimerTitle => 'Miễn trừ trách nhiệm y tế';

  @override
  String get settingsAppVersionTitle => 'Phiên bản ứng dụng';
}
