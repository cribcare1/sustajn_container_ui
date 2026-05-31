import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/notification/notification_services.dart';
import 'package:sustajn_restaurant/notification/notification_notifier.dart';
import 'package:sustajn_restaurant/utils/utility.dart';

import '../constants/imports_util.dart';
import 'notification_model.dart';

final getNotification =
FutureProvider.family<NotificationResponseModel, int>(
      (ref, param) async {
    final notificationState = ref.watch(notificationProvider);

    try {
      final api = ref.read(notificationServiceProvider);

      NotificationResponseModel response =
      await api.fetchAllNotification(param);

      notificationState.setNotificationData(response.data ?? []);

      return response;
    } catch (e) {
      showCustomSnackBar(
        context: notificationState.context,
        message: e.toString(),
        color: Colors.red,
      );

      notificationState.setLoading(false);

      rethrow;
    } finally {
      notificationState.setLoading(false);
    }
  },
);

final getNotificationCount = FutureProvider.family<dynamic, int>((
  ref,
  param,
) async {
  final notificationState = ref.watch(notificationProvider);
  try {
    final api = ref.read(notificationServiceProvider);
    var response = await api.fetchNotificationCount(param);
  } catch (e) {
    showCustomSnackBar(
      context: notificationState.context,
      message: e.toString(),
      color: Colors.red,
    );
    notificationState.setLoading(false);
  } finally {
    notificationState.setLoading(false);
  }
});
