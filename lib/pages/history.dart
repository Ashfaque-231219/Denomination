import 'package:denomination/helper/common_widget/custom_lable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import 'package:share_plus/share_plus.dart';


class HistoryDataPage extends StatefulWidget {
  const HistoryDataPage({Key? key});

  @override
  State<HistoryDataPage> createState() => _HistoryDataPageState();
}

class _HistoryDataPageState extends State<HistoryDataPage> {
  Future<void> _deleteSavedData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedKeys = prefs.getStringList('savedKeys');
    if (savedKeys != null) {
      savedKeys.remove(key);
      await prefs.setStringList('savedKeys', savedKeys);
      await prefs.remove('$key-category');
      await prefs.remove('$key-totalCount');
      await prefs.remove('$key-remarks');
      await prefs.remove('$key-timestamp');
      await prefs.remove('$key-2000');
      await prefs.remove('$key-500');
      await prefs.remove('$key-200');
      await prefs.remove('$key-100');
      await prefs.remove('$key-50');
      await prefs.remove('$key-20');
      await prefs.remove('$key-10');
      await prefs.remove('$key-5');
      await prefs.remove('$key-1');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: CustomLabel(
          text: 'History',
          color: Colors.white,
          size: 22,
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getSavedData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          List<Map<String, dynamic>> savedDataList = snapshot.data ?? [];
          return ListView.builder(
            itemCount: savedDataList.length,
            itemBuilder: (context, index) {
              final savedData = savedDataList[index];
              DateTime? timestamp = savedData['timestamp'];
              String formattedTimestamp =
                  timestamp != null ? _formatTimestamp(timestamp) : '';

              return Slidable(
                key: Key(savedData['key'].toString()),
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                direction: Axis.horizontal,
                // Set direction to horizontal for left swipe
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Edit',
                    color: Colors.blue,
                    icon: Icons.edit,
                    onTap: () {
                      _showEditDialog(context, savedData);
                    },
                  ),
                  IconSlideAction(
                    caption: 'Delete',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () {
                      // Remove item from the list
                      setState(() {
                        savedDataList.removeAt(index);
                        _deleteSavedData(savedData['key']);
                      });
                    },
                  ),
                  IconSlideAction(
                    caption: 'Share',
                    color: Colors.green,
                    icon: Icons.share,
                    onTap: () {
                      Share.share(
                        'Category: ${savedData['category']}\n'
                            'Total Count: ${savedData['totalCount']}\n'
                            'Remarks: ${savedData['remarks'] ?? ''}\n'
                            'Saved on: $formattedTimestamp',
                      );

                    },
                  ),
                ],
                child: Card(
                  elevation: 4,
                  color: Colors.transparent,
                  // Set color to transparent to use gradient

                  margin: EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF4169E1),
                          Color(0xFF00008B),
                        ], // Light and dark blue-black colors
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Navigate to CurrencyCalculator for editing
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CurrencyCalculator(
                              initialData: savedData,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              savedData['category'] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '₹ ${savedData['totalCount']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              savedData['remarks'] ?? '',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '$formattedTimestamp',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    String month = DateFormat('MMMM').format(timestamp);
    String day = DateFormat('d').format(timestamp);
    String year = DateFormat('y').format(timestamp);
    String hourMinute = DateFormat('h:mm a').format(timestamp);
    return '$day $month $year,  $hourMinute';
  }

  Future<List<Map<String, dynamic>>> _getSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedKeys = prefs.getStringList('savedKeys');
    List<Map<String, dynamic>> savedDataList = [];
    if (savedKeys != null) {
      for (String key in savedKeys) {
        String? category = prefs.getString('$key-category');
        int? totalCount = prefs.getInt('$key-totalCount');
        String? remarks = prefs.getString('$key-remarks');
        int? timestampInMillis = prefs.getInt('$key-timestamp');
        DateTime? timestamp = timestampInMillis != null
            ? DateTime.fromMillisecondsSinceEpoch(timestampInMillis)
            : null;
        savedDataList.add({
          'key': key,
          'category': category,
          'totalCount': totalCount,
          'remarks': remarks,
          'timestamp': timestamp,
          '2000': prefs.getString('$key-2000'),
          '500': prefs.getString('$key-500'),
          '200': prefs.getString('$key-200'),
          '100': prefs.getString('$key-100'),
          '50': prefs.getString('$key-50'),
          '20': prefs.getString('$key-20'),
          '10': prefs.getString('$key-10'),
          '5': prefs.getString('$key-5'),
          '1': prefs.getString('$key-1'),
        });
      }
    }
    return savedDataList;
  }
}

void _showEditDialog(BuildContext context, Map<String, dynamic> savedData) {
  TextEditingController totalCountController =
      TextEditingController(text: savedData['totalCount'].toString());

  List<String> categories = ['General', 'Expense', 'Income'];

  String? selectedCategory = savedData['category'];

  if (!categories.contains(selectedCategory)) {
    selectedCategory = 'General';
  }

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Edit Data'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: totalCountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Total Count'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Save'),
                onPressed: () async {
                  // Update saved data
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString(
                      '${savedData['key']}-category', selectedCategory!);
                  await prefs.setInt('${savedData['key']}-totalCount',
                      int.parse(totalCountController.text));

                  // Dismiss dialog
                  Navigator.of(context).pop();

                  // Trigger UI update by popping and pushing the route again
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HistoryDataPage()));
                },
              ),
            ],
          );
        },
      );
    },
  );
}
