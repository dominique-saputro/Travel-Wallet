import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/weather.dart';
import 'package:test2/calendar.dart';
import 'package:test2/journal.dart';
import 'package:test2/ticket.dart';
import 'package:test2/todo.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Travel Wallet',
      debugShowCheckedModeBanner: false,
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  var _currentTab = TabItem.home;
  final _navigatorKeys = {
    TabItem: GlobalKey<NavigatorState>(),
    TabItem.event: GlobalKey<NavigatorState>(),
    TabItem.journal: GlobalKey<NavigatorState>(),
    TabItem.ticket: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_currentTab]!.currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != TabItem.home) {
            // select 'main' tab
            _selectTab(TabItem.home);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.home),
          _buildOffstageNavigator(TabItem.event),
          _buildOffstageNavigator(TabItem.journal),
          _buildOffstageNavigator(TabItem.ticket),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

enum TabItem{ home, event, journal, ticket}

const Map<TabItem, String> tabName = {
  TabItem.home: 'home',
  TabItem.event: 'event',
  TabItem.journal: 'journal',
  TabItem.ticket: 'ticket',
};

class TabNavigator extends StatelessWidget {
  TabNavigator({required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItem tabItem;

  Map<TabItem, WidgetBuilder> _pageDetails(BuildContext context){
    return{
      TabItem.home : (context)=> FirstScreen(),
      TabItem.event : (context)=> CalendarScreen(),
      TabItem.journal : (context)=> JournalScreen(),
      TabItem.ticket : (context)=> TicketScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final pageDetails = _pageDetails(context);
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => pageDetails[tabItem]!(context),
        );
      },
    );
  }
}

class BottomNavigation extends StatelessWidget {
  BottomNavigation({required this.currentTab, required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
          Icons.home_outlined,
          color: Colors.grey,
          ),
          label: 'home'
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.event,
            color: Colors.grey,
          ),
          label: 'event'
        ),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.note_outlined,
              color: Colors.grey,
            ),
            label: 'journal'
        ),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.airplane_ticket_outlined,
              color: Colors.grey,
            ),
            label: 'ticket'
        ),
      ],
      onTap: (index) => onSelectTab(
        TabItem.values[index],
      ),
      currentIndex: currentTab.index,
      selectedItemColor: Color(0xFF4cb8c4),
    );
  }
}

final List<String> titles = <String>[
  'NAME',
  'SURNAME',
  'EMAIL ADDRESS',
  'LOCATION'
];

final List<String> entries = <String>[
  'name',
  'surname',
  'email address',
  'location'
];

final settings = Column(
  children: [
    Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color(0xFF4cb8c4),
            Color(0xFF3cd3ad),
          ],
        ),
      ),
      width: 400,
      height: 250,
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Column(
        children: [
          const Text('PROFILE PICTURE',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Icon(Icons.account_circle_rounded,
            size: 100,
            color: Colors.white,),
          const SizedBox(height: 10),
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
                  onPressed: () {},
                  child: const Text('       Edit Profile       '),
                ),
              ],
            ),
          )
        ],
      ),
    ),
    SizedBox(height: 20,),
    Text('General Information',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    SizedBox(height: 20,),
    Container(
        height: 330,
        width: 330,
        child: ListView.separated(
          padding: const EdgeInsets.all(10),
          itemCount: listLength,
          itemBuilder: (BuildContext context, int index){
            return Container(
              height: 60,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titles[index],
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(entries[index],
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
        )
    )
  ],
);

final listLength = 4;

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {

  String APIkey = '7bb3c9f5fd9682af0f7a04cb1406f979';
  late WeatherFactory ws;
  List<Weather> _data = [];
  String cityName = "Tokyo";
  AppState _state = AppState.NOT_DOWNLOADED;
  late String _temp;
  late String _icon;

  void queryWeather() async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _state = AppState.DOWNLOADING;
    });

    Weather weather = await ws.currentWeatherByCityName(cityName);
    setState(() {
      _data = [weather];
      _state = AppState.FINISHED_DOWNLOADING;
      _temp = _data[0].tempFeelsLike.toString();
      _icon = _data[0].weatherMain.toString();

    });
  }

  _setWeatherIcon(_icon){
    late IconData _weatherIcon;
    if (_icon == "Clouds") {
      _weatherIcon = Icons.wb_cloudy;
    } else if (_icon == "Sunny"){
      _weatherIcon = Icons.wb_sunny;
    }
    return _weatherIcon;
  }

  void initState() {
    super.initState();
    ws = new WeatherFactory(APIkey);
  }

  Widget contentFinishedDownload() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color(0xFF4cb8c4),
            Color(0xFF3cd3ad),
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Color(0x50000000),
            blurRadius: 4,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsets.all(10),
      child: SizedBox(
        width: 400,
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_setWeatherIcon(_icon),
                  size: 60,
                  color: Colors.white,),
                SizedBox(height: 5,),
                Text(
                  _temp,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                _buttons(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: const [
                    Icon(Icons.location_pin,
                        color: Colors.white),
                    Text('Tokyo - To',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white
                      ),
                    ),
                  ],
                ),
                Column(
                  children: const [
                    Text('Upcoming Events',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text('_________________________',
                        style: TextStyle(color: Colors.white)
                    ),
                    SizedBox(height: 5,),
                    Text('_________________________',
                        style: TextStyle(color: Colors.white))
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget contentDownloading() {
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(children: [
        Text(
          'Fetching Weather...',
          style: TextStyle(fontSize: 20),
        ),
        Container(
            margin: EdgeInsets.only(top: 10),
            child: Center(child: CircularProgressIndicator(strokeWidth: 10)))
      ]),
    );
  }

  Widget contentNotDownloaded() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
            child: Icon( Icons.refresh,
              color: Color(0xFF4cb8c4),
            ),
            onPressed: queryWeather,
          ),
          Text(
            'Press the button to download the Weather forecast',
          ),
        ],
      ),
    );
  }

  Widget _resultView() => _state == AppState.FINISHED_DOWNLOADING
      ? contentFinishedDownload()
      : _state == AppState.DOWNLOADING
      ? contentDownloading()
      : contentNotDownloaded();

  Widget _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: TextButton(
            child: Icon( Icons.refresh,
              color: Colors.white,
            ),
            onPressed: queryWeather,
          ),
        ),
      ],
    );
  }

  final head = Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[
          Color(0xFF4cb8c4),
          Color(0xFF3cd3ad),
        ],
      ),
    ),
    child: SizedBox(
      width: 400,
      height: 175,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            child: const Text('MARIA OCTAVIA HANDOYO',
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
             ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:const [
              Icon(Icons.account_circle_rounded,
                size: 100,
                color: Colors.white,
              ),
              SizedBox(width: 20,),
              Text(
                "Let's begin our journey!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            head,
            _resultView(),
          Container(
            child: SizedBox(
              width: 400,
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[
                      TextButton(
                          onPressed: (){},
                          child: Column(
                            children: const [
                              Icon(Icons.event_outlined,
                                  size: 70,
                                  color: Color(0xFF4cb8c4)
                              ),
                              Text('Calendar',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black
                                ),
                              ),
                            ],
                          )
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TodoList()));
                        },
                        child: Column(
                          children: const[
                            Icon(Icons.list_alt,
                                size: 70,
                                color: Color(0xFF4cb8c4)),
                            Text('Checklist',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: (){},
                        child: Column(
                          children: const[
                            Icon(Icons.account_balance_wallet_outlined,
                                size: 70,
                                color: Color(0xFF4cb8c4)),
                            Text('Budget',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black
                              ),
                            ),
                          ],
                        ),)
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:[
                      TextButton(onPressed: (){},
                        child: Column(
                          children: const[
                            Icon(Icons.airplane_ticket_outlined,
                                size: 70,
                                color: Color(0xFF4cb8c4)),
                            Text('Tickets',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(onPressed: (){},
                        child: Column(
                          children: const[
                            Icon(Icons.note_outlined,
                                size: 70,
                                color: Color(0xFF4cb8c4)),
                            Text('Journal',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(onPressed: (){},
                        child: Column(
                          children: const[
                            Icon(Icons.supervisor_account_rounded,
                                size: 70,
                                color: Color(0xFF4cb8c4)),
                            Text('News',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
          ],
        ),
      )
    );
  }
}
