import 'package:flutter_test/flutter_test.dart';

import 'package:app_record/main.dart';

void main() {
  testWidgets('Login smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AppRecord());

    expect(find.text('Inicia sesión para continuar'), findsOneWidget);
    expect(find.text('Correo Electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Ingresar'), findsOneWidget);
  });
}

