import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
        // titlePadding: EdgeInsets.only(bottom: 15),
        centerTitle: true,
        title:
            //  isSearchClicked
            //     ?
            Container(
          // padding: EdgeInsets.only(bottom: 2),
          // constraints: BoxConstraints(minHeight: 40, maxHeight: 40),
          width: 220,
          child: CupertinoTextField(
            // controller: _filter,
            keyboardType: TextInputType.text,
            placeholder: "Search..",
            placeholderStyle: const TextStyle(
              color: Color(0xffC4C6CC),
              fontSize: 14.0,
              fontFamily: 'Brutal',
            ),
            suffix: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: InkWell(
                onTap: (() {}),
                child: const Icon(
                  Icons.search,
                ),
              ),
            ),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
          ),
        ),
        // : Text("Tutorial"),
        background: Image.asset(
          "assets/images/background.jpg",
          fit: BoxFit.cover,
        ));
  }
}
