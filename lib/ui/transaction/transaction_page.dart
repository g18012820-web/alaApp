import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../base/shared_view/common_app_bar.dart';
import '../../base/shared_view/common_scaffold.dart';

@RoutePage()
class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: CommonAppBar(
        text: 'Transaction',
        automaticallyImplyLeading: false,
        leadingWidth: 0,
        leadingIcon: LeadingIcon.none,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
      ),
    );
  }
}
