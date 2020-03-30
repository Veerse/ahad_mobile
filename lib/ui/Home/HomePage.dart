
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:ahadmobile/ui/Home/ExploreTab.dart';
import 'package:ahadmobile/ui/Home/HomeTab.dart';
import 'package:ahadmobile/ui/Home/LibraryTab.dart';
import 'package:ahadmobile/ui/Home/SearchTab.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();

}

class HomePageState extends State<HomePage> {

  int _currentIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeTab(),
    ExploreTab(),
    LibraryTab(),
    SearchTab()
  ];

  static List<String> _pagesName = <String>[
    'Accueil',
    'Explorer',
    'Librairie',
    'Rechercher'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Khutbatizer'),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: Icon(Icons.account_circle),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: _widgetOptions[_currentIndex],
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/player');
        },
        child: Icon(Icons.play_arrow, size: 32),
        //backgroundColor: Theme.of(context).primaryColor,
      ),*/
      floatingActionButton: Consumer<AudioModel>(
        builder: (context, audio, child){
          if (audio.audioPlayer.state != null){
            return GestureDetector(
              onLongPress: () => Navigator.pushNamed(context, '/player'),
              child: FloatingActionButton(
                onPressed: (){
                  Provider.of<AudioModel>(context, listen: false).playOrPause();
                },
                child: Icon(audio.audioPlayer.state == AudioPlayerState.PLAYING ? Icons.play_arrow:Icons.pause, size: 32),
                //backgroundColor: Theme.of(context).primaryColor,
              ),
            );
          } else {
            return Container();
          }
        },
      ),
      bottomNavigationBar: BubbleBottomBar(
          //fabLocation: BubbleBottomBarFabLocation.end, //new
          opacity: .2,
          backgroundColor: Theme.of(context).primaryColor,
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          elevation: 8,
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(backgroundColor: Colors.white, icon: Icon(Icons.home, color: Colors.white), title: Text(_pagesName[_currentIndex])),
            BubbleBottomBarItem(backgroundColor: Colors.white, icon: Icon(Icons.explore, color: Colors.white), title: Text(_pagesName[_currentIndex])),
            BubbleBottomBarItem(backgroundColor: Colors.white, icon: Icon(Icons.library_music, color: Colors.white), title: Text(_pagesName[_currentIndex])),
            BubbleBottomBarItem(backgroundColor: Colors.white, icon: Icon(Icons.search, color: Colors.white), title: Text(_pagesName[_currentIndex])),
          ]
      ),
    );
  }
}