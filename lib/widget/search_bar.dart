import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final bool enabled;
  final String hint;
  final void Function() rightButtonClick;
  final ValueChanged<String> onChanged;

  const SearchBar(
      {Key key,
        this.enabled = true,
        this.hint,
        this.rightButtonClick,
        this.onChanged})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
            ),
            Expanded(
              flex: 1,
              child: _inputBox(),
            ),
            _wrapTap(
                Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Text(
                    'search',
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                ),
                widget.rightButtonClick)
          ]),
    );
  }

  _inputBox() {
    Color inputBoxColor;
      inputBoxColor = Color(int.parse('0xffEDEDED'));
    return Container(
      height: 50,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: inputBoxColor,
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            size: 20,
            color: Color(0xffA9A9A9)
          ),
          Expanded(
            flex: 1,
            child:
              TextField(
                controller: _controller,
                onChanged: _onChanged,
                autofocus: true,
                style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w300
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                  border: InputBorder.none,
                  hintText: widget.hint ?? '',
                  hintStyle: TextStyle(fontSize: 15),
                )
              )
          ),
          _wrapTap(
              Icon(
                Icons.clear,
                size: 22,
                color: Colors.grey,
              ), () {
              setState(() {
                _controller.clear();
              });
              _onChanged('');
              })
        ],
      ),
    );
  }

  _wrapTap(Widget child, void Function() callback){
    return GestureDetector(
      onTap: (){
        if (callback != null) callback();
      },
      child: child,
    );
  }

  _onChanged(String text) {
    if(widget.onChanged != null){
      widget.onChanged(text);
    }
  }
}
