import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:stars/essentials/checkconnectivity.dart';
import 'package:stars/models/postbutton.dart';
import 'package:stars/pages/chatroom.dart';
import 'package:stars/pages/profile.dart';
import 'package:stars/pages/social.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  int activePage = 0;

  //controller used for main page
  PageController pagesController = PageController(
    keepPage: true,
  );
  //dispose method
  @override
  void dispose() {
    super.dispose();
    pagesController.dispose();
  }

// build method
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //Floating action button

        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: const PostButton(),
        bottomNavigationBar: SalomonBottomBar(
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).textTheme.displaySmall!.color,
          items: [
            for (int i = 0; i < _pages.length; i++)
              SalomonBottomBarItem(
                icon: _pages.values.toList()[i],
                title: Text(pageNames[i]),
              ),
          ],
          currentIndex: activePage,
          onTap: (value) {
            //  change the page selected
            pagesController.animateToPage(value,
                duration: const Duration(milliseconds: 1),
                curve: Curves.linear);
          },
        ),

        body:
            //main pages that users see
            DefaultTextStyle(
          style: Theme.of(context).textTheme.displaySmall!,
          child: PageView.builder(
            allowImplicitScrolling: true,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return CheckConnectivity(
                widgetModel: _pages.keys.toList()[index],
                refresh: () {
                  setState(() {});
                },
              );
            },
            controller: pagesController,
            onPageChanged: (value) {
              activePage = value;
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}

//content in  a page
final Map<Widget, Widget> _pages = {
  const Social(): const Icon(FontAwesome5.globe_asia),
  const ChatRoom(): const Icon(Icons.chat),
  const Profile(): const Icon(FontAwesome5.user),
};
final pageNames = ["social", "ChatRoom", "Profile"];
