
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatelessWidget {

  var listPagesViewModel = <PageViewModel>[
    PageViewModel(
      title: "Welcome to MUSLIMY",
      bodyWidget: Column(
        children: <Widget>[
          Text('It\'s like Spotify, but for Islamic audios 🙃')
        ],
      ),
      image: Center(
        child: Image.asset("assets/images/onboarding/welcome.png", height: 250.0)
      ),
    ),
    PageViewModel(
      title: "Search for all types of audio",
      image: Center(
          child: Image.asset("assets/images/onboarding/search.png", height: 250.0)
      ),
      bodyWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Khutbas, dourous, conferences, courses..."),
        ],
      ),
    ),
    PageViewModel(
      title: "Add imams and themes to your favorites",
      image: Center(
          child: Image.asset("assets/images/onboarding/favorite.png", height: 250.0)
      ),
      bodyWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("By clicking the "),
          Icon(Icons.favorite_border),
          Text(" icon"),
        ],
      ),
    ),
    PageViewModel(
      title: "No idea of what to listen to ?",
      image: Center(
          child: Image.asset("assets/images/onboarding/lost.png", height: 250.0)
      ),
      bodyWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Click on "),
          Icon(Icons.explore),
          Text(" to explore new content"),
        ],
      ),
    ),
    PageViewModel(
      title: "Let's go",
      image: Center(
          child: Image.asset("assets/images/onboarding/go.png", height: 250.0)
      ),
      bodyWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('You are ready to go now')
        ],
      )
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: listPagesViewModel,
      onDone: () {
        Navigator.pushNamed(context, "/login");
      },
      showSkipButton: true,
      skip: const Text('Passer', style: TextStyle(fontWeight: FontWeight.w600)),
      done: const Text('C\'est parti', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).accentColor,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)
          )
      ),
    );
  }
}