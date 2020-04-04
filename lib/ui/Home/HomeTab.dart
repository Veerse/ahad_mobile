
import 'package:ahadmobile/blocs/HomeTabs/HomeBloc.dart';
import 'package:ahadmobile/blocs/HomeTabs/HomeEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/HomeStates.dart';
import 'package:ahadmobile/models/Announcement.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

const double _sizedBoxHeight = 16;

class HomeTab extends StatelessWidget{
  final RefreshController _refreshController = new RefreshController();
  final HomeBloc _homeTabBloc = new HomeBloc();

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: (){
        Vibrate.canVibrate.then((v){
          if (v == true){
            Vibrate.feedback(FeedbackType.light);
          }
        });
        _homeTabBloc.add(FetchHome(userId: Provider.of<UserModel>(context, listen: false).user.id));
        _refreshController.refreshCompleted();
      },
      child: BlocBuilder(
          bloc: _homeTabBloc,
          builder: (context, state) {
            if (state is HomeInitial) {
              _homeTabBloc.add(FetchHome(userId: Provider.of<UserModel>(context, listen: false).user.id));
              return Center(
                child: SpinKitFoldingCube(
                  color: Colors.lightGreen,
                  size: 25.0,
                ),
              );
            } else if (state is HomeLoading) {
              return Center(
                child: SpinKitFoldingCube(
                  color: Colors.lightGreen,
                  size: 25.0,
                ),
              );
            } else if (state is HomeLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: _sizedBoxHeight),
                    _FeaturedAudio(state.featuredAudio), // Featured Audio
                    _SeparationWidget(),
                    _Announcement(state.announcement), // Announcement
                    _SeparationWidget(),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: _LastListenedAudio(state.lastListenedAudio)
                        ),
                        Flexible(
                          child: _RandomAudio(state.randomAudio),
                        ),
                      ],
                    ),
                    _SeparationWidget(),
                    /* _LastImamsAudios(_homeTabBloc), // Last imams audios
            _separationWidget(),
            _LastMosquesAudios(_homeTabBloc), // Last mosques audios*/
                    SizedBox(height: _sizedBoxHeight*2),
                  ],
                ),
              );
            } else if (state is HomeLoadFailure) {
              return Center(
                child: Text('Load failure ${state.e.toString()}'),
              );
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
        SizedBox(height: _sizedBoxHeight)
      ],
    );
  }
}

class _FeaturedAudio extends StatelessWidget {
  final Audio featuredAudio;
  _FeaturedAudio(this.featuredAudio);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('En vedette', style: Theme.of(context).textTheme.title),
        SizedBox(height: _sizedBoxHeight),
        Row(
          children: <Widget>[
            //_AudioBox(),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: DecorationImage(
                  image: NetworkImage('https://veerse.xyz/user/${featuredAudio.user.id}/avatar'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              height: 130,
              width: 130,
              alignment: Alignment.bottomRight,
              child: Center(
                child: Opacity(
                  opacity: 0.5,
                  child: Consumer<AudioModel>(
                    builder: (context, audio, child){
                      return IconButton(
                        onPressed: () => audio.playOrPause(featuredAudio),
                        color: Colors.white,
                        icon: Icon(audio.audio != null && audio.audio.id == featuredAudio.id && audio.audioPlayer.state == AudioPlayerState.PLAYING ? Icons.pause:Icons.play_arrow),
                        iconSize: 50,
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${featuredAudio.title}', style: Theme.of(context).textTheme.body2,),
                    Text('${featuredAudio.user.firstName} ${featuredAudio.user.lastName}', style: Theme.of(context).textTheme.caption),
                    SizedBox(height: 16),
                    Text('${featuredAudio.description}',
                      textAlign: TextAlign.justify,
                      maxLines: 4,
                      overflow: TextOverflow.fade,
                    )
                  ],
                )
            )
          ],
        ),
      ],
    );
  }
}

class _Announcement extends StatelessWidget{
  final Announcement announcement;
  _Announcement(this.announcement);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('${announcement.announcementTitle}', style: Theme.of(context).textTheme.title),
        Text('${DateFormat("dd-MM-yyyy").format(announcement.announcementStartDate)}', style: Theme.of(context).textTheme.caption),
        SizedBox(height: _sizedBoxHeight,),
        Text('${announcement.announcementBody}'),
      ],
    );
  }
}

class _LastListenedAudio extends StatelessWidget {
  final Audio lastListenedAudio;
  _LastListenedAudio(this.lastListenedAudio);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Reprendre', style: Theme.of(context).textTheme.title),
        SizedBox(height: _sizedBoxHeight),
        _AudioBoxItem(lastListenedAudio)
      ],
    );
  }
}

class _RandomAudio extends StatelessWidget {
  final Audio randomAudio;
  _RandomAudio(this.randomAudio);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Au hasard', style: Theme.of(context).textTheme.title),
        SizedBox(height: _sizedBoxHeight),
        _AudioBoxItem(randomAudio)
      ],
    );
  }
}

class _LastImamsAudios extends StatelessWidget{
  final HomeBloc _homeBloc;
  _LastImamsAudios(this._homeBloc);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Derniers audios de mes Imams', style: Theme.of(context).textTheme.title),
        SizedBox(height: _sizedBoxHeight),
        BlocBuilder<HomeBloc, HomeState>(
          bloc: _homeBloc,
          builder: (context, state){
            if(state is HomeInitial){
              return Text('Initial');
            }
            if(state is HomeLoaded){
              return Container(
                height: 170,
                child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.lastImamsAudios.length,
                    itemBuilder: (BuildContext context, int index){
                      return _AudioBoxItem(state.lastImamsAudios.elementAt(index));
                    }
                ),
              );
            } else{
              return Text('na');
            }
          },
        )
      ],
    );
  }
}

class _LastMosquesAudios extends StatelessWidget{
  final HomeBloc _homeTabBloc;
  _LastMosquesAudios(this._homeTabBloc);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Derniers audios de mes Mosquees', style: Theme.of(context).textTheme.title),
        SizedBox(height: _sizedBoxHeight),
        BlocBuilder<HomeBloc, HomeState>(
          bloc: _homeTabBloc,
          builder: (context, state){
            if(state is HomeInitial){
              return Text('Initial');
            }
            if(state is HomeLoaded){
              return Container(
                height: 170,
                child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.lastImamsAudios.length,
                    itemBuilder: (BuildContext context, int index){
                      return _AudioBoxItem(state.lastImamsAudios.elementAt(index));
                    }
                ),
              );
            } else{
              return Text('na');
            }
          },
        )
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
        Container(
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
          width: 130,
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
        SizedBox(height: _sizedBoxHeight),
        Text('${audio.title}', style: Theme.of(context).textTheme.body1)
      ],
    );
  }
}