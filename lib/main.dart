import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'data/data.dart';
import 'models/TileModel.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TileModel> showPairs = <TileModel>[];
  List<TileModel> showTiles = <TileModel>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reStart();
  }
  void reStart() {

    iPairs = getPairs();
    iPairs.shuffle();

    showPairs = iPairs;
    Future.delayed(const Duration(seconds: 3), () {
// Here you can write your code
      setState(() {
        showTiles = getShowTiles();
        showPairs = showTiles;
        selected = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              score != 12 ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "$score/12",
                    style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "----Score----",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                ],
              ) : Container(),
              SizedBox(
                height: 20,
              ),
              score != 12 ? GridView(
                shrinkWrap: true,
                //physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisSpacing: 0.0, maxCrossAxisExtent: 100.0),
                children: List.generate(showPairs.length, (index) {
                  return Tile(
                    imageAssetPath: showPairs[index].getImageAssetPath(),
                    tileIndex: index,
                    parent: this,
                  );
                }),
              ) : Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 150, width: 100,),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              score = 0;
                              reStart();
                            });
                          },
                          child: Container(
                            height: 100,
                            width: 300,
                            //alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text("Restart", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w500
                              ),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}



class Tile extends StatefulWidget {
  String imageAssetPath;
  int tileIndex;
  _HomeState parent;

  Tile({this.imageAssetPath, this.tileIndex, this.parent});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!selected) {
          setState(() {
            iPairs[widget.tileIndex].setIsSelected(true);
          });
          if (selectedTile != "") {
            /// testing if the selected tiles are same
            if (selectedTile == iPairs[widget.tileIndex].getImageAssetPath()) {
              score = score + 1;
              print(selectedTile + " t" + widget.imageAssetPath);

              TileModel tileModel = new TileModel();
              print(widget.tileIndex);
              selected = true;
              Future.delayed(const Duration(milliseconds: 500), () {
                tileModel.setImageAssetPath("");
                iPairs[widget.tileIndex] = tileModel;
                print(selectedIndex);
                iPairs[selectedIndex] = tileModel;
                this.widget.parent.setState(() {});
                setState(() {
                  selected = false;
                });
                selectedTile = "";
              });
            } else {
              print(selectedTile + " t " + iPairs[widget.tileIndex].getImageAssetPath());
              print("wrong");
              print(widget.tileIndex);
              print(selectedIndex);
              selected = true;
              Future.delayed(const Duration(milliseconds: 500), () {
                this.widget.parent.setState(() {
                  iPairs[widget.tileIndex].setIsSelected(false);
                  iPairs[selectedIndex].setIsSelected(false);
                });
                setState(() {
                  selected = false;
                });
              });

              selectedTile = "";
            }
          } else {
            setState(() {
              selectedTile = iPairs[widget.tileIndex].getImageAssetPath();
              selectedIndex = widget.tileIndex;
            });

            print(selectedTile);
            print(selectedIndex);
          }
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: iPairs[widget.tileIndex].getImageAssetPath() != ""
            ? Image.asset(iPairs[widget.tileIndex].getIsSelected()
            ? iPairs[widget.tileIndex].getImageAssetPath()
            : widget.imageAssetPath)
            : Container(
          color: Colors.white,
          child: Image.asset("assets/correct.png"),
        ),
      ),
    );
  }
}
