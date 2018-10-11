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
    var records = await provider.getRecords();
    var data = groupBy<Record, String>(records, (record) => record.name)
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
              data: data),
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
          seriesList == null
              ? const Text('Loading')
              : Expanded(
                  //padding: EdgeInsets.all(15.0),
                  child: new charts.BarChart(
                    seriesList,
                    animate: true,
                  ),
                ),
          seriesList == null
              ? const Text('Loading')
              : Expanded(
                  //padding: EdgeInsets.all(15.0),
                  child: Container(
                    padding: EdgeInsets.all(25.0),
                    child: new charts.PieChart(seriesList,
                        animate: true,
                        defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 30,
                            arcRendererDecorators: [
                              new charts.ArcLabelDecorator(  
                                  labelPosition:
                                      charts.ArcLabelPosition.outside)
                            ])),
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
