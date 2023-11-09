import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../helper/utils/Colors.dart';
import '../models/others.dart';
import '../widgets/resuables.dart';

class ListOfInstitutionScreen extends StatefulWidget {
  const ListOfInstitutionScreen({super.key});

  @override
  State<ListOfInstitutionScreen> createState() =>
      _ListOfInstitutionScreenState();
}

class _ListOfInstitutionScreenState extends State<ListOfInstitutionScreen> {
  List<School> _allInstitutions = [];
  List<School> _filteredInstitutions = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  void init() async {
    Dialogs.showProgressBar(context);
    final schools = await fetchSchools("");
    print('done');
setState(() {
  _allInstitutions = schools;
  _filteredInstitutions = schools;
});


    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print(_filteredInstitutions.length);
 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color7,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            onChanged: _filterSchools,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'search institution',
                hintStyle: TextStyle(color: color8),
                labelStyle: TextStyle(
                    color: color8,
                    fontFamily: 'Raleway-SemiBold',
                    fontSize: 15.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                // focusColor: Colors.grey[300],
                contentPadding: EdgeInsets.all(10),
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: Icon(
                          CupertinoIcons.clear_circled_solid,
                          color: color12,
                        ))
                    : SizedBox.shrink()),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "name can't be empty";
              } else if (value.length < 3) {
                return "name too short";
              }
              return null;
            },
          ),
        ),
        elevation: 0,
        leading: Reausables.arrowBackIcon(context),
      ),
      backgroundColor: color7,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child:_filteredInstitutions.isEmpty?Center(child: Text('No data found', style: TextStyle(fontWeight: FontWeight.bold),),) :ListView.builder(
            itemCount: _filteredInstitutions.length,
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              final school = _filteredInstitutions[index];
              return InkWell(
                borderRadius:  BorderRadius.circular(10),
                onTap: (){

                //  String selectedInstitution = "Selected Institution Name"; // Replace with the actual selected institution
                  Navigator.pop(context, school.name);
                },
                child:


                Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 1,
                child: ListTile(

                  title: Text(school.name),
                  subtitle: Text(school.location),

                ),
              ));
            }),
      ),
    );
  }

  void _filterSchools(String searchText) {
    if (searchText.isEmpty) {
      setState(() {
        _filteredInstitutions = _allInstitutions;
      });
    } else {
      setState(() {
        _filteredInstitutions = _allInstitutions
            .where((school) =>
                school.name.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      });
    }
  }

  Future<List<School>> fetchSchools(String searchText) async {
    if(APIs.schoolList.isNotEmpty){
      return APIs.schoolList;
    }else{

      try {
        return APIs.fetchSchools(searchText, context);
      } catch (e) {
        Dialogs.showSnackbar(context, e.toString());
        return [];
      }
    }

  }
}
