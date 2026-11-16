import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';



/// ✏️ Edit your details here.
class Profile {
  static const name = 'Michael Ibrahim';
  static const role = 'Your role or one-line description';
  static const phone = '+20 100 000 0000';
  static const email = 'you@example.com';
  // Put your photo at assets/profile.jpg (or change this path).
  static const image = 'assets/profile.jpg';
}

const ink = Color(0xFF14213D);
const paper = Color(0xFFEEF2F6);
const blue = Color(0xFF2A6F97);
const sun = Color(0xFFF2C14E);

void main() => runApp(const LandingApp());

class LandingApp extends StatelessWidget {
  const LandingApp({super.key});

  @override
  Widget build(BuildContext context) {
    var apply = GoogleFonts.dmSansTextTheme().apply(
          bodyColor: ink,
          displayColor: ink,
        );
    return MaterialApp(
      title: Profile.name,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: paper,
        colorScheme: ColorScheme.fromSeed(seedColor: blue),
      //  textTheme: apply,
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 860;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.sizeOf(context).height -
                  MediaQuery.paddingOf(context).vertical,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: wide ? 48 : 24,
                    vertical: wide ? 48 : 32,
                  ),
                  child: wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(flex: 6, child: _Intro()),
                            const SizedBox(width: 64),
                            Expanded(
                              flex: 5,
                              child: _Portrait(size: 420),
                            ),
                          ],
                        )
                      : const Column(
                          children: [
                            _Portrait(size: 280),
                            SizedBox(height: 36),
                            _Intro(),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 860;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Profile.name,
          style: GoogleFonts.bricolageGrotesque(
            fontSize: wide ? 84 : 48,
            fontWeight: FontWeight.w800,
            height: 1.0,
            letterSpacing: -2,
            color: ink,
          ),
        ),
        const SizedBox(height: 20),
        Container(width: 72, height: 6, color: sun),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Text(
            Profile.role,
            style: const TextStyle(fontSize: 20, height: 1.5),
          ),
        ),
        const SizedBox(height: 40),
        _ContactRow(
          icon: Icons.call_outlined,
          label: Profile.phone,
          actionLabel: 'Call',
          uri: Uri(scheme: 'tel', path: Profile.phone.replaceAll(' ', '')),
        ),
        const SizedBox(height: 12),
        _ContactRow(
          icon: Icons.mail_outline,
          label: Profile.email,
          actionLabel: 'Email',
          uri: Uri(scheme: 'mailto', path: Profile.email),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.actionLabel,
    required this.uri,
  });

  final IconData icon;
  final String label;
  final String actionLabel;
  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ink.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Icon(icon, color: blue),
            const SizedBox(width: 14),
            Expanded(
              child: SelectableText(
                label,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            IconButton(
              tooltip: 'Copy',
              icon: const Icon(Icons.copy_rounded, size: 20),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: label));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied'), duration: Duration(seconds: 1)),
                  );
                }
              },
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: ink,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => launchUrl(uri),
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _Portrait extends StatelessWidget {
  const _Portrait({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    final initials = Profile.name
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();
    return Center(
      child: SizedBox(
        width: size,
        height: size * 1.2,
        child: Stack(
          children: [
            // Offset block behind the photo.
            Positioned(
              left: 18,
              top: 18,
              right: -18,
              bottom: -18,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: blue,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(size / 2),
                    bottom: const Radius.circular(24),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(size / 2),
                  bottom: const Radius.circular(24),
                ),
                child: Image.asset(
                  Profile.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: ink,
                    alignment: Alignment.center,
                    child: Text(
                      initials,
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: size / 3,
                        fontWeight: FontWeight.w800,
                        color: paper,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}