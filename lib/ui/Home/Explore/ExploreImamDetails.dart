
import 'dart:math';

import 'package:ahadmobile/blocs/HomeTabs/Explore/ExploreImamBloc.dart';
import 'package:ahadmobile/blocs/HomeTabs/Explore/ExploreImamEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/Explore/ExploreImamStates.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/models/Favs.dart';
import 'package:ahadmobile/models/User.dart';
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:ahadmobile/repository/FavRepository.dart';
import 'package:ahadmobile/ui/Common.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExploreImamDetails extends StatelessWidget {
  final ExploreImamBloc exploreImamBloc = new ExploreImamBloc();

  @override
  Widget build(BuildContext context) {
    final User imam = ModalRoute.of(context).settings.arguments;

    return BlocBuilder(
      bloc: exploreImamBloc,
      builder: (context, state){
        if (state is ExploreImamInitial){
          exploreImamBloc.add(FetchExploreImam(userId: Provider.of<UserModel>(context, listen: false).user.id, imam: imam));
          return Center(
            child: SpinKitFoldingCube(
              color: Theme.of(context).primaryColor,
              size: 25.0,
            ),
          );
        } else if (state is ExploreImamLoading) {
          return Center(
            child: SpinKitFoldingCube(
              color: Theme.of(context).primaryColor,
              size: 25.0,
            ),
          );
        } else if (state is ExploreImamLoaded) {
          return Scaffold(
            floatingActionButton: FloatingActionPlay(),
            body: CustomScrollView(
              slivers: <Widget>[
                _AppBar(state.imam),
                SliverToBoxAdapter(
                  child: SizedBox(height: 16),
                ),
                _RandomButton(state.allAudios),
                _SliverSeparation(),
                _LastAudio(state.allAudios),
                _SliverSeparation(),
                _AllAudiosTitleSection(),
                _AllAudios(state.allAudios),
                SliverToBoxAdapter(
                  child: SizedBox(height: 64),
                )
              ],
            ),
          );
        } else if (state is ExploreImamLoadFailure) {
          return Center(child: Text('Load failure ${state.e.toString()}'));
        } else {
          return Center(child: Text('Unknown state'));
        }
      },
    );
  }
}

class _SliverSeparation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

}

class _FavButton extends StatefulWidget {
  final int imamId;
  final int userId;
  _FavButton(this.imamId, this.userId);

  @override
  State<StatefulWidget> createState() => _FavButtonState(imamId, userId);
}

class _FavButtonState extends State<_FavButton> {
  final FavRepository favRepository = new FavRepository();

  final int imamId;
  final int userId;
  _FavButtonState(this.imamId, this.userId);

  bool isFaved = false;


  @override
  void initState() {
    super.initState();

    favRepository.fetchImamIsFav(imamId).then((v){
      setState(() {
        isFaved = true;
      });
    }).catchError((e){
      setState(() {
        isFaved = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Vibrate.canVibrate.then((v){
          if (v == true){
            Vibrate.feedback(FeedbackType.light);
          }
        });
        setState(() {
          if (!isFaved)
            favRepository.createImamFav(new FavImam(userId: userId, imamId: imamId, isFaved: true));
          if(isFaved)
            favRepository.deleteImamFav(new FavImam(userId: userId, imamId: imamId, isFaved: true));
          isFaved = ! isFaved;
        });
      },
      icon: isFaved ? Icon(Icons.favorite, color: Colors.red):Icon(Icons.favorite_border),
    );
  }
}

class _AppBar extends StatelessWidget {
  final User imam;

  _AppBar(this.imam);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text('${imam.firstName} ${imam.lastName}'),
      //backgroundColor: Theme.of(context).primaryColor,
      expandedHeight: 200.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network('https://veerse.xyz/user/${imam.id}/cover', fit: BoxFit.cover),
      ),
      pinned: true,
      actions: <Widget>[
        Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _FavButton(imam.id, Provider.of<UserModel>(context, listen: false).user.id)
          ),
        )
      ],
    );
  }

}

class _RandomButton extends StatelessWidget {
  final List<Audio> allAudios;

  _RandomButton(this.allAudios);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: GestureDetector(
          onTap: () {
            vibrate(FeedbackType.light);
            final rand = new Random();
            var playingAudio = Provider.of<AudioModel>(context, listen: false).audio;
            Audio randAudio;

            if(allAudios.length > 1) {
              if (playingAudio != null) {
                do
                  randAudio = allAudios[rand.nextInt(allAudios.length)];
                while (randAudio.id == playingAudio.id);
              } else {
                randAudio = allAudios[rand.nextInt(allAudios.length)];
              }
              Provider.of<AudioModel>(context, listen: false).playOrPause(randAudio);
            }
          },
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8)
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Aléatoire', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  SizedBox(width: 8),
                  Icon(Icons.shuffle, color: Colors.white,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LastAudio extends StatelessWidget {
  final List<Audio> audios;

  _LastAudio(this.audios);

  @override
  Widget build(BuildContext context) {
    audios.sort((a, b) => a.audioDateAdded.compareTo(b.audioDateAdded));
    var lastAudio = audios.elementAt(0);

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Dernier audio', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
            SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //AudioItemList(audios.elementAt(0))
                Container(
                  width: 130,
                  child: _AudioBoxItem(lastAudio),
                ),
                SizedBox(width: 32),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${DateFormat('dd-MM-yyyy').format(lastAudio.audioDateAdded)}', style: Theme.of(context).textTheme.overline),
                      SizedBox(height: 16),
                      Text('${lastAudio.title}', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
                      SizedBox(height: 16),
                      Text('${Audio.getAudioType(lastAudio)}', style: Theme.of(context).textTheme.caption),
                      SizedBox(height: 16),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _AllAudiosTitleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Tous les audio', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
            SizedBox(height: 16)
          ],
        ),
      )
    );
  }
}

class _AllAudiosFilterSection extends StatefulWidget {
  List<Audio> allAudios;
  _AllAudiosFilterSection(this.allAudios);

  @override
  State<StatefulWidget> createState() => _AllAudiosFilterSectionState(allAudios);

}

class _AllAudiosFilterSectionState extends  State<_AllAudiosFilterSection> {
  List<Audio> allAudios;
  _AllAudiosFilterSectionState(this.allAudios);

  @override
  Widget build(BuildContext context) {
    return Text('ici');
  }

}

class _AllAudios extends StatelessWidget {
  List<Audio> allAudios;

  _AllAudios(this.allAudios);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      sliver: SliverList (
        delegate: SliverChildBuilderDelegate((context, index){
          return AudioItemList(allAudios.elementAt(index));
        },
            childCount: allAudios.length
        ),
      ),
    );
  }
}

class _AudioBoxItem extends StatelessWidget{
  final Audio audio;

  _AudioBoxItem(this.audio);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showAudioDialog(context, audio),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff7c94b6),
          image: DecorationImage(
            image: NetworkImage('https://veerse.xyz/user/${audio.user.id}/avatar'),
            fit: BoxFit.cover,
          ),
          border: Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        height: 130,
        //width: 130, // already given on parent container
        alignment: Alignment.bottomRight,
        child: Center(
          child: Opacity(
            opacity: 0.5,
            child: Consumer<AudioModel>(
              builder: (context, audioModel, child){
                return IconButton(
                  onPressed: () {
                    audioModel.playOrPause(audio);
                    vibrate(FeedbackType.light);
                  },
                  color: Colors.white,
                  icon: Icon(audioModel.audio != null && audioModel.audio.id == audio.id && audioModel.audioPlayer.state == AudioPlayerState.PLAYING ? Icons.pause:Icons.play_arrow),
                  iconSize: 50,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}