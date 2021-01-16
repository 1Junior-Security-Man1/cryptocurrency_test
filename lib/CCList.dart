import 'package:cryptocurrency_test/CCData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class CCList extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return _CCListState();
  }
}

class _CCListState extends State<CCList> {
  List<CCData> data = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Cryptocurrency!'),
      ),
      body: Container(
        child: ListView(
          children: _buildList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh, color: Colors.black,),
        backgroundColor: Colors.white70,
        onPressed: () => _loadCC(),
      ),
    );
  }

  _loadCC() async{
    final response = await http.get('https://api.coincap.io/v2/assets?limit=10');
    if(response.statusCode == 200){
      // print(response.body);
      var allData = (json.decode(response.body) as Map)['data'] as Map<String, dynamic>;
      var ccDataList = List<CCData>();
      allData.forEach((String key, dynamic val) {
        var record = CCData(name: val['name'], symbol: val['symbol'], rank: val['rank'],priceUsd: val['priceUsd']);
        ccDataList.add(record);
      });
      setState(() {
        data = ccDataList;
      });
    }
}
  List<Widget> _buildList(){
    return data.map((CCData f)=> ListTile(
      title: Text(f.name),
      subtitle: Text(f.symbol),
      leading: CircleAvatar(child: Text(f.rank.toString())),
      trailing: Text('\$${f.priceUsd.toString()}'),
    )).toList();
  }
}