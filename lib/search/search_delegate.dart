import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Text('data');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final moviesProvide = Provider.of<MoviesProvider>(context, listen: false);

    moviesProvide.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: moviesProvide.suggestionsStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        final movies = snapshot.data;
        if (movies != null) {
          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (_, int index) {
                movies[index].heroId = '$index';
                return _SuggestionItem(movie: movies[index]);
              });
        } else {
          return _emptyContainer();
        }
      },
    );
  }

  Widget _emptyContainer() {
    return Container(
      child: Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.black,
          size: 100,
        ),
      ),
    );
  }
}

class _SuggestionItem extends StatelessWidget {
  final Movie movie;

  const _SuggestionItem({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FadeInImage(
        placeholder: AssetImage('assets/no-image.jpg'),
        image: NetworkImage(movie.fullBackdropPath),
        width: 50,
        fit: BoxFit.contain,
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: movie);
      },
    );
  }
}
