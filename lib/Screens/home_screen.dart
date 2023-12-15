import 'package:flutter/material.dart';
import 'package:wscube_expense_app/Constants/elevated_button.dart';
import 'package:wscube_expense_app/Constants/text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedItem = "Credit";
  String elevatedBtnName = "Choose Date";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000, 2, 15),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      setState(() {
        elevatedBtnName = selectedDate.toLocal().toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        title: const Text("Add Expense"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 21),
            const CstmTextField(
              label: "Name your expense",
              iconData: Icons.abc,
            ),
            const CstmTextField(
              label: "Add Description",
              iconData: Icons.abc,
            ),
            const CstmTextField(
              label: "Enter amount",
              iconData: Icons.money_sharp,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton(
                    value: selectedItem,
                    onChanged: (newValue) {
                      setState(() {
                        selectedItem = newValue.toString();
                      });
                    },
                    items: <String>["Credit", "Item 2", "Item 3"]
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  CstmButton(
                    name: "Choose Expense",
                    btnColor: Colors.black,
                    textColor: Colors.white,
                    onTap: () {},
                  ),
                  CstmButton(
                    name: elevatedBtnName,
                    btnColor: Colors.white,
                    textColor: Colors.purple,
                    onTap: () {
                      _selectDate(context);
                    },
                  ),
                  CstmButton(
                    name: "ADD Expense",
                    btnColor: Colors.black,
                    textColor: Colors.white,
                    onTap: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
