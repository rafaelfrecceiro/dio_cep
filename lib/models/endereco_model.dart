import 'dart:convert';

class EnderecoModel {
  String? logradouro;
  String? complemento;
  String? bairro;
  String? localidade;
  bool? hasData;

  EnderecoModel.empty();

  EnderecoModel(
      {required this.logradouro,
      required this.complemento,
      required this.bairro,
      required this.localidade,
      required this.hasData});

  void fromMap(Map<String, dynamic> data) {
    logradouro = data['logradouro'];
    complemento = data['complemento'];
    bairro = data['bairro'];
    localidade = data['localidade'];
    hasData = true;
  }

  String toJson() {
    return jsonEncode({
      'logradouro': logradouro,
      'complemento': complemento,
      'bairro': bairro,
      'localidade': localidade
    });
  }
}
