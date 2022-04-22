import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prados/favs/bloc/favorites_bloc.dart';
import 'package:prados/favs/favs_page.dart';
import 'package:prados/login/bloc/auth_bloc.dart';
import 'package:prados/login/login_page.dart';
import 'package:prados/record/bloc/record_bloc.dart';
import 'package:prados/song/song_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => AuthBloc()..add(VerifyAuthEvent())),
      BlocProvider(create: (context) => RecordBloc()),
      BlocProvider(create: (context) => FavoritesBloc()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(colorScheme: ColorScheme.dark()),
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AuthAwait)
            return Center(
              child: CircularProgressIndicator(
                color: Colors.purple[700],
              ),
            );
          return state is AuthSuccess ? HomePage() : LoginPage();
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool listening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 40,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: BlocConsumer<RecordBloc, RecordState>(
                  listener: (context, state) {
                    if(state is RecordFinished || state is RecordGetSuccess || state is RecordGotError){
                      setState(() {listening = false;});
                    }
                    if(state is RecordGetSuccess)
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SongPage(data: state.data),));
                    if(state is RecordGotError)
                      ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text("Error al reconocer la canción"), backgroundColor: Colors.red[400],));
                  },
                  builder: (context, state) {
                    return AvatarGlow(
                      glowColor: Colors.purple,
                      endRadius: 150,
                      animate: listening,
                      repeatPauseDuration: Duration(milliseconds: 50),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 8.0,
                        shape: CircleBorder(),
                        child: TextButton(
                          onPressed: () {
                            BlocProvider.of<RecordBloc>(context)
                                .add(RecordStartEvent());
                            this.setState(() => this.listening = true);
                          },
                          style: ButtonStyle(
                              shape:
                                  MaterialStateProperty.all(CircleBorder())),
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/icon/icon.png"),
                            radius: 80,
                            backgroundColor: Colors.grey[200],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 42,
                  ),
                  Text(
                    listening?"Escuchando...":"Toque para escuchar",
                    style: TextStyle(color: Colors.grey[200], fontSize: 16),
                  ),
                  SizedBox(
                    height: 250,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            BlocProvider.of<FavoritesBloc>(context).add(GetFavsEvent());
                            return FavsPage();},));
                        },
                        icon: CircleAvatar(
                          child: Icon(Icons.favorite),
                          backgroundColor: Colors.grey[200],
                        ),
                        tooltip: "Favoritos",
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(context: context, builder: (c)=>AlertDialog(
                            actions: [
                              TextButton(onPressed: ()=>Navigator.of(context).pop(), child: Text("Cancelar")),
                              TextButton(onPressed: (){Navigator.of(context).pop();BlocProvider.of<AuthBloc>(context).add(RemoveAuthEvent());}, child: Text("Cerrar sesión")),
                            ],
                            title: Text("Cerrar sesión"),
                            content: Text("Al cerrar sesión será redirigido a la pantalla de inicio, ¿desea continuar?"),
                          ));
                        },
                        tooltip: "Cerrar sesión",
                        icon: CircleAvatar(
                          child: Icon(Icons.power_settings_new),
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
            ),
          ],
        ),
      )
    );
  }
}
