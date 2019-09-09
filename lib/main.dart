import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simple Interest Calculator",
    home: SimpleInterestForm(),
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent),
  ));
}

class SimpleInterestForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SimpleInterestState();
  }
}

class SimpleInterestState extends State<SimpleInterestForm> {
  var minimumPadding = 5.0;
  var currencies = ['Rupees', 'Dollars', "Pounds", "Others"];
  var currentItemSelected = '';
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    currentItemSelected = currencies[0];
  }

  TextEditingController principalTextController = TextEditingController();
  TextEditingController roiTextController = TextEditingController();
  TextEditingController termTextController = TextEditingController();

  var displayedResult = "";

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
        appBar: AppBar(
          title: Text('Simple Interest Calculator'),
        ),
        body: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.all(minimumPadding * 2),
              child: ListView(
                children: <Widget>[
                  getImageAsset(),
                  Padding(
                      padding: EdgeInsets.only(
                          top: minimumPadding, bottom: minimumPadding),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: textStyle,
                        controller: principalTextController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter principal amount';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Principal',
                            labelStyle: textStyle,
                            errorStyle: TextStyle(
                              color: Colors.yellowAccent,
                            ),
                            hintText: 'Enter Principal e.g. 10000',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          top: minimumPadding, bottom: minimumPadding),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: textStyle,
                        controller: roiTextController,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter rate of interest';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Rate of Interest',
                            labelStyle: textStyle,
                            errorStyle: TextStyle(
                              color: Colors.yellowAccent,
                            ),
                            hintText: 'Enter Rate of Interest',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          top: minimumPadding, bottom: minimumPadding),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: termTextController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter term';
                              }
                            },
                            style: textStyle,
                            decoration: InputDecoration(
                                labelText: 'Term',
                                labelStyle: textStyle,
                                hintText: 'Term (in years)',
                                errorStyle: TextStyle(
                                  color: Colors.yellowAccent,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          )),
                          Container(
                            width: minimumPadding * 5,
                          ),
                          Expanded(
                              child: DropdownButton<String>(
                            items: currencies.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: textStyle),
                              );
                            }).toList(),
                            value: currentItemSelected,
                            onChanged: (String valueSelected) {
                              onCurrencyDropdownSelected(valueSelected);
                            },
                          ))
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: minimumPadding, top: minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColorDark,
                            child: Text("Calculate", textScaleFactor: 1.5),
                            onPressed: () {
                              setState(() {
                                if (formKey.currentState.validate()) {
                                  displayedResult = calculateTotalReturns();
                                }
                              });
                            },
                          ),
                        ),
                        Container(width: minimumPadding * 5),
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              "Reset",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                resetFields();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: minimumPadding, top: minimumPadding),
                    child: Text(displayedResult, style: textStyle),
                  )
                ],
              ),
            )));
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/bank.png');
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );

    return Container(
      child: image,
      margin: EdgeInsets.all(minimumPadding * 5),
    );
  }

  void onCurrencyDropdownSelected(String valueSelected) {
    setState(() {
      this.currentItemSelected = valueSelected;
    });
  }

  String calculateTotalReturns() {
    double principal = double.parse(principalTextController.text);
    double roi = double.parse(roiTextController.text);
    double term = double.parse(termTextController.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;

    String result =
        'After $term years, your investment will be worth $totalAmountPayable $currentItemSelected';
    debugPrint("Result is : $result");
    return result;
  }

  void resetFields() {
    principalTextController.text = '';
    roiTextController.text = '';
    termTextController.text = '';
    displayedResult = '';
    currentItemSelected = currencies[0];
  }
}
