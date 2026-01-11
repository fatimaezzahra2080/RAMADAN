import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/app_theme.dart';
import '../../../core/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsBox = Hive.box('settings');
    final currentLang = settingsBox.get('language', defaultValue: 'ar');
    final isAr = currentLang == 'ar';
    
    // Daily Reminder
    final isEnabled = settingsBox.get('daily_notification_enabled', defaultValue: true);
    final hour = settingsBox.get('notification_hour', defaultValue: 9);
    final minute = settingsBox.get('notification_minute', defaultValue: 0);

    // Morning Adhkar
    final isMorningEnabled = settingsBox.get('morning_adhkar_enabled', defaultValue: false);
    final morningHour = settingsBox.get('morning_adhkar_hour', defaultValue: 6);
    final morningMinute = settingsBox.get('morning_adhkar_minute', defaultValue: 30);

    // Evening Adhkar
    final isEveningEnabled = settingsBox.get('evening_adhkar_enabled', defaultValue: false);
    final eveningHour = settingsBox.get('evening_adhkar_hour', defaultValue: 17);
    final eveningMinute = settingsBox.get('evening_adhkar_minute', defaultValue: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAr ? "الإعدادات" : "Settings",
          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader(isAr ? "اللغة" : "Language"),
          const SizedBox(height: 16),
          _buildSettingTile(
            title: isAr ? "لغة التطبيق" : "App Language",
            subtitle: isAr ? "العربية" : "English",
            trailing: Icon(isAr ? Icons.language : Icons.translate, color: AppTheme.sageGreen),
            onTap: () async {
              final newLang = isAr ? 'en' : 'ar';
              await settingsBox.put('language', newLang);
              (context as Element).markNeedsBuild();
            },
          ),
          const Divider(height: 32),
          _buildSectionHeader(isAr ? "التنبيهات" : "Notifications"),
          const SizedBox(height: 16),
          
          // Daily Reminder
          _buildSettingTile(
            title: isAr ? "تنبيه العبادة اليومية" : "Daily Worship Reminder",
            subtitle: isAr ? "تذكير يومي بسيط بمهامك الروحية" : "A simple daily reminder for your spiritual tasks",
            trailing: Switch.adaptive(
              value: isEnabled,
              activeTrackColor: AppTheme.sageGreen,
              onChanged: (value) async {
                await settingsBox.put('daily_notification_enabled', value);
                if (value) {
                  await ref.read(notificationServiceProvider).scheduleDailyReminder(
                        hour: hour,
                        minute: minute,
                      );
                } else {
                  await ref.read(notificationServiceProvider).cancelSpecific(0);
                }
                (context as Element).markNeedsBuild();
              },
            ),
          ),
          if (isEnabled) ...[
            const SizedBox(height: 8),
            _buildSettingTile(
              title: isAr ? "وقت التنبيه اليومي" : "Daily Reminder Time",
              subtitle: "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}",
              onTap: () async {
                final time = await _showTimePicker(context, hour, minute);
                if (time != null) {
                  await settingsBox.put('notification_hour', time.hour);
                  await settingsBox.put('notification_minute', time.minute);
                  await ref.read(notificationServiceProvider).scheduleDailyReminder(
                        hour: time.hour,
                        minute: time.minute,
                      );
                  (context as Element).markNeedsBuild();
                }
              },
            ),
          ],
          
          const Divider(height: 32),
          
          // Morning Adhkar
          _buildSettingTile(
            title: isAr ? "أذكار الصباح" : "Morning Adhkar",
            subtitle: isAr ? "تنبيه يومي لقراءة أذكار الصباح" : "Daily reminder for Morning Adhkar",
            trailing: Switch.adaptive(
              value: isMorningEnabled,
              activeTrackColor: AppTheme.sageGreen,
              onChanged: (value) async {
                await settingsBox.put('morning_adhkar_enabled', value);
                if (value) {
                  await ref.read(notificationServiceProvider).scheduleMorningAdhkar(
                        hour: morningHour,
                        minute: morningMinute,
                      );
                } else {
                  await ref.read(notificationServiceProvider).cancelSpecific(1);
                }
                (context as Element).markNeedsBuild();
              },
            ),
          ),
          if (isMorningEnabled) ...[
            const SizedBox(height: 8),
            _buildSettingTile(
              title: isAr ? "وقت أذكار الصباح" : "Morning Adhkar Time",
              subtitle: "${morningHour.toString().padLeft(2, '0')}:${morningMinute.toString().padLeft(2, '0')}",
              onTap: () async {
                final time = await _showTimePicker(context, morningHour, morningMinute);
                if (time != null) {
                  await settingsBox.put('morning_adhkar_hour', time.hour);
                  await settingsBox.put('morning_adhkar_minute', time.minute);
                  await ref.read(notificationServiceProvider).scheduleMorningAdhkar(
                        hour: time.hour,
                        minute: time.minute,
                      );
                  (context as Element).markNeedsBuild();
                }
              },
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Evening Adhkar
          _buildSettingTile(
            title: isAr ? "أذكار المساء" : "Evening Adhkar",
            subtitle: isAr ? "تنبيه يومي لقراءة أذكار المساء" : "Daily reminder for Evening Adhkar",
            trailing: Switch.adaptive(
              value: isEveningEnabled,
              activeTrackColor: AppTheme.sageGreen,
              onChanged: (value) async {
                await settingsBox.put('evening_adhkar_enabled', value);
                if (value) {
                  await ref.read(notificationServiceProvider).scheduleEveningAdhkar(
                        hour: eveningHour,
                        minute: eveningMinute,
                      );
                } else {
                  await ref.read(notificationServiceProvider).cancelSpecific(2);
                }
                (context as Element).markNeedsBuild();
              },
            ),
          ),
          if (isEveningEnabled) ...[
            const SizedBox(height: 8),
            _buildSettingTile(
              title: isAr ? "وقت أذكار المساء" : "Evening Adhkar Time",
              subtitle: "${eveningHour.toString().padLeft(2, '0')}:${eveningMinute.toString().padLeft(2, '0')}",
              onTap: () async {
                final time = await _showTimePicker(context, eveningHour, eveningMinute);
                if (time != null) {
                  await settingsBox.put('evening_adhkar_hour', time.hour);
                  await settingsBox.put('evening_adhkar_minute', time.minute);
                  await ref.read(notificationServiceProvider).scheduleEveningAdhkar(
                        hour: time.hour,
                        minute: time.minute,
                      );
                  (context as Element).markNeedsBuild();
                }
              },
            ),
          ],

          const SizedBox(height: 32),
          _buildSectionHeader(isAr ? "معلومات التطبيق" : "App Info"),
          const SizedBox(height: 16),
          _buildSettingTile(
            title: isAr ? "الإصدار" : "Version",
            subtitle: "1.0.0",
          ),
          _buildSettingTile(
            title: isAr ? "عن رمضان 365" : "About Ramadan 365",
            subtitle: isAr 
                ? "الحفاظ على روح رمضان طوال العام من خلال عبادات بسيطة ومستمرة."
                : "Keeping the spirit of Ramadan alive every day of the year through small, consistent acts of worship.",
          ),
        ],
      ),
    );
  }

  Future<TimeOfDay?> _showTimePicker(BuildContext context, int hour, int minute) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.sageGreen,
              onPrimary: Colors.white,
              onSurface: AppTheme.deepTwilight,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.quicksand(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppTheme.sageGreen,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        onTap: onTap,
        title: Text(
          title,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            color: AppTheme.deepTwilight,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.quicksand(
            fontSize: 13,
            color: AppTheme.deepTwilight.withValues(alpha: 0.6),
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}
