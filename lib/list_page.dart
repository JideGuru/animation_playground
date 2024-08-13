import 'package:animation_playground/animations_list.dart';
import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation Playground'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showAboutDialog(
                context: context,
                children: [
                  const Text(
                    'This is a project where i basically dump some animations '
                    'i work on from time to time. I hope it inspires and '
                    'help people with Flutter animations.',
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '- JideGuru 💙',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              );
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: animationList.length,
        itemBuilder: (BuildContext context, int index) {
          AnimationPage page = animationList[index];
          return ListTile(
            leading: Icon(page.icon),
            title: Text(page.title),
            onTap: () {
              Navigator.pushNamed(context, page.route);
            },
          );
        },
      ),
    );
  }
}
