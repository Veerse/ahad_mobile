
import 'package:ahadmobile/blocs/HomeTabs/HomeBloc.dart';
import 'package:ahadmobile/blocs/HomeTabs/HomeEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/HomeStates.dart';
import 'package:ahadmobile/models/Announcement.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/providers/AudioModel.dart';
import 'package:ahadmobile/providers/UserModel.dart';
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
                    SizedBox(height: 64),
                    _ResumeAudio(audio: state.lastListenedAudio),
                    _SeparationWidget(),
                    _FeaturedAudio(state.featuredAudio), // Featured Audio
                    _SeparationWidget(),
                    _Announcement(state.announcement), // Announcement
                    _SeparationWidget(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: _LastListenedAudio(state.lastListenedAudio)
                        ),
                        Expanded(
                          child: _RandomAudio(state.randomAudio),
                        ),
                      ],
                    ),
                    _SeparationWidget(),
                    /* _LastImamsAudios(_homeTabBloc), // Last imams audios
            _separationWidget(),
            _LastMosquesAudios(_homeTabBloc), // Last mosques audios*/
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

class _ResumeAudio extends StatefulWidget {
  final Audio audio;
  _ResumeAudio({this.audio});

  @override
  State<StatefulWidget> createState() => _ResumeAudioState(audio);

}
class _ResumeAudioState extends State<_ResumeAudio> {
  final Audio audio;

  _ResumeAudioState(this.audio);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Reprendre', style: Theme.of(context).textTheme.title),
        SizedBox(height: 32),
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.red,
            image: DecorationImage(
              image: NetworkImage('https://veerse.xyz/user/${audio.user.id}/cover'),
              alignment: Alignment.lerp(Alignment.topCenter, Alignment.center, 0.2),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(16.0)
          ),
          child: Opacity(
            opacity: 0.9,
            child: Column(
              children: <Widget>[
                SizedBox(height: 16),
                Text('${audio.title}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: 4),
                Expanded(
                  child: IconButton(
                    onPressed: () => print('play'),
                    icon: Icon(Icons.play_arrow, size: 48),
                    color: Colors.white,
                  ),
                ),
                Slider(
                  onChanged: (v) => null,
                  activeColor: Colors.white,
                  min:0,
                  max: 100,
                  value: 65,
                ),
              ],
            ),
          )
        )
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
            GestureDetector(
              onLongPress: () => showAudioDialog(context, featuredAudio),
              child: Container(
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
            ),
            SizedBox(width: 16),
            Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${featuredAudio.title}', style: Theme.of(context).textTheme.body2,),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/explore/imam/details', arguments: featuredAudio.user),
                      child: Text('${featuredAudio.user.firstName} ${featuredAudio.user.lastName}', style: Theme.of(context).textTheme.caption),
                    ),
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

class _AudioBoxItem extends StatelessWidget{
  final Audio audio;

  _AudioBoxItem(this.audio);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      child: Column(
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
              // width: 130, // given on parent container
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
          SizedBox(height: _sizedBoxHeight),
          Text('${audio.title}', style: Theme.of(context).textTheme.body2),
          SizedBox(height: 4),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/explore/imam/details', arguments: audio.user),
            child: Text('${audio.user.firstName} ${audio.user.lastName}', style: Theme.of(context).textTheme.caption),
          ),
        ],
      ),
    );
  }
}