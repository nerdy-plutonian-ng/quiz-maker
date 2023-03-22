import 'package:flutter/material.dart';
import 'package:quiz_maker/data/constants/app_dimensions.dart';
import 'package:quiz_maker/data/local_data/home_nav_menu.dart';
import 'package:quiz_maker/ui/widgets/control_box.dart';
import 'package:quiz_maker/ui/widgets/home.dart';
import 'package:quiz_maker/ui/widgets/play.dart';
import 'package:quiz_maker/ui/widgets/profile.dart';
import 'package:quiz_maker/ui/widgets/stats.dart';

const tabs = [HomeWidget(), PlayWidget(), StatsWidget(), ProfileWidget()];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: deviceWidth <= AppDimensions.portraitTabletWidth,
        title: const Text('Quiz Maker'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (deviceWidth > AppDimensions.portraitTabletWidth)
                NavigationRail(
                    extended: true,
                    destinations: homeNav
                        .map((item) => NavigationRailDestination(
                            icon: Icon(item.iconData), label: Text(item.title)))
                        .toList(growable: false),
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    }),
              if (deviceWidth > AppDimensions.portraitTabletWidth)
                const VerticalDivider(),
              Expanded(
                  child: ControlBox(
                child: tabs[_selectedIndex],
              ))
            ],
          ),
        ),
      ),
      bottomNavigationBar: deviceWidth <= AppDimensions.portraitTabletWidth
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: homeNav
                  .map((item) => NavigationDestination(
                      key: Key(item.id),
                      icon: Icon(item.iconData),
                      label: item.title))
                  .toList(growable: false),
            )
          : null,
    );
  }
}
