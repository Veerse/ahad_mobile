
import 'package:ahadmobile/blocs/HomeTabs/LibraryBloc.dart';
import 'package:ahadmobile/blocs/HomeTabs/LibraryEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/LibraryStates.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:ahadmobile/ui/Common.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LibraryTab extends StatelessWidget {
  final RefreshController _refreshController = new RefreshController();
  final LibraryBloc _libraryBloc = new LibraryBloc();

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () {
        Vibrate.canVibrate.then((v){
          if (v == true){
            Vibrate.feedback(FeedbackType.light);
          }
        });
        _libraryBloc.add(FetchLibrary(userId: Provider.of<UserModel>(context, listen: false).user.id));
        _refreshController.refreshCompleted();
      },
      child: BlocBuilder(
          bloc: _libraryBloc,
          builder: (context, state){
            if (state is LibraryInitial) {
              _libraryBloc.add(FetchLibrary(userId: Provider.of<UserModel>(context, listen: false).user.id));
              return Center(
                child: SpinKitFoldingCube(
                  color: Theme.of(context).primaryColor,
                  size: 25.0,
                ),
              );
            } else if (state is LibraryLoading) {
              return Center(
                child: SpinKitFoldingCube(
                  color: Theme.of(context).primaryColor,
                  size: 25.0,
                ),
              );
            } else if (state is LibraryLoaded){
              return SingleChildScrollView (
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 64),
                    _SeparationWidget(),
                    _Categories(state),
                    _SeparationWidget(),
                    _LastOfUsersTags(state.lastOfUsersTags),
                    _SeparationWidget(),
                    _LastOfUsersImams(state.lastOfUsersImams),
                    SizedBox(height: 64),
                  ],
                ),
              );
            } else if (state is LibraryLoadFailure) {
              return Text('Load failure ${state.e.toString()}');
            } else {
              return Text('Unknown state');
            }
          }
      ),
    );
  }
}

class _SeparationWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 16),
        Divider(),
        SizedBox(height: 16),
      ],
    );
  }
}

class _Categories extends StatelessWidget {
  final LibraryLoaded _state;
  _Categories(this._state);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          child: ListTile(
            leading: Icon(Icons.av_timer),
            title: Text('A terminer'),
            subtitle: _state.currentlyListeningOfUser != null ? Text('${_state.currentlyListeningOfUser.length} audios en cours d\'écoute'):null,
            trailing: Icon(Icons.navigate_next),
            onTap: () => Navigator.pushNamed(context, '/library/tofinish', arguments: _state.currentlyListeningOfUser),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.play_for_work),
            title: Text('A écouter'),
            subtitle: _state.toBeListenedForUser != null ? Text('${_state.toBeListenedForUser.length} audios à écouter'):null,
            trailing: Icon(Icons.navigate_next),
            onTap: () => Navigator.pushNamed(context, '/library/tolisten', arguments: _state.toBeListenedForUser),
          ),
        ),
      ],
    );
  }
}

class _LastOfUsersTags extends StatelessWidget {
  final List<Audio> audios;

  _LastOfUsersTags(this.audios);

  @override
  Widget build(BuildContext context) {
   /* if (audios != null)
      audios.sort((a, b) => a.audioDateAdded.compareTo(b.audioDateAdded)); */

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Récent de mes thèmes favoris', style: Theme.of(context).textTheme.title),
        SizedBox(height: 32),
        audios != null ?
        Container(
          height: 240,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: audios.length,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 130,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: _AudioBoxItem(audios.elementAt(index)),
                );
              }
          ),
        ): Container(
          height: 90,
          child: RichText(
            text: TextSpan(
                style: Theme.of(context).textTheme.body1,
                children: [
                  TextSpan(text: 'Ajoutez des '),
                  TextSpan(text: 'Thèmes ', style: Theme.of(context).textTheme.body2),
                  TextSpan(text: 'à vos favoris en cliquant sur le ❤ dans la page du Thème puis rafraîchissez la page en glissant vers le bas'),
                ]
            ),
          ),
        ),
      ],
    );
  }
}

class _LastOfUsersImams extends StatelessWidget {
  final List<Audio> audios;

  _LastOfUsersImams(this.audios);

  @override
  Widget build(BuildContext context) {
   /* if (audios != null)
      audios.sort((a, b) => a.audioDateAdded.compareTo(b.audioDateAdded));*/

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Récent de mes imams favoris', style: Theme.of(context).textTheme.title),
        SizedBox(height: 32),
        audios != null ? Container(
          height: 240,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: audios.length,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 130,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: _AudioBoxItem(audios.elementAt(index)),
                );
              }
          ),
        ):Container(
          height: 90,
          child: RichText(
            text: TextSpan(
                style: Theme.of(context).textTheme.body1,
                children: [
                  TextSpan(text: 'Ajoutez des '),
                  TextSpan(text: 'Imams ', style: Theme.of(context).textTheme.body2),
                  TextSpan(text: 'à vos favoris en cliquant sur le ❤ dans la page de l\'Imam puis rafraîchissez la page en glissant vers le bas'),
                ]
            ),
          ),
        ),
      ],
    );
  }
}

class _AudioBoxItem extends StatelessWidget{
  final Audio audio;

  _AudioBoxItem(this.audio);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
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
                width: 1,
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
                      onPressed: () => audioModel.playOrPause(audio),
                      color: Colors.white,
                      icon: Icon(audioModel.audio != null && audioModel.audio.id == audio.id && audioModel.audioPlayer.state == AudioPlayerState.PLAYING ? Icons.pause:Icons.play_arrow),
                      iconSize: 50,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text('${audio.title}', style: Theme.of(context).textTheme.body2),
        SizedBox(height: 4),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/explore/imam/details', arguments: audio.user),
          child: Text('${audio.user.firstName} ${audio.user.lastName}', style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }
}