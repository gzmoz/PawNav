import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    return Scaffold(
      backgroundColor: AppColors.white3,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(width * 0.035),
          child: Image.asset(
            "assets/app_icon/icon_transparent.png",
            fit: BoxFit.contain,
          ),
        ),
        title: const Text(
          "PawNav",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              icon: const Icon(Icons.search))
          /*GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.search),
            ),
          ),*/
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    // AppBar’ın sağındaki ikonları oluşturur (örneğin temizleme ikonu)
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];

    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // AppBar’ın solundaki ikon (örneğin geri butonu)
    return IconButton(
        onPressed: () {
          close(context, null); //close the search bar
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // Kullanıcı “search” tuşuna bastığında ne gösterileceğini tanımlar
    List<String> matchQuery = [];
    for (var item in searchTerms) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(matchQuery[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Kullanıcı yazarken çıkan önerileri gösterir
    List<String> matchQuery = [];
    for (var item in searchTerms) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return Container(
      color: AppColors.white3,
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(matchQuery[index]),
          );
        },
      ),
    );
  }
}
