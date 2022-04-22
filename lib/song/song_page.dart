import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prados/favs/bloc/favorites_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SongPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const SongPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aquí tienes"),
        backgroundColor: Colors.grey[900],
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
            onPressed: () {
              Map<String,dynamic> mapa = {
                "artist": data["artist"],
                "title": data["title"],
                "album": data["album"],
                "urlPage": data["urlPage"],
              };
              ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text("Procesando..."), backgroundColor: Colors.purple[400],));
              BlocProvider.of<FavoritesBloc>(context).add(AddFavEvent(data: mapa));
            }, 
            icon: Icon(Icons.favorite)
          ),
        ],
      ),
      body: BlocConsumer<FavoritesBloc, FavoritesState>(
        listener: (context, state) {
          if(state is AddFavError)
            ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text(state.alreadyFavved?"La canción ya se encuentra en favoritos":"Error al añadir canción a favoritos"), backgroundColor: Colors.red[400],));
          if(state is AddFavSuccess)
            ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text("La canción ha sido añadida a favoritos"), backgroundColor: Colors.purple[100],));
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Image.network(data["album"].toString())),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  data["title"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Text(
                  data["albumName"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  data["artist"].toString(),
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                ),
                Text(
                  data["releaseDate"].toString(),
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                ),
                SizedBox(
                  height: 16,
                ),
                Divider(
                  color: Colors.grey,
                ),
                Text("Abrir con:"),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 7.7, top: 5.0),
                          child: Icon(
                            Icons.circle,
                            size: 40,
                          ),
                        ),
                        IconButton(
                          onPressed: () => launch(data["spotify"].toString()),
                          icon: Icon(
                            Icons.filter_list_rounded,
                            size: 40,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () => launch(data["urlPage"].toString()),
                        icon: Icon(
                          Icons.podcasts,
                          size: 40,
                        )),
                    IconButton(
                        onPressed: () {
                          if (data["apple"] != null)
                            launch(data["apple"]["url"].toString());
                          else
                            ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text("No se encontró enlace de Apple Music"), backgroundColor: Colors.red[400],));
                        },
                        icon: Icon(
                          Icons.apple,
                          size: 40,
                        )),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          );
        },
      ),
    );
  }
}
