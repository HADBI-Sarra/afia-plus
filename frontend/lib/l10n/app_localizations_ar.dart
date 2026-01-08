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
  String get firstName => 'الاسم (بالفرنسية)';

  @override
  String get enterYourFirstName => 'أدخل اسمك الأول';

  @override
  String get lastName => 'اللقب (بالفرنسية)';

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

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get areYouNewHere => 'هل أنت جديد هنا؟ ';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get createAnAccount => 'إنشاء حساب';

  @override
  String get excitedToHaveYouOnBoard => 'نحن سعداء بانضمامك!';

  @override
  String get registerAs => 'التسجيل كـ';

  @override
  String get doctor => 'طبيب';

  @override
  String get patient => 'مريض';

  @override
  String get createPassword => 'إنشاء كلمة مرور';

  @override
  String get strongPassword => 'كلمة مرور قوية';

  @override
  String get min8CharactersLength => 'الحد الأدنى 8 أحرف';

  @override
  String get min1LowercaseLetter => 'الحد الأدنى حرف صغير واحد';

  @override
  String get min1UppercaseLetter => 'الحد الأدنى حرف كبير واحد';

  @override
  String get min1Digit => 'الحد الأدنى رقم واحد';

  @override
  String get min1SpecialCharacter => 'الحد الأدنى حرف خاص واحد';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get repeatPassword => 'أعد إدخال كلمة المرور';

  @override
  String get next => 'التالي';

  @override
  String get alreadyHaveAnAccount => 'هل لديك حساب بالفعل؟ ';

  @override
  String get french => 'الفرنسية';

  @override
  String get dateFormatHint => 'يوم/شهر/سنة';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get phoneNumberExample => 'مثال: 05123456789';

  @override
  String get nationalIdentificationNumber => 'الرقم الوطني للتعريف (NIN)';

  @override
  String get ninExample => 'مثال: 198012345678901234';

  @override
  String get iAgreeToTermsAndConditions => 'أوافق على الشروط والأحكام';

  @override
  String get providePersonalDataDoctor =>
      'قدم بياناتك الشخصية لتقديم الاستشارات عبر الإنترنت بسرعة وأمان.';

  @override
  String get professionalInfo => 'المعلومات المهنية';

  @override
  String get provideProfessionalDetails =>
      'قدم تفاصيلك المهنية لمساعدة المرضى على التعرف على مؤهلاتك وخبرتك.';

  @override
  String get mainSpeciality => 'التخصص الرئيسي';

  @override
  String get speciality => 'التخصص';

  @override
  String get selectYourSpeciality => 'اختر تخصصك';

  @override
  String get noSpecialitiesFound => 'لا توجد تخصصات';

  @override
  String get failedToLoadSpecialities => 'فشل تحميل التخصصات';

  @override
  String get generalInformation => 'المعلومات العامة';

  @override
  String get bioSpecialization => 'السيرة الذاتية / التخصص';

  @override
  String get describeMedicalBackground =>
      'اوصف خلفيتك الطبية وتخصصاتك وفلسفة الرعاية الخاصة بك';

  @override
  String get currentWorkingPlace => 'مكان العمل الحالي';

  @override
  String get nameAddress => 'الاسم / العنوان';

  @override
  String get workingPlaceExample => 'مثال: عيادة النور، حيدرة، الجزائر';

  @override
  String get education => 'التعليم';

  @override
  String get degree => 'الدرجة العلمية';

  @override
  String get degreeExample => 'مثال: دكتور في الطب (MD)';

  @override
  String get university => 'الجامعة';

  @override
  String get universityExample => 'مثال: جامعة الجزائر 1';

  @override
  String get certification => 'الشهادات';

  @override
  String get certificationOptional => 'الشهادة (اختياري)';

  @override
  String get certificationExample => 'مثال: أخصائي في أمراض القلب';

  @override
  String get institutionOptional => 'المؤسسة (اختياري)';

  @override
  String get institutionExample => 'مثال: جامعة وهران 1';

  @override
  String get training => 'التدريب';

  @override
  String get residencyFellowshipOptional =>
      'تفاصيل الإقامة / الزمالة (اختياري)';

  @override
  String get trainingExample =>
      'مثال: إقامة في الطب الباطني، زمالة في أمراض القلب';

  @override
  String get licensure => 'الترخيص';

  @override
  String get licenseNumber => 'رقم الترخيص';

  @override
  String get licenseNumberExample => 'مثال: 12345';

  @override
  String get descriptionOptional => 'الوصف (اختياري)';

  @override
  String get licenseDescriptionExample => 'مثال: مخول لممارسة الطب في الجزائر';

  @override
  String get experience => 'الخبرة';

  @override
  String get yearsOfPractice => 'سنوات الممارسة';

  @override
  String get yearsOfPracticeExample => 'مثال: 16';

  @override
  String get specificAreasOfExpertise => 'مجالات الخبرة المحددة';

  @override
  String get areasOfExpertiseExample =>
      'مثال: تصوير القلب، ارتفاع ضغط الدم، إدارة قصور القلب';

  @override
  String get consultationFees => 'رسوم الاستشارة';

  @override
  String get priceForOneHourConsultation => 'سعر الاستشارة لمدة ساعة واحدة';

  @override
  String get consultationPriceExample => 'مثال: 1000 دج';

  @override
  String get profilePicture => 'صورة الملف الشخصي';

  @override
  String get helpPeopleRecognizeYou =>
      'ساعد الناس على التعرف عليك من خلال صورة شخصية احترافية.';

  @override
  String get helpPatientsRecognizeYou =>
      'ساعد المرضى على التعرف عليك من خلال صورة شخصية احترافية.';

  @override
  String get moreOptions => 'خيارات أخرى';

  @override
  String get uploadFromGallery => 'رفع من المعرض';

  @override
  String get takePhoto => 'التقط صورة';

  @override
  String get skip => 'تخطي';

  @override
  String get addAProfilePicture => 'إضافة صورة ملف شخصي';

  @override
  String get continueButton => 'متابعة';

  @override
  String get changePhoto => 'تغيير الصورة';

  @override
  String errorPickingImage(String error) {
    return 'خطأ في اختيار الصورة: $error';
  }

  @override
  String errorUploadingProfilePicture(String error) {
    return 'خطأ في رفع صورة الملف الشخصي: $error';
  }

  @override
  String get errorEmailEmpty => 'البريد الإلكتروني لا يمكن أن يكون فارغًا';

  @override
  String get errorEmailInvalid => 'أدخل بريدًا إلكترونيًا صالحًا';

  @override
  String get errorPasswordEmpty => 'كلمة المرور لا يمكن أن تكون فارغة';

  @override
  String get errorPasswordShort => 'يجب ألا تقل كلمة المرور عن 8 أحرف';

  @override
  String get errorPasswordWeak => 'كلمة مرور ضعيفة';

  @override
  String get errorPasswordConfirmationEmpty =>
      'تأكيد كلمة المرور لا يمكن أن يكون فارغًا';

  @override
  String get errorPasswordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get errorEmailTaken => 'البريد الإلكتروني مستخدم بالفعل';

  @override
  String get errorFirstNameEmpty => 'الاسم لا يمكن أن يكون فارغًا';

  @override
  String get errorFirstNameInvalid => 'أدخل اسمًا صحيحًا';

  @override
  String get errorLastNameEmpty => 'اللقب لا يمكن أن يكون فارغًا';

  @override
  String get errorLastNameInvalid => 'أدخل لقبًا صحيحًا';

  @override
  String get errorDobEmpty => 'تاريخ الميلاد لا يمكن أن يكون فارغًا';

  @override
  String get errorDobMinor => 'يجب ألا يقل عمرك عن 16 عامًا لإنشاء حساب';

  @override
  String get errorDobFormat => 'تنسيق التاريخ غير صالح (استخدم يوم/شهر/سنة)';

  @override
  String get errorPhoneEmpty => 'رقم الهاتف لا يمكن أن يكون فارغًا';

  @override
  String get errorPhoneInvalid => 'أدخل رقم هاتف صحيح بالصيغة +213XXXXXXXXX';

  @override
  String get errorNinEmpty => 'رقم التعريف الوطني لا يمكن أن يكون فارغًا';

  @override
  String get errorNinInvalid => 'أدخل رقم تعريف وطني صالحًا';

  @override
  String get errorFieldEmpty => 'هذا الحقل مطلوب';

  @override
  String errorMinCharacters(int num) {
    return 'أدخل على الأقل $num أحرف';
  }

  @override
  String get errorSpecialityNotSelected => 'يرجى اختيار التخصص';

  @override
  String get errorLicenceInvalid => 'أدخل رقم ترخيص صالحًا';

  @override
  String get errorYearsInvalid => 'أدخل عدد سنوات صالح';

  @override
  String get errorPriceInvalid => 'أدخل سعرًا صحيحًا بالدينار الجزائري';

  @override
  String get errorTimeout =>
      'انتهت المهلة. يرجى التحقق من الاتصال وحاول مرة أخرى.';

  @override
  String get errorEmailCheckFailed =>
      'فشل في التحقق من البريد الإلكتروني. حاول مجددًا.';

  @override
  String get errorSignupFailed => 'فشل في إنشاء الحساب';

  @override
  String errorOccurred(String error) {
    return 'حدث خطأ: $error';
  }

  @override
  String get doctorNotFound => 'الطبيب غير موجود';

  @override
  String helloPatient(String name) {
    return 'مرحباً $name!';
  }

  @override
  String helloDoctor(String name) {
    return 'مرحباً د. $name!';
  }

  @override
  String doctorsCount(int count) {
    return '$count طبيب';
  }

  @override
  String doctorsForSpeciality(String speciality) {
    return 'الأطباء - $speciality';
  }

  @override
  String get userNotLoggedIn => 'المستخدم غير مسجل الدخول';

  @override
  String get pleaseLogInAsDoctor =>
      'يرجى تسجيل الدخول كطبيب لعرض الشاشة الرئيسية.';

  @override
  String get noUpcomingConsultations => 'لا توجد استشارات قادمة';

  @override
  String get noPendingConsultations => 'لا توجد استشارات معلقة';

  @override
  String get popularSpecializations => 'التخصصات الشائعة';

  @override
  String get allSpecialities => 'جميع التخصصات';

  @override
  String get popularDoctors => 'الأطباء الشائعون';

  @override
  String get services => 'الخدمات';

  @override
  String get appointments => 'المواعيد';

  @override
  String get availability => 'التوفر';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get today => 'اليوم';

  @override
  String get pendingRequests => 'الطلبات المعلقة';

  @override
  String get totalPatients => 'إجمالي المرضى';

  @override
  String appointmentsCount(int count) {
    return '$count موعد';
  }

  @override
  String requestsCount(int count) {
    return '$count طلب';
  }

  @override
  String requestsCountPlural(int count) {
    return '$count طلبات';
  }

  @override
  String patientsCount(int count) {
    return '$count مريض';
  }

  @override
  String get addressNotAvailable => 'العنوان غير متاح';

  @override
  String get whatsappErrorDoctor =>
      'تعذر فتح واتساب. يرجى التأكد من تثبيت واتساب.';

  @override
  String get phoneNumberNotAvailableDoctor => 'رقم الهاتف غير متاح';

  @override
  String get appointmentAcceptedSuccessfully => 'تم قبول الموعد بنجاح';

  @override
  String get appointmentRejectedSuccessfully => 'تم رفض الموعد بنجاح';

  @override
  String get areYouSureRejectAppointment => 'هل أنت متأكد من رفض هذا الموعد؟';

  @override
  String get patientWillBeNotified => 'سيتم إخطار المريض بالرفض.';

  @override
  String get quickOverview => 'نظرة سريعة';

  @override
  String atTime(String date, String time) {
    return '$date في $time';
  }

  @override
  String whatsappMessageDoctorToPatient(String dateTime) {
    return 'مرحباً، أود مناقشة موعدنا في $dateTime.';
  }
}
