import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prados/favs/bloc/favorites_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class FavsPage extends StatefulWidget {
  FavsPage({Key? key}) : super(key: key);

  @override
  State<FavsPage> createState() => _FavsPageState();
}

class _FavsPageState extends State<FavsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        backgroundColor: Colors.grey[900],
        leading: IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: Icon(Icons.arrow_back)),
      ),
      body: BlocConsumer<FavoritesBloc, FavoritesState>(
        listener: (context, state) {
          if(state is RemoveFavSuccess)
            ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text("Canción eliminada de favoritos"), backgroundColor: Colors.purple[100],));
        },
        builder: (context, state) {
          if(state is GetFavsSuccess){
            // log(state.data.toString());
            if(state.data["favorites"].length<1)
              return Center(child: Text("No se encontraron favoritos"),);
            List<dynamic> favs = state.data["favorites"];
            return ListView.builder(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: favs.length,
              itemBuilder: (BuildContext context, int index) {
                return FavItem(data: favs[index]);
              },
            );
          }
          return Center(child: CircularProgressIndicator(color: Colors.indigo,),);
        },
      ),
    );
  }
}

class FavItem extends StatelessWidget {
  final Map<String, dynamic> data;
  const FavItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(context: context, builder: (c)=>AlertDialog(
          actions: [
            TextButton(onPressed: ()=>Navigator.of(context).pop(), child: Text("Cancelar")),
            TextButton(onPressed: (){launch(data["urlPage"].toString());Navigator.of(context).pop();}, child: Text("Continuar")),
          ],
          content: Text("Será redirigido a una página externa, ¿desea continuar?"),
          title: Text("Abrir canción"),
        ));
      },
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(14.0)),
          ),
          clipBehavior: Clip.antiAlias,
          width: MediaQuery.of(context).size.width*0.8,
          height: MediaQuery.of(context).size.width*0.8,
          child: Stack(children: [
            Image.network(data["album"].toString()),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(24.0)),
                    color: Color.fromARGB(175, 123, 31, 162),
                  ),
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.width*0.8*0.2,
                  child: Column(children: [
                    Text(data["title"].toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    Text(data["artist"].toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),),
                  ],crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,mainAxisSize: MainAxisSize.min,),
                  // color: Colors.indigo.withOpacity(0.80),
                ),
              ],
            ),
            IconButton(onPressed: (){
              showDialog(
                context: context, 
                builder: (c) => AlertDialog(
                  actions: [
                    TextButton(onPressed: ()=>Navigator.of(context).pop(), child: Text("Cancelar")),
                    TextButton(
                      onPressed: (){
                        BlocProvider.of<FavoritesBloc>(context).add(RemoveFavEvent(data: data));
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text("Procesando"), backgroundColor: Colors.purple[100],));
                      }, 
                      child: Text("Eliminar")
                    ),
                  ],
                  content: Text("Este elemento será eliminado de sus favoritos, ¿desea continuar?"),
                  title: Text("Eliminar favorito"),
                )
              );
            }, icon: Stack(children: [
              buildIcon(34, 34, Icons.favorite, Colors.purple[300]!),
              buildIcon(32, 30, Icons.favorite, Colors.pink),
              buildIcon(32, 32, Icons.favorite_outline, Colors.pink[100]!),
              Padding(
                padding: const EdgeInsets.only(top: 2.0, left: 11.5),
                child: buildIcon(20, 8, Icons.circle, Colors.pink[50]!),
              ),
              //Icon(Icons.favorite_outline, color: Colors.purpleAccent, size: 16,),
            ],)),
          ]),
        ),
      ),
    );
  }
}

Widget buildIcon(double w, double size, IconData icon, Color color){
  return Container(
    height: w,
    width: w,
    alignment: Alignment.center,
    child: Icon(
      icon,
      color: color,
      size: size,
    ),
  );
}
