import 'package:flutter/material.dart';
import 'package:hotaal/model/meal_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MealItem extends StatelessWidget{
  final MealModel item;
  MealItem(this.item);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 100)..init(context);
    return Container(
      margin: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
      padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1,color: Colors.white),
        ),
      ),
      child: Row(
        children: <Widget>[
          _mealImage(item),
          Column(
            children: <Widget>[
              _mealTitle(item),
              _mealTime(item),
            ],
          ),
        ],
      ),
    );
  }



  Widget _mealImage(MealModel item){
    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          border: Border.all(width: 1,color: Colors.white)
      ),
      child:Image.network(item.imageUrl),
    );
  }

  Widget _mealTitle(MealModel item){
    return Container(
      width: ScreenUtil().setWidth(300),
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.topLeft,
      child: Text(item.title),
    );
  }

  Widget _mealTime(MealModel item){
    return Container(
      width: ScreenUtil().setWidth(400),
      padding: EdgeInsets.only(right: 10.0),
      alignment: Alignment.topRight,
      child: Text(item.time, style: TextStyle(fontSize: 22, color: Colors.blue)),
    );
  }

}
