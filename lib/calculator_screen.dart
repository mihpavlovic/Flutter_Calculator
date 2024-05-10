import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

import 'package:function_tree/function_tree.dart';
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; // . 0-9
  String number2 = ""; // + - * /
  String operand = ""; // . 0-9
  String exprStr = "";
  String result = "";
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          //delimo ekran na dva dela to jest 2 widgeta, output i input
          
          //expression
          Expanded(
            child: SingleChildScrollView(
              reverse:true,
              child: Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(16),
                child: Text(
                  exprStr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                  
                ),
              ),
            )
          ),

          //output
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: Text(
                  result.isEmpty ? "0" : result, //"$number1$operand$number2".isEmpty ? "0" : "$number1$operand$number2", 
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ), 
          
          //input
          Wrap(
            children: Btn.buttonValues
            .map(
              (value) => SizedBox(
                width: value==Btn.n0 ? screenSize.width / 2 : screenSize.width / 4,
                height: screenSize.width / 5, //isto width da bih dobio kao kockice koje idu u donji deo ekrana
                child: buildButton(value)
              ),
            )
            .toList(), //potrebno .toList jer ovo children prihvata samo list

          )

        ],),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color:  getBtnColor(value),
        clipBehavior: Clip.hardEdge, // kada kliknem dugme da ne ide animacija preko ivice dugmeta vec da ide tacno do ivice
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white24 
          ),
          borderRadius: BorderRadius.circular(100)
        ),
        child: InkWell(
          onTap: () => onBtnTapNew(value),
          child: Center(
            child: Text(
              value, 
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 24
              )
            )
          )
        ),
      ),
    );
  }

  void onBtnTapNew(String value){
    if(value == Btn.del){
      deleteNew();
      return;
    }
    if(value == Btn.clr){
      clearAllNew();
      return;
    }
    if(value == Btn.per){
      convertToPercentageNew();
      return;
    }
  if(value == Btn.calculate){
    calculateNew();
    return;
  }
    appendValueNew(value);
  }

  void clearAllNew(){
    setState(() {
      result = "";
      exprStr = "";
    });
  }

  void deleteNew(){
    if(exprStr.isNotEmpty){
      exprStr = exprStr.substring(0, exprStr.length-1);
    }
    setState(() {});
  }

  void convertToPercentageNew(){


  }

  bool isExprValid(String ex){
    try{
      double.parse(ex);
      return true;
    } catch (e){
      return false;
    }
  }

  void calculateNew(){
    //if(isExprValid(exprStr)){
      result = "${exprStr.interpret()}";
    //} else {
    //  result = "error";
    //}
    setState(() {
      
    });
    
  }

  void appendValueNew(value){
    exprStr += value;
    //if(int.tryParse(value)!=null){
    //  calculateNew();
    //}
    setState(() {});
  }
  




//#########################################################################
//kod sa snimka bez racunanja izraza


  void onBtnTap(String value){
    if(value == Btn.del){
      delete();
      return;
    }
    if(value == Btn.clr){
      clearAll();
      return;
    }
    if(value == Btn.per){
      convertToPercentage();
      return;
    }
  if(value == Btn.calculate){
    calculate();
    return;
  }
    appendValue(value);
  }

  //racunanje rezultata
  void calculate(){
    if(number1.isEmpty) return;
    if(number2.isEmpty) return;
    if(operand.isEmpty) return;
    
    double num1= double.parse(number1);
    double num2= double.parse(number2);
    var result = 0.0;

    switch(operand){
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        if(num2 != 0){
          result = num1 / num2;
        }
        break;
      default:
        break;
    }

    setState(() {
      number1 = "$result";
      if(number1.endsWith(".0")){
        number1 = number1.substring(0, number1.length-2);
      }
      operand = "";
      number2 = "";
    });
  }

  void convertToPercentage(){
    if(number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty){
      //izracunaj pre konverzije u procente 
      calculate();
    }

    if(operand.isNotEmpty){
      //ne moze da se iracuna jer pise fazon 35-
      return;
    }

    final number = double.parse(number1);// rezultat u calculate se uvek upisuje u number1
    setState(() {
      number1 ="${(number/100)}";
      operand = "";
      number2 = "";
    });
  }


  //brise sve
  void clearAll(){
    setState(() {
      number1="";
      number2="";
      operand="";
    });
  }

  //obrisi jedan karakter sa kraja
  void delete() {
    if(number2.isNotEmpty){
      number2 = number2.substring(0, number2.length - 1);
    } else if(operand.isNotEmpty) {
      operand = "";
    } else if(number1.isNotEmpty){
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }

  void appendValue(String value) {
    // number1 opernad number2
    // 234       +      5343

    // if is operand and not "."
    if (value != Btn.dot && int.tryParse(value) == null) {
      // operand pressed
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operand = value;
    }
    // assign value to number1 variable
    else if (number1.isEmpty || operand.isEmpty) {
      // check if value is "." | ex: number1 = "1.2"
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        // ex: number1 = "" | "0"
        value = "0.";
      }
      number1 += value;
    }
    // assign value to number2 variable
    else if (number2.isEmpty || operand.isNotEmpty) {
      // check if value is "." | ex: number1 = "1.2"
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        // number1 = "" | "0"
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }

  Color getBtnColor(value){
    return [Btn.del, Btn.clr].contains(value) 
              ? Colors.blueGrey 
              : [
                  Btn.per, 
                  Btn.multiply, 
                  Btn.add, 
                  Btn.subtract, 
                  Btn.divide, 
                  Btn.calculate
                ]
                .contains(value) 
                    ? Colors.deepPurple 
                    : Colors.lightGreen;
  }

}