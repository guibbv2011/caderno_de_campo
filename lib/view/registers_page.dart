import 'package:flutter/material.dart';

class RegistersPage extends StatefulWidget {
  const RegistersPage({super.key});
  @override
  RegistersPageState createState() => RegistersPageState();
}

class RegistersPageState extends State<RegistersPage> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ValueNotifier(null),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Registros'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  iconSize: 14,
                  icon: const Icon(Icons.filter_alt),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightGreen,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  bottom: 4.0,
                  top: 10.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightGreen),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(children: [Text('Data: '), Text('12/03/2023')]),
                      Row(children: [Text('Cultura: '), Text('Cafe')]),
                      Row(children: [Text('Area: '), Text('100')]),
                      Row(children: [Text('Atividade: '), Text('Colheita')]),
                      Row(children: [Text('Responsável: '), Text('Daniel')]),
                      Row(children: [Text('Ações: '), Text('Sem ações')]),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
