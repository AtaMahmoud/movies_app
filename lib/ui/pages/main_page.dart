import 'package:flutter/material.dart';

import '../pages/movie_list.dart';
import '../../scoped-models/main.dart';

class MainPage extends StatefulWidget {
  final MainModel mainModel;

  const MainPage(this.mainModel);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  
  
  PageController _pageController;

  final _bottomNavigationBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.movie), title: Text('Movies')),
    BottomNavigationBarItem(
        icon: Icon(Icons.favorite), title: Text('Favorite Movies')),
   
  ];
  final List<String> titles = [
    'Movies',
    'Favorite Movies',
    
  ];
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      items: _bottomNavigationBarItems,
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _onNavigationTapped,
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    widget.mainModel.getAllMovies().then((_){
      widget.mainModel.getUserFavotiteMovies();
    });
    
  }

  void _onNavigationTapped(int pageIndex) {
    _pageController.animateToPage(pageIndex,
        duration: Duration(
          milliseconds: 300,
        ),
        curve: Curves.ease);
  }

  void _onPageChannged(int pageIndex) {
    setState(() {
      _currentIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChannged,
        children: <Widget>[
         MovieList(widget.mainModel),
         MovieList(widget.mainModel,true),
        ],
      ),
    );
  }
}
