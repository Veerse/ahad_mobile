
import 'package:ahadmobile/blocs/HomeTabs/Explore/ExploreTagBloc.dart';
import 'package:ahadmobile/blocs/HomeTabs/Explore/ExploreTagEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/Explore/ExploreTagStates.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/models/Tag.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:ahadmobile/ui/Common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
              color: Colors.lightGreen,
              size: 25.0,
            ),
          );
        } else if (state is ExploreTagLoading) {
          return Center(
            child: SpinKitFoldingCube(
              color: Colors.lightGreen,
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