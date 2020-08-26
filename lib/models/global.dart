import 'package:flutter/material.dart';
import 'post.dart';


TextStyle textStyle = new TextStyle(fontFamily: 'Gotham',color: Colors.white);
TextStyle textStyleBold = new TextStyle(fontFamily: 'Gotham', fontWeight: FontWeight.bold, color: Colors.white);
TextStyle textStyleLigthGrey = new TextStyle(fontFamily: 'Gotham', color: Colors.grey);


List<Post> userPosts = [
  new Post(new AssetImage('assets/images/messi.jpg'), 'leomessi', 'assets/images/messip.jpg', "See you in Lisbon!! 😉👍🏻", false, false),
  new Post(new AssetImage('assets/images/cristiano.jpg'), 'cristiano', 'assets/images/cristanop.jpg' , "On board🛥😉", false, false),
 ];


 String title = "Instagram"; 