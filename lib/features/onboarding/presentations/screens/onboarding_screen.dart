import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/onboarding/presentations/widgets/onboarding_component.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const OnboardingComponent(
        title: "Hope Starts with a Helping Hand",
        description:
            "Join thousands of pet lovers on a mission to protect, rescue, and care for every furry friend out there.",
        imagePath: "assets/onboarding/onboarding1.png"),
    const OnboardingComponent(
        title: "A Simple Post Can Bring Them Home",
        description:
            "Post a lost or found pet so people can reach you easily and reunite every friend with their home.",
        imagePath: "assets/onboarding/onboarding2.png"),
    const OnboardingComponent(
        title: "See the Paws Around You",
        description:
            "Open the map, discover nearby pets, and take the first step toward a reunion.",
        imagePath: "assets/onboarding/onboarding3.png"),
    const OnboardingComponent(
        title: "Give Them a Home",
        description:
            "Browse through hundreds of pets waiting for adoption and offer them the loving home they deserve.",
        imagePath: "assets/onboarding/onboarding4.png"),
  ];

  void _skip(){
    _pageController.animateToPage(_pages.length -1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);

  }

  void _onNext(){
    if(_currentIndex < _pages.length - 1){
      _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
      );
    }else{
      _onFinish();
    }
  }

  void _onFinish() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) => _pages[index],
          ),
          _currentIndex == _pages.length - 1
              ? const SizedBox.shrink()
              : Positioned(
                  bottom: height * 0.04,
                  left: width * 0.07,
                  child: TextButton(
                    onPressed: () {
                      _skip();
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
          Positioned(
            bottom: height * 0.04,
            right: width * 0.07,
            child: TextButton(
              onPressed: () {
                _onNext();
              },
              child: Text(
                _currentIndex == _pages.length - 1 ? "Finish" : "Next",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: width * 0.045,
            child: Center(
              child: SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: WormEffect(
                    dotHeight: width * 0.03,
                    dotWidth: width * 0.03,
                    dotColor: Colors.grey,
                    activeDotColor: AppColors.primary,
                    spacing: width * 0.02,
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
