import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GlobalErrorHandler {
  static void initialize() {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      log('Flutter Error: ${details.exception}');
      log('Stack Trace: ${details.stack}');
    };

    // Handle other errors
    PlatformDispatcher.instance.onError = (error, stack) {
      log('Platform Error: $error');
      log('Stack Trace: $stack');
      return true;
    };
  }

  static Widget buildErrorWidget(FlutterErrorDetails details) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            if (kDebugMode)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  details.exception.toString(),
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // يمكنك إضافة restart logic هنا
                log('Restart button pressed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Restart App'),
            ),
          ],
        ),
      ),
    );
  }
}
