import 'package:flutter/material.dart';
// import 'package:flutter/service.dart';

double title_wbox(context) {
  return MediaQuery.of(context).size.width * 0.7;
}

Widget title_default(title) {
  return Text(
    '${title}',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    softWrap: true,
    overflow: TextOverflow.fade,
  );
}

Widget kv_card({required BuildContext context, required k, required model}) {
  Map<String, String> key = <String, String>{
    'datetime': 'Data Hora',
    'culture': 'Cultura',
    'area': 'Área',
    'activity': 'Atividade',
    'responsable': 'Resposável',
    'actions': 'Ações',
    'category': 'Categoria',
    'description': 'Descrição',
    'value': 'Valor',
    'name': 'Nome',
    'location': 'Local',
    'plat': 'Canteiros',
    'variety': 'Variedade',
    'cycle': 'Ciclos',
    'obs': 'Observações',
    'id': 'id',
  };

  return Row(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Text('${key[k].toString()}: ', style: TextStyle(fontSize: 14)),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Text('${model[k]}'),
      ),
    ],
  );
}
