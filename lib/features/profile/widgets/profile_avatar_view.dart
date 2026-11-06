import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/network/api_client.dart';

/// Reusable avatar widget that reliably handles:
/// 1. Base64 data URIs (`data:image/jpeg;base64,...`) and raw Base64 strings.
/// 2. Remote HTTP/HTTPS URLs.
/// 3. Relative API upload paths (`/uploads/...`).
/// 4. Graceful initial fallback (e.g. 'D' or 'M' on institutional emerald/teal background).
class ProfileAvatarView extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String? username;
  final double size;
  final bool showCameraBadge;
  final VoidCallback? onCameraTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final bool? isDark;

  const ProfileAvatarView({
    super.key,
    required this.avatarUrl,
    required this.name,
    this.username,
    this.size = 80,
    this.showCameraBadge = false,
    this.onCameraTap,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 2.0,
    this.isDark,
  });

  bool _isDarkMode(BuildContext context) {
    if (isDark != null) return isDark!;
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Extracts the 1st letter of the username or full name (capitalized).
  /// Gracefully handles emails (e.g. "pranab@..." -> "P"), handles prefixes ("@pranab" -> "P").
  String get _initial {
    String source = '';
    if (username != null && username!.trim().isNotEmpty) {
      source = username!.trim();
    } else if (name.trim().isNotEmpty) {
      source = name.trim();
    }
    if (source.isEmpty) return 'A';

    // Remove leading punctuation or handle prefixes (e.g. "@sarkar" -> "sarkar")
    source = source.replaceFirst(RegExp(r'^[@_.\s]+'), '');
    if (source.isEmpty) return 'A';

    // If string is an email address (e.g. "pranab@alumni.edu"), strip the domain
    if (source.contains('@')) {
      source = source.split('@').first;
    }
    if (source.isEmpty) return 'A';

    return source.substring(0, 1).toUpperCase();
  }

  bool get _hasValidAvatar {
    final trimmed = avatarUrl.trim();
    if (trimmed.isEmpty) return false;
    final lower = trimmed.toLowerCase();
    if (lower == 'null' || lower == 'undefined' || lower == 'none') return false;
    return true;
  }

  Uint8List? _tryDecodeBase64(String input) {
    try {
      final clean = input.contains(',') ? input.split(',').last : input;
      final normalized = base64.normalize(clean.trim());
      return base64Decode(normalized);
    } catch (_) {
      return null;
    }
  }

  Widget _buildFallbackAvatar(BuildContext context) {
    final dark = _isDarkMode(context);
    final effectiveBg = backgroundColor ??
        (dark ? const Color(0xFF042F2C) : const Color(0xFFE6F4EA));
    final effectiveText =
        dark ? const Color(0xFF34D399) : const Color(0xFF044E3D);
    final effectiveBorder = borderColor ??
        (dark
            ? const Color(0xFF10B981).withValues(alpha: 0.5)
            : const Color(0xFFA7F3D0));

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: effectiveBg,
        shape: BoxShape.circle,
        border: Border.all(
          color: effectiveBorder,
          width: borderWidth,
        ),
      ),
      child: Center(
        child: Text(
          _initial,
          style: GoogleFonts.manrope(
            fontSize: size * 0.42,
            fontWeight: FontWeight.w800,
            color: effectiveText,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBase64 = avatarUrl.startsWith('data:image/') ||
        (!avatarUrl.startsWith('http') && !avatarUrl.startsWith('/') && avatarUrl.length > 100);

    Widget imageContent;

    if (!_hasValidAvatar) {
      imageContent = _buildFallbackAvatar(context);
    } else if (isBase64) {
      final bytes = _tryDecodeBase64(avatarUrl);
      if (bytes != null && bytes.isNotEmpty) {
        imageContent = ClipOval(
          child: Image.memory(
            bytes,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildFallbackAvatar(context),
          ),
        );
      } else {
        imageContent = _buildFallbackAvatar(context);
      }
    } else {
      final effectiveUrl = avatarUrl.startsWith('http')
          ? avatarUrl
          : ApiClient.formatUrl(avatarUrl);

      imageContent = ClipOval(
        child: Image.network(
          effectiveUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackAvatar(context),
        ),
      );
    }

    final avatarWithBorder = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? const Color(0xFF10B981),
          width: borderWidth,
        ),
      ),
      child: imageContent,
    );

    if (!showCameraBadge) {
      return avatarWithBorder;
    }

    final badgeSize = size * 0.32;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatarWithBorder,
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onCameraTap,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isDarkMode(context)
                      ? const Color(0xFF0F172A)
                      : Colors.white,
                  width: 2.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                size: badgeSize * 0.58,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
