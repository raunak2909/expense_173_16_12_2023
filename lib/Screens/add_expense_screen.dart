import 'package:flutter/material.dart';
import 'package:wscube_expense_app/AppConstant/content_constant.dart';

import '../Constants/elevated_button.dart';
import '../Constants/text_field.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  var titleController = TextEditingController();

  var descController = TextEditingController();

  var amtController = TextEditingController();

  var transactionType = ["Debit", "Credit"];

  var selectedTransactionType = "Debit";

  var selectedCatIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 21),
            /*CstmTextField(
              label: "Add Description",
              iconData: Icons.abc,
            ),
            CstmTextField(
              label: "Add Description",
              iconData: Icons.abc,
            ),
            CstmTextField(
              label: "Enter amount",
              iconData: Icons.money_sharp,
              keyboardType: TextInputType.number,
            ),*/
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 35,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButton(
                        value: selectedTransactionType,
                        items: transactionType
                            .map((type) => DropdownMenuItem(
                          value: type,
                            child: Text(type)))
                            .toList(),
                        onChanged: (value) {
                          selectedTransactionType = value!;
                          setState(() {

                          });
                        },
                      )),
                  const SizedBox(height: 11),
                  CstmButton(
                    name: "Choose Expense",
                    mWidget: selectedCatIndex!=-1 ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppConstants.mCategories[selectedCatIndex].catImgPath, width: 25, height: 25,),
                        Text(" - ${AppConstants.mCategories[selectedCatIndex].catTitle}", style: TextStyle(color: Colors.white),),
                      ],
                    ) : null,
                    btnColor: Colors.black,
                    textColor: Colors.white,
                    onTap: () {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15))
                        ),
                          context: context,
                          builder: (context) {
                            return GridView.builder(
                                itemCount: AppConstants.mCategories.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4),
                                itemBuilder: (context, index) {
                                  var eachCat = AppConstants.mCategories[index];
                                  return InkWell(
                                    onTap: (){
                                      selectedCatIndex = index;
                                      setState(() {

                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.cyan.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Image.asset(
                                            eachCat.catImgPath),
                                      ),
                                    ),
                                  );
                                });
                          });
                    },
                  ),
                  /*CstmButton(
                    name: elevatedBtnName,
                    btnColor: Colors.white,
                    textColor: Colors.purple,
                    onTap: () {
                      _selectDate(context);
                    },
                  ),*/
                  CstmButton(
                    name: "Add Expense",
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
