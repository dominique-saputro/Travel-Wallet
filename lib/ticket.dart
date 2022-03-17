import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test2/main.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar',
      home: TicketScreen(),
    );
  }
}

class ticketEntry{
  ticketEntry ({
    required this.title,
    required this.image
});

  String title;
  File image;
}

class ticketItem extends StatelessWidget {
  const ticketItem({required this.entry, required this.onEntryChanged});

  final ticketEntry entry;
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
                MaterialPageRoute(builder: (context) => 
                    SavedTicket(savedTicket: entry, ticketList: _tickets,)
                )
            );
          },
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.file(
                  entry.image,
                width: 150,
                height: 150,
                fit: BoxFit.cover,),
                Text(entry.title,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}


final List<int> colorCode = <int> [
  0xFF4cb8c4,
  0xFF3cd3ad,
];

final List<ticketEntry> _tickets = <ticketEntry>[];

class TicketScreen extends StatefulWidget {
  TicketScreen({Key? key}) : super(key: key);

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket'),
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
          itemCount: _tickets.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
              height: 200,
              color: Color(colorCode[index%2]),
              padding: const EdgeInsets.all(5),
              child: Center(
                  child: ticketItem(
                    entry: _tickets[index],
                    onEntryChanged: _tickets[index],
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
              MaterialPageRoute(builder: (context) => NewTicket(ticketList: _tickets))
          ).then((_) => setState((){}));
        },
        tooltip: 'Add New Ticket',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewTicket extends StatefulWidget {
  const NewTicket({required this.ticketList});

  final ticketList;

  @override
  _NewTicketState createState() => _NewTicketState(ticketList: ticketList);
}

class _NewTicketState extends State<NewTicket> {
  _NewTicketState({required this.ticketList});

  final TextEditingController _titleController = TextEditingController();

  final ticketList;
  var newTicket;
  var imageFile = null;

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Ticket'),
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
                  controller: _titleController,
                  decoration: const InputDecoration(hintText: "Which ticket is this?"),
                ),
                const SizedBox(height: 30,),
                Container(
                  child: imageFile == null
                  ? Container(
                    child: Column(
                      children: [
                        Text("Choose Image from:"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: (){
                                  _getFromGallery();
                                },
                                child: Text("Gallery")),
                            TextButton(
                                onPressed: (){
                                  _getFromCamera();
                                },
                                child: Text("Camera")),
                          ],
                        ),
                      ],
                    ),
                  ) : Container(
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    ),
                  )
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
                          newTicket = _addTicketItem(
                            _titleController.text,
                            imageFile,
                          );
                          Navigator.pop(context);
                          _titleController.clear();
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

  _addTicketItem(String title, File image){
    var newTicket = ticketEntry(
        title: title,
        image: image,
    );
    ticketList.add(newTicket);
  }
}


class SavedTicket extends StatelessWidget {
  const SavedTicket({ required this.savedTicket, required this.ticketList});

  final savedTicket;
  final ticketList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Ticket'),
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
                  Text(savedTicket.title,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Center(
                    child: Image.file(
                      savedTicket.image,
                      fit: BoxFit.cover,
                    ),
                  ),
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
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Are you sure you want to delete this entry?'),
                              content: const Text('This action can not be undone'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    _deleteTicket(savedTicket),
                                    Navigator.pop(context),
                                  },
                                  child: const Text('DELETE'),
                                ),
                              ],
                            ),
                          ),
                          child: const Text('       DELETE       '),
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

  _deleteTicket(savedTicket){
    ticketEntry selectedTicket = savedTicket;
    _tickets.removeWhere((ticketEntry) => ticketEntry.title  == selectedTicket.title);
  }

}
