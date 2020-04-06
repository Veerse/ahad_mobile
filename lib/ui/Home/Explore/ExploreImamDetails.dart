
import 'package:ahadmobile/blocs/HomeTabs/Explore/ExploreImamBloc.dart';
import 'package:ahadmobile/blocs/HomeTabs/Explore/ExploreImamEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/Explore/ExploreImamStates.dart';
import 'package:ahadmobile/models/Audio.dart';
import 'package:ahadmobile/models/User.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:ahadmobile/ui/Common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
              color: Colors.lightGreen,
              size: 25.0,
            ),
          );
        } else if (state is ExploreImamLoading) {
          return Center(
            child: SpinKitFoldingCube(
              color: Colors.lightGreen,
              size: 25.0,
            ),
          );
        } else if (state is ExploreImamLoaded) {
          return _ImamDetails(state.imam, state.allAudios);
        } else if (state is ExploreImamLoadFailure) {
          return Center(child: Text('Load failure ${state.e.toString()}'));
        } else {
          return Center(child: Text('Unknown state'));
        }
      },
    );
  }
}

class _ImamDetails extends StatelessWidget {
  final User imam;
  final List<Audio> audios;

  _ImamDetails(this.imam, this.audios);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionPlay(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('${imam.firstName} ${imam.lastName}'),
            //backgroundColor: Theme.of(context).primaryColor,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network('https://veerse.xyz/user/${imam.id}/cover', fit: BoxFit.cover),
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