// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'عافية بلس';

  @override
  String get upcomingAppointments => 'المواعيد القادمة';

  @override
  String get pastAppointments => 'المواعيد السابقة';

  @override
  String get pendingConsultations => 'الاستشارات المعلقة';

  @override
  String get comingConsultations => 'الاستشارات القادمة';

  @override
  String get prescriptions => 'الوصفات الطبية';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get accept => 'قبول';

  @override
  String get reject => 'رفض';

  @override
  String get uploadPdf => 'رفع ملف PDF';

  @override
  String get pdfUploaded => 'تم رفع الملف';

  @override
  String get viewPrescription => 'عرض الوصفة';

  @override
  String get whatsapp => 'واتساب';

  @override
  String get delete => 'حذف';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get error => 'خطأ';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get noAppointmentsFound => 'لا توجد مواعيد';

  @override
  String get noConsultationsFound => 'لا توجد استشارات';

  @override
  String get noPrescriptionsFound => 'لا توجد وصفات طبية';

  @override
  String get confirmAccept => 'قبول الموعد';

  @override
  String get confirmAcceptMessage => 'هل أنت متأكد من قبول هذا الموعد؟';

  @override
  String get confirmReject => 'رفض الموعد';

  @override
  String get confirmRejectMessage =>
      'هل أنت متأكد من رفض هذا الموعد؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get confirmDelete => 'حذف الموعد';

  @override
  String get confirmDeleteMessage =>
      'هل أنت متأكد من حذف هذا الموعد؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get appointmentAccepted => 'تم قبول الموعد بنجاح';

  @override
  String get appointmentRejected => 'تم رفض الموعد بنجاح';

  @override
  String get appointmentDeleted => 'تم حذف الموعد بنجاح';

  @override
  String get pdfUploadedSuccess => 'تم رفع ملف الوصفة بنجاح';

  @override
  String pdfUploadFailed(String error) {
    return 'فشل رفع الملف: $error';
  }

  @override
  String pdfOpenFailed(String error) {
    return 'فشل فتح الملف: $error';
  }

  @override
  String get downloadingPdf => 'جاري تحميل الوصفة...';

  @override
  String get whatsappNotInstalled =>
      'تعذر فتح واتساب. يرجى التأكد من تثبيت واتساب.';

  @override
  String get phoneNumberNotAvailable => 'رقم الهاتف غير متاح';

  @override
  String get doctorPhoneNumberNotAvailable => 'رقم هاتف الطبيب غير متاح';

  @override
  String get errorLoadingConsultations => 'خطأ في تحميل الاستشارات';

  @override
  String get errorLoadingAppointments => 'خطأ في تحميل المواعيد';

  @override
  String get statusPending => 'معلق';

  @override
  String get statusScheduled => 'مجدول';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get statusCancelled => 'ملغي';

  @override
  String get logIn => 'تسجيل الدخول';

  @override
  String get niceToHaveYouBack => 'مرحباً بعودتك!';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get enterYourEmail => 'أدخل بريدك الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterYourPassword => 'أدخل كلمة المرور';

  @override
  String get personalData => 'البيانات الشخصية';

  @override
  String get providePersonalData =>
      'قدم بياناتك الشخصية لحجز الزيارات ببضع نقرات فقط.';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get enterYourFirstName => 'أدخل اسمك الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get enterYourLastName => 'أدخل اسم العائلة';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get pullToRefresh => 'اسحب للتحديث';

  @override
  String get myPrescriptions => 'وصفاتي';

  @override
  String get myAppointments => 'مواعيدي';

  @override
  String get confirmedAppointments => 'المواعيد المؤكدة';

  @override
  String get notConfirmedAppointments => 'المواعيد غير المؤكدة';

  @override
  String get noPrescriptionAvailable => 'لا توجد وصفة متاحة';

  @override
  String get pdfFileNotFound => 'لم يتم العثور على ملف PDF';

  @override
  String get cancelAppointment => 'إلغاء الموعد';

  @override
  String get keepAppointment => 'الاحتفاظ بالموعد';

  @override
  String get appointmentCancelled => 'تم إلغاء الموعد بنجاح';

  @override
  String get thisActionCannotBeUndone => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get areYouSureCancelAppointment => 'هل أنت متأكد من إلغاء هذا الموعد؟';

  @override
  String get specialist => 'أخصائي';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get french => 'الفرنسية';

  @override
  String get whatsappError => 'تعذر فتح واتساب. يرجى التأكد من تثبيت واتساب.';

  @override
  String whatsappMessageDoctor(String doctorName, String date) {
    return 'مرحباً د. $doctorName، لدي سؤال حول موعدي في $date.';
  }

  @override
  String get doctorProfile => 'ملف الطبيب';

  @override
  String get book => 'حجز';

  @override
  String get about => 'حول';

  @override
  String get reviews => 'التقييمات';

  @override
  String get bookAppointment => 'حجز موعد';

  @override
  String get doctorNotFound => 'الطبيب غير موجود';

  @override
  String get bookingSuccessMessage =>
      'تم الحجز بنجاح ويجب تأكيده من قبل الطبيب.';

  @override
  String get pleaseSelectTime => 'يرجى اختيار وقت لاستشارتك.';

  @override
  String get cannotBookPastDate =>
      'لا يمكنك حجز مواعيد للتواريخ السابقة. يرجى اختيار تاريخ حالي أو مستقبلي.';

  @override
  String get cannotBookPastTime =>
      'لا يمكنك حجز مواعيد للأوقات السابقة. يرجى اختيار وقت مستقبلي.';

  @override
  String get noAvailableSlot =>
      'لم يتم العثور على موعد متاح للتاريخ/الوقت المحدد.';

  @override
  String get mustBeLoggedInAsPatient => 'يجب أن تكون مسجلاً كـ مريض.';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get bookedAppointments => 'المواعيد المحجوزة';

  @override
  String get myPatients => 'مرضاي';

  @override
  String get availability => 'التوفر';

  @override
  String get notificationSettings => 'إعدادات الإشعارات';

  @override
  String get policies => 'السياسات';

  @override
  String get changeEmail => 'تغيير البريد الإلكتروني';

  @override
  String get securitySettings => 'إعدادات الأمان';

  @override
  String get aboutMe => 'نبذة عني';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmation => 'هل أنت متأكد من أنك تريد تسجيل الخروج؟';

  @override
  String get specialtyNotSet => 'التخصص غير محدد';

  @override
  String get loadingSpecialty => 'جاري تحميل التخصص...';

  @override
  String get favoriteDoctors => 'الأطباء المفضلون';

  @override
  String get dobNotSet => 'تاريخ الميلاد غير محدد';

  @override
  String get patientProfile => 'ملف المريض';

  @override
  String get phone => 'الهاتف';

  @override
  String get address => 'العنوان';

  @override
  String get healthInfo => 'المعلومات الصحية';

  @override
  String get sendMessage => 'إرسال رسالة';

  @override
  String get generalInformation => 'المعلومات العامة';

  @override
  String get currentWorkingPlace => 'مكان العمل الحالي';

  @override
  String get education => 'التعليم';

  @override
  String get certification => 'الشهادات';

  @override
  String get training => 'التدريب';

  @override
  String get licensure => 'الترخيص';

  @override
  String get experience => 'الخبرة';

  @override
  String get notSpecified => 'غير محدد';

  @override
  String get licenseNumber => 'رقم الترخيص:';

  @override
  String get over => 'أكثر من';

  @override
  String get year => 'سنة';

  @override
  String get years => 'سنوات';

  @override
  String get ofExperience => 'من الخبرة';

  @override
  String get specializingIn => 'متخصص في';

  @override
  String get price => 'السعر';

  @override
  String get oneHourConsultation => 'استشارة لمدة ساعة واحدة';

  @override
  String get selectTime => 'اختر الوقت';

  @override
  String get noAvailableTimesForDay => 'لا توجد أوقات متاحة لهذا اليوم';

  @override
  String get noUpcomingAvailability =>
      'لا يوجد توفر قادم. هذا الطبيب ليس لديه أوقات متاحة للحجز.';

  @override
  String get noAvailability => 'لا يوجد توفر';

  @override
  String get review => 'تقييم';

  @override
  String get reviewsPlural => 'تقييمات';

  @override
  String get leaveReview => 'اترك تقييماً';

  @override
  String get noReviewsYet => 'لا توجد تقييمات بعد. كن أول من يقيم!';

  @override
  String get anonymous => 'مجهول';

  @override
  String get selectAvailableHours => 'اختر الساعات المتاحة';

  @override
  String get addTimes => 'إضافة أوقات';

  @override
  String get deleteSlot => 'حذف الفترة؟';

  @override
  String get deleteSlotMessage => 'هل أنت متأكد من حذف هذه الفترة الزمنية؟';

  @override
  String availableSlotsFor(String date) {
    return 'الفترات المتاحة لـ $date';
  }

  @override
  String get noTimesForDay =>
      'لا توجد أوقات لهذا اليوم. أضف بعضها باستخدام + .';

  @override
  String get cannotSetPastAvailability => 'لا يمكنك تحديد التوفر في الماضي.';

  @override
  String get selectFutureDateAvailability =>
      'اختر اليوم أو تاريخًا مستقبليًا لإضافة التوفر.';
}
