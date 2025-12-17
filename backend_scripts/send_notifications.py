"""
Helper script to send test FCM notifications that match the app’s filters.

Steps to use:
1) Put the doctor’s FCM token in DOCTOR_TOKEN and the patient’s in PATIENT_TOKEN.
2) Set the IDs/names below to real values that exist in your DB/session.
3) Run: python backend_scripts/send_notifications.py
"""

import os
import firebase_admin
from firebase_admin import messaging, credentials

SERVICE_ACCOUNT = os.environ.get(
    "FIREBASE_SERVICE_ACCOUNT",
    "../firebase_credentials/service_account.json",
)

cred = credentials.Certificate(SERVICE_ACCOUNT)
firebase_admin.initialize_app(cred)

DOCTOR_TOKEN = "eyM6m19NSCCOxXmWdNRRqk:APA91bHL5nLum3fpPVrL1TxJMldU8j1Vtk6qDdDb5u1AAoIXq5h07rWOv7rwdmf6_SyPfHmi0pof_WTB3iHJXIBq4m7_vvIerwfZ8q0gtMDw51d-AVivlDs"
PATIENT_TOKEN = "eyM6m19NSCCOxXmWdNRRqk:APA91bHL5nLum3fpPVrL1TxJMldU8j1Vtk6qDdDb5u1AAoIXq5h07rWOv7rwdmf6_SyPfHmi0pof_WTB3iHJXIBq4m7_vvIerwfZ8q0gtMDw51d-AVivlDs"

# Use real IDs from your database/auth session
DOCTOR_ID = "1"
PATIENT_ID = "1"
APPOINTMENT_ID = "1"

PATIENT_NAME = "ridah houssin"
DOCTOR_NAME = "Dr. ahmed mahmoud"
APPOINTMENT_DATE = "2025-12-15"
APPOINTMENT_TIME = "15:00"


def send_notification(token: str, title: str, body: str, data: dict):
  if not token or token.startswith("REPLACE"):
    print(f"Skip sending to placeholder token for {title}")
    return

  message = messaging.Message(
      notification=messaging.Notification(title=title, body=body),
      data={k: str(v) for k, v in data.items()},
      token=token,
  )
  response = messaging.send(message)
  print(f"✅ Sent '{title}' to token: {response}")


def send_new_appointment_to_doctor():
  send_notification(
      DOCTOR_TOKEN,
      "New Appointment",
      f"{PATIENT_NAME} booked an appointment",
      {
          "type": "new_booking",
          "appointmentId": APPOINTMENT_ID,
          "doctorId": DOCTOR_ID,
          "patientName": PATIENT_NAME,
          "appointmentDate": APPOINTMENT_DATE,
          "appointmentTime": APPOINTMENT_TIME,
      },
  )


def send_confirmed_to_patient():
  send_notification(
      PATIENT_TOKEN,
      "Appointment Confirmed",
      f"{DOCTOR_NAME} confirmed your appointment",
      {
          "type": "booking_confirmed",
          "appointmentId": APPOINTMENT_ID,
          "patientId": PATIENT_ID,
          "doctorName": DOCTOR_NAME,
          "appointmentDate": APPOINTMENT_DATE,
          "appointmentTime": APPOINTMENT_TIME,
      },
  )


if __name__ == "__main__":
  send_new_appointment_to_doctor()
  send_confirmed_to_patient()
