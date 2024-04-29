import 'package:clp_flutter/models/depot.dart';
import 'package:clp_flutter/pages/mission/decisions_views.dart';
import 'package:clp_flutter/pages/mission/depots_view.dart';
import 'package:clp_flutter/pages/mission/discussions_view.dart';
import 'package:clp_flutter/pages/mission/mission_view.dart';
import 'package:clp_flutter/services/depots_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;

// import '../../models/fiche.dart';

class MissionPage extends StatefulWidget {
  MissionPage({super.key, this.mission, this.collecte});

  // ignore: prefer_typing_uninitialized_variables
  final mission;
  final collecte;

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  late String pdf;
  var isLoaded = false;
  var isLoadedFiche = false;
  final int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  List<depots>? depotsListe;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('La mission'),
      ),
           
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) => _pageController.jumpToPage(index),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'depots'),
            if (widget.mission.typeMission == "mairie") BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'décisions'),
            BottomNavigationBarItem(icon: Icon(Icons.comment_rounded), label: 'discussion'),
          ]),
      body: PageView(
        controller: _pageController,
        children: [
          MissionView(mission: widget.mission),
          DepotsView(collecte: widget.collecte, mission: widget.mission),
          if (widget.mission.typeMission == "mairie") DecisionsView(collecte: widget.collecte, mission: widget.mission),
          DiscussionsView(collecte: widget.collecte, mission: widget.mission)
        ],
      ),
    );
  }
}
