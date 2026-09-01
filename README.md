Check-Uppers

A Flutter app for carers of elderly patients. It keeps a medication list per patient, runs a timer for each medication, and sends a notification when a dose is due.

What it does

The app is built around one job: make sure a dose is not missed.

Per-patient lists. A carer looking after more than one person keeps them separate, each with their own medications and a free-text notes area for anything that does not fit a field.
Timers per medication. Each medication carries its own schedule rather than sharing one global reminder, because dosing intervals rarely line up.
Notifications. The app raises a notification when a dose is due, so the carer does not have to keep the app open or remember on their own.
Why it is designed the way it is

The user is a carer, and the cost of a missed notification is a missed dose. That constraint drove the design decisions:

Notifications are the primary interface, not an optional extra. The app is useful while it is closed.
The notes field is deliberately unstructured. Carers record things that no schema anticipates — a reaction, a refusal, a changed instruction from a doctor — and a rigid form would push that information out of the app and onto paper.
Nothing is auto-dismissed. A dose is marked by the carer, not by the timer expiring.
Tech

Flutter / Dart, targeting Android.

bash
flutter pub get
flutter run

Requires the Flutter SDK. Notifications need permission granted on the device; on Android 13 and later that prompt appears on first launch.

Known limitations
No backend. Everything lives on the device, so data does not sync between phones and is lost if the app is uninstalled. For a single carer with one phone this is fine; for a team sharing care of the same patient it is not.
Notifications depend on the OS. Aggressive battery optimisation on some Android builds can delay or suppress a scheduled notification. For an app whose whole purpose is timing, that is the most important weakness in it.
No dose history. The app tells the carer what is due; it does not keep a record of what was actually given. That record is what a doctor would want to see, and it is the most valuable thing to add next.
Context

University project for a Computer Engineering degree. It is a working prototype, not a clinically validated tool — it does not replace a medication chart or professional advice.
