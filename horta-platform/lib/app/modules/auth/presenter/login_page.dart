import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/horta_logo.dart';
import 'cubits/auth_cubit.dart';
import 'widgets/background_glow.dart';
import 'widgets/login_card.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.from});

  final String? from;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) context.go(from ?? '/nursery');
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ));
          }
        },
        child: const _LoginBody(),
      ),
    );
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HortaTheme.darkBackground,
      body: Stack(
        children: [
          const BackgroundGlow(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const HortaLogo(size: 80),
                    const SizedBox(height: 24),
                    Text(
                      'HORTA',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -2,
                      ),
                    ),
                    Text(
                      'app.subtitle'.tr().toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: HortaTheme.primaryEmerald,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 64),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) => LoginCard(
                        isLoading: state is AuthLoading,
                        onSignIn:
                            context.read<AuthCubit>().signInWithGoogle,
                      ),
                    ),
                    const SizedBox(height: 48),
                    const Text(
                      'V2.0 ALPHA',
                      style: TextStyle(
                        color: Colors.white10,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
