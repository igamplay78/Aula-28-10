import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int fator1 = 2;
  int fator2 = 1;
  String digitado = '';

  @override
  void initState() {
    carregar();
  }

  Future<void> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fator1 = prefs.getInt('fator1') ?? 2;
      fator2 = prefs.getInt('fator2') ?? 1;
    });
  }

  Future<void> salvar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('fator1', fator1);
    await prefs.setInt('fator2', fator2);
  }

  void mudarFator() {
    setState(() {
      fator1 = fator1 + 1;
      fator2 = 1;
      digitado = '';
    });
    salvar();
  }

  void proximaOperacao() {
    setState(() {
      fator2 = fator2 + 1;
      digitado = '';
    });
    salvar();
  }

  @override
  Widget build(BuildContext context) {
    final numeros = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Text('$fator1 * $fator2'),
            Text(digitado),
            LinearProgressIndicator(value: fator2 / 9),
            ...numeros.map((n) {
              return ElevatedButton(
                child: Text(n.toString()),
                onPressed: () {
                  setState(() {
                    digitado = digitado + n.toString();
                  });
                },
              );
            }),
            Builder(builder: (interno_context) {
              return ElevatedButton(
                onPressed: () {
                  int esperado = fator1 * fator2;
                  if (digitado == esperado.toString()) {
                    if (fator2 >= 9) {
                      mudarFator();
                    } else {
                      proximaOperacao();
                    }
                  } else {
                    final snackBar = SnackBar(
                      content: const Text('Errou!'),
                      action: SnackBarAction(
                        label: 'Clique aqui para continuar',
                        onPressed: () {
                          mudarFator();
                        },
                      ),
                    );
                    ScaffoldMessenger.of(interno_context)
                        .showSnackBar(snackBar);
                  }
                },
                child: Text('Verificar'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
