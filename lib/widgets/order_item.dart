import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import '../providers/orders.dart';

class OrderItem extends StatefulWidget {
  final Order _order;
  const OrderItem(this._order);
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _showDetails = false;
  @override
  Widget build(BuildContext context) {
    final order = widget._order;
    return Column(
      children: <Widget>[
        Card(
          child: Column(
            children: <Widget>[
              ListTile(
                onTap: () => setState(() => _showDetails = !_showDetails),
                title: Text("Rs. ${order.price}"),
                subtitle:
                    Text(formatDate(order.dateTime, [MM, ' ', dd, ', ', yyyy])),
                trailing:
                    Icon(_showDetails ? Icons.expand_less : Icons.expand_more),
              ),
              if (_showDetails)
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: Column(
                    children: order.cart.map((ci) => Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(ci.title),
                          Text("Rs. ${ci.price}  x  ${ci.quantity}")
                        ],
                      ),
                    )).toList(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
