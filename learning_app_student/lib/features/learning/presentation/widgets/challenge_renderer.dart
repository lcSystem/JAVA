import 'package:flutter/material.dart';

class ChallengeRenderer extends StatelessWidget {
  final Map<String, dynamic> challenge;
  final Function(String) onAnswerSubmit;

  const ChallengeRenderer({
    Key? key,
    required this.challenge,
    required this.onAnswerSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String type = challenge['type'] ?? 'UNKNOWN';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            challenge['question'] ?? "Selecciona la opción correcta",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3C3C3C),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          _buildChallengeContent(type),
        ],
      ),
    );
  }

  Widget _buildChallengeContent(String type) {
    switch (type) {
      case 'MULTIPLE_CHOICE':
        return _buildMultipleChoice();
      case 'FILL_BLANK':
        return _buildFillBlank();
      case 'TRUE_FALSE':
        return _buildTrueFalse();
      default:
        return Center(child: Text("Challenge Type $type not implemented yet."));
    }
  }

  Widget _buildMultipleChoice() {
    final options = ["Opción A", "Opción B", "Opción C", "Opción D"];
    return Column(
      children: options.map((opt) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: InkWell(
          onTap: () => onAnswerSubmit(opt),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFE5E5E5), width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Color(0xFFE5E5E5), child: Text(opt.substring(0,1), style: TextStyle(color: Colors.grey))),
                SizedBox(width: 16),
                Text(opt, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildFillBlank() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("La capital de Francia es ", style: TextStyle(fontSize: 20)),
            Container(
              width: 100,
              decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2))),
            ),
          ],
        ),
        SizedBox(height: 40),
        Wrap(
          spacing: 10,
          children: ["Lyon", "Paris", "Marseille"].map((city) => ActionChip(
            label: Text(city),
            onPressed: () => onAnswerSubmit(city),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(10)),
          )).toList(),
        )
      ],
    );
  }

  Widget _buildTrueFalse() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => onAnswerSubmit("TRUE"),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF58CC02), padding: EdgeInsets.all(24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            child: Text("VERDADERO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => onAnswerSubmit("FALSE"),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF4B4B), padding: EdgeInsets.all(24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
            child: Text("FALSO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}
