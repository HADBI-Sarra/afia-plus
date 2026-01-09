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
  String get downloadingPdf => 'Téléchargement de l\'ordonnance...';

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
  String get keepAppointment => 'Garder le rendez-vous';

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
  String get french => 'Français';

  @override
  String get whatsappError =>
      'Impossible d\'ouvrir WhatsApp. Veuillez vous assurer que WhatsApp est installé.';

  @override
  String whatsappMessageDoctor(String doctorName, String date) {
    return 'Bonjour Dr. $doctorName, j\'ai une question concernant mon rendez-vous du $date.';
  }

  @override
  String get doctorProfile => 'Profil du médecin';

  @override
  String get book => 'Réserver';

  @override
  String get about => 'À propos';

  @override
  String get reviews => 'Avis';

  @override
  String get bookAppointment => 'Réserver un rendez-vous';

  @override
  String get doctorNotFound => 'Médecin introuvable';

  @override
  String get bookingSuccessMessage =>
      'La réservation a réussi et doit être confirmée par le médecin.';

  @override
  String get pleaseSelectTime =>
      'Veuillez sélectionner une heure pour votre consultation.';

  @override
  String get cannotBookPastDate =>
      'Vous ne pouvez pas réserver de rendez-vous pour des dates passées. Veuillez sélectionner une date actuelle ou future.';

  @override
  String get cannotBookPastTime =>
      'Vous ne pouvez pas réserver de rendez-vous pour des heures passées. Veuillez sélectionner un créneau horaire futur.';

  @override
  String get noAvailableSlot =>
      'Aucun créneau disponible trouvé pour la date/heure sélectionnée.';

  @override
  String get mustBeLoggedInAsPatient =>
      'Vous devez être connecté en tant que patient.';

  @override
  String get profile => 'Profil';

  @override
  String get bookedAppointments => 'Rendez-vous réservés';

  @override
  String get myPatients => 'Mes patients';

  @override
  String get availability => 'Disponibilité';

  @override
  String get notificationSettings => 'Paramètres de notification';

  @override
  String get policies => 'Politiques';

  @override
  String get changeEmail => 'Changer l\'e-mail';

  @override
  String get securitySettings => 'Paramètres de sécurité';

  @override
  String get aboutMe => 'À propos de moi';

  @override
  String get logout => 'Déconnexion';

  @override
  String get logoutConfirmation =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get specialtyNotSet => 'Spécialité non définie';

  @override
  String get loadingSpecialty => 'Chargement de la spécialité...';

  @override
  String get favoriteDoctors => 'Médecins favoris';

  @override
  String get dobNotSet => 'Date de naissance non définie';

  @override
  String get patientProfile => 'Profil du patient';

  @override
  String get phone => 'Téléphone';

  @override
  String get address => 'Adresse';

  @override
  String get healthInfo => 'Informations de santé';

  @override
  String get sendMessage => 'Envoyer un message';

  @override
  String get generalInformation => 'Informations générales';

  @override
  String get currentWorkingPlace => 'Lieu de travail actuel';

  @override
  String get education => 'Éducation';

  @override
  String get certification => 'Certification';

  @override
  String get training => 'Formation';

  @override
  String get licensure => 'Licence';

  @override
  String get experience => 'Expérience';

  @override
  String get notSpecified => 'Non spécifié';

  @override
  String get licenseNumber => 'Numéro de licence :';

  @override
  String get over => 'Plus de';

  @override
  String get year => 'an';

  @override
  String get years => 'ans';

  @override
  String get ofExperience => 'd\'expérience';

  @override
  String get specializingIn => 'spécialisé en';

  @override
  String get price => 'Prix';

  @override
  String get oneHourConsultation => 'Consultation d\'une heure';

  @override
  String get selectTime => 'Sélectionner l\'heure';

  @override
  String get noAvailableTimesForDay => 'Aucune heure disponible pour ce jour';

  @override
  String get noUpcomingAvailability =>
      'Aucune disponibilité à venir. Ce médecin n\'a pas de créneaux horaires disponibles pour la réservation.';

  @override
  String get noAvailability => 'Aucune disponibilité';

  @override
  String get review => 'avis';

  @override
  String get reviewsPlural => 'avis';

  @override
  String get leaveReview => 'Laisser un avis';

  @override
  String get noReviewsYet =>
      'Aucun avis pour le moment. Soyez le premier à donner votre avis !';

  @override
  String get anonymous => 'Anonyme';
}
