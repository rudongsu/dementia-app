import 'package:flutter/material.dart';
import 'package:hotaal/dao/search_dao.dart';
import 'package:hotaal/model/search_model.dart';
import 'package:hotaal/widget/search_bar.dart';
import 'package:hotaal/widget/webview.dart';

const URL = 'https://api.spoonacular.com/recipes/search?query=';
const apiKey = '&number=20&apiKey=53a56460fcf24acf82b91106279f8130';

class SearchPage extends StatefulWidget {
  final String searchUrl;

  const SearchPage({Key key, this.searchUrl = URL}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchModel searchModel;
  String keyword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SearchBar(
            hint: ' recipe',
            onChanged: _onTextChange,
          ),
          MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Expanded(
                  flex: 1,
                  child: ListView.builder(
                      itemCount: searchModel?.results?.length??0,
                      itemBuilder: (BuildContext context, int position){
                        return _item(position);
                      }),
              ),
          )
        ],
      ),
    );
  }

  _onTextChange(String text){
    keyword = text;
    if(text.length == 0){
      setState(() {
        searchModel = null;
      });
      return;
    }
    String url = widget.searchUrl + keyword + apiKey;
    SearchDao.fetch(url).then((SearchModel model){
      setState((){
        searchModel = model;
      });
    }).catchError((e){
      print(e);
    });
  }

  _item(int position){
    if(searchModel == null || searchModel.results == null) return null;
    SearchItem item = searchModel.results[position];
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => WebView(
                id: item.id,
                url: searchModel.baseUri + item.imageUrls[0],
                title: item.title,
                readyInMinutes: item.readyInMinutes,
                servings: item.servings,
            )));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))
        ),
        child: Container(
          width: 300, child: Text('${item.title}'),
        ),
      ),
    );
  }
}

