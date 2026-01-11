import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:adhan/adhan.dart';
import '../../../core/app_theme.dart';
import '../data/prayer_repository.dart';

class PrayerTimesCard extends ConsumerWidget {
  const PrayerTimesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerTimesAsync = ref.watch(prayerTimesProvider);

    return prayerTimesAsync.when(
      data: (prayerTimes) {
        if (prayerTimes == null) {
          return _buildErrorCard('يرجى تفعيل الموقع لعرض أوقات الصلاة');
        }

        final nextPrayer = prayerTimes.nextPrayer();
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.deepTwilight,
                AppTheme.deepTwilight.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: AppTheme.deepTwilight.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'أوقات الصلاة',
                        style: AppTheme.arabicStyle.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        DateFormat('EEEE, d MMMM', 'ar').format(DateTime.now()),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.mosque,
                    color: AppTheme.mutedGold,
                    size: 40,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _PrayerItem(
                    name: 'الفجر',
                    time: prayerTimes.fajr,
                    isActive: nextPrayer == Prayer.fajr,
                  ),
                  _PrayerItem(
                    name: 'الظهر',
                    time: prayerTimes.dhuhr,
                    isActive: nextPrayer == Prayer.dhuhr,
                  ),
                  _PrayerItem(
                    name: 'العصر',
                    time: prayerTimes.asr,
                    isActive: nextPrayer == Prayer.asr,
                  ),
                  _PrayerItem(
                    name: 'المغرب',
                    time: prayerTimes.maghrib,
                    isActive: nextPrayer == Prayer.maghrib,
                  ),
                  _PrayerItem(
                    name: 'العشاء',
                    time: prayerTimes.isha,
                    isActive: nextPrayer == Prayer.isha,
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const _LoadingCard(),
      error: (err, stack) => _buildErrorCard('حدث خطأ أثناء جلب أوقات الصلاة'),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_off, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerItem extends StatelessWidget {
  final String name;
  final DateTime time;
  final bool isActive;

  const _PrayerItem({
    required this.name,
    required this.time,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            color: isActive ? AppTheme.mutedGold : Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.mutedGold.withValues(alpha: 0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isActive ? Border.all(color: AppTheme.mutedGold, width: 1) : null,
          ),
          child: Text(
            DateFormat.Hm().format(time),
            style: TextStyle(
              color: isActive ? AppTheme.mutedGold : Colors.white,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 180,
      decoration: BoxDecoration(
        color: AppTheme.deepTwilight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppTheme.sageGreen),
      ),
    );
  }
}
