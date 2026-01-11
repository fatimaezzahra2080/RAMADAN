import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/app_theme.dart';
import '../../../core/providers.dart';
import '../../worship/presentation/micro_audio_player.dart';
import '../domain/adhkar_item.dart';

class AdhkarScreen extends ConsumerStatefulWidget {
  const AdhkarScreen({super.key});

  @override
  ConsumerState<AdhkarScreen> createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends ConsumerState<AdhkarScreen> {
  late String _currentType;
  late String _currentLang;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _currentType = args?['type'] ?? 'morning';
    final settingsBox = Hive.box('settings');
    _currentLang = settingsBox.get('language', defaultValue: 'ar');
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(adhkarRepositoryProvider);
    final items = repository.getAdhkarByType(_currentType);

    final title = _currentLang == 'ar'
        ? (_currentType == 'morning' ? 'أذكار الصباح' : 'أذكار المساء')
        : (_currentType == 'morning' ? 'Morning Adhkar' : 'Evening Adhkar');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              setState(() {
                _currentLang = _currentLang == 'ar' ? 'en' : 'ar';
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _AdhkarCard(item: item, lang: _currentLang);
        },
      ),
    );
  }
}

class _AdhkarCard extends StatefulWidget {
  final AdhkarItem item;
  final String lang;

  const _AdhkarCard({required this.item, required this.lang});

  @override
  State<_AdhkarCard> createState() => _AdhkarCardState();
}

class _AdhkarCardState extends State<_AdhkarCard> {
  int _currentCount = 0;

  @override
  Widget build(BuildContext context) {
    final isAr = widget.lang == 'ar';
    final content = isAr ? widget.item.contentAr : widget.item.contentEn;
    final description = isAr ? widget.item.descriptionAr : widget.item.descriptionEn;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.sageGreen.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            content,
            textAlign: TextAlign.center,
            style: isAr
                ? AppTheme.arabicStyle.copyWith(fontSize: 22)
                : GoogleFonts.quicksand(fontSize: 18, color: AppTheme.deepTwilight),
          ),
          if (description != null) ...[
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 14,
                color: AppTheme.deepTwilight.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (widget.item.audioPath != null) ...[
            const SizedBox(height: 16),
            MicroAudioPlayer(assetPath: widget.item.audioPath!),
          ],
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              if (_currentCount < widget.item.count) {
                setState(() => _currentCount++);
              }
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentCount == widget.item.count
                    ? AppTheme.sageGreen
                    : AppTheme.softCream,
                border: Border.all(
                  color: AppTheme.sageGreen.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  '$_currentCount / ${widget.item.count}',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: _currentCount == widget.item.count
                        ? Colors.white
                        : AppTheme.sageGreen,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
