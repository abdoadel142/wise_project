import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

class constant {
//AppBar customAppBar(){
//  return AppBar()
//}

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
  var selected = [];

  final titleTextstile = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      letterSpacing: 1,
      fontSize: 20.0);

  Widget chooise_chips(BuildContext Context, int index) {
    return FilterChip(
      label: Text(data[index]),
      onSelected: (bool value) {
        if (selected.contains(index)) {
          selected.remove(index);
        } else {
          selected.add(index);
        }
      },
      selected: selected.contains(index),
      selectedColor: Colors.black87,
      labelStyle: TextStyle(
        color: Colors.white,
      ),
      backgroundColor: Colors.grey,
      checkmarkColor: Colors.white,
    );
  }
}
