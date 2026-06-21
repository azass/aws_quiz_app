import 'package:aws_quiz_app/models/scoring.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ScoringTable extends StatefulWidget {
  final List<ScoringTableItem> scoringTableItems;
  ScoringTable(this.scoringTableItems);

  @override
  State<StatefulWidget> createState() => _ScoringTableState();

  double tagWidth(BuildContext context) {
    return double.infinity;
  }

  Color bgcolor(ScoringTableItem item) {
    return Colors.grey[800];
  }
  onPressed(BuildContext context, ScoringTableItem item) {}
}

class _ScoringTableState extends State<ScoringTable> {
  int _currentSortColumn = 0;
  bool _isAscending = true;

  @override
  Widget build(BuildContext context) {
    return DataTable(
        sortColumnIndex: _currentSortColumn,
        sortAscending: _isAscending,
        headingRowColor: MaterialStateProperty.all(Colors.blueGrey[900]),
        dataRowHeight: 28,
        headingRowHeight: 28,
        horizontalMargin: 1,
        columnSpacing: 1,
        columns: [
          DataColumn(
              label: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(''))),
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isAscending == true) {
                    _isAscending = false;
                    // sort the product list in Ascending, order by Price
                    widget.scoringTableItems.sort(
                        (itemA, itemB) => itemB.sort.compareTo(itemA.sort));
                  } else {
                    _isAscending = true;
                    // sort the product list in Descending, order by Price
                    widget.scoringTableItems.sort(
                        (itemA, itemB) => itemA.sort.compareTo(itemB.sort));
                  }
                });
              }),
          DataColumn(
              label: Container(
                  width: MediaQuery.of(context).size.width * 0.03,
                  child: Text(
                    '数',
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
              // Sorting function
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isAscending == true) {
                    _isAscending = false;
                    // sort the product list in Ascending, order by Price
                    widget.scoringTableItems.sort((itemA, itemB) =>
                        itemB.questionCount.compareTo(itemA.questionCount));
                  } else {
                    _isAscending = true;
                    // sort the product list in Descending, order by Price
                    widget.scoringTableItems.sort((itemA, itemB) =>
                        itemA.questionCount.compareTo(itemB.questionCount));
                  }
                });
              }),
          DataColumn(
              label: const Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    '正解率',
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
              // Sorting function
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isAscending == true) {
                    _isAscending = false;
                    // sort the product list in Ascending, order by Price
                    widget.scoringTableItems.sort((itemA, itemB) => itemB
                        .correctAnswerRate
                        .compareTo(itemA.correctAnswerRate));
                  } else {
                    _isAscending = true;
                    // sort the product list in Descending, order by Price
                    widget.scoringTableItems.sort((itemA, itemB) => itemA
                        .correctAnswerRate
                        .compareTo(itemB.correctAnswerRate));
                  }
                });
              }),
          DataColumn(
              label: const Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    '平均定着度',
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
              // Sorting function
              onSort: (columnIndex, _) {
                setState(() {
                  _currentSortColumn = columnIndex;
                  if (_isAscending == true) {
                    _isAscending = false;
                    // sort the product list in Ascending, order by Price
                    widget.scoringTableItems.sort((itemA, itemB) =>
                        itemB.avgRetention.compareTo(itemA.avgRetention));
                  } else {
                    _isAscending = true;
                    // sort the product list in Descending, order by Price
                    widget.scoringTableItems.sort((itemA, itemB) =>
                        itemA.avgRetention.compareTo(itemB.avgRetention));
                  }
                });
              }),
        ],
        rows: widget.scoringTableItems.map((item) {
          return DataRow(cells: [
            DataCell(buildTag(context, item)),
            DataCell(Container(
                width: MediaQuery.of(context).size.width * 0.05,
                child: Text(
                  item.questionCount.toString(),
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ))),
            DataCell(Row(children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width * 0.1,
                    lineHeight: 8.0,
                    percent: item.correctAnswerRate,
                    progressColor: Colors.red,
                  )),
              Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.08,
                      child: Text(
                        item.toRatePercentage(item.correctAnswerRate),
                        style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ))),
            ])),
            DataCell(Row(children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width * 0.1,
                    lineHeight: 8.0,
                    percent: item.avgRetention / 100 < 1
                        ? item.avgRetention / 100
                        : 1,
                    progressColor: Colors.red,
                  )),
              Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.08,
                      child: Text(
                        item.avgRetention.toString(),
                        style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ))),
            ])),
          ]);
        }).toList());
  }

  Widget buildTag(BuildContext context, ScoringTableItem item) {
    return Container(
      height: 26,
      width: widget.tagWidth(context),
      child: Padding(
          padding: EdgeInsets.only(left: item.indent),
          child: ElevatedButton(
              child: Text(item.label),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 11.0, color: Colors.white),
                primary: widget.bgcolor(item),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.centerLeft,
              ),
              onPressed: () => pressed(context, item))),
    );
  }

  pressed(BuildContext context, ScoringTableItem item) {
    setState(() => widget.onPressed(context, item));
  }
}
