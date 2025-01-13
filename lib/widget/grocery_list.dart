// import 'package:flutter/material.dart';

// import 'package:shoping_list/models/grocery_item.dart';
// import 'package:shoping_list/widget/new_item.dart';

// class GroceryList extends StatefulWidget {
//   const GroceryList({super.key});

//   @override
//   State<GroceryList> createState() => _GroceryListState();
// }

// class _GroceryListState extends State<GroceryList> {
//   final List<GroceryItem> _groceryItems =
//       []; // thi is used to store the groceroy items
//   void _addItem() async {
//     // it method is used to go from one page to another page
//     final newItem = await Navigator.of(context).push<GroceryItem>(
//       MaterialPageRoute(
//         builder: (ctx) => const NewItem(),
//       ),
//     );

//     if (newItem == null) {
//       return;
//     }
//     setState(() {
//       _groceryItems.add(newItem); // this is used to add into _groceroyItems
//       ScaffoldMessenger.of(context).showSnackBar( const SnackBar( duration: Duration(seconds: 1) ,content: Text("Itmes Added")));
//     });
//   }

//   void _removeItems(GroceryItem item){
//       _groceryItems.remove(item);

//       ScaffoldMessenger.of(context).showSnackBar( SnackBar( duration: const Duration(seconds: 1) ,content: const Text("Itmes Delted"),action: SnackBarAction(label: 'Undo', onPressed: (){
//         setState(() {
//           _groceryItems.add(item);
//         });
//       }),));
//   }



//   @override
//   Widget build(BuildContext context) {
//     Widget content = const Center(
//       child: Text("No Items Added Yet."),
//     ); // to display before there is no items are available

//     if (_groceryItems.isNotEmpty) {
//       content = ListView.builder(// we added the this all UI to the content and content pass in the body
//         itemCount: _groceryItems
//             .length, // this is used to go to all item and also to show the items in UI
//         itemBuilder: (ctx, index) => Dismissible(// it is used to swam the item and delete it
//         onDismissed: (direction) => {
//             _removeItems(_groceryItems[index])
//         },
//           key: ValueKey( // we added a key to uniquely identify every list item
//             _groceryItems[index].id,
//           ),
//           child: ListTile(
//             title: Text(_groceryItems[index].name), // this display the name
//             leading: Container(
//               //leading it is used to display before the title
//               width: 24,
//               height: 24,
//               color: _groceryItems[index].category.color,
//             ),
//             trailing: Text(_groceryItems[index]
//                 .quantity
//                 .toString()), // it is used to after the title
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Grocery List',
//           ),
//           actions: [
//             IconButton(onPressed: _addItem, icon: const Icon(Icons.add))
//           ],
//         ),
//         body: content // to display the added items
//         );
//   }
// }




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shoping_list/data/categories.dart';
import 'package:shoping_list/models/grocery_item.dart';
import 'package:shoping_list/widget/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
 List<GroceryItem> _groceryItems = []; // List to store grocery items
  var _isLoading = true;
  String? _error;
    @override
  void initState() {
    super.initState();
    _loadItem();
  }

  void _loadItem() async{
      final url = Uri.https('flutter-prep-57ae2-default-rtdb.firebaseio.com',
          'shopping-list.json');
        try {
          final response =  await http.get(url);


          // print(response.statusCode); //Status code is >400 or 400 <= 500 codes are errors codes 
         if(response.statusCode > 400){ // if any error found in code greater then 400 we see this masseage
         setState(() {
            _error = 'Failded to featch. please  try again later';// this is how to handle error
         });     
         }

         if(response.body == 'null'){
          setState(() {
            _isLoading = false;
          });
          return;
         }
       final Map<String,dynamic> listData =  json.decode(response.body); // it is converts the json format into map format
      final List<GroceryItem> loadedItems = [];
       for(final item in listData.entries){// inside this loop now convert these nested maps to grocery items
       final category =  categories.entries.firstWhere((catItem) => catItem.value.title == item.value['category']).value;
          loadedItems.add(GroceryItem(id: item.key, name: item.value['name'], quantity: item.value['quantity'], category: category));
       }
      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      }); 
        } catch (error) {
            setState(() {
            _error = 'Something went wrong!. please try again later';// this is how to handle error
         });
        }
        
      
  }

  void _addItem() async {
    // Navigate to the NewItem page and await the result
      final newItem =  await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    // _loadItem();

    if(newItem == null){
      return;
    } 
    setState(() {
      _groceryItems.add(newItem);// this is used for instant show the data
    });

      
    
    // if (newItem == null) {
    //   return;
    // }

    // setState(() {
    //   _groceryItems.add(newItem); // Add the new item to the list
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       duration: Duration(seconds: 1),
    //       content: Text("Item Added"),
    //     ),
    //   );
    // });
  }

  void _removeItems(GroceryItem item) async{
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item); // Remove the item from the list
    });
    final url = Uri.https('flutter-prep-57ae2-default-rtdb.firebaseio.com','shopping-list/${item.id}.json');
    final response = await http.delete(url);// there is no need add async and await other wise some case you add a this method
    if(response.statusCode >= 400){
        setState(() {
          _groceryItems.insert(index, item);
        });
    }
    

    // Show SnackBar with Undo option
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Item Deleted"),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            // If Undo is pressed, add the item back to the list
            setState(() {
              _groceryItems.add(item);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No Items Added Yet."),
    ); // Default content when the list is empty

    if(_isLoading){
      content = const Center(child: CircularProgressIndicator(),);
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        // Display the grocery items if the list is not empty
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          // Swipe to delete an item
          onDismissed: (direction) => {
            _removeItems(_groceryItems[index])
          },
          key: ValueKey(
            _groceryItems[index].id,
          ),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }
    if(_error != null){// this is how to handle error
        content = Center(child: Text(_error!));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: content, // Display the grocery items

      // body: FutureBuilder(future: future, builder: builder),
    );
  }
}