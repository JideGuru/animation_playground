import 'package:animation_playground/animations_list.dart';
import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playground'),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: animationList.length,
        itemBuilder: (BuildContext context, int index) {
          AnimationPage page = animationList[index];
          return ListTile(
            leading: Icon(page.icon),
            title: Text(page.title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page.page),
              );
            },
          );
        },
      ),
    );
  }
}
