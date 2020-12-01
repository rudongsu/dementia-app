import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hotaal/dao/search_dao.dart';
import 'package:hotaal/model/search_model.dart';
import 'package:hotaal/widget/webview.dart';


const baseUri = 'https://spoonacular.com/recipeImages/';
const URL = 'https://api.spoonacular.com/recipes/search?';
const query = 'query=';
const number = '&number=';
const apiKey = '&apiKey=53a56460fcf24acf82b91106279f8130';

/// caregiver
class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  SearchModel bannerModel;
  SearchModel saladModel;
  SearchModel riceModel;
  SearchModel pastaModel;
  SearchModel steaksModel;
  SearchModel burgersModel;
  SearchModel soupsModel;
  SearchModel vegetablesModel;
  SearchModel othersModel;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async{
    setState((){isLoading=true;});
    SearchDao.fetch(URL + number + '5' + apiKey).then((SearchModel model){
      setState((){
        bannerModel = model;
      });
    }).catchError((e){
      print(e);
    });
    SearchDao.fetch(URL + query + 'salad' + number + '10' + apiKey).then((SearchModel model){
      setState((){
        saladModel = model;
      });
    }).catchError((e){
      print(e);
    });
    SearchDao.fetch(URL + query + 'rice' + number + '10' + apiKey).then((SearchModel model){
      setState((){
        riceModel = model;
      });
    }).catchError((e){
      print(e);
    });
    SearchDao.fetch(URL + query + 'pasta' + number + '10' + apiKey).then((SearchModel model){
      setState((){
        pastaModel = model;
      });
    }).catchError((e){
      print(e);
    });
    SearchDao.fetch(URL + query + 'burger' + number + '10' + apiKey).then((SearchModel model){
      setState((){
        burgersModel = model;
      });
    }).catchError((e){
      print(e);
    });
    SearchDao.fetch(URL + query + 'soup' + number + '10' + apiKey).then((SearchModel model){
      setState((){
        soupsModel = model;
      });
    }).catchError((e){
      print(e);
    });
    SearchDao.fetch(URL + query + 'steak' + number + '10' + apiKey).then((SearchModel model){
      setState((){
        steaksModel = model;
      });
    }).catchError((e){
      print(e);
    });
    SearchDao.fetch(URL + query + 'vegetable' + number + '10' + apiKey).then((SearchModel model){
      setState((){
        vegetablesModel = model;
      });
    }).catchError((e){
      print(e);
    });
    SearchDao.fetch(URL + 'diet=vegetarian' + number + '10' + apiKey).then((SearchModel model){
      setState((){
        isLoading = false;
        othersModel = model;
      });
    }).catchError((e){
      print(e);
    });
    await Future.delayed(Duration(seconds: 2));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.grey,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('pick your one day meal', style: TextStyle(color: Colors.grey)),
      ),
      body: isLoading
          ? Center(child: new CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _banner,
            Container(
              height: 55,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(top: 10, left: 10.0),
              child: Text(' s a l a d ', style: TextStyle(color: Colors.grey, fontSize: 35, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 260,
              padding: EdgeInsets.only(top: 0, bottom: 10.0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: saladModel?.results?.length ?? 0, itemBuilder: (BuildContext context, int position) {
                return _item(position, saladModel);
              }
              ),
            ),
            // rice
            Container(
              height: 55,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(top: 10, left: 10.0),
              child: Text(' r i c e ', style: TextStyle(color: Colors.grey, fontSize: 35, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 260,
              padding: EdgeInsets.only(top: 0, bottom: 10.0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: riceModel?.results?.length ?? 0, itemBuilder: (BuildContext context, int position) {
                return _item(position, riceModel);
              }
              ),
            ),
            // pasta
            Container(
              height: 55,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(top: 10, left: 10.0),
              child: Text(' p a s t a ', style: TextStyle(color: Colors.grey, fontSize: 35, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 260,
              padding: EdgeInsets.only(top: 0, bottom: 10.0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: pastaModel?.results?.length ?? 0, itemBuilder: (BuildContext context, int position) {
                return _item(position, pastaModel);
              }
              ),
            ),
            // steak
            Container(
              height: 55,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(top: 10, left: 10.0),
              child: Text(' s t e a k ', style: TextStyle(color: Colors.grey, fontSize: 35, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 260,
              padding: EdgeInsets.only(top: 0, bottom: 10.0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: steaksModel?.results?.length ?? 0, itemBuilder: (BuildContext context, int position) {
                return _item(position, steaksModel);
              }
              ),
            ),
            // burger
            Container(
              height: 55,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(top: 10, left: 10.0),
              child: Text(' b u r g e r s ', style: TextStyle(color: Colors.grey, fontSize: 35, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 260,
              padding: EdgeInsets.only(top: 0, bottom: 10.0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: burgersModel?.results?.length ?? 0, itemBuilder: (BuildContext context, int position) {
                return _item(position, burgersModel);
              }
              ),
            ),
            // soup
            Container(
              height: 55,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(top: 10, left: 10.0),
              child: Text(' s o u p s ', style: TextStyle(color: Colors.grey, fontSize: 35, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 300,
              padding: EdgeInsets.only(top: 0, bottom: 10.0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: soupsModel?.results?.length ?? 0, itemBuilder: (BuildContext context, int position) {
                return _item(position, soupsModel);
              }
              ),
            ),
            // vegetable
            Container(
              height: 55,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(top: 10, left: 10.0),
              child: Text(' v e g e t a b l e ', style: TextStyle(color: Colors.grey, fontSize: 35, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 260,
              padding: EdgeInsets.only(top: 0, bottom: 10.0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: vegetablesModel?.results?.length ?? 0, itemBuilder: (BuildContext context, int position) {
                return _item(position, vegetablesModel);
              }
              ),
            ),
            // other
            Container(
              height: 55,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(top: 10, left: 10.0),
              child: Text(' o t h e r s ', style: TextStyle(color: Colors.grey, fontSize: 35, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 260,
              padding: EdgeInsets.only(top: 0, bottom: 10.0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: othersModel?.results?.length ?? 0, itemBuilder: (BuildContext context, int position) {
                return _item(position, othersModel);
              }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _banner {
    if (bannerModel == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container(
        height: 300,
        child: Swiper(
          itemCount: bannerModel.results.length,
          autoplay: true,
          itemBuilder: (BuildContext context, int index) {
            return _picture(index);
          },
          pagination: SwiperPagination(),
        ),
      );
    }
  }

  _item(int position, SearchModel searchModel){
    if(searchModel == null || searchModel.results == null) return null;
    SearchItem meals = searchModel.results[position];
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => WebView(
              url: baseUri + meals.imageUrls[0],
              id: meals.id,
              title: meals.title,
              readyInMinutes: meals.readyInMinutes,
              servings: meals.servings,
            )));
      },
      child: Container(
        width: 200,
        margin: EdgeInsets.only(right: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.transparent),
        child: Card(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 20)),
              Image.network(
                baseUri + meals.imageUrls[0],
                height: 150,
                width: 150,
                alignment: Alignment.center,
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(top: 10, left: 20),
                alignment: Alignment.centerLeft,
                child: Text('${meals.title}',
                    style: TextStyle(color: Colors.grey, fontSize: 15)),
              ),
            ],
          ),
        )
      ),
    );
  }

  _picture(int position){
    if(bannerModel == null || bannerModel.results == null) return null;
    SearchItem meals = bannerModel.results[position];
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => WebView(
              url: baseUri + meals.imageUrls[0],
              id: meals.id,
              title: meals.title,
              readyInMinutes: meals.readyInMinutes,
              servings: meals.servings,
            )));
      },
      child: Image.network(
        baseUri + bannerModel.results[position].imageUrls[0],
        fit: BoxFit.fill,
      ),
    );
  }
}
