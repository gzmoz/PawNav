import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pawnav/features/addPost/presentation/widget/post_type_option_card.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  bool _sheetClosed = false;

  Future<void> _showAddPostOptions() async {
    await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: false,
      useSafeArea: true,
      isDismissible: true,
      enableDrag: true,
      useRootNavigator: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                PostTypeOptionCard(
                  icon: Icons.search,
                  color: Colors.red.shade400,
                  borderColor: Colors.red.shade700,
                  title: "Lost Post",
                  subtitle: "Report a missing pet",
                  onTap: () {
                    this.context.push('/addPostForm?type=Lost');
                    /*Navigator.pop(context);
                    this.context.push('/addPostForm?type=Lost');*/
                  },
                ),
                PostTypeOptionCard(
                  icon: Icons.location_on,
                  color: Colors.blueAccent.shade400,
                  borderColor: Colors.blueAccent.shade700,
                  title: "Found Post",
                  subtitle: "Share a pet you have found",
                  onTap: () {
                    this.context.push('/addPostForm?type=Found');
                    /*Navigator.pop(context);
                    this.context.push('/addPostForm?type=Found');*/
                  },
                ),
                PostTypeOptionCard(
                  icon: Icons.favorite,
                  color: Colors.green.shade400,
                  borderColor: Colors.green.shade700,
                  title: "Adoption Post",
                  subtitle: "Find a new home for a pet",
                  onTap: () {
                    // Navigator.pop(context);
                    this.context.push('/addPostForm?type=Adoption');
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      // Sheet gerçekten kapandıktan sonra tetiklenir
      if (mounted) {
        setState(() => _sheetClosed = true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _showAddPostOptions();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _sheetClosed
              ? Padding(
            key: const ValueKey('content'),
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: LottieBuilder.asset(
                    "assets/lottie/world_map.json",
                    width: width * 1,
                    height: height * 0.2,
                    fit: BoxFit.contain,
                  
                  ),
                ),
                /*Container(
                  width: width * 0.22,
                  height: width * 0.22,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.pets,
                    color: AppColors.primary,
                    size: width * 0.12,
                  ),
                ),*/
                const SizedBox(height: 24),
                Text(
                  "Put another paw on the map",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D1D1D),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Create a post to report a missing pet, share one you’ve found, or help a furry friend find a new home.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.04,
                    color: const Color(0xFF5A5A5A),
                    // height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                /*SizedBox(
                  width: double.infinity,
                  height: height * 0.05,
                  child: ElevatedButton(
                    onPressed: _showAddPostOptions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      "Create Post",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),*/

                GestureDetector(
                  onTap: () async {
                    _showAddPostOptions();
                  },


                  child: Container(
                    width: width * 0.88,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF233E96), Color(0xFF3C59C7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Create post",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ),
    );
  }
}
