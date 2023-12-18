import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wscube_expense_app/Screens/add_expense_screen.dart';
import 'package:wscube_expense_app/Screens/login_screen.dart';
import 'package:wscube_expense_app/exp_bloc/expense_bloc.dart';

import '../Model/expense_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
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
        builder: (_, state){
          if(state is ExpenseLoadingState){
            return Center(child: CircularProgressIndicator(),);
          }

          if(state is ExpenseErrorState){
            return Center(child: Text(state.errorMsg),);
          }

          if(state is ExpenseLoadedState){
            state.mData.forEach((element) {
              print(element.toMap().toString());
            });
            filterDayWiseExpenses(state.mData);
            return ListView.builder(itemBuilder: (_, index){
              return Container();
            });
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

  void filterDayWiseExpenses(List<ExpenseModel> allExpenses){

  }
}
