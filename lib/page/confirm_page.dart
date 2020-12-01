import 'package:flutter/material.dart';
import 'package:hotaal/caregiver.dart';
import 'package:hotaal/provide/mealplan_provide.dart';
import 'package:hotaal/widget/meal_item.dart';
import 'package:provide/provide.dart';

class ConfirmPage extends StatelessWidget {


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
        title: Text('Confrim', style: TextStyle(color: Colors.grey)),
      ),
      body: FutureBuilder(
          future: _getMealInfo(context),
          builder: (context, snapshot) {
            var temp;
            try{temp = Provide.value<MealPlanProvide>(context);}catch(e){}

            List mealList = List();
            if(temp!=null)mealList=temp.mealList;
//            List mealList = Provide.value<MealPlanProvide>(context).mealList;
            if (snapshot.hasData && mealList != null) {
              return Stack(
                children: <Widget>[
                  Provide<MealPlanProvide>(
                    builder: (context, child, mealPlanProvide) {
//                      mealList =
//                          Provide.value<MealPlanProvide>(context).mealList;
                      return ListView.builder(
                        key: Key(UniqueKey().toString()),
                        itemCount: mealList!=null?mealList.length:0,
                        itemBuilder: (context, index) {
                          final meal = mealList[index].toString();
                          return new Dismissible(
                              key: new Key(meal),
                              onDismissed: (direction){
                                Provide.value<MealPlanProvide>(context).deleteOneMeal(mealList[index].id);
                              Scaffold.of(context).showSnackBar(
                              new SnackBar(content: new Text("${mealList[index].title} is deleted")));
                          },
                              background: new Container(color: Colors.grey),
                              child: new MealItem(mealList[index]),);
                        },
                      );
                    },
                  ),
                ],
              );
            } else {
              return Text('loading...');
            }
          }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => Caregiver()));
          },
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          label: new Text('Confirm this meal plan', maxLines: 1),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future _getMealInfo(BuildContext context) async {
    await Provide.value<MealPlanProvide>(context).getMealInfo();
    return 'end';
  }
}
