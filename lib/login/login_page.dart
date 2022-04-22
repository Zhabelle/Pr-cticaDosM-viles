import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prados/login/bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign In',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black.withOpacity(1),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
          ),
          Image.asset("assets/circle.gif"),
          Container(
            color: Colors.black.withOpacity(0.666),
          ),
          Column(
            children: [
              Image.asset("assets/icon/icon.png", width: 64,),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: TextButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(GoogleAuthEvent());
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "G",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Iniciar con Google",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )),
            ),
          ),
        ],
        fit: StackFit.expand,
      ),
    );
  }
}
