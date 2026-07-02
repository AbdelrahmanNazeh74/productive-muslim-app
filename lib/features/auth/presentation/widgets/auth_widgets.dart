import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../shared/theme/app_theme.dart';

// Google "G" logo SVG — inline so no network request is needed.
const _kGoogleLogoSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
  <path fill="#4285F4" d="M23.745 12.27c0-.79-.07-1.54-.19-2.27h-11.3v4.51h6.47
    c-.29 1.48-1.14 2.73-2.4 3.58v3h3.86c2.26-2.09 3.56-5.17 3.56-8.82z"/>
  <path fill="#34A853" d="M12.255 24c3.24 0 5.95-1.08 7.93-2.91l-3.86-3
    c-1.08.72-2.45 1.16-4.07 1.16-3.13 0-5.78-2.11-6.73-4.96h-3.98v3.09
    C3.515 21.3 7.565 24 12.255 24z"/>
  <path fill="#FBBC05" d="M5.525 14.29c-.25-.72-.38-1.49-.38-2.29s.14-1.57
    .38-2.29V6.62h-3.98a11.86 11.86 0 000 10.76l3.98-3.09z"/>
  <path fill="#EA4335" d="M12.255 4.75c1.77 0 3.35.61 4.6 1.8l3.42-3.42
    C18.205 1.19 15.495 0 12.255 0c-4.69 0-8.74 2.7-10.71 6.62l3.98 3.09
    c.95-2.85 3.6-4.96 6.73-4.96z"/>
</svg>
''';

// Button styled per Google sign-in branding guidelines:
// white background, #dadce0 border, Google G logo, Roboto medium text.
class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.12),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFDADCE0)),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF4285F4)),
                    ),
                  )
                else
                  SvgPicture.string(
                    _kGoogleLogoSvg,
                    width: 20,
                    height: 20,
                  ),
                const SizedBox(width: 12),
                Text(
                  isLoading ? 'Signing in...' : 'Continue with Google',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3C4043),
                    letterSpacing: 0.25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Divider with "or" text between sign-in options.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.white30, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: AppTextStyles.bodyMedium
                .copyWith(color: Colors.white.withValues(alpha: 0.6)),
          ),
        ),
        const Expanded(child: Divider(color: Colors.white30, thickness: 1)),
      ],
    );
  }
}
