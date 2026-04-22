import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/avatar_state_model.dart';

class VisualAssetGallery extends StatelessWidget {
  static const hairOptions = [
    {'id': 'shortCombover', 'label': 'Corto Elegante'},
    {'id': 'shortComboverChops', 'label': 'Corto con Patillas'},
    {'id': 'long', 'label': 'Largo Clásico'},
    {'id': 'extraLong', 'label': 'Extra Largo'},
    {'id': 'bobCut', 'label': 'Bob Clásico'},
    {'id': 'bobBangs', 'label': 'Bob con Flequillo'},
    {'id': 'curly', 'label': 'Rizado'},
    {'id': 'curlyBun', 'label': 'Moño Rizado'},
    {'id': 'curlyHighTop', 'label': 'Rizado Alto'},
    {'id': 'pigtails', 'label': 'Coletas'},
    {'id': 'straightBun', 'label': 'Moño Liso'},
    {'id': 'bunUndercut', 'label': 'Moño Undercut'},
    {'id': 'buzzcut', 'label': 'Militar / Crew'},
    {'id': 'fade', 'label': 'Fade / Degradado'},
    {'id': 'mohawk', 'label': 'Mohicano'},
    {'id': 'sideShave', 'label': 'Pixie / Lateral'},
    {'id': 'cap', 'label': 'Con Gorra'},
    {'id': 'beanie', 'label': 'Gorro de Lana'},
    {'id': 'balding', 'label': 'Entradas'},
    {'id': 'bald', 'label': 'Rapado'},
  ];

  static const eyeOptions = [
    {'id': 'open', 'label': 'Abiertos'},
    {'id': 'happy', 'label': 'Felices'},
    {'id': 'wink', 'label': 'Guiño'},
    {'id': 'sleep', 'label': 'Somnolientos'},
    {'id': 'glasses', 'label': 'Con Gafas'},
    {'id': 'sunglasses', 'label': 'Gafas de Sol'},
  ];

  static const mouthOptions = [
    {'id': 'smile', 'label': 'Sonrisa'},
    {'id': 'bigSmile', 'label': 'Sonrisa Grande'},
    {'id': 'smirk', 'label': 'Neutral / Mueca'},
    {'id': 'frown', 'label': 'Serio / Triste'},
    {'id': 'surprise', 'label': 'Sorprendido'},
    {'id': 'lips', 'label': 'Labios Marcados'},
    {'id': 'pacifier', 'label': 'Chupete'},
  ];

  static const noseOptions = [
    {'id': 'mediumRound', 'label': 'Estándar'},
    {'id': 'smallRound', 'label': 'Pequeña'},
    {'id': 'wrinkles', 'label': 'Respingada/Arrugas'},
  ];

  final String title;
  final String category; // 'hair', 'eyes', 'mouth', 'nose'
  final String selectedId;
  final List<Map<String, String>> options;
  final Function(String) onSelected;
  final AvatarState currentState;

  const VisualAssetGallery({
    super.key,
    required this.title,
    required this.category,
    required this.selectedId,
    required this.options,
    required this.onSelected,
    required this.currentState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: options.length,
            itemBuilder: (context, index) {
              final opt = options[index];
              final isSelected = selectedId == opt['id'];
              
              // Generate a preview URL for this specific option
              final previewState = currentState.copyWith(
                hair: category == 'hair' ? opt['id'] : null,
                eyes: category == 'eyes' ? opt['id'] : null,
                mouth: category == 'mouth' ? opt['id'] : null,
                nose: category == 'nose' ? opt['id'] : null,
              );

              return GestureDetector(
                onTap: () => onSelected(opt['id']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.network(
                            previewState.toDiceBearUrl(),
                            placeholderBuilder: (context) => const Center(child: SizedBox(width: 10, height: 10, child: CircularProgressIndicator(strokeWidth: 1))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          opt['label']!,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.blue : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SkinToneStudioPicker extends StatelessWidget {
  final String selectedTone;
  final Function(String) onSelected;

  const SkinToneStudioPicker({super.key, required this.selectedTone, required this.onSelected});

  static const List<Map<String, String>> _tones = [
    {'id': 'fde7d1', 'label': 'Pálido'},
    {'id': 'fadcc0', 'label': 'Claro'},
    {'id': 'ebc196', 'label': 'Trigueño C.'},
    {'id': 'd6a57c', 'label': 'Trigueño'},
    {'id': 'b98457', 'label': 'Canela'},
    {'id': 'a26b40', 'label': 'Moreno'},
    {'id': '7e4a2f', 'label': 'Oscuro'},
    {'id': '4b2e1e', 'label': 'Ébano'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text('Tono de Piel Realista', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        ),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _tones.length,
            itemBuilder: (context, index) {
              final tone = _tones[index];
              final isSelected = selectedTone == tone['id'];
              final color = Color(int.parse('FF${tone['id']}', radix: 16));

              return GestureDetector(
                onTap: () => onSelected(tone['id']!),
                child: Container(
                  width: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow: isSelected ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8)] : null,
                  ),
                  child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
