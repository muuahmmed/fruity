import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Login/login_screen.dart';
import '../compoents/components.dart';
import '../network/local/cache helper.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({required this.body, required this.image, required this.title});
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardingController = PageController();
  bool isLast = false;

  void submit() {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        navigateAndFinish(context, const LoginScreen());
      }
    });
  }

  List<BoardingModel> boarding = [
    BoardingModel(
      body: 'OnBoarding1 body',
      image: 'assets/pics/shopping.jpg',
      title: 'OnBoarding1 title',
    ),
    BoardingModel(
      body: 'OnBoarding2 body',
      image: 'assets/pics/shopping.jpg',
      title: 'OnBoarding2 title',
    ),
    BoardingModel(
      body: 'OnBoarding3 body',
      image: 'assets/pics/shopping.jpg',
      title: 'OnBoarding3 title',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [TextButton(onPressed: submit, child: const Text('SKIP'))],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                    print('last');
                  } else {
                    setState(() {
                      isLast = false;
                    });
                    print('not last');
                  }
                },
                controller: boardingController,
                physics: const BouncingScrollPhysics(),
                itemBuilder:
                    (context, index) => buildBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardingController,
                  count: boarding.length,
                  effect: const ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.blue,
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 5,
                    expansionFactor: 4,
                  ),
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      submit();
                    } else {
                      boardingController.nextPage(
                        duration: const Duration(milliseconds: 1),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: Image.asset(model.image)),
      const SizedBox(height: 20),
      Text(
        model.title,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 20),
      Text(
        model.body,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    ],
  );
}
