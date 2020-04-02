
import 'package:ahadmobile/blocs/HomeTabs/HomeTabBloc.dart';
import 'package:ahadmobile/blocs/HomeTabs/HomeTabEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/HomeTabStates.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

const double _padding = 16;
const double _sizedBoxHeight = 16;

class HomeTab extends StatelessWidget{
  final RefreshController _refreshController = new RefreshController();
  final HomeTabBloc _homeTabBloc = new HomeTabBloc();

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: (){
        _homeTabBloc.add(FetchHomeTab(userId: 5));
        _refreshController.refreshCompleted();
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: _sizedBoxHeight),
            _FeaturedAudio(_homeTabBloc), // Featured Audio
            _separationWidget(),
            _Announcement(_homeTabBloc), // Announcement
            _separationWidget(),
            /* _LastImamsAudios(_homeTabBloc), // Last imams audios
            _separationWidget(),
            _LastMosquesAudios(_homeTabBloc), // Last mosques audios*/
            SizedBox(height: _sizedBoxHeight,),
          ],
        ),
      ),
    );
  }
}

class _separationWidget extends StatelessWidget{
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
  final HomeTabBloc _homeTabBloc;
  _FeaturedAudio(this._homeTabBloc);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeTabBloc, HomeTabState>(
      bloc: _homeTabBloc,
      builder: (context, state){
        if(state is HomeTabLoaded){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('En vedette', style: Theme.of(context).textTheme.title),
              SizedBox(height: _sizedBoxHeight),
              Row(
                children: <Widget>[
                  //_AudioBox(),
                  GestureDetector(
                    onTap: () => print('tapped'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          image: NetworkImage('https://veerse.xyz/user/${state.featuredAudio.user.id}/avatar'),
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
                                onPressed: () => audio.playOrPause(state.featuredAudio),
                                color: Colors.white,
                                icon: Icon(audio.audio.id == state.featuredAudio.id && audio.audioPlayer.state == AudioPlayerState.PLAYING ? Icons.pause:Icons.play_arrow),
                                iconSize: 50,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${state.featuredAudio.title}', style: Theme.of(context).textTheme.body2,),
                          Text('${state.featuredAudio.user.firstName} ${state.featuredAudio.user.lastName}', style: Theme.of(context).textTheme.caption),
                          SizedBox(height: 16),
                          Text('${state.featuredAudio.description}',
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
          ) ;
        } else{
          return Text('Loading');
        }
      },
    );
  }
}

class _Announcement extends StatelessWidget{
  final HomeTabBloc _homeTabBloc;
  _Announcement(this._homeTabBloc);

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<HomeTabBloc, HomeTabState>(
      bloc: _homeTabBloc,
      builder: (context, state){
        if(state is HomeTabInitial){
          return Text('initial');
        }
        if(state is HomeTabLoading){
          return Text('Loading');
        }
        if(state is HomeTabLoaded){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${state.announcement.announcementTitle}', style: Theme.of(context).textTheme.title),
              Text('${DateFormat("dd-MM-yyyy").format(state.announcement.announcementStartDate)}', style: Theme.of(context).textTheme.caption),
              SizedBox(height: _sizedBoxHeight,),
              Text('${state.announcement.announcementBody}'),
            ],
          );
        }
        if(state is HomeTabLoadFailure){
          return Text(state.e.toString());
        }
        return Text('NOT FOUND STATE');
      },
    );
  }
}

class _LastImamsAudios extends StatelessWidget{
  final HomeTabBloc _homeTabBloc;
  _LastImamsAudios(this._homeTabBloc);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Derniers audios de mes Imams', style: Theme.of(context).textTheme.title),
        SizedBox(height: _sizedBoxHeight),
        BlocBuilder<HomeTabBloc, HomeTabState>(
          bloc: _homeTabBloc,
          builder: (context, state){
            if(state is HomeTabInitial){
              return Text('Initial');
            }
            if(state is HomeTabLoaded){
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
  final HomeTabBloc _homeTabBloc;
  _LastMosquesAudios(this._homeTabBloc);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Derniers audios de mes Mosquees', style: Theme.of(context).textTheme.title),
        SizedBox(height: _sizedBoxHeight),
        BlocBuilder<HomeTabBloc, HomeTabState>(
          bloc: _homeTabBloc,
          builder: (context, state){
            if(state is HomeTabInitial){
              return Text('Initial');
            }
            if(state is HomeTabLoaded){
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
  final Audio _audio;

  _AudioBoxItem(this._audio);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 120, // (b) - see below
          width: 120,
          child: Card(
            color: Colors.red,
          ),
        ),
        SizedBox(
          width: 110,
          height: 40, // MUST be equals ton container (a) height - sizedBox (b) height
          child: Text('${_audio.title}', overflow: TextOverflow.fade),
        )
      ],
    );
  }
}