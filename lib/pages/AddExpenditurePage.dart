import 'package:mycashbook/helper/dbhelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpenditurePage extends StatefulWidget {
  AddExpenditurePage({Key? key}) : super(key: key);

  @override
  State<AddExpenditurePage> createState() => _AddExpenditurePageState();
}

class _AddExpenditurePageState extends State<AddExpenditurePage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final DbHelper dbHelper = DbHelper();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  void resetForm() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    amountController.clear();
    descriptionController.clear();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              "Add Expense",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          TextField(
            controller: dateController,
            readOnly: true,
            onTap: () {
              _selectDate(context);
            },
            decoration: InputDecoration(
              labelText: "Date",
              labelStyle: TextStyle(color: Colors.deepPurple),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple)),
            ),
          ),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Amount (Nominal)",
              labelStyle: TextStyle(color: Colors.deepPurple),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple)),
            ),
            // create style use color deeppurple
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: "Information",
              labelStyle: TextStyle(color: Colors.deepPurple),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple)),
            ),
          ),
          SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.amber),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)))),
                  onPressed: () {
                    resetForm();
                  },
                  child: const Text("Reset"),
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.deepPurple.shade200),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)))),
                  onPressed: () async {
                    String date = dateController.text;
                    String amount = amountController.text;
                    String description = descriptionController.text;

                    if (date.isNotEmpty && amount.isNotEmpty) {
                      int rowCount = await dbHelper.insertExpense(
                          date, amount, description);
                      if (rowCount > 0) {
                        // Successfully added income data
                        resetForm(); // Reset the form
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Expenses saved successfully."),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Failure to save expenses."),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Date and Amount must be filled in."),
                        ),
                      );
                    }
                  },
                  child: const Text("Save"),
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Kembali ke halaman Beranda
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.deepPurple),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)))),
                  child: const Text("<< Back"),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
