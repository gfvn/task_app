// ignore: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:junior_test/resources/api/mall_api_provider.dart';
import 'package:junior_test/tools/MyColors.dart';
import 'package:junior_test/tools/MyDimens.dart';
import 'package:junior_test/tools/Strings.dart';
import 'package:junior_test/ui/actions/item/actions_item_widget.dart';
import 'item/actions_item_arguments.dart';

class ActionsWidget extends StatelessWidget {
  @override
  final mallApiProvider = MallApiProvider();

  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        ActionsItemWidget.TAG: (context) => ActionsItemWidget(),
      },
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text(Strings.actions)),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 250.0,
                width: double.infinity,
                child: const Image(
                  image: NetworkImage(
                      'https://bonus.andreyp.ru//uploads/promo/img/1/thumb_1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                color: Colors.white,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: mallApiProvider.fetchActionInfoAll(1, 5),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return const Center(
                            child: Text(
                          'Loading...',
                          style: TextStyle(color: MyColors.black),
                        ));
                      } else {
                        return StaggeredGridView.countBuilder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot
                              .data.serverResponse.body.promo.list.length,
                          itemBuilder: (context, index) => buildItemCart(
                              snapshot
                                  .data.serverResponse.body.promo.list[index],
                              context),
                          staggeredTileBuilder: (index) =>
                              StaggeredTile.count(2, index.isEven ? 3 : 2),
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItemCart(snapshot, context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ActionsItemWidget.TAG,
            arguments: ActionsItemArguments(snapshot.id));
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), BlendMode.dstATop),
                  image: NetworkImage(
                    MallApiProvider.baseImageUrl + snapshot.imgFull,
                  ),
                ),
              ),
            ),
            Text(
              snapshot.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MyDimens.titleBig,
              ),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: Text(
                snapshot.shop,
                style: TextStyle(fontSize: MyDimens.subtitleBig),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
