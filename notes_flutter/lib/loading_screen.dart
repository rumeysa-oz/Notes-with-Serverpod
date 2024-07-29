import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    this.exception,
    required this.onTryAgain,
    super.key,
  });

  final Exception? exception;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: exception != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'An error occurred: ${exception.toString()}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onTryAgain,
                  child: const Text('Try again'),
                ),
              ],
            )
          : const CircularProgressIndicator(),
    );
  }
}
