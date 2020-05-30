import 'package:flutter/material.dart';
import 'package:wise/classes/category.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

class test extends StatefulWidget {
  static const id = 'test';
  @override
  _testState createState() => _testState();
}

class _testState extends State<test> with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  var data = [
    'Sports',
    'Eduction',
    'Culture',
    'Food',
    'Science',
    'Travel',
    'Work issues',
    'free time',
    'Music',
    'Movies',
    'Books',
    'Travel',
    'Hobbies',
    'Childern',
    'Pets',
    'Humor',
    'Sexual assault',
    'College Life',
    'Family Problems'
  ];

  final List<Category> categories = [
    Category(9, "General Knowledge", icon: FontAwesomeIcons.globeAsia),
    Category(10, "Books", icon: FontAwesomeIcons.bookOpen),
    Category(11, "Film", icon: FontAwesomeIcons.video),
    Category(12, "Music", icon: FontAwesomeIcons.music),
    Category(13, "Musicals & Theatres", icon: FontAwesomeIcons.theaterMasks),
    Category(14, "Television", icon: FontAwesomeIcons.tv),
    Category(15, "Video Games", icon: FontAwesomeIcons.gamepad),
    Category(16, "Board Games", icon: FontAwesomeIcons.chessBoard),
    Category(17, "Science & Nature", icon: FontAwesomeIcons.microscope),
    Category(18, "Computer", icon: FontAwesomeIcons.laptopCode),
    Category(19, "Maths", icon: FontAwesomeIcons.sortNumericDown),
    Category(20, "Mythology"),
    Category(21, "Sports", icon: FontAwesomeIcons.footballBall),
    Category(22, "Geography", icon: FontAwesomeIcons.mountain),
    Category(23, "History", icon: FontAwesomeIcons.monument),
    Category(24, "Politics"),
    Category(25, "Art", icon: FontAwesomeIcons.paintBrush),
    Category(26, "Celebrities"),
    Category(27, "Animals", icon: FontAwesomeIcons.dog),
    Category(28, "Vehicles", icon: FontAwesomeIcons.carAlt),
    Category(29, "Comics", icon: Icons.face),
    Category(30, "Gadgets", icon: FontAwesomeIcons.mobileAlt),
    Category(31, "Japanese Anime & Manga"),
    Category(32, "Cartoon & Animation"),
  ];

  var selected = [];
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                leading: Icon(
                  Icons.apps,
                  color: Colors.white,
                ),
                title: Text(
                  'Topics',
                ),
                backgroundColor: Colors.black,
                floating: false,
                pinned: true,
              ),
            ];
          },
          body: Stack(
            children: <Widget>[
              CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Select your topics',
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w800,
                            fontSize: 30),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(16.0),
                    sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.2,
                        ),
                        delegate: SliverChildBuilderDelegate(_buildCategoryItem,
                            childCount: categories.length)),
                  )
                ],
              )
            ],
          )),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = categories[index];
    return MaterialButton(
      onPressed: () {
        setState(() {});
      },
      elevation: 10.0,
      highlightElevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      disabledColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
          .withOpacity(1.0),
      disabledTextColor: Colors.black87,
      color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
          .withOpacity(1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (category.icon != null) Icon(category.icon),
          if (category.icon != null) SizedBox(height: 5.0),
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget chooise_chips(BuildContext Context, int index) {
    return FilterChip(
      label: Text(data[index]),
      onSelected: (bool value) {
        if (selected.contains(index)) {
          selected.remove(index);
        } else {
          selected.add(index);
        }
        setState(() {});
      },
      selected: selected.contains(index),
      selectedColor: Colors.black87,
      labelStyle: TextStyle(
        color: Colors.white,
      ),
      backgroundColor:
          Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0)
              .withOpacity(1.0),
      checkmarkColor: Colors.white,
    );
  }
}
