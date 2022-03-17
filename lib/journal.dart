import 'package:flutter/material.dart';
import 'package:test2/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar',
      home: JournalScreen()
      ,
    );
  }
}

class journalEntry {
  journalEntry({
    required this.date,
    required this.place,
    required this.mood,
    required this.desc,
    required this.selected
  });
  
  final String date;
  String place;
  bool mood;
  String desc;
  bool selected;
}

class entryItem extends StatelessWidget {
  const entryItem({
    required this.entry,
    required this.onEntryChanged,
});

  final journalEntry entry;
  final onEntryChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        onEntryChanged(entry);
      },
      title: TextButton(
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedEntry(savedEntry: entry,))
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(entry.date,
              style: const TextStyle(
                color: Colors.black,
                ),
              ),
              Text(entry.place,
                style: const TextStyle(
                  color: Colors.black,
                ),
              )
            ],
          ),
      )
    );
  }
}

final List<int> colorCode = <int> [
  0xFF4cb8c4,
  0xFF3cd3ad,
];

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final List<journalEntry> _entries = <journalEntry>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Journal'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Settings'),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.cyan,
                      ),
                      body: settings
                    );
                  },
                ));
              },
            ),
          ],
          backgroundColor: Colors.white,
          foregroundColor: Colors.cyan,
        ),
        body: Center(
          child: ListView.separated(
            padding: const EdgeInsets.all(15),
            itemCount: _entries.length,
            itemBuilder: (BuildContext context, int index){
              return Container(
                height: 50,
                color: Color(colorCode[index%2]),
                child: Center(
                  child: entryItem(
                      entry: _entries[index],
                      onEntryChanged: _entries[index],
                  )
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new NewEntry(entryList: _entries))
            ).then((_) => setState((){}));
            },
          tooltip: 'Add New Entry',
          child: const Icon(Icons.edit),
        ),
        );
  }
}

//TO DO: FIX OVERLOAD, WRAP INPUTS IN LISTVIEW
class NewEntry extends StatelessWidget {
 NewEntry ({Key? key, required this.entryList}) : super(key : key);

   final TextEditingController _dateController = TextEditingController();
   final TextEditingController _placeController = TextEditingController();
   final TextEditingController _descController = TextEditingController();
   late bool mood;

   final entryList;
   var newEntry;

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: const Text('New Entry'),
         backgroundColor: Colors.white,
         foregroundColor: Colors.cyan,
         ),
       body: Container(
         padding: EdgeInsets.fromLTRB(50,30,50,30),
         child: Expanded(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               TextField(
                 controller: _dateController,
                 decoration: const InputDecoration(hintText: "When did you do go on a trip?"),
               ),
               const SizedBox(height: 30,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   TextButton(
                       onPressed: (){
                         mood = true;
                       },
                       child: const Icon(Icons.thumb_up_rounded, color: Colors.green,)),
                   TextButton(
                       onPressed: (){
                         mood = false;
                       },
                       child: const Icon(Icons.thumb_down, color: Colors.red,))
                 ],
               ),
               const SizedBox(height: 20,),
               TextField(
                 controller: _placeController,
                 decoration: const InputDecoration(hintText: "Where did you go?"),
               ),
               const SizedBox(height: 20,),
               TextField(
                 controller: _descController,
                 decoration: const InputDecoration(hintText: "What did you do?"),
               ),
               const SizedBox(height: 50,),
               ClipRRect(
                 borderRadius: BorderRadius.circular(15),
                 child: Stack(
                   children: <Widget>[
                     Positioned.fill(
                       child: Container(
                         color: Colors.black,
                       ),
                     ),
                     TextButton(
                       style: TextButton.styleFrom(
                         padding: const EdgeInsets.all(15.0),
                         primary: Colors.white,
                         textStyle: const TextStyle(fontSize: 16),
                       ),
                       onPressed: () {
                         newEntry = _addEntryItem(
                             _dateController.text,
                             mood,
                             _placeController.text,
                             _descController.text);
                         Navigator.pop(context);
                         _dateController.clear();
                         _descController.clear();
                         _placeController.clear();
                       },
                       child: const Text('       SAVE       '),
                     ),
                   ],
                 ),
               )
             ],
           ),
         )
       ),
     );
   }

_addEntryItem(String date, bool mood, String place, String desc){
   var newEntry = journalEntry(
       date: date,
       place: place,
       mood: mood,
       desc: desc,
       selected: true);
   entryList.add(newEntry);
 }
 }

 //TO DO: WRAP INPUT IN LIST VIEW, INPUT MOOD ICONS, 
class SavedEntry extends StatefulWidget {
  SavedEntry({required this.savedEntry});

  final savedEntry;

  @override
  State<SavedEntry> createState() => _SavedEntryState(savedEntry: savedEntry);
}

class _SavedEntryState extends State<SavedEntry> {
  _SavedEntryState({required this.savedEntry});

  final savedEntry;

   setMoodIcon(savedMood){
    bool selectedMood = savedMood;
    var moodIcon;
    if (selectedMood == true){
      moodIcon = Icons.thumb_up;
    } else {
      moodIcon = Icons.thumb_down;
    }
    return moodIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Entry'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.cyan,
      ),
      body: Container(
        padding: const EdgeInsets.all(35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(savedEntry.date,
                            style: const TextStyle(
                            fontSize: 20,
                          ),
                      ),
                      Icon(setMoodIcon(savedEntry.mood)),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  Text("That day I visited "+ savedEntry.place,
                    style: const TextStyle(
                      fontSize: 20,
                    ),),
                  const SizedBox(height: 30,),
                  Text("In " + savedEntry.place + ", " + savedEntry.desc,
                    style: const TextStyle(
                      fontSize: 20,
                    ),),
                  const SizedBox(height: 80,),
                ],
              ),
              Center(
                child:
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(15.0),
                          primary: Colors.white,
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => EditEntry(
                                selectedEntry: savedEntry,
                                savedDate: savedEntry.date,
                                savedMood: savedEntry.mood,
                                savedPlace: savedEntry.place,
                                savedDesc: savedEntry.desc,
                              ))
                          ).then((_) => setState((){}));
                        },
                        child: const Text('       EDIT       '),
                      ),
                    ],
                  ),
                )
              ),
            ],
          )
      ),
    );
  }
}

//TO DO: DELETE FUNCITON, FIX OVERLOAD
class EditEntry extends StatelessWidget {
  EditEntry({Key? key,
    required this.selectedEntry,
    required this.savedDate,
    required this.savedMood,
    required this.savedPlace,
    required this.savedDesc}) : super(key: key);

  final selectedEntry;
  final String savedDate;
  final bool savedMood;
  final String savedPlace;
  final String savedDesc;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  late bool mood;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Entry'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.cyan,
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _dateController,
              decoration: InputDecoration(hintText: savedDate),
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: (){
                      mood = true;
                    },
                    child: const Icon(Icons.thumb_up_rounded, color: Colors.green,)),
                TextButton(
                    onPressed: (){
                      mood = false;
                    },
                    child: const Icon(Icons.thumb_down, color: Colors.red,))
              ],
            ),
            const SizedBox(height: 30,),
            TextField(
              controller: _placeController,
              decoration: InputDecoration(hintText: savedPlace),
            ),
            const SizedBox(height: 30,),
            TextField(
              controller: _descController,
              decoration: InputDecoration(hintText: savedDesc),
            ),
            const SizedBox(height: 80,),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(15.0),
                      primary: Colors.white,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('       SAVE       '),
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




