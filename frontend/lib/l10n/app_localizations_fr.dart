// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => '3afiaPlus';

  @override
  String get upcomingAppointments => 'Rendez-vous à venir';

  @override
  String get pastAppointments => 'Rendez-vous passés';

  @override
  String get pendingConsultations => 'Consultations en attente';

  @override
  String get comingConsultations => 'Consultations à venir';

  @override
  String get prescriptions => 'Ordonnances';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get accept => 'Accepter';

  @override
  String get reject => 'Rejeter';

  @override
  String get uploadPdf => 'Téléverser PDF';

  @override
  String get pdfUploaded => 'PDF téléversé';

  @override
  String get viewPrescription => 'Voir l\'ordonnance';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get delete => 'Supprimer';

  @override
  String get retry => 'Réessayer';

  @override
  String get error => 'Erreur';

  @override
  String get loading => 'Chargement...';

  @override
  String get noAppointmentsFound => 'Aucun rendez-vous trouvé';

  @override
  String get noConsultationsFound => 'Aucune consultation trouvée';

  @override
  String get noPrescriptionsFound => 'Aucune ordonnance trouvée';

  @override
  String get confirmAccept => 'Accepter le rendez-vous';

  @override
  String get confirmAcceptMessage =>
      'Êtes-vous sûr de vouloir accepter ce rendez-vous ?';

  @override
  String get confirmReject => 'Rejeter le rendez-vous';

  @override
  String get confirmRejectMessage =>
      'Êtes-vous sûr de vouloir rejeter ce rendez-vous ? Cette action est irréversible.';

  @override
  String get confirmDelete => 'Supprimer le rendez-vous';

  @override
  String get confirmDeleteMessage =>
      'Êtes-vous sûr de vouloir supprimer ce rendez-vous ? Cette action est irréversible.';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get appointmentAccepted => 'Rendez-vous accepté avec succès';

  @override
  String get appointmentRejected => 'Rendez-vous rejeté avec succès';

  @override
  String get appointmentDeleted => 'Rendez-vous supprimé avec succès';

  @override
  String get pdfUploadedSuccess => 'Ordonnance PDF téléversée avec succès';

  @override
  String pdfUploadFailed(String error) {
    return 'Échec du téléversement du PDF : $error';
  }

  @override
  String pdfOpenFailed(String error) {
    return 'Échec de l\'ouverture du PDF : $error';
  }

  @override
  String get whatsappNotInstalled =>
      'Impossible d\'ouvrir WhatsApp. Veuillez vous assurer que WhatsApp est installé.';

  @override
  String get phoneNumberNotAvailable => 'Numéro de téléphone non disponible';

  @override
  String get doctorPhoneNumberNotAvailable =>
      'Numéro du médecin non disponible';

  @override
  String get errorLoadingConsultations =>
      'Erreur lors du chargement des consultations';

  @override
  String get errorLoadingAppointments =>
      'Erreur lors du chargement des rendez-vous';

  @override
  String get statusPending => 'En attente';

  @override
  String get statusScheduled => 'Planifié';

  @override
  String get statusCompleted => 'Terminé';

  @override
  String get statusCancelled => 'Annulé';

  @override
  String get logIn => 'Connexion';

  @override
  String get niceToHaveYouBack => 'Content de vous revoir !';

  @override
  String get email => 'E-mail';

  @override
  String get enterYourEmail => 'Entrez votre e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get enterYourPassword => 'Entrez votre mot de passe';

  @override
  String get personalData => 'Données personnelles';

  @override
  String get providePersonalData =>
      'Fournissez vos données personnelles pour réserver en quelques clics.';

  @override
  String get firstName => 'Prénom';

  @override
  String get enterYourFirstName => 'Entrez votre prénom';

  @override
  String get lastName => 'Nom';

  @override
  String get enterYourLastName => 'Entrez votre nom';

  @override
  String get dateOfBirth => 'Date de naissance';

  @override
  String get pullToRefresh => 'Tirez pour actualiser';

  @override
  String get myPrescriptions => 'Mes ordonnances';

  @override
  String get myAppointments => 'Mes rendez-vous';

  @override
  String get confirmedAppointments => 'Rendez-vous confirmés';

  @override
  String get notConfirmedAppointments => 'Rendez-vous non confirmés';

  @override
  String get noPrescriptionAvailable => 'Aucune ordonnance disponible';

  @override
  String get pdfFileNotFound => 'Fichier PDF non trouvé';

  @override
  String get cancelAppointment => 'Annuler le rendez-vous';

  @override
  String get keepAppointment => 'Conserver le rendez-vous';

  @override
  String get appointmentCancelled => 'Rendez-vous annulé avec succès';

  @override
  String get thisActionCannotBeUndone => 'Cette action est irréversible.';

  @override
  String get areYouSureCancelAppointment =>
      'Êtes-vous sûr de vouloir annuler ce rendez-vous ?';

  @override
  String get specialist => 'Spécialiste';

  @override
  String get english => 'Anglais';

  @override
  String get arabic => 'Arabe';

  @override
  String get whatsappError =>
      'Impossible d\'ouvrir WhatsApp. Veuillez vous assurer que WhatsApp est installé.';

  @override
  String whatsappMessageDoctor(String doctorName, String date) {
    return 'Bonjour Dr. $doctorName, j\'ai une question concernant mon rendez-vous du $date.';
  }

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get areYouNewHere => 'Vous êtes nouveau ici ? ';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get createAnAccount => 'Créer un compte';

  @override
  String get excitedToHaveYouOnBoard => 'Ravi de vous accueillir !';

  @override
  String get registerAs => 'S\'inscrire en tant que';

  @override
  String get doctor => 'Médecin';

  @override
  String get patient => 'Patient';

  @override
  String get createPassword => 'Créer un mot de passe';

  @override
  String get strongPassword => 'Mot de passe fort';

  @override
  String get min8CharactersLength => 'Min 8 caractères';

  @override
  String get min1LowercaseLetter => 'Min 1 lettre minuscule';

  @override
  String get min1UppercaseLetter => 'Min 1 lettre majuscule';

  @override
  String get min1Digit => 'Min 1 chiffre';

  @override
  String get min1SpecialCharacter => 'Min 1 caractère spécial';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get repeatPassword => 'Répéter le mot de passe';

  @override
  String get next => 'Suivant';

  @override
  String get alreadyHaveAnAccount => 'Vous avez déjà un compte ? ';

  @override
  String get french => 'Français';

  @override
  String get dateFormatHint => 'JJ/MM/AAAA';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get phoneNumberExample => 'ex. 05123 45 67 89';

  @override
  String get nationalIdentificationNumber =>
      'Numéro d\'identification national (NIN)';

  @override
  String get ninExample => 'ex. 198012345678901234';

  @override
  String get iAgreeToTermsAndConditions =>
      'J\'accepte les conditions générales';

  @override
  String get providePersonalDataDoctor =>
      'Fournissez vos données personnelles pour offrir des consultations en ligne rapidement et en toute sécurité.';

  @override
  String get professionalInfo => 'Informations professionnelles';

  @override
  String get provideProfessionalDetails =>
      'Fournissez vos détails professionnels pour aider les patients à en apprendre davantage sur vos qualifications et votre expertise.';

  @override
  String get mainSpeciality => 'Spécialité principale';

  @override
  String get speciality => 'Spécialité';

  @override
  String get selectYourSpeciality => 'Sélectionnez votre spécialité';

  @override
  String get noSpecialitiesFound => 'Aucune spécialité trouvée';

  @override
  String get failedToLoadSpecialities => 'Échec du chargement des spécialités';

  @override
  String get generalInformation => 'Informations générales';

  @override
  String get bioSpecialization => 'Bio / Spécialisation';

  @override
  String get describeMedicalBackground =>
      'Décrivez votre parcours médical, vos spécialités et votre philosophie de soins';

  @override
  String get currentWorkingPlace => 'Lieu de travail actuel';

  @override
  String get nameAddress => 'Nom / Adresse';

  @override
  String get workingPlaceExample => 'ex. Clinique Nour, Hydra, Alger';

  @override
  String get education => 'Formation';

  @override
  String get degree => 'Diplôme';

  @override
  String get degreeExample => 'ex. Docteur en médecine (MD)';

  @override
  String get university => 'Université';

  @override
  String get universityExample => 'ex. Université d\'Alger 1';

  @override
  String get certification => 'Certification';

  @override
  String get certificationOptional => 'Certification (Optionnel)';

  @override
  String get certificationExample => 'ex. Spécialiste en cardiologie';

  @override
  String get institutionOptional => 'Institution (Optionnel)';

  @override
  String get institutionExample => 'ex. Université d\'Oran 1';

  @override
  String get training => 'Formation';

  @override
  String get residencyFellowshipOptional =>
      'Détails de résidence / fellowship (Optionnel)';

  @override
  String get trainingExample =>
      'ex. Résidence en médecine interne, Fellowship en cardiologie';

  @override
  String get licensure => 'Autorisation d\'exercer';

  @override
  String get licenseNumber => 'Numéro de licence';

  @override
  String get licenseNumberExample => 'ex. 12345';

  @override
  String get descriptionOptional => 'Description (Optionnel)';

  @override
  String get licenseDescriptionExample =>
      'ex. Autorisé à exercer la médecine en Algérie';

  @override
  String get experience => 'Expérience';

  @override
  String get yearsOfPractice => 'Années de pratique';

  @override
  String get yearsOfPracticeExample => 'ex. 16';

  @override
  String get specificAreasOfExpertise => 'Domaines d\'expertise spécifiques';

  @override
  String get areasOfExpertiseExample =>
      'ex. Imagerie cardiaque, hypertension, prise en charge de l\'insuffisance cardiaque';

  @override
  String get consultationFees => 'Frais de consultation';

  @override
  String get priceForOneHourConsultation =>
      'Prix pour une consultation d\'1 heure';

  @override
  String get consultationPriceExample => 'ex. 1000 DA';

  @override
  String get profilePicture => 'Photo de profil';

  @override
  String get helpPeopleRecognizeYou =>
      'Aidez les gens à vous reconnaître avec une photo professionnelle.';

  @override
  String get helpPatientsRecognizeYou =>
      'Aidez les patients à vous reconnaître avec une photo professionnelle.';

  @override
  String get moreOptions => 'Plus d\'options';

  @override
  String get uploadFromGallery => 'Téléverser depuis la galerie';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get skip => 'Passer';

  @override
  String get addAProfilePicture => 'Ajouter une photo de profil';

  @override
  String get continueButton => 'Continuer';

  @override
  String get changePhoto => 'Changer la photo';

  @override
  String errorPickingImage(String error) {
    return 'Erreur lors de la sélection de l\'image : $error';
  }

  @override
  String errorUploadingProfilePicture(String error) {
    return 'Erreur lors du téléversement de la photo de profil : $error';
  }

  @override
  String get errorEmailEmpty => 'L\'e-mail ne peut pas être vide';

  @override
  String get errorEmailInvalid => 'Saisissez un e-mail valide';

  @override
  String get errorPasswordEmpty => 'Le mot de passe ne peut pas être vide';

  @override
  String get errorPasswordShort =>
      'Le mot de passe doit comporter au moins 8 caractères';

  @override
  String get errorPasswordWeak => 'Mot de passe faible';

  @override
  String get errorPasswordConfirmationEmpty =>
      'La confirmation du mot de passe ne peut pas être vide';

  @override
  String get errorPasswordsDoNotMatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get errorEmailTaken => 'Cet e-mail est déjà utilisé';

  @override
  String get errorFirstNameEmpty => 'Le prénom ne peut pas être vide';

  @override
  String get errorFirstNameInvalid => 'Saisissez un prénom valide';

  @override
  String get errorLastNameEmpty => 'Le nom ne peut pas être vide';

  @override
  String get errorLastNameInvalid => 'Saisissez un nom valide';

  @override
  String get errorDobEmpty => 'La date de naissance ne peut pas être vide';

  @override
  String get errorDobMinor =>
      'Vous devez avoir au moins 16 ans pour créer un compte';

  @override
  String get errorDobFormat => 'Format de date invalide (utilisez JJ/MM/AAAA)';

  @override
  String get errorPhoneEmpty => 'Le numéro de téléphone ne peut pas être vide';

  @override
  String get errorPhoneInvalid =>
      'Saisissez un numéro de téléphone valide au format +213XXXXXXXXX';

  @override
  String get errorNinEmpty => 'Le NIN ne peut pas être vide';

  @override
  String get errorNinInvalid => 'Saisissez un NIN valide';

  @override
  String get errorFieldEmpty => 'Ce champ est obligatoire';

  @override
  String errorMinCharacters(int num) {
    return 'Saisissez au moins $num caractères';
  }

  @override
  String get errorSpecialityNotSelected =>
      'Veuillez sélectionner votre spécialité';

  @override
  String get errorLicenceInvalid => 'Saisissez un numéro de licence valide';

  @override
  String get errorYearsInvalid => 'Saisissez un nombre d\'années valide';

  @override
  String get errorPriceInvalid => 'Saisissez un prix valide en DA';

  @override
  String get errorTimeout =>
      'Délai d\'attente dépassé. Vérifiez votre connexion et réessayez.';

  @override
  String get errorEmailCheckFailed =>
      'Échec de la vérification de l\'e-mail. Veuillez réessayer.';

  @override
  String get errorSignupFailed => 'Échec de l\'inscription';

  @override
  String errorOccurred(String error) {
    return 'Une erreur s\'est produite : $error';
  }

  @override
  String get doctorNotFound => 'Médecin non trouvé';

  @override
  String helloPatient(String name) {
    return 'Bonjour $name !';
  }

  @override
  String helloDoctor(String name) {
    return 'Bonjour Dr. $name !';
  }

  @override
  String doctorsCount(int count) {
    return '$count médecins';
  }

  @override
  String doctorsForSpeciality(String speciality) {
    return 'Médecins - $speciality';
  }

  @override
  String get userNotLoggedIn => 'Utilisateur non connecté';

  @override
  String get pleaseLogInAsDoctor =>
      'Veuillez vous connecter en tant que médecin pour voir votre écran d\'accueil.';

  @override
  String get noUpcomingConsultations => 'Aucune consultation à venir';

  @override
  String get noPendingConsultations => 'Aucune consultation en attente';

  @override
  String get popularSpecializations => 'Spécialités populaires';

  @override
  String get allSpecialities => 'Toutes les spécialités';

  @override
  String get popularDoctors => 'Médecins populaires';

  @override
  String get services => 'Services';

  @override
  String get appointments => 'Rendez-vous';

  @override
  String get availability => 'Disponibilité';

  @override
  String get faq => 'FAQ';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get pendingRequests => 'Demandes en attente';

  @override
  String get totalPatients => 'Total des patients';

  @override
  String appointmentsCount(int count) {
    return '$count rendez-vous';
  }

  @override
  String requestsCount(int count) {
    return '$count demande';
  }

  @override
  String requestsCountPlural(int count) {
    return '$count demandes';
  }

  @override
  String patientsCount(int count) {
    return '$count patients';
  }

  @override
  String get addressNotAvailable => 'Adresse non disponible';

  @override
  String get whatsappErrorDoctor =>
      'Impossible d\'ouvrir WhatsApp. Veuillez vous assurer que WhatsApp est installé.';

  @override
  String get phoneNumberNotAvailableDoctor =>
      'Numéro de téléphone non disponible';

  @override
  String get appointmentAcceptedSuccessfully =>
      'Rendez-vous accepté avec succès';

  @override
  String get appointmentRejectedSuccessfully =>
      'Rendez-vous rejeté avec succès';

  @override
  String get areYouSureRejectAppointment =>
      'Êtes-vous sûr de vouloir rejeter ce rendez-vous ?';

  @override
  String get patientWillBeNotified => 'Le patient sera averti du rejet.';

  @override
  String get quickOverview => 'Aperçu rapide';

  @override
  String atTime(String date, String time) {
    return '$date à $time';
  }

  @override
  String whatsappMessageDoctorToPatient(String dateTime) {
    return 'Bonjour, je souhaite discuter de notre rendez-vous le $dateTime.';
  }
}
