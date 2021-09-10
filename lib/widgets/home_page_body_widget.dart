import 'package:flutter/material.dart';
import 'package:maps/constants/home_page_sizedbox_constant.dart';
import 'package:maps/constants/home_page_text_constants.dart';
import 'package:maps/constants/icon_constant.dart';
import 'package:maps/pages/map_page.dart';

class HomePageBodyWidget extends StatelessWidget {
  const HomePageBodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          kHomeIcon,
          SizedBox(
            height: HomeKHeight,
          ),
          Text(
            'Get User Location',
            style: kHomeTextStyle,
          ),
          SizedBox(
            height: HomeKHeight,
          ),
          SizedBox(
            height: HomeKHeight,
          ),
          FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MapPage(),
                ),
              );
            },
            color: Color.fromRGBO(4, 122, 24, 0.2),
            splashColor: Colors.green,
            child: Text('Open Google Map'),
          ),
        ],
      ),
    );
  }
}
