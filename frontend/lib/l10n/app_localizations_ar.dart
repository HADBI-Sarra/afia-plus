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
  String get whatsappError => 'تعذر فتح واتساب. يرجى التأكد من تثبيت واتساب.';

  @override
  String whatsappMessageDoctor(String doctorName, String date) {
    return 'مرحباً د. $doctorName، لدي سؤال حول موعدي في $date.';
  }
}
