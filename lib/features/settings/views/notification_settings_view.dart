import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/configs/app_config.dart';
import 'package:flutterflare/core/logger/logger.dart';
import 'package:flutterflare/core/services/notification/notification_service.dart';
import 'package:flutterflare/core/services/notification/toast_service.dart';

/// View for managing notification settings
class NotificationSettingsView extends ConsumerStatefulWidget {
  /// Route path for this view
  static const String routePath = '/settings/notifications';

  const NotificationSettingsView({super.key});

  @override
  ConsumerState<NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState
    extends ConsumerState<NotificationSettingsView> {
  bool _pushNotificationsEnabled = true;
  bool _newsAndUpdatesEnabled = true;
  bool _messageNotificationsEnabled = true;
  bool _reminderNotificationsEnabled = true;
  String? _fcmToken;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFcmToken();
  }

  Future<void> _loadFcmToken() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = await ref.read(notificationServiceProvider).getToken();
      setState(() {
        _fcmToken = token;
      });
    } catch (e) {
      logger.e('Error getting FCM token: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _subscribeToTopic(String topic) async {
    try {
      await ref.read(notificationServiceProvider).subscribeToTopic(topic);
      // Show success message
      if (mounted) {
        Toast.showSuccess('Subscribed successfully');
      }
    } catch (e) {
      logger.e('Error subscribing to topic: $e');
      // Show error message
      if (mounted) {
        Toast.showError('Failed to subscribe: $e');
      }
    }
  }

  Future<void> _unsubscribeFromTopic(String topic) async {
    try {
      await ref.read(notificationServiceProvider).unsubscribeFromTopic(topic);
      // Show success message
      if (mounted) {
        Toast.showSuccess('Unsubscribed successfully');
      }
    } catch (e) {
      logger.e('Error unsubscribing from topic: $e');
      // Show error message
      if (mounted) {
        Toast.showError('Failed to unsubscribe: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildNotificationSettings(),
    );
  }

  Widget _buildNotificationSettings() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildHeaderSection(),
        const SizedBox(height: 24),
        _buildNotificationOptions(),
        const SizedBox(height: 24),
        _buildTopicSubscriptions(),
        const SizedBox(height: 24),
        if (_fcmToken != null) _buildTokenInfo(),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notification Preferences',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Customize how and when you receive notifications from ${AppConfig.appName}.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildNotificationOptions() {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Settings',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive notifications on this device'),
              value: _pushNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _pushNotificationsEnabled = value;
                });
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('News & Updates'),
              subtitle: const Text('Get notified about app updates and news'),
              value: _newsAndUpdatesEnabled,
              onChanged:
                  _pushNotificationsEnabled
                      ? (value) {
                        setState(() {
                          _newsAndUpdatesEnabled = value;
                        });
                        if (value) {
                          _subscribeToTopic('news');
                        } else {
                          _unsubscribeFromTopic('news');
                        }
                      }
                      : null,
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Messages'),
              subtitle: const Text('Notifications for new messages'),
              value: _messageNotificationsEnabled,
              onChanged:
                  _pushNotificationsEnabled
                      ? (value) {
                        setState(() {
                          _messageNotificationsEnabled = value;
                        });
                        if (value) {
                          _subscribeToTopic('messages');
                        } else {
                          _unsubscribeFromTopic('messages');
                        }
                      }
                      : null,
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Reminders'),
              subtitle: const Text('Get reminded about important events'),
              value: _reminderNotificationsEnabled,
              onChanged:
                  _pushNotificationsEnabled
                      ? (value) {
                        setState(() {
                          _reminderNotificationsEnabled = value;
                        });
                        if (value) {
                          _subscribeToTopic('reminders');
                        } else {
                          _unsubscribeFromTopic('reminders');
                        }
                      }
                      : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicSubscriptions() {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Topic Subscriptions',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Subscribe to specific notification topics that interest you.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTopicChip('news', 'News', _newsAndUpdatesEnabled),
                _buildTopicChip(
                  'messages',
                  'Messages',
                  _messageNotificationsEnabled,
                ),
                _buildTopicChip(
                  'reminders',
                  'Reminders',
                  _reminderNotificationsEnabled,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicChip(String topic, String label, bool isSubscribed) {
    return FilterChip(
      label: Text(label),
      selected: isSubscribed,
      onSelected:
          _pushNotificationsEnabled
              ? (selected) {
                if (selected) {
                  _subscribeToTopic(topic);
                } else {
                  _unsubscribeFromTopic(topic);
                }

                // Update the corresponding switch
                setState(() {
                  if (topic == 'news') {
                    _newsAndUpdatesEnabled = selected;
                  } else if (topic == 'messages') {
                    _messageNotificationsEnabled = selected;
                  } else if (topic == 'reminders') {
                    _reminderNotificationsEnabled = selected;
                  }
                });
              }
              : null,
    );
  }

  Widget _buildTokenInfo() {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Device Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Device Token:',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _fcmToken ?? 'No token available',
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: () {
                      if (_fcmToken != null) {
                        Clipboard.setData(ClipboardData(text: _fcmToken!));
                        Toast.showSuccess('Token copied to clipboard');
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _loadFcmToken,
                    child: const Text('Refresh Token'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
