import 'package:flutter/material.dart';
import '../models/publicacion.dart';
import '../models/usuario.dart';
import '../models/comentario.dart';
import '../services/servicio_api.dart';

class PantallaDetalle extends StatelessWidget {
  final Publicacion publicacion;

  const PantallaDetalle({super.key, required this.publicacion});

  Future<Map<String, dynamic>> _cargarDatos() async {
    final resultados = await Future.wait([
      ServicioApi.obtenerUsuario(publicacion.usuarioId),
      ServicioApi.obtenerComentarios(publicacion.id),
    ]);
    return {
      'usuario': resultados[0] as Usuario,
      'comentarios': resultados[1] as List<Comentario>,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _cargarDatos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final usuario = snapshot.data!['usuario'] as Usuario;
          final comentarios =
              snapshot.data!['comentarios'] as List<Comentario>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  publicacion.titulo,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),

                Text(publicacion.contenido),
                const SizedBox(height: 16),

                const Divider(),
                Text(
                  'Autor',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(usuario.nombre),
                  subtitle: Text('${usuario.email}\n${usuario.ciudad}'),
                  isThreeLine: true,
                ),

                const Divider(),
                Text(
                  'Comentarios (${comentarios.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),

                ...comentarios.map((comentario) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comentario.nombre,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              comentario.email,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(comentario.contenido),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
