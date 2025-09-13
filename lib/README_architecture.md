Project structure (summary)

- lib/
  - core/
    - config/app_config.dart            # Base URL, API key, env
    - network/api_client.dart           # Centralized HTTP client
    - notifications/notification_service.dart # Local + FCM notifications
  - Concrete/                           # Legacy area (to be migrated gradually)
  - Helpers/
  - Models/
  - UI/

Notifications

- Default Android channel id: high_importance_with_sound
- To use a custom Android sound:
  1) Put a sound file named exactly `notification.wav` (or .mp3) into `android/app/src/main/res/raw/`
  2) Already enabled in NotificationService: `sound: RawResourceAndroidNotificationSound('notification')`
  3) If you change the file name, update it in NotificationService in both channel creation and show()
- iOS: place `notification.caf` into `ios/Runner` and ensure it is added to the app target. Already enabled in NotificationService as `sound: 'notification.caf'`.
  - If you use a different name, update NotificationService accordingly.
