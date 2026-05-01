import 'package:flutter/material.dart';
import '../models/publicacion.dart';
import '../services/servicio_api.dart';
import 'pantalla_detalle.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Red Social'),
      ),
      body: FutureBuilder<List<Publicacion>>(
        future: ServicioApi.obtenerPosts(),
        
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final listaPosts = snapshot.data!;

          return ListView.builder(
            itemCount: listaPosts.length,
            itemBuilder: (context, index) {
              final publicacion = listaPosts[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${publicacion.id}')),
                title: Text(
                  publicacion.titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  publicacion.contenido,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PantallaDetalle(publicacion: publicacion),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
