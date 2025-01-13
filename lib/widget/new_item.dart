import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // as is the important keyword in this statment it tell dart all the conetent provided by this packeage should be bounded into object
import 'package:shoping_list/data/categories.dart';
import 'package:shoping_list/models/category.dart';
import 'package:shoping_list/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<
      FormState>(); // clobal key easy access to the underlaying  widget to widget is connected
  var _enteredName = ''; // save the value of name
  var _enteredQuintity = 1; // save the value of quintity
  var _selectedCategory = categories[Categories.vegetables]!;
  var _isSending = false; // it is a circuler proccessing design

  void _saveItem() async {
    // this method is used to save the item and also check the  validate all the condition are tru or false validate are return true or false
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!
          .save(); // when we call this saveOn fucntion are triggered

      setState(() {
        // you click the save button then we visibale the circuler process digram
        _isSending = true;
      });

      final url = Uri.https(
          'flutter-prep-57ae2-default-rtdb.firebaseio.com', // firebase want a htps request
          'shopping-list.json');
      final respone = await http.post(
          // post it is used to store the data
          url,
          headers: {
            'content-type':
                'application/json', // this will help firebase understand how the data were sending to it will be formatted
          },
          body: json.encode({
            'name': _enteredName,
            'quantity': _enteredQuintity,
            'category': _selectedCategory.title,
          }) //encode() converts data into json formatted text// which define the data that should be attached to the outgoing request
          );
      // print(respone.body);
      // print(respone.statusCode);

      final Map<String, dynamic> resData = json.decode(respone.body);
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(GroceryItem(
          id: resData['name'],
          name: _enteredName,
          quantity: _enteredQuintity,
          category: _selectedCategory));
      // Navigator.of(context).pop(// it is used to back the screent from B to A
      //     GroceryItem(
      //         id: DateTime.now().toString(),
      //         name: _enteredName,
      //         quantity: _enteredQuintity,
      //         category: _selectedCategory));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(// form is a combination of input fields
          key: _formKey,
          child: Column(
            children: [
              TextFormField(// TextField(), this is normaly we use. we use textformfield it is available in the form
                maxLength: 50,
                decoration: const InputDecoration(label: Text("Name")),
                validator: (value) {// it is used to add a condition in the text. it is in the form. it is used to vlidate a name it is a new widget in this section
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <=
                          1 || // trim is used to remove white space at the begining and end
                      value.trim().length >= 50) {
                    return "must be between 1 and  50 caharacter";
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quentity'),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _enteredQuintity.toString(),
                      validator: (value) {
                        // it is used to add a condition in the text. it is in the form. it is used to vlidate a name it is a new widget in this section
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) ==
                                null || // trim is used to remove white space at the begining and end
                            int.tryParse(value)! <= 0) {
                          return "must be a valid, positive number.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuintity = int.parse(
                            value!); // parse is through error if it fails to converet the string to number where tryPharse yeilds null
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value:
                          _selectedCategory, // in dropdownbuttonformfield initial value does not support initialvalues  parameter
                      items: [
                        for (final category in categories
                            .entries) // enteries are used to convert the map into list
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value
                                      .color, // it is access the value(key:value ) of the categories
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(category.value.title)
                              ],
                            ),
                          )
                      ],
                      onChanged: (value) {
                        _selectedCategory =
                            value!; // there is no need to Onsave patrameter
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: _isSending
                          ? null
                          : () {
                              // we used turnery operator for function is use as a value on pressed to show the circuler digram
                              _formKey.currentState!
                                  .reset(); // reset the value all
                            },
                      child: const Text('Reset')),
                  ElevatedButton(
                    onPressed: _isSending ? null : _saveItem, // we used turnery operator for function is use as a value on pressed to show the circuler digram
                  child:  _isSending ? const SizedBox(height: 16,width: 16, child: CircularProgressIndicator(),) : const Text('Add Item'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
