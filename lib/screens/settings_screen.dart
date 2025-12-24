import 'package:flutter/material.dart';
import 'package:lumora/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/storage_service.dart';
import 'disclaimer_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = packageInfo.version;
      });
    }
  }

  Future<void> _reshowDisclaimer(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('disclaimer_shown');
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DisclaimerScreen(
            onAccept: () async {
              await prefs.setBool('disclaimer_shown', true);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      );
    }
  }

  Future<void> _deleteAllData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2937),
        title: Text(
          AppLocalizations.of(context)!.deleteAllDataTitle,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          AppLocalizations.of(context)!.deleteAllDataConfirmation,
          style: const TextStyle(color: Color(0xFFD1D5DB)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final storageService = StorageService();
      await storageService.clearAllData();
      if (context.mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.dataDeleted),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        title: Text(
          l10n.settingsTitle,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildSection(context, l10n.dataSection, [
                  _buildTile(
                    context,
                    icon: Icons.delete_sweep,
                    title: l10n.deleteAllDataTitle,
                    subtitle: l10n.deleteAllDataSubtitle,
                    onTap: () => _deleteAllData(context),
                    color: Colors.red,
                  ),
                ]),
                _buildSection(context, l10n.appSection, [
                  _buildTile(
                    context,
                    icon: Icons.description,
                    title: l10n.reshowDisclaimer,
                    subtitle: l10n.reshowDisclaimerSubtitle,
                    onTap: () => _reshowDisclaimer(context),
                  ),
                ]),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(
              '${l10n.appName} v$_appVersion',
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? const Color(0xFF9CA3AF)),
        title: Text(
          title,
          style: TextStyle(
            color: color ?? Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(color: Color(0xFF9CA3AF)))
            : null,
        trailing: Icon(Icons.chevron_right, color: const Color(0xFF4B5563)),
        onTap: onTap,
      ),
    );
  }
}
