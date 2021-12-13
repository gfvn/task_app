import 'package:flutter/cupertino.dart';

class MallLogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
        child: Stack(children: const [
          Image(
            image: NetworkImage('https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png'),
            fit: BoxFit.cover,
          ),
          /*  Container(
              margin: EdgeInsets.only(left: 24.0, top: 24.0, bottom: 8.0),
              child: Image(image: AssetImage('mall_logo_transparent.png')))*/
        ]),
        fit: BoxFit.cover);
  }
}
