import 'package:denomination/helper/common_widget/custom_lable.dart';
import 'package:denomination/helper/image_const.dart';
import 'package:denomination/pages/history.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helper/common_widget/save_dialouge.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initSharedPreferences();

  runApp(MyApp());
}

Future<void> initSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CurrencyCalculator(),
    );
  }
}

class CurrencyCalculator extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const CurrencyCalculator({Key? key, this.initialData}) : super(key: key);

  @override
  _CurrencyCalculatorState createState() => _CurrencyCalculatorState();
}

class _CurrencyCalculatorState extends State<CurrencyCalculator> {
  TextEditingController _controller2000 = TextEditingController();
  TextEditingController _controller500 = TextEditingController();
  TextEditingController _controller200 = TextEditingController();
  TextEditingController _controller100 = TextEditingController();
  TextEditingController _controller50 = TextEditingController();
  TextEditingController _controller20 = TextEditingController();
  TextEditingController _controller10 = TextEditingController();
  TextEditingController _controller5 = TextEditingController();
  TextEditingController _controller1 = TextEditingController();
  int _totalCount = 0;
  bool isVisible = true;
  bool isVisible2 = false;
  bool isVisibleHistory = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _controller2000.text = (widget.initialData!['2000'] ?? '').toString();
      _controller500.text = (widget.initialData!['500'] ?? '').toString();
      _controller200.text = (widget.initialData!['200'] ?? '').toString();
      _controller100.text = (widget.initialData!['100'] ?? '').toString();
      _controller50.text = (widget.initialData!['50'] ?? '').toString();
      _controller20.text = (widget.initialData!['20'] ?? '').toString();
      _controller10.text = (widget.initialData!['10'] ?? '').toString();
      _controller5.text = (widget.initialData!['5'] ?? '').toString();
      _controller1.text = (widget.initialData!['1'] ?? '').toString();
      _calculateTotal();
    }
    _controller2000.addListener(_calculateTotal);
    _controller500.addListener(_calculateTotal);
    _controller200.addListener(_calculateTotal);
    _controller100.addListener(_calculateTotal);
    _controller50.addListener(_calculateTotal);
    _controller20.addListener(_calculateTotal);
    _controller10.addListener(_calculateTotal);
    _controller5.addListener(_calculateTotal);
    _controller1.addListener(_calculateTotal);
  }

  String convertToWords(int number) {
    if (number == 0) {
      return 'zero';
    }

    String result = '';

    List<String> units = [
      '',
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine'
    ];
    List<String> teens = [
      'ten',
      'eleven',
      'twelve',
      'thirteen',
      'fourteen',
      'fifteen',
      'sixteen',
      'seventeen',
      'eighteen',
      'nineteen'
    ];
    List<String> tens = [
      '',
      '',
      'twenty',
      'thirty',
      'forty',
      'fifty',
      'sixty',
      'seventy',
      'eighty',
      'ninety'
    ];
    List<String> thousands = ['', 'thousand', 'million', 'billion', 'trillion'];

    int groupIndex = 0;

    while (number > 0) {
      if (number % 1000 != 0) {
        String str = '';
        if (number % 100 < 10) {
          str = units[number % 100];
        } else if (number % 100 < 20) {
          str = teens[number % 10];
        } else {
          str = tens[(number % 100) ~/ 10] + ' ' + units[number % 10];
        }

        result = str.trim() + ' ' + thousands[groupIndex] + ' ' + result;
      }

      number ~/= 1000;
      groupIndex++;
    }
    print("the result is ===>> ${result}");
    return result.trim();
  }

  void _calculateTotal() {
    setState(() {
      int count2000 = int.tryParse(_controller2000.text) ?? 0;
      int count500 = int.tryParse(_controller500.text) ?? 0;
      int count200 = int.tryParse(_controller200.text) ?? 0;
      int count100 = int.tryParse(_controller100.text) ?? 0;
      int count50 = int.tryParse(_controller50.text) ?? 0;
      int count20 = int.tryParse(_controller20.text) ?? 0;
      int count10 = int.tryParse(_controller10.text) ?? 0;
      int count5 = int.tryParse(_controller5.text) ?? 0;
      int count1 = int.tryParse(_controller1.text) ?? 0;

      _totalCount = (count2000 * 2000) +
          (count500 * 500) +
          (count200 * 200) +
          (count100 * 100) +
          (count50 * 50) +
          (count20 * 20) +
          (count10 * 10) +
          (count5 * 5) +
          (count1);
      if (_totalCount != 0) {
        setState(() {
          isVisible = false;
          isVisible2 = true;
        });
      } else {
        setState(() {
          isVisible = true;
          isVisible2 = false;
        });
      }
    });
  }

  void _clearField(TextEditingController controller) {
    setState(() {
      controller.clear();
      _calculateTotal();
    });
  }

  void _showSaveDialog() async {
    String category = 'General'; // Default category
    String remarks = ''; // Initialize remarks
    DateTime timestamp = DateTime.now(); // Get current timestamp

    SharedPreferences prefs = await SharedPreferences.getInstance();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Save Data'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  DropdownButton<String>(
                    isExpanded: true,
                    value: category,
                    onChanged: (String? newValue) {
                      setState(() {
                        category = newValue ?? 'General';
                      });
                    },
                    items: <String>['General', 'Expense', 'Income']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    onChanged: (value) {
                      remarks = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Remarks',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
            int count2000 = int.tryParse(_controller2000.text) ?? 0;
            int count500 = int.tryParse(_controller500.text) ?? 0;
            int count200 = int.tryParse(_controller200.text) ?? 0;
            int count100 = int.tryParse(_controller100.text) ?? 0;
            int count50 = int.tryParse(_controller50.text) ?? 0;
            int count20 = int.tryParse(_controller20.text) ?? 0;
            int count10 = int.tryParse(_controller10.text) ?? 0;
            int count5 = int.tryParse(_controller5.text) ?? 0;
            int count1 = int.tryParse(_controller1.text) ?? 0;

            int totalCount = (count2000 * 2000) +
            (count500 * 500) +
            (count200 * 200) +
            (count100 * 100) +
            (count50 * 50) +
            (count20 * 20) +
            (count10 * 10) +
            (count5 * 5) +
            (count1);

            // Get the current savedKeys list or initialize an empty list
            List<String> savedKeys = prefs.getStringList('savedKeys') ?? [];

            // Create a new key for this saved data
            String key =
            'savedData_${DateTime.now().millisecondsSinceEpoch}';

            // Save the data
            await prefs.setString('$key-category', category);
            await prefs.setInt('$key-totalCount', totalCount);
            await prefs.setString('$key-remarks', remarks);
            await prefs.setInt(
            '$key-timestamp', timestamp.millisecondsSinceEpoch);

            // Add the new key to the list of keys
            savedKeys.add(key);

            // Update the list of keys in SharedPreferences
            await prefs.setStringList('savedKeys', savedKeys);

            // Clear fields and dismiss dialog
            _clearAllFields();
            Navigator.of(context).pop();
            },

                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _clearAllFields() {
    setState(() {
      _controller2000.clear();
      _controller500.clear();
      _controller200.clear();
      _controller100.clear();
      _controller50.clear();
      _controller20.clear();
      _controller10.clear();
      _controller5.clear();
      _controller1.clear();
      _calculateTotal();
    });
  }

  Widget commonTextWidget(String denomination, TextEditingController controller, {String hintText = ''}) {
    int denominationValue = int.parse(denomination);
    int count = int.tryParse(controller.text) ?? 0;
    int totalValue = denominationValue * count;

    return Padding(
      padding: const EdgeInsets.only(top: 8,bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            ' ₹ $denomination x',
            style: TextStyle(fontSize: 18.0,color: Colors.white,fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: SizedBox(
              height: 40,
              width: 100,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateTotal(),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                      color: Colors.white
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0, color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.grey,
                  suffixIcon: controller.text.isNotEmpty ? IconButton(
                    icon: Icon(Icons.cancel, color: Colors.white),
                    onPressed: () => controller.clear(),
                  ) : null,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            '=  ₹ $totalValue',
            style: TextStyle(fontSize: 18.0,color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                isVisibleHistory = false;
                setState(() {});
              },
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Image.asset(ImageConst.ooumphImage),
                  Visibility(
                    visible: isVisibleHistory,
                    child: Positioned(
                        right: 3,
                        child: Container(
                          color: Colors.blue,
                          height: 60,
                          width: 90,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HistoryDataPage(),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.history,
                                color: Colors.white,
                              )),
                        )),
                  ),
                  Positioned(
                      right: 0,
                      child: GestureDetector(
                          onTap: () {
                            isVisibleHistory = !isVisibleHistory;
                            setState(() {});
                          },
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ))),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Column(
                      children: [
                        Visibility(
                            visible: isVisible,
                            child: CustomLabel(
                              text: 'Denomination',
                              color: Colors.white,
                              size: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        Visibility(
                          visible: isVisible2,
                          child: Column(
                            children: [
                              const CustomLabel(
                                text: 'Total Amount',
                                color: Colors.white,
                                size: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomLabel(
                                text: '₹ ${_totalCount}',
                                color: Colors.white,
                                size: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomLabel(
                                text: '${convertToWords(_totalCount)} Only/'
                                    .toUpperCase(),
                                color: Colors.white,
                                size: 16,
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            commonTextWidget("2000", _controller2000,hintText: 'try'),
            commonTextWidget("500", _controller500),
            commonTextWidget("200", _controller200),
            commonTextWidget("100", _controller100),
            commonTextWidget("50", _controller50),
            commonTextWidget("20", _controller20),
            commonTextWidget("10", _controller10),
            commonTextWidget("5", _controller5),
            commonTextWidget("1", _controller1),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return BottomDialogue(downloadFunction: (){
                _showSaveDialog();

              },
                clearFunction: (){
                _clearAllFields();
                },
              ); // Custom dialog widget
            },
          );
        },
        child: Icon(Icons.bolt),
      ),
    );
  }
}


