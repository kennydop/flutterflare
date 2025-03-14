import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterflare/core/services/notification/toast_service.dart';
import 'package:flutterflare/features/auth/models/user_model.dart';
import 'package:flutterflare/features/auth/viewmodels/auth_viewmodel.dart';

class UserProfileView extends ConsumerWidget {
  static const routePath = '/profile';
  const UserProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(authStateProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await ref.read(authProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: userAsyncValue.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('You are not logged in'));
          }
          return _buildProfileContent(context, ref, user, authState.isLoading);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
    bool isLoading,
  ) {
    final bool hasIncompleteProfile =
        user.firstName == null ||
        user.lastName == null ||
        user.firstName!.isEmpty ||
        user.lastName!.isEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header with image
          Center(
            child: Column(
              children: [
                _buildProfileImage(user),
                const SizedBox(height: 16),
                Text(
                  '${user.firstName ?? ''} ${user.lastName ?? ''}'
                          .trim()
                          .isNotEmpty
                      ? '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim()
                      : 'Complete Your Profile',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
                if (user.provider != null)
                  Chip(
                    label: Text(
                      'Signed in with ${_formatProvider(user.provider!)}',
                    ),
                    backgroundColor: _getProviderColor(user.provider!),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Incomplete profile notice
          if (hasIncompleteProfile)
            Card(
              color: Colors.amber.shade100,
              margin: const EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          'Complete Your Profile',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please update your profile information to enhance your experience.',
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        _showEditDialog(
                          context,
                          ref,
                          'First Name',
                          user.firstName ?? '',
                          (value) async {
                            await ref
                                .read(authProvider.notifier)
                                .updateUserProfile(firstName: value);
                            if (context.mounted) Navigator.of(context).pop();
                          },
                        );
                      },
                      child: const Text('Update Profile'),
                    ),
                  ],
                ),
              ),
            ),

          // Account information
          _buildSectionHeader(context, 'Account Information'),
          _buildInfoItem(context, 'Email', user.email),
          _buildInfoItem(
            context,
            'Email Verified',
            user.emailVerified ? 'Yes' : 'No',
          ),
          _buildInfoItem(context, 'Phone', user.phoneNumber ?? 'Not provided'),
          _buildInfoItem(
            context,
            'Provider',
            user.provider != null ? _formatProvider(user.provider!) : 'Email',
          ),
          _buildInfoItem(
            context,
            'Status',
            user.isOnline ? 'Online' : 'Offline',
          ),

          const SizedBox(height: 24),

          // Profile information section
          _buildSectionHeader(context, 'Profile'),
          _buildEditableInfoItem(
            context,
            'First Name',
            user.firstName ?? 'Not provided',
            () => _showEditDialog(
              context,
              ref,
              'First Name',
              user.firstName ?? '',
              (value) async {
                await ref
                    .read(authProvider.notifier)
                    .updateUserProfile(firstName: value);
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ),
          _buildEditableInfoItem(
            context,
            'Last Name',
            user.lastName ?? 'Not provided',
            () => _showEditDialog(
              context,
              ref,
              'Last Name',
              user.lastName ?? '',
              (value) async {
                await ref
                    .read(authProvider.notifier)
                    .updateUserProfile(lastName: value);
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ),
          _buildEditableInfoItem(
            context,
            'Bio',
            user.bio ?? 'Not provided',
            () => _showEditDialog(context, ref, 'Bio', user.bio ?? '', (
              value,
            ) async {
              await ref
                  .read(authProvider.notifier)
                  .updateUserProfile(bio: value);
              if (context.mounted) Navigator.of(context).pop();
            }),
          ),

          const SizedBox(height: 24),

          // Edit profile button
          const SizedBox(height: 32),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            ElevatedButton(
              onPressed: () {
                // Navigate to a dedicated profile edit screen
                Toast.showInfo('Edit profile button pressed');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Edit Full Profile'),
            ),
        ],
      ),
    );
  }

  String _formatProvider(String provider) {
    switch (provider) {
      case 'google':
        return 'Google';
      case 'apple':
        return 'Apple';
      case 'email':
        return 'Email & Password';
      default:
        return provider;
    }
  }

  Color _getProviderColor(String provider) {
    switch (provider) {
      case 'google':
        return Colors.blue.shade100;
      case 'apple':
        return Colors.grey.shade300;
      case 'email':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Widget _buildProfileImage(UserModel user) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage:
              user.photoURL != null ? NetworkImage(user.photoURL!) : null,
          child:
              user.photoURL == null
                  ? Text(
                    _getInitials(user),
                    style: const TextStyle(fontSize: 32),
                  )
                  : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              iconSize: 20,
              onPressed: () {
                // Add image upload functionality
                Toast.showInfo('Upload photo feature coming soon');
              },
            ),
          ),
        ),
      ],
    );
  }

  String _getInitials(UserModel user) {
    final firstName = user.firstName ?? '';
    final lastName = user.lastName ?? '';

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '${firstName[0]}${lastName[0]}';
    } else if (firstName.isNotEmpty) {
      return firstName[0];
    } else if (lastName.isNotEmpty) {
      return lastName[0];
    } else {
      // If no name is available, use the first letter of the email
      return user.email.isNotEmpty ? user.email[0].toUpperCase() : '?';
    }
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Divider(),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildEditableInfoItem(
    BuildContext context,
    String label,
    String value,
    VoidCallback onEdit,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: onEdit),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    String label,
    String initialValue,
    Future<void> Function(String) onSave,
  ) {
    final textController = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit $label'),
            content: TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final value = textController.text.trim();
                  if (value.isEmpty) {
                    Toast.showError('Field cannot be empty');
                    return;
                  }
                  onSave(value);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }
}
