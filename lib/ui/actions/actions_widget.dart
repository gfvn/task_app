// ignore: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:junior_test/blocs/actions/actions_item_query_bloc.dart';
import 'package:junior_test/blocs/base/bloc_provider.dart';
import 'package:junior_test/model/actions/Promo.dart';
import 'package:junior_test/model/actions/promo_item.dart';
import 'package:junior_test/model/root_response.dart';
import 'package:junior_test/resources/api/RootType.dart';
import 'package:junior_test/resources/api/mall_api_provider.dart';
import 'package:junior_test/tools/MyDimens.dart';
import 'package:junior_test/tools/Strings.dart';
import 'package:junior_test/ui/base/new_base_page_state.dart';

import 'item/actions_item_arguments.dart';
import 'item/actions_item_widget.dart';

class ActionsWidget extends StatefulWidget {
  @override
  _ActionsWidgetState createState() => _ActionsWidgetState();
}

class _ActionsWidgetState extends NewBasePageState<ActionsWidget> {
  ActionsItemQueryBloc bloc;

  _ActionsWidgetState() {
    bloc = ActionsItemQueryBloc();
  }

  void runOnWidgetInit() {
    bloc.loadAction(1,5);
  }

  @override
  Widget build(BuildContext context) {
    return
      BlocProvider<ActionsItemQueryBloc>(
                  bloc: bloc, child: getBaseQueryStream(bloc.shopItemContentStream));

  }

  @override
  Widget onSuccess(RootTypes event, RootResponse response) {
    var actionInfo = response.serverResponse.body.promo;
    var imageInfo = 'uploads/promo/img/1/thumb_1.jpg';
    return getNetworkAppBar(
        imageInfo, _getBody(actionInfo), Strings.actions,
        brightness: Brightness.dark);
  }

  Widget _getBody(Promos actionInfo) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _getCategories(actionInfo),
          ],
        ));
  }


  Widget _getCategories(Promos actionInfo) => Container(
    color: Colors.white,
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: _staggeredGridView(actionInfo),
    ),
  );

  Widget _staggeredGridView(actionInfo) => StaggeredGridView.countBuilder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: actionInfo.list.length,
    itemBuilder: (context, index) => _buildItemCart(
        actionInfo.list[index],
        context),
    staggeredTileBuilder: (index) =>
        StaggeredTile.count(2, index.isEven ? 3 : 2),
    crossAxisCount: 4,
    crossAxisSpacing: 10,
    mainAxisSpacing: 8,
  );

  Widget _buildItemCart(actionInfo, context) {
    return InkWell(
      onTap: () {
        _navigatorPush(actionInfo,context);
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            _imageThumb(actionInfo),
            _nameInfo(actionInfo),
            _showInfo(actionInfo),
          ],
        ),
      ),
    );
  }

  void _navigatorPush(actionInfo,context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActionsItemWidget(),
        settings: RouteSettings(
          arguments: ActionsItemArguments(actionInfo.id),),),);
  }

  Widget _imageThumb(actionInfo) => Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3), BlendMode.dstATop),
        image: NetworkImage(
          MallApiProvider.baseImageUrl + actionInfo.imgThumb,
        ),
      ),
    ),
  );

  Widget _nameInfo(actionInfo) => Text(
    actionInfo.name,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: MyDimens.titleBig,
    ),
  );

  Widget _showInfo(actionInfo) => Positioned(
    bottom: 12,
    right: 12,
    child: Text(
      actionInfo.shop,
      style: TextStyle(fontSize: MyDimens.subtitleBig),
    ),
  );

}