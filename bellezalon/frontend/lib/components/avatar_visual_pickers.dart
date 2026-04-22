import 'package:flutter/material.dart';

class SkinTonePicker extends StatelessWidget {
  final String? selectedTone;
  final Function(String) onSelected;

  const SkinTonePicker({super.key, this.selectedTone, required this.onSelected});

  static const List<Map<String, dynamic>> _tones = [
    {'id': 'muy_claro', 'color': Color(0xFFFFF3E0), 'label': 'Muy Blanco'},
    {'id': 'claro', 'color': Color(0xFFFBE9E7), 'label': 'Claro'},
    {'id': 'medio_claro', 'color': Color(0xFFFFCCBC), 'label': 'Trigueño C.'},
    {'id': 'medio', 'color': Color(0xFFD7CCC8), 'label': 'Trigueño'},
    {'id': 'moreno_claro', 'color': Color(0xFFBCAAA4), 'label': 'Moreno C.'},
    {'id': 'moreno', 'color': Color(0xFFA1887F), 'label': 'Moreno'},
    {'id': 'oscuro', 'color': Color(0xFF8D6E63), 'label': 'Canela'},
    {'id': 'muy_oscuro', 'color': Color(0xFF5D4037), 'label': 'Ebano'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tono de Piel', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _tones.length,
            itemBuilder: (context, index) {
              final tone = _tones[index];
              final isSelected = selectedTone == tone['id'];
              return GestureDetector(
                onTap: () => onSelected(tone['id']),
                child: Container(
                  width: 50,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: tone['color'],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow: isSelected ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8)] : null,
                  ),
                  child: isSelected ? const Icon(Icons.check, color: Colors.blueGrey) : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class VisualShapeSelector extends StatelessWidget {
  final String title;
  final String? selectedId;
  final List<Map<String, dynamic>> options;
  final Function(String) onSelected;

  const VisualShapeSelector({
    super.key,
    required this.title,
    this.selectedId,
    required this.options,
    required this.onSelected,
  });

  Widget _buildShapeVisual(String id, Color color) {
    if (id == 'liso' || id == 'ondulado' || id == 'crespo' || id == 'afro' || id == 'rapado' || id == 'corto') {
      // Hair visuals
      return _buildHairVisual(id, color);
    }

    // Face shapes
    return Container(
      width: 40,
      height: 50,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color, width: 2),
        borderRadius: _getBorderRadiusForFace(id),
      ),
      child: CustomPaint(
        painter: FaceFeaturesPainter(color),
      ),
    );
  }

  BorderRadius _getBorderRadiusForFace(String id) {
    switch (id) {
      case 'ovalado': return const BorderRadius.all(Radius.elliptical(100, 150));
      case 'redondo': return BorderRadius.circular(100);
      case 'cuadrado': return BorderRadius.circular(8);
      case 'diamante': return const BorderRadius.only(
        topLeft: Radius.circular(50), 
        bottomRight: Radius.circular(50),
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(20),
      );
      case 'corazon': return const BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
        bottomLeft: Radius.circular(100),
        bottomRight: Radius.circular(100),
      );
      case 'largo': return const BorderRadius.all(Radius.elliptical(100, 200));
      default: return BorderRadius.circular(16);
    }
  }

  Widget _buildHairVisual(String id, Color color) {
    return SizedBox(
      width: 45,
      height: 45,
      child: CustomPaint(painter: HairPainter(id, color)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.85,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            final opt = options[index];
            final isSelected = selectedId == opt['id'];
            final color = isSelected ? Colors.blue : Colors.blueGrey;
            
            return GestureDetector(
              onTap: () => onSelected(opt['id']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade200, width: 1.5),
                  boxShadow: isSelected ? [BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 4)] : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShapeVisual(opt['id'], color),
                    const SizedBox(height: 10),
                    Text(opt['label'], style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.blue : Colors.black87)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class FaceFeaturesPainter extends CustomPainter {
  final Color color;
  FaceFeaturesPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color..style = PaintingStyle.fill..strokeWidth = 1.5;
    // Eyes
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.45), 2, p);
    canvas.drawCircle(Offset(size.width * 0.65, size.height * 0.45), 2, p);
    // Mouth
    p.style = PaintingStyle.stroke;
    final path = Path()..moveTo(size.width * 0.4, size.height * 0.75)..quadraticBezierTo(size.width * 0.5, size.height * 0.8, size.width * 0.6, size.height * 0.75);
    canvas.drawPath(path, p);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HairPainter extends CustomPainter {
  final String type;
  final Color color;
  HairPainter(this.type, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2;
    switch (type) {
      case 'liso':
        for (double i=0; i<size.width; i+=4) canvas.drawLine(Offset(i, 0), Offset(i, size.height), p);
        break;
      case 'ondulado':
        for (double i=0; i<size.width; i+=8) {
          final path = Path()..moveTo(i, 0);
          for (double j=0; j<size.height; j+=10) path.relativeQuadraticBezierTo(5, 5, 0, 10);
          canvas.drawPath(path, p);
        }
        break;
      case 'crespo':
        for (double i=0; i<size.width; i+=6) {
          final path = Path()..moveTo(i, 0);
          for (double j=0; j<size.height; j+=8) path.relativeCubicTo(5, -2, -5, 10, 0, 8);
          canvas.drawPath(path, p);
        }
        break;
      case 'afro':
        p.style = PaintingStyle.fill;
        for (double i=0; i<size.width; i+=6) {
          for (double j=0; j<size.height; j+=6) {
            canvas.drawCircle(Offset(i + (j%4), j), 4, p);
          }
        }
        break;
      case 'rapado':
        p.strokeWidth = 1;
        for (double i=0; i<size.width; i+=3) {
          for (double j=0; j<size.height; j+=3) {
            canvas.drawCircle(Offset(i, j), 0.5, p);
          }
        }
        break;
      case 'corto':
        for (double i=5; i<size.width; i+=10) {
          canvas.drawLine(Offset(i, 5), Offset(i+5, 20), p);
          canvas.drawLine(Offset(i+2, 10), Offset(i-3, 25), p);
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
