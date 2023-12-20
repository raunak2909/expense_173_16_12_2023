import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wscube_expense_app/Screens/add_expense_screen.dart';
import 'package:wscube_expense_app/Screens/login_screen.dart';
import 'package:wscube_expense_app/date_utils.dart';
import 'package:wscube_expense_app/exp_bloc/expense_bloc.dart';

import '../AppConstant/content_constant.dart';
import '../Model/expense_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ExpenseBloc>(context).add(FetchAllExpenseEvent());
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    var mWidth = mq.size.width;
    var mHeight = mq.size.height;
    print("Width : $mWidth, Height: $mHeight");

    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        title: const Text("Add Expense"),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 21),
              TextButton.icon(
                onPressed: () async {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (ctx) => LoginScreen()));
                  var prefs = await SharedPreferences.getInstance();
                  prefs.setBool(LoginScreen.LOGIN_PREFS_KEY, false);
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.blue,
                ),
                label: const Text(
                  "Log out",
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          ),
        ),
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (_, state) {
          if (state is ExpenseLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ExpenseErrorState) {
            return Center(
              child: Text(state.errorMsg),
            );
          }

          if (state is ExpenseLoadedState) {
            var dateWiseExpenses = filterDayWiseExpenses(state.mData);

            return mq.orientation==Orientation.landscape
                ? landscapeLay(dateWiseExpenses)
                : portraitLay(dateWiseExpenses);
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddExpenseScreen(),
              ));
        },
      ),
    );
  }

  Widget portraitLay(List<DateWiseExpenseModel> dateWiseExpenses) {
    return Column(
      children: [
        Expanded(
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Your Balance till now:'),
                  Text(
                    '0.0',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: ListView.builder(
              itemCount: dateWiseExpenses.length,
              itemBuilder: (_, parentIndex) {
                var eachItem = dateWiseExpenses[parentIndex];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${eachItem.date}'),
                          Text('${eachItem.totalAmt}')
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: eachItem.allTransactions.length,
                          itemBuilder: (_, childIndex) {
                            var eachTrans =
                                eachItem.allTransactions[childIndex];
                            return ListTile(
                              leading: Image.asset(AppConstants
                                  .mCategories[eachTrans.expCatType]
                                  .catImgPath),
                              title: Text(eachTrans.expTitle),
                              subtitle: Text(eachTrans.expDesc),
                              trailing: Column(
                                children: [
                                  Text(eachTrans.expAmt.toString()),

                                  ///balance will be added here
                                ],
                              ),
                            );
                          })
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget landscapeLay(List<DateWiseExpenseModel> dateWiseExpenses) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Your Balance till now:'),
                  Text(
                    '0.0',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: ListView.builder(
              itemCount: dateWiseExpenses.length,
              itemBuilder: (_, parentIndex) {
                var eachItem = dateWiseExpenses[parentIndex];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${eachItem.date}'),
                          Text('${eachItem.totalAmt}')
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: eachItem.allTransactions.length,
                          itemBuilder: (_, childIndex) {
                            var eachTrans =
                                eachItem.allTransactions[childIndex];
                            return ListTile(
                              leading: Image.asset(AppConstants
                                  .mCategories[eachTrans.expCatType]
                                  .catImgPath),
                              title: Text(eachTrans.expTitle),
                              subtitle: Text(eachTrans.expDesc),
                              trailing: Column(
                                children: [
                                  Text(eachTrans.expAmt.toString()),

                                  ///balance will be added here
                                ],
                              ),
                            );
                          })
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  List<DateWiseExpenseModel> filterDayWiseExpenses(
      List<ExpenseModel> allExpenses) {
    //dateWiseExpenses.clear();
    List<DateWiseExpenseModel> dateWiseExpenses = [];

    var listUniqueDates = [];

    for (ExpenseModel eachExp in allExpenses) {
      var mDate = DateTimeUtils.getFormattedDateFromMilli(
          int.parse(eachExp.expTimeStamp));

      if (!listUniqueDates.contains(mDate)) {
        ///not contains
        listUniqueDates.add(mDate);
      }
    }

    print(listUniqueDates);

    for (String date in listUniqueDates) {
      List<ExpenseModel> eachDateExp = [];
      var totalAmt = 0.0;

      for (ExpenseModel eachExp in allExpenses) {
        var mDate = DateTimeUtils.getFormattedDateFromMilli(
            int.parse(eachExp.expTimeStamp));

        if (date == mDate) {
          eachDateExp.add(eachExp);

          if (eachExp.expType == 0) {
            ///debit
            totalAmt -= eachExp.expAmt;
          } else {
            ///credit
            totalAmt += eachExp.expAmt;
          }
        }
      }

      ///for today
      var formattedTodayDate =
          DateTimeUtils.getFormattedDateFromDateTime(DateTime.now());

      if (formattedTodayDate == date) {
        date = "Today";
      }

      ///for Yesterday
      var formattedYesterdayDate = DateTimeUtils.getFormattedDateFromDateTime(
          DateTime.now().subtract(Duration(days: 1)));

      if (formattedYesterdayDate == date) {
        date = "Yesterday";
      }

      dateWiseExpenses.add(DateWiseExpenseModel(
          date: date,
          totalAmt: totalAmt.toString(),
          allTransactions: eachDateExp));
    }

    return dateWiseExpenses;
  }
}
