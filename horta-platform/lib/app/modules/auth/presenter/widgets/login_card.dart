import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_theme.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({
    super.key,
    required this.isLoading,
    required this.onSignIn,
  });

  final bool isLoading;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Text(
            'app.description'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Color(0xFF94A3B8), fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 32),
          isLoading
              ? const CircularProgressIndicator(
                  color: HortaTheme.primaryEmerald)
              : SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: onSignIn,
                    icon: const Icon(Icons.login, size: 20),
                    label: Text(
                      'app.login'.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 1.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
