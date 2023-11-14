
class UserModel {
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  int edad;
  String paisOrigen;
  int calificacion;

  UserModel({
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.edad,
    required this.paisOrigen,
    required this.calificacion,
  });

  // Método para convertir un mapa a un objeto UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      nombre: map['nombre'],
      apellidoPaterno: map['apellido_paterno'],
      apellidoMaterno: map['apellido_materno'],
      edad: map['edad'],
      paisOrigen: map['pais_origen'],
      calificacion: map['calificacion'],
    );
  }

  // Método para convertir un objeto UserModel a un mapa
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido_paterno': apellidoPaterno,
      'apellido_materno': apellidoMaterno,
      'edad': edad,
      'pais_origen': paisOrigen,
      'calificacion': calificacion,
    };
  }
}
