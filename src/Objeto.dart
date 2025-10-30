class Objeto{
  int idObjeto;
  String descripcionObjeto;
  bool tipoObjeto;

  Objeto({
    required this.idObjeto,
    required this.descripcionObjeto,
    required this.tipoObjeto,
  });

  int get getIdObjeto => idObjeto;

  String get getDescripcionObjeto => descripcionObjeto;
}