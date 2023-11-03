import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  const Error({
    super.key,
    required String? errorMessage,
  }) : _errorMessage = errorMessage;

  final String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: Theme.of(context).colorScheme.onErrorContainer,
                size: 50,
              ),
              const SizedBox(height: 20),
              Text(
                'Error: $_errorMessage',
                style: TextStyle(
                  height: 1.5,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
