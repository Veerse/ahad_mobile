
import 'package:ahadmobile/blocs/HomeTabs/Explore/ExploreTagBloc.dart';
import 'package:ahadmobile/blocs/HomeTabs/Explore/ExploreTagEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/Explore/ExploreTagStates.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/models/Favs.dart';
import 'package:ahadmobile/models/Tag.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:ahadmobile/repository/FavRepository.dart';
import 'package:ahadmobile/ui/Common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';

class ExploreTagDetails extends StatelessWidget {
  final ExploreTagBloc exploreTagBloc = new ExploreTagBloc();

  @override
  Widget build(BuildContext context) {
    final Tag tag = ModalRoute.of(context).settings.arguments;

    return BlocBuilder(
      bloc: exploreTagBloc,
      builder: (context, state){
        if (state is ExploreTagInitial){
          exploreTagBloc.add(FetchExploreTag(userId: Provider.of<UserModel>(context, listen: false).user.id, tag: tag));
          return Center(
            child: SpinKitFoldingCube(
              color: Theme.of(context).primaryColor,
              size: 25.0,
            ),
          );
        } else if (state is ExploreTagLoading) {
          return Center(
            child: SpinKitFoldingCube(
              color: Theme.of(context).primaryColor,
              size: 25.0,
            ),
          );
        } else if (state is ExploreTagLoaded) {
          return _TagDetails(state.tag, state.allAudios);
        } else if (state is ExploreTagLoadFailure) {
          return Text('State loading failure : ${state.e.toString()}');
        } else {
          return Center(
            child: Text('Unknown state'),
          );
        }
      },
    );
  }
}

class _FavButton extends StatefulWidget {
  final int tagId;
  final int userId;
  _FavButton(this.tagId, this.userId);

  @override
  State<StatefulWidget> createState() => _FavButtonState(tagId, userId);
}

class _FavButtonState extends State<_FavButton> {
  final FavRepository favRepository = new FavRepository();

  final int tagId;
  final int userId;
  _FavButtonState(this.tagId, this.userId);

  bool isFaved = false;


  @override
  void initState() {
    super.initState();

    favRepository.fetchTagIsFaved(tagId, userId).then((v){
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
            favRepository.createTagFav(new FavTag(userId: userId, tagId: tagId, isFaved: true));
          if(isFaved)
            favRepository.deleteFavTag(new FavTag(userId: userId, tagId: tagId, isFaved: true));
          isFaved = ! isFaved;
        });
      },
      icon: isFaved ? Icon(Icons.favorite, color: Colors.red):Icon(Icons.favorite_border),
    );
  }
}

class _TagDetails extends StatelessWidget {
  final Tag tag;
  final List<Audio> audios;

  _TagDetails(this.tag, this.audios);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionPlay(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(tag.tagName),
            //backgroundColor: Theme.of(context).primaryColor,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network('https://veerse.xyz/tag/${tag.id}/image', fit: BoxFit.cover),
            ),
            pinned: true,
            actions: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _FavButton(tag.id, Provider.of<UserModel>(context, listen: false).user.id)
                ),
              )
            ],
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),

          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index){
                return AudioItemList(audios.elementAt(index));
              },
                  childCount: audios.length),
            ),
          )
        ],
      ),
    );
  }
}