class Comentario {
  final int id;
  final String nombre;
  final String email;
  final String contenido;

  Comentario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.contenido,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id: json['id'],
      nombre: json['name'],
      email: json['email'],
      contenido: json['body'],
    );
  }
}
