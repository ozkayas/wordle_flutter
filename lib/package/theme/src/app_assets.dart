// class AppAssets {
//   static String get ttBottomLogo =>
//       _('images/tt_bottom_logo.svg', brightnessAware: true);
//   static String get logoCompass =>
//       _('images/logo_compass.svg', brightnessAware: true);
//   static String get cancel => _('icons/cancel.svg', brightnessAware: true);
//   static String get chevronRight => _('icons/chevron_right.svg');
//   static String get chevronLeft => _('icons/chevron_left.svg');
//   static String get arrowLeft => _('icons/arrow_left.svg');
//   static String get arrowDown => _('icons/arrow_down.svg');
//   static String get emptyListImage =>
//       _('images/empty_list.svg', brightnessAware: true);
//   static String get warningIcon => _('icons/warning_icon.svg');

//   /// DIALOG ICONS
//   static String get dialogSuccessIcon =>
//       _('icons/dialog/dialog_success_icon.svg');
//   static String get dialogWarningIcon =>
//       _('icons/dialog/dialog_warning_icon.svg');
//   static String get dialogErrorIcon => _('icons/dialog/dialog_error_icon.svg');
//   static String get dialogInfoIcon => _('icons/dialog/dialog_info_icon.svg');

//   /// HUB ICONS
//   static String get notificationIcon => _('icons/hub/notification.svg');
//   static String get userAdd =>
//       _('icons/hub/user-add.svg', brightnessAware: true);
//   static String get documentText =>
//       _('icons/hub/document-text.svg', brightnessAware: true);
//   static String get scanBarcode =>
//       _('icons/hub/scan-barcode.svg', brightnessAware: true);
//   static String get userTick =>
//       _('icons/hub/user-tick.svg', brightnessAware: true);
//   static String get profileTwoUser =>
//       _('icons/hub/profile-2user.svg', brightnessAware: true);
//   static String get cubeScan =>
//       _('icons/hub/cube-scan.svg', brightnessAware: true);
//   static String get attend => _('icons/hub/attend.svg');
//   static String get tickCircle => _('icons/hub/circle_tick.svg');

//   /// PROFILE ICONS
//   static String get cubeScanProfile => _('icons/profile/cube-scan.svg');
//   static String get elementProfile => _('icons/profile/element-3.svg');
//   static String get twoUserProfile => _('icons/profile/profile-2user.svg');
//   static String get scanBarcodeProfile => _('icons/profile/scan-barcode.svg');
//   static String get userProfile => _('icons/profile/user.svg');
//   static String get arrowRightProfile => _('icons/profile/arrow-right.svg');
//   static String get notificationBell =>
//       _('icons/profile/notification_bell.svg');
//   static String get airplane => _('icons/profile/airplane.svg');
//   static String get data => _('icons/profile/data.svg');
//   static String get multiTask => _('icons/profile/multi_task.svg');
//   static String get task => _('icons/profile/task.svg');
//   static String get notificationBellError =>
//       _('icons/profile/notification_bell_error.gif');
//   static String get notificationBellWarning =>
//       _('icons/profile/notification_bell_warning.gif');
//   static String get warningBellAnimation => _('animations/warning_bell.json');
//   static String get errorBellAnimation => _('animations/error_bell.json');

//   /// Attendance Assignment
//   static String get attendedIcon =>
//       _('icons/attendance/attended_icon.svg', brightnessAware: true);
//   static String get unattendedIcon =>
//       _('icons/attendance/unattended_icon.svg', brightnessAware: true);
//   static String get timerIcon =>
//       _('icons/attendance/timer.svg', brightnessAware: true);
//   static String get airplaneIcon =>
//       _('icons/attendance/airplane.svg', brightnessAware: true);
//   static String get multiTaskIcon =>
//       _('icons/attendance/multi_task.svg', brightnessAware: true);
//   static String get zoneIcon =>
//       _('icons/attendance/zone.svg', brightnessAware: true);
//   static String get editIcon =>
//       _('icons/attendance/edit.svg', brightnessAware: true);

//   /// MANHOUR
//   static String get timerBlue =>
//       _('icons/manhour/timer_blue.svg', brightnessAware: true);
//   static String get timerRed =>
//       _('icons/manhour/timer_red.svg', brightnessAware: true);
//   static String get timerGreen =>
//       _('icons/manhour/timer_green.svg', brightnessAware: true);
//   static String get timerGray =>
//       _('icons/manhour/timer_gray.svg', brightnessAware: true);
//   static String get manhourArrowRight => _('icons/manhour/arrow_right.svg');

//   static String get manhourTaskSquare =>
//       _('icons/manhour/task_square.svg', brightnessAware: true);
//   static String get manhourSettings =>
//       _('icons/manhour/setting.svg', brightnessAware: true);

//   /// Picklist
//   static String get shoppingCart => _('icons/shopping_cart.svg');

//   // If brightnessAware is true, we will check the current brightness of the app
//   // and return the dark version of the asset if the app is in dark mode.
//   // dark version of the asset has pattern: <asset_name>_dark.<asset_extension>
//   static String _(String path, {bool brightnessAware = false}) {
//     // final bool isDark = sl<ThemeService>().brightness == Brightness.dark;
//     // NOTE: Disabling dark mode for now. Remove the below line and
//     // uncomment the above line when dark mode is enabled.
//     const bool isDark = false;
//     if (brightnessAware && isDark) {
//       final parts = path.split('.');
//       return 'assets/${parts[0]}_dark.${parts[1]}';
//     }
//     return 'assets/$path';
//   }
// }
