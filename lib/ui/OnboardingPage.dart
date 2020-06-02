
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatelessWidget {

  final listPagesViewModel = <PageViewModel>[
    PageViewModel(
      title: "Bienvenue sur MUSLIMY",
      bodyWidget: Column(
        children: <Widget>[
          Text('C\'est comme Spotify, mais avec des audios islamiques 🙃')
        ],
      ),
      image: Center(
        child: Image.asset("assets/images/onboarding/welcome.png", height: 250.0)
      ),
    ),
    PageViewModel(
      title: "Plusieurs types d'audios disponibles",
      image: Center(
          child: Image.asset("assets/images/onboarding/search.png", height: 250.0)
      ),
      bodyWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Khutbas, dourous, conférences..."),
        ],
      ),
    ),
    PageViewModel(
      title: "Ajoutez un imam ou un thème à vos favoris",
      image: Center(
          child: Image.asset("assets/images/onboarding/favorite.png", height: 250.0)
      ),
      bodyWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("En cliquant sur l'icône "),
          Icon(Icons.favorite_border),
          //Text(""),
        ],
      ),
    ),
    PageViewModel(
      title: "Vous ne savez pas quoi écouter ?",
      image: Center(
          child: Image.asset("assets/images/onboarding/lost.png", height: 250.0)
      ),
      bodyWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Cliquez sur "),
          Icon(Icons.explore),
          Text(" pour explorer du nouveau contenu"),
        ],
      ),
    ),
    PageViewModel(
      title: "C\'est parti !",
      image: Center(
          child: Image.asset("assets/images/onboarding/go.png", height: 250.0)
      ),
      bodyWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Vous êtes prêts')
        ],
      )
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: listPagesViewModel,
      onDone: () {
        Navigator.pushReplacementNamed(context, "/login");
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