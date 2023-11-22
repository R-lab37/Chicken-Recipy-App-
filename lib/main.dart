import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'splash_screen.dart'; // Import your splash screen file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color.fromARGB(
            255, 176, 255, 247), // Change the accent color as needed
        fontFamily: 'Roboto', // Change the font family as needed
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(fontSize: 16.0),
        ),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.orangeAccent),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class RecipeList extends StatefulWidget {
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  List<dynamic> recipes = [];

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=chicken'));

    if (response.statusCode == 200) {
      setState(() {
        recipes = json.decode(response.body)['meals'];
      });
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe List'),
      ),
      body: _buildRecipeList(),
    );
  }

  Widget _buildRecipeList() {
    if (recipes.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return ListTile(
            title: Text(recipe['strMeal']),
            subtitle: Text(recipe['strCategory']),
            onTap: () {
              // Navigate to the recipe detail screen when a recipe is tapped.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetail(recipe: recipe),
                ),
              );
            },
          );
        },
      );
    }
  }
}

class RecipeDetail extends StatelessWidget {
  final dynamic recipe;

  RecipeDetail({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['strMeal']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(recipe['strMealThumb']),
              ),

              SizedBox(height: 16.0),
              Text('Category: ${recipe['strCategory']}',
                  style: Theme.of(context).textTheme.headline6),
              Text('Area: ${recipe['strArea']}',
                  style: Theme.of(context).textTheme.headline6),
              Text('Instructions: ${recipe['strInstructions']}'),
              SizedBox(height: 16.0),
              Text('Ingredients:',
                  style: Theme.of(context).textTheme.headline6),
              _buildIngredientsList(recipe),
              SizedBox(height: 16.0),
              YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: _extractVideoId(recipe['strYoutube']),
                  flags: YoutubePlayerFlags(
                    autoPlay: false,
                    mute: false,
                  ),
                ),
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
              ),
              // Add more information as needed based on the API response
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientsList(dynamic recipe) {
    List<Widget> ingredientsList = [];
    for (int i = 1; i <= 20; i++) {
      // Check if the ingredient is present in the API response
      if (recipe['strIngredient$i'] != null &&
          recipe['strIngredient$i'].trim().isNotEmpty) {
        ingredientsList.add(
          Text('${recipe['strIngredient$i']} - ${recipe['strMeasure$i']}'),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredientsList,
    );
  }

  String _extractVideoId(String youtubeUrl) {
    RegExp regExp = RegExp(
      r'https://www\.youtube\.com/watch\?v=([a-zA-Z0-9_-]+)',
      caseSensitive: false,
      multiLine: false,
    );

    Match match = regExp.firstMatch(youtubeUrl)!;
    return match.group(1)!;
  }
}
