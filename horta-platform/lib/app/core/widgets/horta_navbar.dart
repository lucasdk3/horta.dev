import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:easy_localization/easy_localization.dart';
import '../auth/auth_service.dart';
import '../theme/app_theme.dart';
import '../theme/theme_notifier.dart';

class HortaNavbar extends StatefulWidget implements PreferredSizeWidget {
  const HortaNavbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  State<HortaNavbar> createState() => _HortaNavbarState();
}

class _HortaNavbarState extends State<HortaNavbar> {
  @override
  Widget build(BuildContext context) {
    final auth = GetIt.I<AuthService>();
    final isWide = MediaQuery.of(context).size.width > 800;
    final currentLang = context.locale.languageCode.toUpperCase();

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/nursery'),
            child: Row(children: [
              SvgPicture.asset('assets/images/logo.svg', width: 32, height: 32),
              const SizedBox(width: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'horta',
                      style: TextStyle(
                        color: HortaTheme.pageText(context),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const TextSpan(
                      text: '.dev',
                      style: TextStyle(
                        color: HortaTheme.primaryEmerald,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          const Spacer(),
          if (isWide) ...[
            _NavPill(children: [
              _NavLink(label: 'app.home'.tr().toUpperCase(), route: '/nursery'),
              _NavLink(label: 'app.about'.tr().toUpperCase(), route: '/about'),
              _NavLink(
                  label: 'app.contribute'.tr().toUpperCase(),
                  route: '/about?section=contribute'),
              _NavLink(
                  label: 'app.privacy'.tr().toUpperCase(),
                  route: '/about?section=privacy'),
            ]),
            const SizedBox(width: 16),
          ],
          if (isWide) ...[
            _ThemeToggleButton(),
            const SizedBox(width: 8),
            _NavPill(children: [
              _LangButton(
                lang: 'PT',
                selected: currentLang == 'PT',
                onTap: () => context.setLocale(const Locale('pt', 'BR')),
              ),
              _LangButton(
                lang: 'EN',
                selected: currentLang == 'EN',
                onTap: () => context.setLocale(const Locale('en', 'US')),
              ),
              _LangButton(
                lang: 'ES',
                selected: currentLang == 'ES',
                onTap: () => context.setLocale(const Locale('es', 'ES')),
              ),
            ]),
            const SizedBox(width: 8),
          ],
          if (!isWide) ...[
            _MobileMenuButton(currentLang: currentLang, auth: auth),
            const SizedBox(width: 8),
          ],
          ListenableBuilder(
            listenable: auth,
            builder: (_, __) => auth.isAuthenticated
                ? _UserAvatar(auth: auth)
                : isWide
                    ? _LoginButton(auth: auth)
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _MobileMenuButton extends StatelessWidget {
  final String currentLang;
  final AuthService auth;
  const _MobileMenuButton({required this.currentLang, required this.auth});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 48),
      color: HortaTheme.darkCardBg(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: HortaTheme.containerBorder(context)),
      ),
      icon: Icon(Icons.menu, color: HortaTheme.pageText(context), size: 22),
      onSelected: (value) async {
        if (value == 'pt') {
          context.setLocale(const Locale('pt', 'BR'));
        } else if (value == 'en') {
          context.setLocale(const Locale('en', 'US'));
        } else if (value == 'es') {
          context.setLocale(const Locale('es', 'ES'));
        } else if (value == 'login') {
          await auth.signInWithGoogle();
        } else {
          context.go(value);
        }
      },
      itemBuilder: (_) => [
        _menuItem('/nursery', Icons.home_outlined, 'app.home'.tr()),
        _menuItem('/about', Icons.info_outline, 'app.about'.tr()),
        _menuItem('/about?section=contribute',
            Icons.volunteer_activism_outlined, 'app.contribute'.tr()),
        _menuItem('/about?section=privacy', Icons.shield_outlined,
            'app.privacy'.tr()),
        const PopupMenuDivider(),
        _langItem('pt', 'PT', currentLang == 'PT'),
        _langItem('en', 'EN', currentLang == 'EN'),
        _langItem('es', 'ES', currentLang == 'ES'),
        if (!auth.isAuthenticated) ...[
          const PopupMenuDivider(),
          _menuItem('login', Icons.login, 'app.login'.tr()),
        ],
      ],
    );
  }

  PopupMenuItem<String> _menuItem(String value, IconData icon, String label) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(children: [
        Icon(icon, size: 16, color: HortaTheme.primaryEmerald),
        const SizedBox(width: 12),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: HortaTheme.primaryEmerald,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ]),
    );
  }

  PopupMenuItem<String> _langItem(String value, String label, bool selected) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: selected ? HortaTheme.primaryEmerald : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? HortaTheme.primaryEmerald
                  : HortaTheme.primaryEmerald.withValues(alpha: 0.3),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : HortaTheme.primaryEmerald.withValues(alpha: 0.6),
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color:
                selected ? HortaTheme.primaryEmerald : HortaTheme.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ]),
    );
  }
}

class _NavPill extends StatelessWidget {
  final List<Widget> children;
  const _NavPill({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: HortaTheme.containerBg(context),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: HortaTheme.containerBorder(context)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final String route;
  const _NavLink({required this.label, required this.route});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(route),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: HortaTheme.primaryEmerald,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _LangButton extends StatelessWidget {
  final String lang;
  final bool selected;
  final VoidCallback onTap;

  const _LangButton(
      {required this.lang, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: selected ? HortaTheme.primaryEmerald : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: Text(
          lang,
          style: TextStyle(
            color: selected
                ? Colors.white
                : HortaTheme.primaryEmerald.withValues(alpha: 0.5),
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = GetIt.I<ThemeNotifier>();
    final isDark = HortaTheme.isDark(context);

    return ListenableBuilder(
      listenable: notifier,
      builder: (_, __) => GestureDetector(
        onTap: notifier.toggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDark ? HortaTheme.primaryEmerald : HortaTheme.darkSurface,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              key: ValueKey(isDark),
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatefulWidget {
  final AuthService auth;
  const _LoginButton({required this.auth});

  @override
  State<_LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<_LoginButton> {
  bool _loading = false;

  Future<void> _onTap() async {
    setState(() => _loading = true);
    final ok = await widget.auth.signInWithGoogle();
    if (!mounted) return;
    setState(() => _loading = false);
    if (!ok && kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Login via Google na web requer o botão Google Sign-In. '
            'Use o app móvel ou implemente renderButton.',
          ),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: _loading ? null : _onTap,
      icon: _loading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white54),
            )
          : Icon(Icons.login, size: 16, color: HortaTheme.pageText(context)),
      label: Text(
        'app.login'.tr().toUpperCase(),
        style: TextStyle(
          color: HortaTheme.pageText(context),
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final AuthService auth;
  const _UserAvatar({required this.auth});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<void>(
      offset: const Offset(0, 48),
      color: HortaTheme.darkCardBg(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: HortaTheme.containerBorder(context)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: HortaTheme.primaryEmerald,
            backgroundImage: auth.currentUser?.photoUrl != null
                ? NetworkImage(auth.currentUser!.photoUrl!)
                : null,
            child: auth.currentUser?.photoUrl == null
                ? const Icon(Icons.person, color: Colors.white, size: 20)
                : null,
          ),
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const Text(
                '1',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
      itemBuilder: (_) => <PopupMenuEntry<void>>[
        PopupMenuItem<void>(
          onTap: () => context.go('/garden'),
          child: _PopupRow(
              icon: Icons.forest, label: 'app.garden'.tr().toUpperCase()),
        ),
        PopupMenuItem<void>(
          onTap: () => context.go('/admin'),
          child: _PopupRow(
              icon: Icons.shield, label: 'app.admin'.tr().toUpperCase()),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<void>(
          onTap: () => auth.signOut(),
          child: _PopupRow(
              icon: Icons.logout,
              label: 'app.logout'.tr().toUpperCase(),
              danger: true),
        ),
      ],
    );
  }
}

class _PopupRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool danger;

  const _PopupRow(
      {required this.icon, required this.label, this.danger = false});

  @override
  Widget build(BuildContext context) {
    final color = danger ? Colors.red : HortaTheme.textSecondary;
    return Row(children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: 12),
      Text(
        label,
        style: TextStyle(
          color: danger ? Colors.red : HortaTheme.pageText(context),
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
    ]);
  }
}

class HortaFooter extends StatelessWidget {
  const HortaFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: HortaTheme.primaryEmerald,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            _FooterText('app.footer_ecosystem'.tr()),
            const SizedBox(width: 32),
            _FooterText('app.footer_version'.tr()),
          ]),
          _FooterText('app.footer_nurtured_by'.tr()),
        ],
      ),
    );
  }
}

class _FooterText extends StatelessWidget {
  final String text;
  const _FooterText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 9,
        fontWeight: FontWeight.w900,
        letterSpacing: 3,
      ),
    );
  }
}
