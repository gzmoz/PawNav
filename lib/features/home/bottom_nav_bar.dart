import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pawnav/AddPostPage.dart';
import 'package:pawnav/MessagePage.dart';
import 'package:pawnav/PostPage.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/account/presentations/screens/AccountPage.dart';
import 'package:pawnav/features/home/presentations/screens/HomePage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  int index = 0;

  final screens = [
    const HomePage(),
    const PostPage(),
    const AddPostPage(),
    const MessagePage(),
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;


    final items = <Widget>[
      Icon(Icons.home_outlined,
          color: index == 0 ? Colors.white : Colors.black54, size: width * 0.07),
      Icon(Icons.list,
          color: index == 1 ? Colors.white : Colors.black54, size: width * 0.07),
      Icon(Icons.add,
          color: index == 2 ? Colors.white : Colors.black54, size: width * 0.07),
      Icon(Icons.messenger_outline_sharp,
          color: index == 3 ? Colors.white : Colors.black54, size: width * 0.07),
      Icon(Icons.person_outline,
          color: index == 4 ? Colors.white : Colors.black54, size: width * 0.07),
    ];


    return SafeArea(
      top: false,
      child: ClipRect( //Bir child widget, belirli bir dikdörtgen alanın dışına taşarsa, o taşan kısımları kes (gizle).
        child: Scaffold(
          backgroundColor: AppColors.background,
          extendBody: true,
        
          body: screens[index],
        
          bottomNavigationBar: CurvedNavigationBar(
              height: height * 0.08,
              backgroundColor: Colors.transparent,
              // backgroundColor: AppColors.background,
              buttonBackgroundColor: AppColors.primary,
              items: items,
              index: index,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 300),
              onTap: (index) => setState(() => this.index = index),
        
          ),
        ),
      ),
    );
  }
}
