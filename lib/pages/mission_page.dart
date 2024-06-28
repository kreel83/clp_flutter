import 'package:clp_flutter/models/depot.dart';
import 'package:clp_flutter/pages/mission/decisions_views.dart';
import 'package:clp_flutter/pages/mission/depots_view.dart';
import 'package:clp_flutter/pages/mission/discussions_view.dart';
import 'package:clp_flutter/pages/mission/mission_view.dart';
import 'package:flutter/material.dart';

class MissionPage extends StatefulWidget {
  const MissionPage(
      {super.key, this.mission, this.collecte, this.defaultIndex});

  // ignore: prefer_typing_uninitialized_variables
  final defaultIndex;
  // ignore: prefer_typing_uninitialized_variables
  final mission;
  // ignore: prefer_typing_uninitialized_variables
  final collecte;

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  late String pdf;
  var isLoaded = false;
  var isLoadedFiche = false;
  int _currentIndex = 0;
  final String titleMisson = "Mission";
  late PageController _pageController;
  List<depots>? depotsListe;

  final title4 = ['Home', 'Dépots', 'Décisions', 'Discussions'];
  final title3 = ['Home', 'Dépots', 'Discussions'];

  late final List<String> _titles;
  late final List<Center> _pages;

  final pages4 = [
    const Center(child: Text('Home page')),
    const Center(child: Text('Dépots')),
    const Center(child: Text('Décisions')),
    const Center(child: Text('Discussions')),
  ];

  final pages3 = [
    const Center(child: Text('Home page')),
    const Center(child: Text('Dépots')),
    const Center(child: Text('Discussions')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.defaultIndex;
    _pageController = PageController(initialPage: _currentIndex);
    if (widget.mission.typeMission == "mairie") {
      _titles = title4;
      _pages = pages4;
    } else {
      _titles = title3;
      _pages = pages4;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_interpolation_to_compose_strings
        title: Text('N° ${widget.mission.id} à ${widget.mission.commune}'),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) =>
              {_pageController.jumpToPage(index), _onItemTapped(index)},
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'home'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.list), label: 'depots'),
            if (widget.mission.typeMission == "mairie")
              const BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt), label: 'décisions'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.comment_rounded), label: 'discussion'),
          ]),
      body: PageView(
        controller: _pageController,
        children: [
          MissionView(mission: widget.mission),
          DepotsView(collecte: widget.collecte, mission: widget.mission),
          if (widget.mission.typeMission == "mairie")
            DecisionsView(collecte: widget.collecte, mission: widget.mission),
          DiscussionsView(collecte: widget.collecte, mission: widget.mission)
        ],
      ),
    );
  }
}
