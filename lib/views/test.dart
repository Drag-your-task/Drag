import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TwoListViewDragDrop extends StatefulWidget {
  @override
  _TwoListViewDragDropState createState() => _TwoListViewDragDropState();
}

class _TwoListViewDragDropState extends State<TwoListViewDragDrop> {
  List<String> list1 = ["Item 1", "Item 2", "Item 3"];
  List<String> list2 = ["Item 4", "Item 5", "Item 6"];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: buildDragTargetListView(list1, list2),
        ),
        Expanded(
          child: buildDragTargetListView(list2, list1),
        ),
      ],
    );
  }

  Widget buildDragTargetListView(List<String> list, List<String> otherList) {
    return DragTarget<String>(
      onAccept: (receivedItem) {
        setState(() {
          if (otherList.contains(receivedItem)) {
            otherList.remove(receivedItem);
            list.add(receivedItem);
          }
        });
      },
      builder: (context, candidateData, rejectedData) {
        return ListView(
          children: list.map((item) => Draggable<String>(
            data: item,
            child: ListTile(title: Text(item)),
            feedback: Opacity(
              opacity: 0,
              child: ListTile(title: Container(child: Text(item))),
            ),
            childWhenDragging: const SizedBox(
              width: 100,
              height: 100,
            ),
          )).toList(),
        );
      },
    );
  }
}
