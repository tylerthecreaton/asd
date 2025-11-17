// Example usage of Authentication feature

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../../core/constants/route_constants.dart';

/// Example: Using Auth Provider in a widget
class ExampleAuthUsage extends ConsumerWidget {
  const ExampleAuthUsage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Auth Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display authentication status
            Text(
              authState.isAuthenticated ? 'Logged In' : 'Not Logged In',
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 20),

            // Display user info if logged in
            if (authState.user != null) ...[
              Text('Email: ${authState.user!.email}'),
              if (authState.user!.name != null)
                Text('Name: ${authState.user!.name}'),
            ],

            const SizedBox(height: 20),

            // Show error if any
            if (authState.errorMessage != null) ...[
              Text(
                authState.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
            ],

            // Login button
            if (!authState.isAuthenticated)
              ElevatedButton(
                onPressed: authState.isLoading
                    ? null
                    : () => context.go(RouteConstants.login),
                child: const Text('Go to Login'),
              ),

            // Logout button
            if (authState.isAuthenticated)
              ElevatedButton(
                onPressed: authState.isLoading
                    ? null
                    : () async {
                        await ref.read(authProvider.notifier).logout();
                        if (context.mounted) {
                          context.go(RouteConstants.login);
                        }
                      },
                child: authState.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Logout'),
              ),
          ],
        ),
      ),
    );
  }
}

/// Example: Manual login
Future<void> manualLoginExample(WidgetRef ref, BuildContext context) async {
  // Get auth notifier
  final authNotifier = ref.read(authProvider.notifier);

  // Perform login
  await authNotifier.login('user@example.com', 'password123');

  // Check result
  final authState = ref.read(authProvider);
  if (authState.isAuthenticated) {
    // Navigate to home on success
    if (context.mounted) {
      context.go(RouteConstants.home);
    }
  } else if (authState.errorMessage != null) {
    // Show error
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(authState.errorMessage!)));
    }
  }
}

/// Example: Manual registration
Future<void> manualRegisterExample(WidgetRef ref, BuildContext context) async {
  // Get auth notifier
  final authNotifier = ref.read(authProvider.notifier);

  // Perform registration
  await authNotifier.register(
    email: 'newuser@example.com',
    password: 'password123',
    fullName: 'John Doe',
    phoneNumber: '0812345678',
  );

  // Check result
  final authState = ref.read(authProvider);
  if (authState.isAuthenticated) {
    // Navigate to home on success
    if (context.mounted) {
      context.go(RouteConstants.home);
    }
  } else if (authState.errorMessage != null) {
    // Show error
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(authState.errorMessage!)));
    }
  }
}

/// Example: Protected route
class ProtectedPage extends ConsumerWidget {
  const ProtectedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Redirect to login if not authenticated
    if (!authState.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RouteConstants.login);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Protected Page')),
      body: const Center(child: Text('This page requires authentication')),
    );
  }
}
