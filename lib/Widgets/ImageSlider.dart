import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';

import '../providers/Products_provider.dart';
import 'package:provider/provider.dart';
class ImageSlider extends StatelessWidget {
  const ImageSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductsData =  Provider.of<Products>(context) ;
    final products =   ProductsData.lastfour;

    List<String> imgList = [];
    if(products.length <=3 ){
        imgList = [];
    }else{
      imgList = [
        products[0].imageUrl ,
        products[1].imageUrl ,
        products[2].imageUrl ,
        products[3].imageUrl == null ? products[0].imageUrl : products[3].imageUrl ,
      ];
    }
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.network(item, fit: BoxFit.cover, width: 350.0),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    child: Text(
                      ' ${products[imgList.indexOf(item)].title} image',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    ))
        .toList();
    return imgList.isEmpty? SizedBox(height: 20,): Container(
      height: 150,
        width: double.infinity,
        child: CarouselSlider(
          options: CarouselOptions(

            aspectRatio: 5/2,
            viewportFraction: 0.9,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            initialPage: 0,
            autoPlay: true,
          ),
          items: imageSliders,
        ));
  }
}
