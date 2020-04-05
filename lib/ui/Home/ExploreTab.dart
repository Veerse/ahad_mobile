
import 'package:ahadmobile/blocs/HomeTabs/ExploreBloc.dart';
import 'package:ahadmobile/blocs/HomeTabs/ExploreEvents.dart';
import 'package:ahadmobile/blocs/HomeTabs/ExploreStates.dart';
import 'package:ahadmobile/providers/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                color: Colors.lightGreen,
                size: 25.0,
              ),
            );
          } else if (state is ExploreLoading) {
            return Center(
              child: SpinKitFoldingCube(
                color: Colors.lightGreen,
                size: 25.0,
              ),
            );
          } else if (state is ExploreLoaded){
            return SingleChildScrollView (
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: _sizedBoxHeight),
                  _Categories(state),
                  _separationWidget()
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
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.all_inclusive),
            title: Text('Tous les audios'),
            trailing: Icon(Icons.navigate_next),
            onTap: () => Navigator.pushNamed(context, '/explore/all', arguments: _state.allAudios),
          ),
        ),
      ],
    );
  }

}