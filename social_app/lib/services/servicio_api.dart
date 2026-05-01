import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/publicacion.dart';
import '../models/comentario.dart';
import '../models/usuario.dart';

class ServicioApi {
  static const String urlBase = "https://jsonplaceholder.typicode.com";

  static Future<List<Publicacion>> obtenerPosts() async {
    final respuesta = await http.get(Uri.parse("$urlBase/posts"));
    if (respuesta.statusCode == 200) {
      final List datos = json.decode(respuesta.body);
      return datos.map((e) => Publicacion.fromJson(e)).toList();
    } else {
      throw Exception("Error al cargar publicaciones");
    }
  }

  static Future<Usuario> obtenerUsuario(int usuarioId) async {
    final respuesta = await http.get(Uri.parse("$urlBase/users/$usuarioId"));
    if (respuesta.statusCode == 200) {
      return Usuario.fromJson(json.decode(respuesta.body));
    } else {
      throw Exception("Error al cargar usuario");
    }
  }

  static Future<List<Comentario>> obtenerComentarios(int postId) async {
    final respuesta =
        await http.get(Uri.parse("$urlBase/comments?postId=$postId"));
    if (respuesta.statusCode == 200) {
      final List datos = json.decode(respuesta.body);
      return datos.map((e) => Comentario.fromJson(e)).toList();
    } else {
      throw Exception("Error al cargar comentarios");
    }
  }
}
