class Usuario {
  final int id;
  final String nombre;
  final String email;
  final String ciudad;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.ciudad,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['name'],
      email: json['email'],
      ciudad: json['address']['city'],
    );
  }
}
