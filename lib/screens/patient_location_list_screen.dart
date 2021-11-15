import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:patient_relative/services/patient_location_list_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientLocationListScreen extends StatefulWidget {
  final String pName;

  PatientLocationListScreen({required this.pName});

  @override
  State<PatientLocationListScreen> createState() =>
      _PatientLocationListScreenState();
}

class _PatientLocationListScreenState extends State<PatientLocationListScreen> {
  String? lastSeenTimeDay = "";
  String? lastSeenTimeHour = "";
  String? location = "";
  String? distance = "";
  String? link = "";
  List allLocations = [];
  int pageNumber = 0;
  bool loading = true;

  late List httpRequest;

  bool buttonLoading = false;
  final ScrollController _sc = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      refreshPosts();
    });
    super.initState();
    // if scroll's position at maxScrollExtent fetch new products(new page)
    _sc.addListener(() async {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        setState(() {
          buttonLoading = true;
        });
        await pullUpScreen();
        setState(() {
          buttonLoading = false;
        });
        // searchProductProvider.fetchData(widget.query);
      }
    });
  }

  Future<void> pullUpScreen() async {
    List get10Loc = await getLocationInfo(pageNumber + 1);
    if (get10Loc.isEmpty) {
      setState(() {
        pageNumber = pageNumber;
      });
      return;
    } else {
      setState(() {
        for (final location in get10Loc) {
          allLocations.add(location);
        }
      });
      setState(() {
        pageNumber += 1;
      });
    }
  }

  Future<void> refreshPosts() async {
    setState(() {
      pageNumber = 0;
    });
    allLocations = await getLocationInfo(pageNumber);
  }

  Future<List> getLocationInfo(int pageNum) async {
    var result =
        await PatientLocationListService().getLastLocationInfo(pageNum);
    if (result[0] == "No More Patient Info") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${widget.pName} başka bir bilgiye sahip değildir"),
      ));
      return [];
    }
    httpRequest = result[1];
    setState(() {
      for (final location in httpRequest) {
        var currentElement = location;
        var parsedDate = DateTime.parse(currentElement["SeenTime"]);
        final DateFormat formatter = DateFormat('dd.MM.yyyy HH:mm');
        final String formatted = formatter.format(parsedDate);
        var fullTime = formatted.split(" ");
        location["SeenTime"] = fullTime[0] + " " + fullTime[1];
      }
      loading = false;
    });
    return httpRequest;
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: buttonLoading ? 1.0 : 0.0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Tubitak'),
      ),
      body: Container(
        child: loading
            ? SpinKitSpinningLines(
                color: Colors.redAccent,
                size: 100,
                duration: Duration(seconds: 3),
              )
            : RefreshIndicator(
                onRefresh: refreshPosts,
                child: ListView.builder(
                    controller: _sc,
                    itemCount: allLocations.length + 1,
                    itemBuilder: (context, index) {
                      if (index == allLocations.length) {
                        return _buildProgressIndicator();
                      }

                      // liste oluşturup verileri o listeden çek
                      // liste için model de oluşturabilirsin lcoation diye
                      // daha sonra indexe göre yerleştir
                      return GestureDetector(
                        onDoubleTap: () async {
                          final url = allLocations[index]["GoogleMapLink"];
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: ListTile(
                          leading: Icon(Icons.location_city),
                          title: Text(allLocations[index]["Location"]),
                          subtitle: Text("Tarih: ${allLocations[index]["SeenTime"]}"),
                          trailing: Text("${allLocations[index]["Distance"]}m"),
                        ),
                      );
                    }),
              ),
      ),
    );
  }
}
