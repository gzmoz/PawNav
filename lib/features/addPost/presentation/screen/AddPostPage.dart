import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/addPost/presentation/widget/post_type_option_card.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {

  Future<void> _showAddPostOptions() async {
    // Bottom sheet'i bekle ki kapandıktan sonra sayfa davranışı kontrol edilebilsin
    await showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      useRootNavigator: true,
      isDismissible: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "What would you like to post?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                PostTypeOptionCard(
                  icon: Icons.search,
                  color: Colors.blue.shade100,
                  borderColor: Colors.blue,
                  title: "Lost Post",
                  subtitle: "Report a missing pet",
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/addPostForm?type=Lost');
                  },
                ),
                PostTypeOptionCard(
                  icon: Icons.location_on,
                  color: Colors.green.shade100,
                  borderColor: Colors.green,
                  title: "Found Post",
                  subtitle: "Share a pet you have found",
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/addPostForm?type=Found');
                  },
                ),
                PostTypeOptionCard(
                  icon: Icons.favorite,
                  color: Colors.orange.shade100,
                  borderColor: Colors.orange,
                  title: "Adoption Post",
                  subtitle: "Find a new home for a pet",
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/addPostForm?type=Adoption');
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );

    // Sheet kapanınca sayfa da kapansın (isteğe bağlı)
    /*if (mounted) {
      context.go('/post');
    }*//*ontext.pop();*/
  }

  @override
  void initState() {
    super.initState();
    // Bu kısım garantili olarak widget build edildikten sonra çalışır
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Future.delayed ekleyerek Flutter render'ının tamamlanmasını bekletiyoruz
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _showAddPostOptions();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background2,
      appBar: AppBar(
        title: const Text("Add Post"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(""),
      ),
    );
  }
}
