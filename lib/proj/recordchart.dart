import 'package:collection/collection.dart';
import 'package:daily_helper/del/recordtype.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RecordChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RecordChart();
}

class _RecordChart extends State<RecordChart> {
  List<charts.Series<RecordStat, String>> seriesList;
  List<Record> _original_list;
  List<RecordStat> _alldata;
  List<RecordStat> _weekData;

  RecordDBProvider provider;
  @override
  void initState() {
    super.initState();
    _initialProvider();
  }

  void _initialProvider() async {
    if (provider == null) {
      provider = new RecordDBProvider();
      await provider.open("dh.db");
    }
    _original_list = await provider.getRecords();
    _alldata = groupBy<Record, String>(_original_list, (record) => record.name)
        .map<String, int>((key, value) => MapEntry(
            key,
            value.fold<int>(
                0,
                (prev, curr) =>
                    prev + curr.endTime.difference(curr.startTime).inMinutes)))
        .entries
        .map<RecordStat>((f) => RecordStat(f.key, f.value))
        .toList();

    var monday = DateTime.now().subtract(
      Duration(
        days: DateTime.now().weekday - 1,
      ),
    );
    var firstDayofWeek = DateTime(
      monday.year,
      monday.month,
      monday.day,
    );
    _weekData = groupBy<Record, String>(
            _original_list.where((r) => r.startTime.isAfter(firstDayofWeek)),
            (record) => record.name)
        .map<String, int>((key, value) => MapEntry(
            key,
            value.fold<int>(
                0,
                (prev, curr) =>
                    prev + curr.endTime.difference(curr.startTime).inMinutes)))
        .entries
        .map<RecordStat>((f) => RecordStat(f.key, f.value))
        .toList();

    if (this.mounted) {
      setState(() {
        seriesList = [
          new charts.Series<RecordStat, String>(
              id: 'Records',
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
              domainFn: (RecordStat r, _) => r.name,
              measureFn: (RecordStat r, _) => r.count,
              data: _alldata),
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text('Chart')),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              RaisedButton(
                child: Text('ALL'),
                onPressed: () {
                  if (this.mounted) {
                    setState(() {
                      seriesList = [
                        new charts.Series<RecordStat, String>(
                            id: 'Records',
                            colorFn: (_, __) =>
                                charts.MaterialPalette.blue.shadeDefault,
                            domainFn: (RecordStat r, _) => r.name,
                            measureFn: (RecordStat r, _) => r.count,
                            data: _alldata),
                      ];
                    });
                  }
                },
              ),
              RaisedButton(
                child: Text('WEEK'),
                onPressed: () {
                  if (this.mounted) {
                    setState(() {
                      seriesList = [
                        new charts.Series<RecordStat, String>(
                            id: 'Records',
                            colorFn: (_, __) =>
                                charts.MaterialPalette.blue.shadeDefault,
                            domainFn: (RecordStat r, _) => r.name,
                            measureFn: (RecordStat r, _) => r.count,
                            data: _weekData),
                      ];
                    });
                  }
                },
              ),
            ],
          ),
          seriesList == null
              ? const Text('Loading')
              : Expanded(
                  //padding: EdgeInsets.all(15.0),
                  child: Container(
                    padding: EdgeInsets.all(25.0),
                    child: new charts.BarChart(
                      seriesList,
                      animate: true,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class RecordStat {
  final String name;
  final int count;

  RecordStat(this.name, this.count);
}
