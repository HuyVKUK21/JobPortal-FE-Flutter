import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/core/models/notification.dart';

// Notification State
class NotificationState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final String? error;

  NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notification Notifier
class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(NotificationState());

  // Get all notifications
  Future<void> getNotifications(int userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // TODO: Replace with actual API call
      // final response = await apiService.getNotifications(userId);
      // final notifications = (response.data as List)
      //     .map((json) => NotificationModel.fromJson(json))
      //     .toList();
      
      // Mock data for now
      await Future.delayed(const Duration(seconds: 1));
      final notifications = _getMockNotifications();
      
      state = state.copyWith(
        notifications: notifications,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Mark notification as read
  Future<void> markAsRead(int notificationId) async {
    try {
      // TODO: Replace with actual API call
      // await apiService.markNotificationAsRead(notificationId);
      
      // Update local state
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == notificationId) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();
      
      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      // TODO: Replace with actual API call
      // await apiService.markAllNotificationsAsRead();
      
      // Update local state
      final updatedNotifications = state.notifications.map((notification) {
        return notification.copyWith(isRead: true);
      }).toList();
      
      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // Mock data generator (remove when API is ready)
  List<NotificationModel> _getMockNotifications() {
    final now = DateTime.now();
    return [
      // General Notifications
      NotificationModel(
        id: 1,
        title: 'Bảo mật đã được cập nhật',
        message: 'Tài khoản của bạn giờ đã an toàn hơn! Chúng tôi đã cập nhật hệ thống bảo mật. Liên hệ với chúng tôi nếu bạn có bất kỳ câu hỏi nào.',
        type: 'general',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: 2,
        title: 'Mẹo mới đã có sẵn!',
        message: 'Bạn có 3 mẹo mới để cải thiện việc tìm kiếm công việc. Hãy xem ngay bây giờ!',
        type: 'general',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      NotificationModel(
        id: 3,
        title: 'Thiết lập tài khoản thành công!',
        message: 'Tài khoản của bạn đã được tạo thành công. Bắt đầu ứng tuyển công việc ngay bây giờ!',
        type: 'general',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      
      // Application Notifications
      NotificationModel(
        id: 4,
        title: 'Quản lý Sản phẩm',
        message: 'Chúc mừng! Đơn ứng tuyển của bạn đã được chấp nhận. Nhà tuyển dụng sẽ sớm liên hệ với bạn.',
        type: 'application',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 3)),
        jobId: 1,
        applicationId: 1,
        companyName: 'Google Inc.',
        companyLogo: 'assets/logo_lutech.png',
      ),
      NotificationModel(
        id: 5,
        title: 'Thiết kế UI & Lập trình viên',
        message: 'Đơn ứng tuyển của bạn đang được xem xét. Chúng tôi sẽ thông báo cho bạn về các bước tiếp theo sớm.',
        type: 'application',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 8)),
        jobId: 2,
        applicationId: 2,
        companyName: 'Facebook',
        companyLogo: 'assets/logo_lutech.png',
      ),
      NotificationModel(
        id: 6,
        title: 'Đảm bảo Chất lượng',
        message: 'Cảm ơn bạn đã quan tâm. Rất tiếc, chúng tôi đã quyết định tiếp tục với các ứng viên khác.',
        type: 'application',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
        jobId: 3,
        applicationId: 3,
        companyName: 'Apple Inc.',
        companyLogo: 'assets/logo_lutech.png',
      ),
      NotificationModel(
        id: 7,
        title: 'Kỹ sư Phần mềm',
        message: 'Đơn ứng tuyển của bạn đã được nhận. Đội ngũ của chúng tôi đang xem xét và sẽ phản hồi trong vòng 48 giờ.',
        type: 'application',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 2)),
        jobId: 4,
        applicationId: 4,
        companyName: 'Microsoft',
        companyLogo: 'assets/logo_lutech.png',
      ),
      NotificationModel(
        id: 8,
        title: 'Quản trị Mạng',
        message: 'Chúng tôi muốn sắp xếp một cuộc phỏng vấn với bạn. Vui lòng kiểm tra email để biết thêm chi tiết.',
        type: 'application',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 12)),
        jobId: 5,
        applicationId: 5,
        companyName: 'Amazon',
        companyLogo: 'assets/logo_lutech.png',
      ),
      NotificationModel(
        id: 9,
        title: 'Kỹ sư DevOps',
        message: 'Đơn ứng tuyển của bạn đang được xử lý. Chúng tôi đánh giá cao sự kiên nhẫn của bạn.',
        type: 'application',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 3)),
        jobId: 6,
        applicationId: 6,
        companyName: 'Netflix',
        companyLogo: 'assets/logo_lutech.png',
      ),
    ];
  }
}

// Providers
final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});

// Convenience providers
final notificationsListProvider = Provider<List<NotificationModel>>((ref) {
  return ref.watch(notificationProvider).notifications;
});

final generalNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  return ref.watch(notificationProvider).notifications
      .where((n) => n.type == 'general')
      .toList();
});

final applicationNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  return ref.watch(notificationProvider).notifications
      .where((n) => n.type == 'application')
      .toList();
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).notifications
      .where((n) => !n.isRead)
      .length;
});

final notificationLoadingProvider = Provider<bool>((ref) {
  return ref.watch(notificationProvider).isLoading;
});

final notificationErrorProvider = Provider<String?>((ref) {
  return ref.watch(notificationProvider).error;
});
