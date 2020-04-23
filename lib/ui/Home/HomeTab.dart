
import 'package:ahadmobile/blocs/HomeTabs/HomeBloc.dart';
import 'package:ahadmobile/blocs/HomeTabs/HomeEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/HomeStates.dart';
import 'package:ahadmobile/models/Announcement.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:ahadmobile/repository/AudioRepository.dart';
import 'package:ahadmobile/ui/Common.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                  color: Theme.of(context).primaryColor,
                  size: 25.0,
                ),
              );
            } else if (state is HomeLoading) {
              return Center(
                child: SpinKitFoldingCube(
                  color: Theme.of(context).primaryColor,
                  size: 25.0,
                ),
              );
            } else if (state is HomeLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 64),
                    _Greetings(),
                    _SeparationWidget(),
                    state.lastListenedAudio != null ? _ResumeAudio(audio: state.lastListenedAudio):Container(),
                    state.lastListenedAudio != null ? _SeparationWidget():Container(),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _Featured(state.featuredAudio),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: _Random(state.randomAudio),
                        )
                      ],
                    ),
                    _SeparationWidget(),
                    state.audiosToFinish != null ?_AudiosToFinish(state.audiosToFinish):Container(),
                    state.audiosToFinish != null ? _SeparationWidget():Container(),
                    /*_Announcement(state.announcement), // Announcement
                    _SeparationWidget(),*/
                    SizedBox(height: _sizedBoxHeight*4),
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
        SizedBox(height: _sizedBoxHeight),
      ],
    );
  }
}

class _Greetings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, user, child) {
        return Row(
          children: <Widget>[
            Expanded(
              child: Text('Bonjour ${user.user.firstName}', style: Theme.of(context).textTheme.display1),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: Provider.of<UserModel>(context).user.isMale ?
                  AssetImage("assets/images/profile/muslim_man.png")
                      :
                  AssetImage("assets/images/profile/muslim_woman.png"),
                ),
              ),
            )
          ],
        );
      }
    );
  }
}


class _ResumeAudio extends StatefulWidget {
  final Audio audio;
  _ResumeAudio({this.audio});

  @override
  State<StatefulWidget> createState() => _ResumeAudioState(audio);
}

class _ResumeAudioState extends State<_ResumeAudio> {
  final Audio audio;

  double currentPosition = 0.0;

  _ResumeAudioState(this.audio);

  @override
  void initState() {
    super.initState();
    if(audio != null) {
      AudioRepository().fetchListening(Provider.of<UserModel>(context, listen: false).user.id, audio.id).then((v){
        setState(() {
          currentPosition = v.position.toDouble();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showAudioDialog(context, audio),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Reprendre', style: Theme.of(context).textTheme.title),
          SizedBox(height: 24),
          Stack(
            children: <Widget>[
              Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://veerse.xyz/user/${audio.user.id}/cover'),
                        alignment: Alignment.lerp(Alignment.topCenter, Alignment.center, 0.2),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(16.0)
                  ),
              ),
              Opacity(
                opacity: 0.3,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black,
                          Colors.transparent,
                          Colors.black
                        ]
                    ),
                    borderRadius: BorderRadius.circular(16.0)
                  ),
                ),
              ),
              Container(
                height: 200,
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 16),
                    Text('${audio.title}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18), textAlign: TextAlign.center,),
                    SizedBox(height: 4),
                    Expanded(
                      child: Consumer<AudioModel>(
                        builder: (context, audioModel, child) {
                          return IconButton(
                            onPressed: () {
                              vibrate(FeedbackType.light);
                              audioModel.playOrPause(audio);
                            },
                            icon: Icon( audioModel.audio != null && audioModel.audio.id == audio.id && audioModel.audioPlayer.state == AudioPlayerState.PLAYING ? Icons.pause:Icons.play_arrow, size: 48),
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                    //SizedBox(height: 24),
                    Text('${((audio.length - currentPosition)/60).floor()} minutes restantes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 16)),
                    SizedBox(height: 16)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

/*


class _ResumeAudioState extends State<_ResumeAudio> {
  final Audio audio;

  double currentPosition = 0.0;

  _ResumeAudioState(this.audio);

  @override
  void initState() {
    super.initState();
    if(audio != null) {
      AudioRepository().fetchListening(Provider.of<UserModel>(context, listen: false).user.id, audio.id).then((v){
        setState(() {
          currentPosition = v.position.toDouble();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showAudioDialog(context, audio),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Reprendre', style: Theme.of(context).textTheme.title),
          SizedBox(height: 24),
          Stack(
            children: <Widget>[
              Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://veerse.xyz/user/${audio.user.id}/cover'),
                        alignment: Alignment.lerp(Alignment.topCenter, Alignment.center, 0.2),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(16.0)
                  ),
              ),
              Opacity(
                opacity: 0.3,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black,
                          Colors.transparent,
                          Colors.black
                        ]
                    ),
                    borderRadius: BorderRadius.circular(16.0)
                  ),
                ),
              ),
              Container(
                height: 200,
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 16),
                    Text('${audio.title}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18), textAlign: TextAlign.center,),
                    SizedBox(height: 4),
                    Expanded(
                      child: Consumer<AudioModel>(
                        builder: (context, audioModel, child) {
                          return IconButton(
                            onPressed: () {
                              Vibrate.canVibrate.then((v){
                                if (v == true){
                                  Vibrate.feedback(FeedbackType.light);
                                }
                              });
                              audioModel.playOrPause(audio);
                            },
                            icon: Icon( audioModel.audio != null && audioModel.audio.id == audio.id && audioModel.audioPlayer.state == AudioPlayerState.PLAYING ? Icons.pause:Icons.play_arrow, size: 48),
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                    //SizedBox(height: 24),
                    Text('${((audio.length - currentPosition)/60).floor()} minutes restantes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 16)),
                    SizedBox(height: 16)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

 */

class _Featured extends StatelessWidget {
  final Audio audio;

  _Featured(this.audio);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showAudioDialog(context, audio),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("En vedette", style: Theme.of(context).textTheme.title),
          SizedBox(height: 16),
          Stack(
            children: <Widget>[
              Container(
                height: 250,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://veerse.xyz/user/${audio.user.id}/avatar'),
                      //alignment: Alignment.lerp(Alignment.topCenter, Alignment.center, 0.2),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(16)
                ),
              ),
              Container(
                height: 250,
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black,
                          ]
                      ),
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              Container(
                height: 250,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: 125,
                        width: double.infinity,
                        child: Consumer<AudioModel>(
                          builder: (context, audioModel, child) {
                            return IconButton(
                              onPressed: () {
                                Vibrate.canVibrate.then((v){
                                  if (v == true){
                                    Vibrate.feedback(FeedbackType.light);
                                  }
                                });
                                audioModel.playOrPause(audio);
                              },
                              icon: Icon( audioModel.audio != null && audioModel.audio.id == audio.id && audioModel.audioPlayer.state == AudioPlayerState.PLAYING ? Icons.pause:Icons.play_arrow, size: 48),
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('${audio.title}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/explore/imam/details', arguments: audio.user),
                        child: Text('${audio.user.firstName} ${audio.user.lastName}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _Random extends StatelessWidget {
  final Audio audio;

  _Random(this.audio);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showAudioDialog(context, audio),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Au hasard", style: Theme.of(context).textTheme.title),
          SizedBox(height: 16),
          Stack(
            children: <Widget>[
              Container(
                height: 250,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://veerse.xyz/user/${audio.user.id}/avatar'),
                      //alignment: Alignment.lerp(Alignment.topCenter, Alignment.center, 0.2),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(16)
                ),
              ),
              Container(
                height: 250,
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black,
                          ]
                      ),
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              Container(
                height: 250,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: 125,
                        width: double.infinity,
                        child: Consumer<AudioModel>(
                          builder: (context, audioModel, child) {
                            return IconButton(
                              onPressed: () {
                                Vibrate.canVibrate.then((v){
                                  if (v == true){
                                    Vibrate.feedback(FeedbackType.light);
                                  }
                                });
                                audioModel.playOrPause(audio);
                              },
                              icon: Icon( audioModel.audio != null && audioModel.audio.id == audio.id && audioModel.audioPlayer.state == AudioPlayerState.PLAYING ? Icons.pause:Icons.play_arrow, size: 48),
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('${audio.title}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/explore/imam/details', arguments: audio.user),
                        child: Text('${audio.user.firstName} ${audio.user.lastName}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _AudiosToFinish extends StatelessWidget {
  final List<Audio> audios;

  _AudiosToFinish(this.audios);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('N\'oubliez pas de terminer', style: Theme.of(context).textTheme.title),
        SizedBox(height: 24),
        Container(
          height: 230,
          //width: 200,
          child: ListView.builder(
            itemCount: audios.length <= 4 ? audios.length:4,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => _AudioItem(audios.elementAt(index))
          ),
        )
      ],
    );
  }
}

class _AudioItem extends StatelessWidget {
  final Audio audio;

  _AudioItem(this.audio);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showAudioDialog(context, audio),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
            height: 230,
            width: 200,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 250,
                  width: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://veerse.xyz/user/${audio.user.id}/avatar'),
                        alignment: Alignment.lerp(Alignment.topCenter, Alignment.center, 0.2),
                        fit: BoxFit.cover,
                      ),

                      borderRadius: BorderRadius.circular(32)
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: Container(
                    height: 230,
                    width: 200,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black
                            ]
                        ),
                        borderRadius: BorderRadius.circular(32)
                    ),
                  ),
                ),
                Container(
                  height: 230,
                  width: 200,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          height: 125,
                          width: double.infinity,
                          child: Consumer<AudioModel>(
                            builder: (context, audioModel, child) {
                              return IconButton(
                                onPressed: () {
                                  Vibrate.canVibrate.then((v){
                                    if (v == true){
                                      Vibrate.feedback(FeedbackType.light);
                                    }
                                  });
                                  audioModel.playOrPause(audio);
                                },
                                icon: Icon( audioModel.audio != null && audioModel.audio.id == audio.id && audioModel.audioPlayer.state == AudioPlayerState.PLAYING ? Icons.pause:Icons.play_arrow, size: 48),
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('${audio.title}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/explore/imam/details', arguments: audio.user),
                          child: Text('${audio.user.firstName} ${audio.user.lastName}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300)),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
        ),
      ),
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