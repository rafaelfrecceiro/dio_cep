import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_cep/models/endereco_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _cepEdit = TextEditingController();
  bool loading = false;

  EnderecoModel? address;

  @override
  void dispose() {
    _cepEdit.dispose();
    super.dispose();
  }

  Future<EnderecoModel> getReq(String cep) async {
    var dio = Dio();
    final Response response;
    try {
      response = await dio.get('https://viacep.com.br/ws/$cep/json/');
      Map<String, dynamic> rp = jsonDecode(response.toString());
      EnderecoModel enderecoModal = EnderecoModel.empty();
      enderecoModal.fromMap(rp);
      return enderecoModal;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'CEP não encontrado',
          ),
        ),
      );
      EnderecoModel enderecoModal = EnderecoModel.empty();
      enderecoModal.hasData = false;
      return enderecoModal;
    }
  }

  Future<void> requestCEP() async {
    setState(() {
      loading = true;
    });
    EnderecoModel reqs = await getReq(_cepEdit.text);
    setState(() {
      address = reqs;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Consulta CEP',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.go,
                onFieldSubmitted: (value) => requestCEP(),
                controller: _cepEdit,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    requestCEP();
                  },
                  child: const Text(
                    'Consultar',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            (loading)
                ? const CircularProgressIndicator()
                : (address?.hasData == true)
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Endereço: ${address?.logradouro ?? ""}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Número: ${address?.complemento ?? ""}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Bairro: ${address?.bairro ?? ""}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Cidade: ${address?.localidade ?? ""}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          )
                        ],
                      )
                    : const Text(
                        '',
                      )
          ],
        ),
      ),
    );
  }
}
