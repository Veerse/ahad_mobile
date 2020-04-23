
import 'package:ahadmobile/blocs/HomeTabs/ExploreBloc.dart';
import 'package:ahadmobile/blocs/HomeTabs/ExploreEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/ExploreStates.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:ahadmobile/ui/Common.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

const double _sizedBoxHeight = 16;

class ExploreTab extends StatelessWidget {
  final RefreshController _refreshController = new RefreshController();
  final ExploreBloc _exploreBloc = new ExploreBloc();

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
        _exploreBloc.add(FetchExplore(userId: Provider.of<UserModel>(context, listen: false).user.id));
        _refreshController.refreshCompleted();
      },
      child: BlocBuilder(
          bloc: _exploreBloc,
          builder: (context, state){
            if (state is ExploreInitial) {
              _exploreBloc.add(FetchExplore(userId: Provider.of<UserModel>(context, listen: false).user.id));
              return Center(
                child: SpinKitFoldingCube(
                  color: Theme.of(context).primaryColor,
                  size: 25.0,
                ),
              );
            } else if (state is ExploreLoading) {
              return Center(
                child: SpinKitFoldingCube(
                  color: Theme.of(context).primaryColor,
                  size: 25.0,
                ),
              );
            } else if (state is ExploreLoaded){
              return SingleChildScrollView (
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 64),
                    _SearchBar(),
                    SizedBox(height: 32),
                    _Categories(state),
                    _SeparationWidget(),
                    _LastPostedAudios(state.lastAudiosAdded),
                    _SeparationWidget(),
                    SizedBox(height: 64),
                  ],
                ),
              );
            } else if (state is ExploreLoadFailure) {
              return Text('Load failur ${state.e.toString()}');
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
        SizedBox(height: _sizedBoxHeight),
        Divider(),
        SizedBox(height: _sizedBoxHeight),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: FormBuilderTextField(
        readOnly: true,
        attribute: "search",
        initialValue: "",
        decoration: InputDecoration(
            suffixIcon: Icon(Icons.search),
            hintText: 'Rechercher un audio, un imam ou un thème',
            hintStyle: Theme.of(context).textTheme.caption
        ),
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  final ExploreLoaded _state;
  _Categories(this._state);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Imams'),
            trailing: Icon(Icons.navigate_next),
            onTap: () => Navigator.pushNamed(context, '/explore/imams', arguments: _state.allImams),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.apps),
            title: Text('Themes'),
            trailing: Icon(Icons.navigate_next),
            onTap: () => Navigator.pushNamed(context, '/explore/tags', arguments: _state.allTags),
          ),
        )
      ],
    );
  }
}

class _LastPostedAudios extends StatelessWidget {
  final List<Audio> audios;

  _LastPostedAudios(this.audios);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Derniers ajouts', style: Theme.of(context).textTheme.title),
        SizedBox(height: 32),
        Container(
          height: 240,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
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