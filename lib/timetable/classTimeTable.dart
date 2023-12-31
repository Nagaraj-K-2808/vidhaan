import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as p;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:vidhaan/timetable/timetable.dart';
import '../print/classwise_timetable_print.dart';
import '../print/time_table_print.dart';

class ClassWiseTimeTable extends StatefulWidget {
  const ClassWiseTimeTable({Key? key}) : super(key: key);

  @override
  State<ClassWiseTimeTable> createState() => _ClassWiseTimeTableState();
}

class _ClassWiseTimeTableState extends State<ClassWiseTimeTable> {


  final texteditingmonday = List<TextEditingController>.generate(200, (int index) => TextEditingController(), growable: true);
  final textediting2 = List<TextEditingController>.generate(200, (int index) => TextEditingController(), growable: true);


  final TextEditingController _typeAheadControllerclass = TextEditingController();
  final TextEditingController _typeAheadControllersection = TextEditingController();
  final TextEditingController _typeAheadControllerday = TextEditingController();


  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  static final List<String> classes = [];
  static List<String> getSuggestionsclass(String query) {
    List<String> matches = <String>[];
    matches.addAll(classes);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }


  static final List<String> staffs = [];

  static List<String> getSuggestionsubject(String query) {
    List<String> matches = <String>[];
    matches.addAll(staffs);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  String classid="";

  firstcall() async {
    var document3 = await  FirebaseFirestore.instance.collection("ClassMaster").orderBy("order").get();
    var document2 = await  FirebaseFirestore.instance.collection("SectionMaster").orderBy("order").get();
    setState(() {
      _typeAheadControllerclass.text=document3.docs[0]["name"];
      _typeAheadControllersection.text=document2.docs[0]["name"];
      classid=document3.docs[0].id;
    });
    subjectdrop();
    settimestable();
  }
  adddropvalue() async {
    setState(() {
      classes.clear();
      section.clear();
    });
    var document3 = await  FirebaseFirestore.instance.collection("ClassMaster").orderBy("order").get();
    var document2 = await  FirebaseFirestore.instance.collection("SectionMaster").orderBy("order").get();
    setState(() {
      classes.add("Select Option");
      section.add("Select Option");
    });
    for(int i=0;i<document3.docs.length;i++) {
      setState(() {
        classes.add(document3.docs[i]["name"]);
      });

    }
    for(int i=0;i<document2.docs.length;i++) {
      setState(() {
        section.add(document2.docs[i]["name"]);
      });

    }

  }
  subjectdrop() async {
    setState(() {
      staffs.clear();
    });
    var document = await  FirebaseFirestore.instance.collection("ClassMaster").doc(classid).collection("Sections").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}").collection("Subjects").orderBy("timestamp").get();
    for(int i=0;i<document.docs.length;i++) {
      setState(() {
        staffs.add(document.docs[i]["staffname"]);
      });
    }
  }

  static final List<String> section = [];
  static final List<String> daysOfWeek = ["Select Option","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
  static List<String> getSuggestionssection(String query) {
    List<String> matches = <String>[];
    matches.addAll(section);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  addtimetable() async {
    var documents= await FirebaseFirestore.instance.collection("ClassMaster").doc(classid).collection("Sections").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}").collection("Subjects").orderBy("timestamp").get();
    var documentstecher= await FirebaseFirestore.instance.collection("Staffs").get();


    for(int i=0;i<8;i++) {
      for(int j=0;j<documents.docs.length;j++) {
        if (texteditingmonday[i].text == documents.docs[j]["name"]) {
          FirebaseFirestore.instance.collection("ClassTimeTable").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}")
              .collection("TimeTable").doc("monday${i}").set({
            "subject": texteditingmonday[i].text,
            "staff": documents.docs[j]["staffname"],
            "order":i
          });
          for(int k=0;k<documentstecher.docs.length;k++){
            if(documents.docs[j]["staffid"]==documentstecher.docs[k]["regno"]){
              FirebaseFirestore.instance.collection("Staffs").doc(documentstecher.docs[k].id).collection("Timetable").doc("monday${i}").set({
                "subject": texteditingmonday[i].text,
                "class": _typeAheadControllerclass.text,
                "section": _typeAheadControllersection.text,
                "period":i,
                "day":"Monday",
              });
            }
          }
        }
      }
    }
    for(int i=8;i<16;i++) {
      for(int j=0;j<documents.docs.length;j++) {
        if (texteditingmonday[i].text == documents.docs[j]["name"]) {
          FirebaseFirestore.instance.collection("ClassTimeTable").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}")
              .collection("TimeTable").doc("tuesday${i}").set({
            "subject": texteditingmonday[i].text,
            "staff": documents.docs[j]["staffname"],
            "order":i
          });
          for(int k=0;k<documentstecher.docs.length;k++){
            if(documents.docs[j]["staffid"]==documentstecher.docs[k]["regno"]){
              FirebaseFirestore.instance.collection("Staffs").doc(documentstecher.docs[k].id).collection("Timetable").doc("tuesday${i}").set({
                "subject": texteditingmonday[i].text,
                "class": _typeAheadControllerclass.text,
                "section": _typeAheadControllersection.text,
                "period":i,
                "day":"Tuesday",
              });
            }
          }
        }
      }
    }
    for(int i=16;i<24;i++) {
      for(int j=0;j<documents.docs.length;j++) {
        if (texteditingmonday[i].text == documents.docs[j]["name"]) {
          FirebaseFirestore.instance.collection("ClassTimeTable").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}")
              .collection("TimeTable").doc("wednesday${i}").set({
            "subject": texteditingmonday[i].text,
            "staff": documents.docs[j]["staffname"],
            "order":i
          });
          for(int k=0;k<documentstecher.docs.length;k++){
            if(documents.docs[j]["staffid"]==documentstecher.docs[k]["regno"]){
              FirebaseFirestore.instance.collection("Staffs").doc(documentstecher.docs[k].id).collection("Timetable").doc("tuesday${i}").set({
                "subject": texteditingmonday[i].text,
                "class": _typeAheadControllerclass.text,
                "section": _typeAheadControllersection.text,
                "period":i,
                "day":"Wednesday",
              });
            }
          }
        }
      }
    }
    for(int i=24;i<32;i++) {
      for(int j=0;j<documents.docs.length;j++) {
        if (texteditingmonday[i].text == documents.docs[j]["name"]) {
          FirebaseFirestore.instance.collection("ClassTimeTable").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}")
              .collection("TimeTable").doc("thursday${i}").set({
            "subject": texteditingmonday[i].text,
            "staff": documents.docs[j]["staffname"],
            "staffid": documents.docs[j]["staffid"],
            "order":i
          });
          for(int k=0;k<documentstecher.docs.length;k++){
            if(documents.docs[j]["staffid"]==documentstecher.docs[k]["regno"]){
              FirebaseFirestore.instance.collection("Staffs").doc(documentstecher.docs[k].id).collection("Timetable").doc("tuesday${i}").set({
                "subject": texteditingmonday[i].text,
                "class": _typeAheadControllerclass.text,
                "section": _typeAheadControllersection.text,
                "period":i,
                "day":"Thursday",
              });
            }
          }
        }
      }
    }
    for(int i=32;i<40;i++) {
      for(int j=0;j<documents.docs.length;j++) {
        if (texteditingmonday[i].text == documents.docs[j]["name"]) {
          FirebaseFirestore.instance.collection("ClassTimeTable").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}")
              .collection("TimeTable").doc("friday${i}").set({
            "subject": texteditingmonday[i].text,
            "staff": documents.docs[j]["staffname"],
            "order":i
          });
          for(int k=0;k<documentstecher.docs.length;k++){
            if(documents.docs[j]["staffid"]==documentstecher.docs[k]["regno"]){
              FirebaseFirestore.instance.collection("Staffs").doc(documentstecher.docs[k].id).collection("Timetable").doc("tuesday${i}").set({
                "subject": texteditingmonday[i].text,
                "class": _typeAheadControllerclass.text,
                "section": _typeAheadControllersection.text,
                "period":i,
                "day":"Friday",
              });
            }
          }
        }
      }
    }
    for(int i=40;i<48;i++) {
      for(int j=0;j<documents.docs.length;j++) {
        if (texteditingmonday[i].text == documents.docs[j]["name"]) {
          FirebaseFirestore.instance.collection("ClassTimeTable").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}")
              .collection("TimeTable").doc("saturday${i}").set({
            "subject": texteditingmonday[i].text,
            "staff": documents.docs[j]["staffname"],
            "order":i
          });
          for(int k=0;k<documentstecher.docs.length;k++){
            if(documents.docs[j]["staffid"]==documentstecher.docs[k]["regno"]){
              FirebaseFirestore.instance.collection("Staffs").doc(documentstecher.docs[k].id).collection("Timetable").doc("tuesday${i}").set({
                "subject": texteditingmonday[i].text,
                "class": _typeAheadControllerclass.text,
                "section": _typeAheadControllersection.text,
                "period":i,
                "day":"Saturday",
              });
            }
          }
        }
      }
    }
  }
  getstaffbyid() async {
    print("fdgggggggggg");

    var document = await FirebaseFirestore.instance.collection("ClassMaster").get();
    for(int i=0;i<document.docs.length;i++){
      if(_typeAheadControllerclass.text==document.docs[i]["name"]){
        setState(() {
          classid= document.docs[i].id;
        }
        );
      }
      print("Class id: ${classid}");
    }
    print("fdgggggggggg");


  }
  Successdialog(){
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/3.035555555555556,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Time Table Assigned Successfully',
      desc: '',


      btnOkOnPress: () {

      },
    )..show();
  }
  Successdialog2(){
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/3.035555555555556,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Time Table cannot have null values',
      desc: '',


      btnOkOnPress: () {

      },
    )..show();
  }
  @override
  void initState() {
    setState(() {
      _typeAheadControllerclass.text="Select Option";
      _typeAheadControllersection.text="Select Option";
      _typeAheadControllerday.text="Select Option";
    });
    firstcall();
    adddropvalue();
    // TODO: implement initState
    super.initState();
  }


  settimestable() async {
    var snap = await FirebaseFirestore.instance.collection("ClassTimeTable").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}").collection("TimeTable").orderBy("order").get();
    var value=snap.docs;
    setState(() {
      texteditingmonday[0].text=snap.docs.length<1?"":value[0]["staff"];
      texteditingmonday[1].text=snap.docs.length<2?"":value[1]["staff"];
      texteditingmonday[2].text=snap.docs.length<3?"":value[2]["staff"];
      texteditingmonday[3].text=snap.docs.length<4?"":value[3]["staff"];
      texteditingmonday[4].text=snap.docs.length<5?"":value[4]["staff"];
      texteditingmonday[5].text=snap.docs.length<6?"":value[5]["staff"];
      texteditingmonday[6].text=snap.docs.length<7?"":value[6]["staff"];
      texteditingmonday[7].text=snap.docs.length<8?"":value[7]["staff"];
      texteditingmonday[8].text=snap.docs.length<9?"":value[8]["staff"];
      texteditingmonday[9].text=snap.docs.length<10?"":value[9]["staff"];
      texteditingmonday[10].text=snap.docs.length<11?"":value[10]["staff"];
      texteditingmonday[11].text=snap.docs.length<12?"":value[11]["staff"];
      texteditingmonday[12].text=snap.docs.length<13?"":value[12]["staff"];
      texteditingmonday[13].text=snap.docs.length<14?"":value[13]["staff"];
      texteditingmonday[14].text=snap.docs.length<15?"":value[14]["staff"];
      texteditingmonday[15].text=snap.docs.length<16?"":value[15]["staff"];
      texteditingmonday[16].text=snap.docs.length<17?"":value[16]["staff"];
      texteditingmonday[17].text=snap.docs.length<18?"":value[17]["staff"];
      texteditingmonday[18].text=snap.docs.length<19?"":value[18]["staff"];
      texteditingmonday[19].text=snap.docs.length<20?"":value[19]["staff"];
      texteditingmonday[20].text=snap.docs.length<21?"":value[20]["staff"];
      texteditingmonday[21].text=snap.docs.length<22?"":value[21]["staff"];
      texteditingmonday[22].text=snap.docs.length<23?"":value[22]["staff"];
      texteditingmonday[23].text=snap.docs.length<24?"":value[23]["staff"];
      texteditingmonday[24].text=snap.docs.length<25?"":value[24]["staff"];
      texteditingmonday[25].text=snap.docs.length<26?"":value[25]["staff"];
      texteditingmonday[26].text=snap.docs.length<27?"":value[26]["staff"];
      texteditingmonday[27].text=snap.docs.length<28?"":value[27]["staff"];
      texteditingmonday[28].text=snap.docs.length<29?"":value[28]["staff"];
      texteditingmonday[29].text=snap.docs.length<30?"":value[29]["staff"];
      texteditingmonday[30].text=snap.docs.length<31?"":value[30]["staff"];
      texteditingmonday[31].text=snap.docs.length<32?"":value[31]["staff"];
      texteditingmonday[32].text=snap.docs.length<33?"":value[32]["staff"];
      texteditingmonday[33].text=snap.docs.length<34?"":value[33]["staff"];
      texteditingmonday[34].text=snap.docs.length<35?"":value[34]["staff"];
      texteditingmonday[35].text=snap.docs.length<36?"":value[35]["staff"];
      texteditingmonday[36].text=snap.docs.length<37?"":value[36]["staff"];
      texteditingmonday[37].text=snap.docs.length<38?"":value[37]["staff"];
      texteditingmonday[38].text=snap.docs.length<39?"":value[38]["staff"];
      texteditingmonday[39].text=snap.docs.length<40?"":value[39]["staff"];
      texteditingmonday[40].text=snap.docs.length<41?"":value[40]["staff"];
      texteditingmonday[41].text=snap.docs.length<42?"":value[41]["staff"];
      texteditingmonday[42].text=snap.docs.length<43?"":value[42]["staff"];
      texteditingmonday[43].text=snap.docs.length<44?"":value[43]["staff"];
      texteditingmonday[44].text=snap.docs.length<45?"":value[44]["staff"];
      texteditingmonday[45].text=snap.docs.length<46?"":value[45]["staff"];
      texteditingmonday[46].text=snap.docs.length<47?"":value[46]["staff"];
      texteditingmonday[47].text=snap.docs.length<48?"":value[47]["staff"];
    });

  }

  @override
  Widget build(BuildContext context) {
    final double width=MediaQuery.of(context).size.width;
    final double height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Container(child: Padding(
              padding: const EdgeInsets.only(left: 38.0,top: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Classwise Time Table",style: GoogleFonts.poppins(fontSize: width/75.888888889,fontWeight: FontWeight.bold),),
                  SizedBox(width: width/136.6),
                ],
              ),
            ),
              //color: Colors.white,
              width: width/1.050,
              height: height/8.212,
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20.0,top:20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0,top:20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: [
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.only(right:0.0),
                      //       child: Text("Class",style: GoogleFonts.poppins(fontSize: 15,)),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 0.0,right: 25),
                      //       child: Container(child:
                      //       DropdownButtonHideUnderline(
                      //         child: DropdownButton2<String>(
                      //           isExpanded: true,
                      //           hint:  Row(
                      //             children: [
                      //               Icon(
                      //                 Icons.list,
                      //                 size: 16,
                      //                 color: Colors.black,
                      //               ),
                      //               SizedBox(
                      //                 width: width/341.5,
                      //               ),
                      //               Expanded(
                      //                 child: Text(
                      //                   'Select Option',
                      //                   style: GoogleFonts.poppins(
                      //                       fontSize: 15
                      //                   ),
                      //                   overflow: TextOverflow.ellipsis,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           items: classes
                      //               .map((String item) => DropdownMenuItem<String>(
                      //             value: item,
                      //             child: Text(
                      //               item,
                      //               style:  GoogleFonts.poppins(
                      //                   fontSize: 15
                      //               ),
                      //               overflow: TextOverflow.ellipsis,
                      //             ),
                      //           ))
                      //               .toList(),
                      //           value:  _typeAheadControllerclass.text,
                      //           onChanged: (String? value) {
                      //             setState(() {
                      //               _typeAheadControllerclass.text = value!;
                      //             });
                      //             subjectdrop();
                      //             settimestable();
                      //           },
                      //           buttonStyleData: ButtonStyleData(
                      //             height:height/13.02,
                      //             width: width/8.5375,
                      //             padding: const EdgeInsets.only(left: 14, right: 14),
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(5),
                      //
                      //               color: Color(0xffDDDEEE),
                      //             ),
                      //
                      //           ),
                      //           iconStyleData: const IconStyleData(
                      //             icon: Icon(
                      //               Icons.arrow_forward_ios_outlined,
                      //             ),
                      //             iconSize: 14,
                      //             iconEnabledColor: Colors.black,
                      //             iconDisabledColor: Colors.grey,
                      //           ),
                      //           dropdownStyleData: DropdownStyleData(
                      //             maxHeight:height/3.255,
                      //             width: width/5.464,
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(14),
                      //               color: Color(0xffDDDEEE),
                      //             ),
                      //
                      //             scrollbarTheme: ScrollbarThemeData(
                      //               radius: const Radius.circular(7),
                      //               thickness: MaterialStateProperty.all<double>(6),
                      //               thumbVisibility: MaterialStateProperty.all<bool>(true),
                      //             ),
                      //           ),
                      //           menuItemStyleData: const MenuItemStyleData(
                      //             height:height/16.275,
                      //             padding: EdgeInsets.only(left: 14, right: 14),
                      //           ),
                      //         ),
                      //       ),
                      //         width: width/6.902,
                      //         height: height/16.42,
                      //         //color: Color(0xffDDDEEE),
                      //         decoration: BoxDecoration(color: Color(0xffDDDEEE),borderRadius: BorderRadius.circular(5)),
                      //
                      //       ),
                      //     ),
                      //
                      //   ],
                      //
                      // ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.only(right:0.0),
                      //       child: Text("Section",style: GoogleFonts.poppins(fontSize: 15,)),
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 0.0,right: 25),
                      //       child: Container(child:
                      //
                      //       DropdownButtonHideUnderline(
                      //         child: DropdownButton2<String>(
                      //           isExpanded: true,
                      //           hint:  Row(
                      //             children: [
                      //               Icon(
                      //                 Icons.list,
                      //                 size: 16,
                      //                 color: Colors.black,
                      //               ),
                      //               SizedBox(
                      //                 width: width/341.5,
                      //               ),
                      //               Expanded(
                      //                 child: Text(
                      //                   'Select Option',
                      //                   style: GoogleFonts.poppins(
                      //                       fontSize: 15
                      //                   ),
                      //                   overflow: TextOverflow.ellipsis,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           items: section
                      //               .map((String item) => DropdownMenuItem<String>(
                      //             value: item,
                      //             child: Text(
                      //               item,
                      //               style:  GoogleFonts.poppins(
                      //                   fontSize: 15
                      //               ),
                      //               overflow: TextOverflow.ellipsis,
                      //             ),
                      //           ))
                      //               .toList(),
                      //           value:  _typeAheadControllersection.text,
                      //           onChanged: (String? value) {
                      //             setState(() {
                      //               _typeAheadControllersection.text = value!;
                      //             });
                      //             subjectdrop();
                      //             settimestable();
                      //           },
                      //           buttonStyleData: ButtonStyleData(
                      //             height:height/13.02,
                      //             width: width/8.5375,
                      //             padding: const EdgeInsets.only(left: 14, right: 14),
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(5),
                      //
                      //               color: Color(0xffDDDEEE),
                      //             ),
                      //
                      //           ),
                      //           iconStyleData: const IconStyleData(
                      //             icon: Icon(
                      //               Icons.arrow_forward_ios_outlined,
                      //             ),
                      //             iconSize: 14,
                      //             iconEnabledColor: Colors.black,
                      //             iconDisabledColor: Colors.grey,
                      //           ),
                      //           dropdownStyleData: DropdownStyleData(
                      //             maxHeight:height/3.255,
                      //             width: width/5.464,
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(14),
                      //               color: Color(0xffDDDEEE),
                      //             ),
                      //
                      //             scrollbarTheme: ScrollbarThemeData(
                      //               radius: const Radius.circular(7),
                      //               thickness: MaterialStateProperty.all<double>(6),
                      //               thumbVisibility: MaterialStateProperty.all<bool>(true),
                      //             ),
                      //           ),
                      //           menuItemStyleData: const MenuItemStyleData(
                      //             height:height/16.275,
                      //             padding: EdgeInsets.only(left: 14, right: 14),
                      //           ),
                      //         ),
                      //       ),
                      //         width: width/6.83,
                      //         height: height/16.42,
                      //         //color: Color(0xffDDDEEE),
                      //         decoration: BoxDecoration(color: Color(0xffDDDEEE),borderRadius: BorderRadius.circular(5)),
                      //
                      //       ),
                      //     ),
                      //
                      //   ],
                      //
                      // ),
                      // GestureDetector(
                      //   onTap: (){
                      //     int count =0;
                      //     setState(() {
                      //       count=0;
                      //     });
                      //     for(int i=0;i<47;i++) {
                      //       if(texteditingmonday[i].text==""){
                      //         setState(() {
                      //           count=count+1;
                      //         });
                      //       }
                      //
                      //     }
                      //     if(count==0) {
                      //       addtimetable();
                      //       Successdialog();
                      //     }
                      //     else{
                      //       Successdialog2();
                      //     }
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(right: 25.0),
                      //     child: Container(child: Center(child: Text("Save",style: GoogleFonts.poppins(color:Colors.white),)),
                      //       width: width/10.507,
                      //       height: height/16.425,
                      //       // color:Color(0xff00A0E3),
                      //       decoration: BoxDecoration(color: Color(0xff00A0E3),borderRadius: BorderRadius.circular(5)),
                      //
                      //     ),
                      //   ),
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right:0.0),
                            child: Text("Select Day",style: GoogleFonts.poppins(fontSize: 15,)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0,right: 25),
                            child: Container(child:

                            DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint:  Row(
                                  children: [
                                    Icon(
                                      Icons.list,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: width/341.5,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Select Option',
                                        style: GoogleFonts.poppins(
                                            fontSize: 15
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: daysOfWeek
                                    .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style:  GoogleFonts.poppins(
                                        fontSize: 15
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                                    .toList(),
                                value:  _typeAheadControllerday.text,
                                onChanged: (String? value) {
                                  setState(() {
                                    _typeAheadControllerday.text = value!;
                                  });
                                  getClassWiseTimeTable(_typeAheadControllerday.text);
                                  // subjectdrop();
                                  // settimestable();
                                },
                                buttonStyleData: ButtonStyleData(
                                  height:height/13.02,
                                  width: width/8.5375,
                                  padding: const EdgeInsets.only(left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),

                                    color: Color(0xffDDDEEE),
                                  ),

                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  iconSize: 14,
                                  iconEnabledColor: Colors.black,
                                  iconDisabledColor: Colors.grey,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight:height/3.255,
                                  width: width/5.464,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Color(0xffDDDEEE),
                                  ),

                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(7),
                                    thickness: MaterialStateProperty.all<double>(6),
                                    thumbVisibility: MaterialStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: MenuItemStyleData(
                                  height:height/16.275,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                              width: width/6.83,
                              height: height/16.42,
                              //color: Color(0xffDDDEEE),
                              decoration: BoxDecoration(color: Color(0xffDDDEEE),borderRadius: BorderRadius.circular(5)),

                            ),
                          ),

                        ],

                      ),
                      InkWell(
                        onTap: (){
                          printTimeTable();
                          //getvalue();
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(5),
                          elevation: 7,
                          child: Container(child: Center(
                            child:

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right:8.0),
                                  child: Icon(Icons.print,color:Colors.white),
                                ),
                                Text("Print Table",style: GoogleFonts.poppins(color:Colors.white),),
                              ],
                            ),
                          ),
                            width: width/6.507,
                            height: height/16.425,
                            // color:Color(0xff00A0E3),
                            decoration: BoxDecoration(color: const Color(0xff53B175),borderRadius: BorderRadius.circular(5)),

                          ),
                        ),
                      ),


                    ],
                  ),
                ),
                SizedBox(height:height/65.1,),
                Row(
                  children: [
                    Container(
                      height:height/16.275,
                      width: width/9.106666666666667,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                      ),
                      child: Center(child: Text("Day/Period",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w600),)),
                    ),
                    Container(
                      height:height/16.275,
                      width: width/13.66,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                      ),
                      child: Center(child: Text("Period -01",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w600),)),
                    ),
                    Container(
                      height:height/16.275,
                      width: width/13.66,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                      ),
                      child: Center(child: Text("Period -02",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w600),)),
                    ),
                    Container(
                      height:height/16.275,
                      width: width/13.66,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                      ),
                      child: Center(child: Text("Period -03",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w600),)),
                    ),
                    Container(
                      height:height/16.275,
                      width: width/13.66,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                      ),
                      child: Center(child: Text("Period -04",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w600),)),
                    ),
                    Container(
                      height:height/16.275,
                      width: width/13.66,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                      ),
                      child: Center(child: Text("Period -05",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w600),)),
                    ),
                    Container(
                      height:height/16.275,
                      width: width/13.66,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                      ),
                      child: Center(child: Text("Period -06",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w600),)),
                    ),
                    Container(
                      height:height/16.275,
                      width: width/13.66,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                      ),
                      child: Center(child: Text("Period -07",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w600),)),
                    ),
                    Container(
                      height:height/16.275,
                      width: width/13.66,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                      ),
                      child: Center(child: Text("Period -08",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w600),)),
                    ),
                  ],
                ),
                Container(
                  height:height/1.631578947368421,
                  child: FutureBuilder<List<ClassWiseTimeTableModel>>(
                    future: getClassWiseTimeTable(_typeAheadControllerday.text),
                    builder: (ctx, snap){
                      if(snap.hasData){
                        return ListView.builder(
                          itemCount: snap.data!.length,
                          itemBuilder: (ctx, i){
                            ClassWiseTimeTableModel timeTable = snap.data![i];
                           return Row(
                              children: [
                                Container(
                                  height:height/16.275,
                                  width: width/9.106666666666667,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)
                                  ),
                                  child: Center(child: Text(timeTable.staffName,
                                    style: GoogleFonts.poppins(
                                        fontSize: 15, fontWeight: FontWeight.w600),)),
                                ),
                                Container(
                                  height:height/16.275,
                                  width: width/13.66,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)
                                  ),
                                  child: Center(
                                    child: Text(
                                      timeTable.firstPeriod,
                                      style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: timeTable.firstPeriod == 'Free' ? Colors.green : Colors.black,
                                      ),
                                    ),
                                  )
                                ),
                                Container(
                                    height:height/16.275,
                                    width: width/13.66,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black)
                                    ),
                                    child: Center(
                                      child: Text(
                                        timeTable.secondPeriod,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: timeTable.secondPeriod == 'Free' ? Colors.green : Colors.black,
                                        ),
                                      ),
                                    )
                                ),
                                Container(
                                    height:height/16.275,
                                    width: width/13.66,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black)
                                    ),
                                    child: Center(
                                      child: Text(
                                        timeTable.thirdPeriod,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: timeTable.thirdPeriod == 'Free' ? Colors.green : Colors.black,
                                        ),
                                      ),
                                    )
                                ),
                                Container(
                                    height:height/16.275,
                                    width: width/13.66,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black)
                                    ),
                                    child: Center(
                                      child: Text(
                                        timeTable.fourthPeriod,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: timeTable.fourthPeriod == 'Free' ? Colors.green : Colors.black,
                                        ),
                                      ),
                                    )
                                ),
                                Container(
                                    height:height/16.275,
                                    width: width/13.66,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black)
                                    ),
                                    child: Center(
                                      child: Text(
                                        timeTable.fifthPeriod,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: timeTable.fifthPeriod == 'Free' ? Colors.green : Colors.black,
                                        ),
                                      ),
                                    )
                                ),
                                Container(
                                    height:height/16.275,
                                    width: width/13.66,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black)
                                    ),
                                    child: Center(
                                      child: Text(
                                        timeTable.sixthPeriod,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: timeTable.sixthPeriod == 'Free' ? Colors.green : Colors.black,
                                        ),
                                      ),
                                    )
                                ),
                                Container(
                                    height:height/16.275,
                                    width: width/13.66,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black)
                                    ),
                                    child: Center(
                                      child: Text(
                                        timeTable.seventhPeriod,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: timeTable.seventhPeriod == 'Free' ? Colors.green : Colors.black,
                                        ),
                                      ),
                                    )
                                ),
                                Container(
                                    height:height/16.275,
                                    width: width/13.66,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black)
                                    ),
                                    child: Center(
                                      child: Text(
                                        timeTable.eighthPeriod,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: timeTable.eighthPeriod == 'Free' ? Colors.green : Colors.black,
                                        ),
                                      ),
                                    )
                                ),
                                // Container(
                                //   height:height/16.275,
                                //   width: width/13.66,
                                //   decoration: BoxDecoration(
                                //       border: Border.all(color: Colors.black)
                                //   ),
                                //   child: TypeAheadFormField(
                                //     suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                //         color: Color(0xffDDDEEE),
                                //         borderRadius: BorderRadius.only(
                                //           bottomLeft: Radius.circular(5),
                                //           bottomRight: Radius.circular(5),
                                //         )
                                //     ),
                                //     textFieldConfiguration: TextFieldConfiguration(
                                //       style: GoogleFonts.poppins(
                                //           fontSize: 15
                                //       ),
                                //       decoration: InputDecoration(
                                //         hintText: timeTable.secondPeriod,
                                //         hintStyle: GoogleFonts.poppins(
                                //           fontSize: 15,
                                //           color: timeTable.secondPeriod == 'Free' ? Colors.green : Colors.black,
                                //         ),
                                //         contentPadding: EdgeInsets.only(
                                //             left: 10, bottom: 8),
                                //         border: InputBorder.none,
                                //       ),
                                //       controller: this.texteditingmonday[1],
                                //     ),
                                //     suggestionsCallback: (pattern) {
                                //       return getSuggestionsubject(pattern);
                                //     },
                                //     itemBuilder: (context, String suggestion) {
                                //       return ListTile(
                                //         title: Text(suggestion),
                                //       );
                                //     },
                                //
                                //     transitionBuilder: (context, suggestionsBox,
                                //         controller) {
                                //       return suggestionsBox;
                                //     },
                                //     onSuggestionSelected: (String suggestion) {
                                //       this.texteditingmonday[1].text = suggestion;
                                //
                                //     },
                                //     suggestionsBoxController: suggestionBoxController,
                                //     validator: (value) =>
                                //     value!.isEmpty ? 'Please select a section' : null,
                                //
                                //   ),
                                // ),
                                // Container(
                                //   height:height/16.275,
                                //   width: width/13.66,
                                //   decoration: BoxDecoration(
                                //       border: Border.all(color: Colors.black)
                                //   ),
                                //   child: TypeAheadFormField(
                                //
                                //
                                //     suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                //         color: Color(0xffDDDEEE),
                                //         borderRadius: BorderRadius.only(
                                //           bottomLeft: Radius.circular(5),
                                //           bottomRight: Radius.circular(5),
                                //         )
                                //     ),
                                //
                                //     textFieldConfiguration: TextFieldConfiguration(
                                //       style: GoogleFonts.poppins(
                                //           fontSize: 15
                                //       ),
                                //       decoration: InputDecoration(
                                //         hintText: timeTable.thirdPeriod,
                                //         hintStyle: GoogleFonts.poppins(
                                //           fontSize: 15,
                                //           color: timeTable.thirdPeriod == 'Free' ? Colors.green : Colors.black,
                                //         ),
                                //         contentPadding: EdgeInsets.only(
                                //             left: 10, bottom: 8),
                                //         border: InputBorder.none,
                                //       ),
                                //       controller: this.texteditingmonday[2],
                                //     ),
                                //     suggestionsCallback: (pattern) {
                                //       return getSuggestionsubject(pattern);
                                //     },
                                //     itemBuilder: (context, String suggestion) {
                                //       return ListTile(
                                //         title: Text(suggestion),
                                //       );
                                //     },
                                //
                                //     transitionBuilder: (context, suggestionsBox,
                                //         controller) {
                                //       return suggestionsBox;
                                //     },
                                //     onSuggestionSelected: (String suggestion) {
                                //       this.texteditingmonday[2].text = suggestion;
                                //
                                //     },
                                //     suggestionsBoxController: suggestionBoxController,
                                //     validator: (value) =>
                                //     value!.isEmpty ? 'Please select a section' : null,
                                //
                                //   ),
                                // ),
                                // Container(
                                //   height:height/16.275,
                                //   width: width/13.66,
                                //   decoration: BoxDecoration(
                                //       border: Border.all(color: Colors.black)
                                //   ),
                                //   child: TypeAheadFormField(
                                //
                                //
                                //     suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                //         color: Color(0xffDDDEEE),
                                //         borderRadius: BorderRadius.only(
                                //           bottomLeft: Radius.circular(5),
                                //           bottomRight: Radius.circular(5),
                                //         )
                                //     ),
                                //
                                //     textFieldConfiguration: TextFieldConfiguration(
                                //       style: GoogleFonts.poppins(
                                //           fontSize: 15
                                //       ),
                                //       decoration: InputDecoration(
                                //         hintText: timeTable.fourthPeriod,
                                //         hintStyle: GoogleFonts.poppins(
                                //           fontSize: 15,
                                //           color: timeTable.fourthPeriod == 'Free' ? Colors.green : Colors.black,
                                //         ),
                                //         contentPadding: EdgeInsets.only(
                                //             left: 10, bottom: 8),
                                //         border: InputBorder.none,
                                //       ),
                                //       controller: this.texteditingmonday[3],
                                //     ),
                                //     suggestionsCallback: (pattern) {
                                //       return getSuggestionsubject(pattern);
                                //     },
                                //     itemBuilder: (context, String suggestion) {
                                //       return ListTile(
                                //         title: Text(suggestion),
                                //       );
                                //     },
                                //
                                //     transitionBuilder: (context, suggestionsBox,
                                //         controller) {
                                //       return suggestionsBox;
                                //     },
                                //     onSuggestionSelected: (String suggestion) {
                                //       this.texteditingmonday[3].text = suggestion;
                                //
                                //     },
                                //     suggestionsBoxController: suggestionBoxController,
                                //     validator: (value) =>
                                //     value!.isEmpty ? 'Please select a section' : null,
                                //
                                //   ),
                                // ),
                                // Container(
                                //   height:height/16.275,
                                //   width: width/13.66,
                                //   decoration: BoxDecoration(
                                //       border: Border.all(color: Colors.black)
                                //   ),
                                //   child: TypeAheadFormField(
                                //
                                //
                                //     suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                //         color: Color(0xffDDDEEE),
                                //         borderRadius: BorderRadius.only(
                                //           bottomLeft: Radius.circular(5),
                                //           bottomRight: Radius.circular(5),
                                //         )
                                //     ),
                                //
                                //     textFieldConfiguration: TextFieldConfiguration(
                                //       style: GoogleFonts.poppins(
                                //           fontSize: 15
                                //       ),
                                //       decoration: InputDecoration(
                                //         hintText: timeTable.fifthPeriod,
                                //         hintStyle: GoogleFonts.poppins(
                                //           fontSize: 15,
                                //           color: timeTable.fifthPeriod == 'Free' ? Colors.green : Colors.black,
                                //         ),
                                //         contentPadding: EdgeInsets.only(
                                //             left: 10, bottom: 8),
                                //         border: InputBorder.none,
                                //       ),
                                //       controller: this.texteditingmonday[4],
                                //     ),
                                //     suggestionsCallback: (pattern) {
                                //       return getSuggestionsubject(pattern);
                                //     },
                                //     itemBuilder: (context, String suggestion) {
                                //       return ListTile(
                                //         title: Text(suggestion),
                                //       );
                                //     },
                                //
                                //     transitionBuilder: (context, suggestionsBox,
                                //         controller) {
                                //       return suggestionsBox;
                                //     },
                                //     onSuggestionSelected: (String suggestion) {
                                //       this.texteditingmonday[4].text = suggestion;
                                //
                                //     },
                                //     suggestionsBoxController: suggestionBoxController,
                                //     validator: (value) =>
                                //     value!.isEmpty ? 'Please select a section' : null,
                                //
                                //   ),
                                // ),
                                // Container(
                                //   height:height/16.275,
                                //   width: width/13.66,
                                //   decoration: BoxDecoration(
                                //       border: Border.all(color: Colors.black)
                                //   ),
                                //   child: TypeAheadFormField(
                                //
                                //
                                //     suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                //         color: Color(0xffDDDEEE),
                                //         borderRadius: BorderRadius.only(
                                //           bottomLeft: Radius.circular(5),
                                //           bottomRight: Radius.circular(5),
                                //         )
                                //     ),
                                //
                                //     textFieldConfiguration: TextFieldConfiguration(
                                //       style: GoogleFonts.poppins(
                                //           fontSize: 15
                                //       ),
                                //       decoration: InputDecoration(
                                //         hintText: timeTable.sixthPeriod,
                                //         hintStyle: GoogleFonts.poppins(
                                //           fontSize: 15,
                                //           color: timeTable.sixthPeriod == 'Free' ? Colors.green : Colors.black,
                                //         ),
                                //         contentPadding: EdgeInsets.only(
                                //             left: 10, bottom: 8),
                                //         border: InputBorder.none,
                                //       ),
                                //       controller: this.texteditingmonday[5],
                                //     ),
                                //     suggestionsCallback: (pattern) {
                                //       return getSuggestionsubject(pattern);
                                //     },
                                //     itemBuilder: (context, String suggestion) {
                                //       return ListTile(
                                //         title: Text(suggestion),
                                //       );
                                //     },
                                //
                                //     transitionBuilder: (context, suggestionsBox,
                                //         controller) {
                                //       return suggestionsBox;
                                //     },
                                //     onSuggestionSelected: (String suggestion) {
                                //       this.texteditingmonday[5].text = suggestion;
                                //
                                //     },
                                //     suggestionsBoxController: suggestionBoxController,
                                //     validator: (value) =>
                                //     value!.isEmpty ? 'Please select a section' : null,
                                //
                                //   ),
                                // ),
                                // Container(
                                //   height:height/16.275,
                                //   width: width/13.66,
                                //   decoration: BoxDecoration(
                                //       border: Border.all(color: Colors.black)
                                //   ),
                                //   child: TypeAheadFormField(
                                //
                                //
                                //     suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                //         color: Color(0xffDDDEEE),
                                //         borderRadius: BorderRadius.only(
                                //           bottomLeft: Radius.circular(5),
                                //           bottomRight: Radius.circular(5),
                                //         )
                                //     ),
                                //
                                //     textFieldConfiguration: TextFieldConfiguration(
                                //       style: GoogleFonts.poppins(
                                //           fontSize: 15
                                //       ),
                                //       decoration: InputDecoration(
                                //         hintText: timeTable.seventhPeriod,
                                //         hintStyle: GoogleFonts.poppins(
                                //           fontSize: 15,
                                //           color: timeTable.seventhPeriod == 'Free' ? Colors.green : Colors.black,
                                //         ),
                                //         contentPadding: EdgeInsets.only(
                                //             left: 10, bottom: 8),
                                //         border: InputBorder.none,
                                //       ),
                                //       controller: this.texteditingmonday[6],
                                //     ),
                                //     suggestionsCallback: (pattern) {
                                //       return getSuggestionsubject(pattern);
                                //     },
                                //     itemBuilder: (context, String suggestion) {
                                //       return ListTile(
                                //         title: Text(suggestion),
                                //       );
                                //     },
                                //
                                //     transitionBuilder: (context, suggestionsBox,
                                //         controller) {
                                //       return suggestionsBox;
                                //     },
                                //     onSuggestionSelected: (String suggestion) {
                                //       this.texteditingmonday[6].text = suggestion;
                                //
                                //     },
                                //     suggestionsBoxController: suggestionBoxController,
                                //     validator: (value) =>
                                //     value!.isEmpty ? 'Please select a section' : null,
                                //
                                //   ),
                                // ),
                                // Container(
                                //   height:height/16.275,
                                //   width: width/13.66,
                                //   decoration: BoxDecoration(
                                //       border: Border.all(color: Colors.black)
                                //   ),
                                //   child: TypeAheadFormField(
                                //
                                //
                                //     suggestionsBoxDecoration: SuggestionsBoxDecoration(
                                //         color: Color(0xffDDDEEE),
                                //         borderRadius: BorderRadius.only(
                                //           bottomLeft: Radius.circular(5),
                                //           bottomRight: Radius.circular(5),
                                //         )
                                //     ),
                                //
                                //     textFieldConfiguration: TextFieldConfiguration(
                                //       style: GoogleFonts.poppins(
                                //           fontSize: 15
                                //       ),
                                //       decoration: InputDecoration(
                                //         hintText: timeTable.eighthPeriod,
                                //         hintStyle: GoogleFonts.poppins(
                                //           fontSize: 15,
                                //           color: timeTable.eighthPeriod == 'Free' ? Colors.green : Colors.black,
                                //         ),
                                //         contentPadding: EdgeInsets.only(
                                //             left: 10, bottom: 8),
                                //         border: InputBorder.none,
                                //       ),
                                //       controller: this.texteditingmonday[7],
                                //     ),
                                //     suggestionsCallback: (pattern) {
                                //       return getSuggestionsubject(pattern);
                                //     },
                                //     itemBuilder: (context, String suggestion) {
                                //       return ListTile(
                                //         title: Text(suggestion),
                                //       );
                                //     },
                                //
                                //     transitionBuilder: (context, suggestionsBox,
                                //         controller) {
                                //       return suggestionsBox;
                                //     },
                                //     onSuggestionSelected: (String suggestion) {
                                //       this.texteditingmonday[7].text = suggestion;
                                //
                                //     },
                                //     suggestionsBoxController: suggestionBoxController,
                                //     validator: (value) =>
                                //     value!.isEmpty ? 'Please select a section' : null,
                                //
                                //   ),
                                // ),
                              ],
                            );
                          },
                        );
                      }return Container();
                    },
                  ),
                )
                // StreamBuilder(
                //     stream:            FirebaseFirestore.instance.collection("ClassTimeTable").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}").collection("TimeTable").orderBy("order").snapshots(),
                //     builder:(context,snap) {
                //       var value = snap.data!.docs;
                //       return Row(
                //         children: [
                //           Container(
                //             height:height/16.275,
                //             width: width/9.106666666666667,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: Center(child: Text("Monday",
                //               style: GoogleFonts.poppins(
                //                   fontSize: 15, fontWeight: FontWeight.w600),)),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //
                //                 decoration: InputDecoration(
                //
                //                   hintText: snap.data!.docs.length<1?"":value[0]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[0],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[0].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<2?"":value[1]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[1],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[1].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<3?"":value[2]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[2],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[2].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<4?"":value[3]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[3],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[3].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<5?"":value[4]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[4],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[4].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<6?"":value[5]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[5],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[5].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<7?"":value[6]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[6],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[6].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<8?"":value[7]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[7],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[7].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //         ],
                //       );
                //
                //     }
                // ),
                // StreamBuilder(
                //     stream:  FirebaseFirestore.instance.collection("ClassTimeTable").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}").collection("TimeTable").orderBy("order").snapshots(),
                //     builder:(context,snap) {
                //       var value = snap.data!.docs;
                //       return Row(
                //         children: [
                //           Container(
                //             height:height/16.275,
                //             width: width/9.106666666666667,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: Center(child: Text("Tuesday",
                //               style: GoogleFonts.poppins(
                //                   fontSize: 15, fontWeight: FontWeight.w600),)),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<9?"":value[8]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[8],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[8].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<10?"":value[9]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[9],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[9].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<11?"":value[10]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[10],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[10].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<12?"":value[11]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[11],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[11].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<13?"":value[12]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[12],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[12].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<14?"":value[13]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[13],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[13].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<15?"":value[14]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[14],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[14].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<16?"":value[15]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[15],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[15].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //         ],
                //       );
                //
                //     }
                // ),
                // StreamBuilder(
                //     stream:  FirebaseFirestore.instance.collection("ClassTimeTable").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}").collection("TimeTable").orderBy("order").snapshots(),
                //     builder:(context,snap) {
                //       var value = snap.data!.docs;
                //       return Row(
                //         children: [
                //           Container(
                //             height:height/16.275,
                //             width: width/9.106666666666667,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: Center(child: Text("Wednesday",
                //               style: GoogleFonts.poppins(
                //                   fontSize: 15, fontWeight: FontWeight.w600),)),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<17?"":value[16]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[16],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[16].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<18?"":value[17]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[17],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[17].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<19?"":value[18]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[18],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[18].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<20?"":value[19]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[19],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[19].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<21?"":value[20]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[20],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[20].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<22?"":value[21]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[21],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[21].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<23?"":value[22]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[22],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[22].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<24?"":value[23]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[23],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[23].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //         ],
                //       );
                //
                //     }
                // ),
                // StreamBuilder(
                //     stream:  FirebaseFirestore.instance.collection("ClassTimeTable").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}").collection("TimeTable").orderBy("order").snapshots(),
                //     builder:(context,snap) {
                //       var value = snap.data!.docs;
                //       return Row(
                //         children: [
                //           Container(
                //             height:height/16.275,
                //             width: width/9.106666666666667,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: Center(child: Text("Thursday",
                //               style: GoogleFonts.poppins(
                //                   fontSize: 15, fontWeight: FontWeight.w600),)),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<25?"":value[24]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[24],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[24].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<26?"":value[25]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[25],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[25].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<27?"":value[26]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[26],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[26].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<28?"":value[27]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[27],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[27].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<29?"":value[28]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[28],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[28].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<30?"":value[29]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[29],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[29].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<31?"":value[30]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[30],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[30].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<32?"":value[31]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[31],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[31].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //         ],
                //       );
                //
                //     }
                // ),
                // StreamBuilder(
                //     stream:  FirebaseFirestore.instance.collection("ClassTimeTable").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}").collection("TimeTable").orderBy("order").snapshots(),
                //     builder:(context,snap) {
                //       var value = snap.data!.docs;
                //       return Row(
                //         children: [
                //           Container(
                //             height:height/16.275,
                //             width: width/9.106666666666667,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: Center(child: Text("Friday",
                //               style: GoogleFonts.poppins(
                //                   fontSize: 15, fontWeight: FontWeight.w600),)),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<33?"":value[32]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[32],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[32].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<34?"":value[33]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[33],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[33].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<35?"":value[34]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[34],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[34].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<36?"":value[35]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[35],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[35].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<37?"":value[36]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[36],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[36].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<38?"":value[37]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[37],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[37].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<39?"":value[38]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[38],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[38].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<40?"":value[39]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[39],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[39].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //         ],
                //       );
                //
                //     }
                // ),
                // StreamBuilder(
                //     stream:  FirebaseFirestore.instance.collection("ClassTimeTable").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}").collection("TimeTable").orderBy("order").snapshots(),
                //     builder:(context,snap) {
                //       var value = snap.data!.docs;
                //       return Row(
                //         children: [
                //           Container(
                //             height:height/16.275,
                //             width: width/9.106666666666667,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: Center(child: Text("Saturday",
                //               style: GoogleFonts.poppins(
                //                   fontSize: 15, fontWeight: FontWeight.w600),)),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<41?"":value[40]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[40],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[40].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<42?"":value[41]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[41],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[41].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<43?"":value[42]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[42],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[42].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<44?"":value[43]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[43],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[43].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<45?"":value[44]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[44],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[44].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<46?"":value[45]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[45],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[45].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<47?"":value[46]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[46],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[46].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //           Container(
                //             height:height/16.275,
                //             width: width/13.66,
                //             decoration: BoxDecoration(
                //                 border: Border.all(color: Colors.black)
                //             ),
                //             child: TypeAheadFormField(
                //
                //
                //               suggestionsBoxDecoration: SuggestionsBoxDecoration(
                //                   color: Color(0xffDDDEEE),
                //                   borderRadius: BorderRadius.only(
                //                     bottomLeft: Radius.circular(5),
                //                     bottomRight: Radius.circular(5),
                //                   )
                //               ),
                //
                //               textFieldConfiguration: TextFieldConfiguration(
                //                 style: GoogleFonts.poppins(
                //                     fontSize: 15
                //                 ),
                //                 decoration: InputDecoration(
                //                   hintText: snap.data!.docs.length<48?"":value[47]["subject"],
                //                   contentPadding: EdgeInsets.only(
                //                       left: 10, bottom: 8),
                //                   border: InputBorder.none,
                //                 ),
                //                 controller: this.texteditingmonday[47],
                //               ),
                //               suggestionsCallback: (pattern) {
                //                 return getSuggestionsubject(pattern);
                //               },
                //               itemBuilder: (context, String suggestion) {
                //                 return ListTile(
                //                   title: Text(suggestion),
                //                 );
                //               },
                //
                //               transitionBuilder: (context, suggestionsBox,
                //                   controller) {
                //                 return suggestionsBox;
                //               },
                //               onSuggestionSelected: (String suggestion) {
                //                 this.texteditingmonday[47].text = suggestion;
                //
                //               },
                //               suggestionsBoxController: suggestionBoxController,
                //               validator: (value) =>
                //               value!.isEmpty ? 'Please select a section' : null,
                //
                //             ),
                //           ),
                //         ],
                //       );
                //
                //     }
                // ),

              ],
            ),
          )

        ],
      ),
    );
  }

  printTimeTable() async {
    List<ClassWiseTimeTableModel> timetables = await getClassWiseTimeTable(_typeAheadControllerday.text);
    generateClassWiseTimeTablePdf(PdfPageFormat.a4,timetables);
  }


  Future<List<ClassWiseTimeTableModel>> getClassWiseTimeTable(String today) async {
    List<ClassWiseTimeTableModel> timetable = [];
    int multiplier = 0;
    switch(today){
      case "Monday":
        multiplier = 0;
        break;
      case "Tuesday":
        multiplier = 1;
        break;
      case "Wednesday":
        multiplier = 2;
        break;
      case "Thursday":
        multiplier = 3;
        break;
      case "Friday":
        multiplier = 4;
        break;
      case "Saturday":
        multiplier = 5;
        break;
    }
    var staffs = await FirebaseFirestore.instance.collection('Staffs').orderBy("regno").get();
    for(int s = 0; s < staffs.docs.length; s ++){
      ClassWiseTimeTableModel classTimeTable = ClassWiseTimeTableModel(
        staffName: staffs.docs[s].get("stname"),
        firstPeriod: 'Free',
        secondPeriod: "Free",
        thirdPeriod: "Free",
        fourthPeriod: "Free",
        fifthPeriod: "Free",
        sixthPeriod: "Free",
        seventhPeriod: "Free",
        eighthPeriod: "Free",
      );
      var staffTimetable = await FirebaseFirestore.instance.collection('Staffs').doc(staffs.docs[s].id).collection('Timetable').where("day", isEqualTo: today).get();
      try{
        classTimeTable.firstPeriod = staffTimetable.docs.where((element) => element.get("period") == (multiplier * 8) + 0).first.get("class") +" - "+staffTimetable.docs.where((element) => element.get("period") == (multiplier * 8) + 0).first.get("section");
      }catch(e){
        print(e);
      }
      try{
        classTimeTable.secondPeriod = staffTimetable.docs.where((element) => element.get("period") == (multiplier * 8) + 1).first.get("class") +" - "+staffTimetable.docs.where((element) => element.get("period") == (multiplier * 8) + 1).first.get("section");
      }catch(e){
        print(e);
      }
      try{
        classTimeTable.thirdPeriod = staffTimetable.docs.where((element) => element.get("period") == (multiplier * 8) + 2).first.get("class") +" - "+staffTimetable.docs.where((element) => element.get("period") == (multiplier * 8) + 2).first.get("section");
      }catch(e){
        print(e);
      }
      try{
        classTimeTable.fourthPeriod = staffTimetable.docs.where((element) => element.get("period") == (multiplier * 8) + 3).first.get("class") +" - "+staffTimetable.docs.where((element) => element.get("period") == (multiplier * 8) + 3).first.get("section");
      }catch(e){
        print(e);
      }
      try{
        classTimeTable.fifthPeriod = staffTimetable.docs.where((element) => element.get("period") == (multiplier * 8) + 4).first.get("class") +" - "+staffTimetable.docs.where((element) => element.get("period") == (multiplier * 8) + 4).first.get("section");
      }catch(e){
        print(e);
      }
      try{
       classTimeTable.sixthPeriod = staffTimetable.docs.where((element) => element.get("period") == (multiplier * 8) + 5).first.get("class") +" - "+staffTimetable.docs.where((element) => element.get("period") == (multiplier * 8) + 5).first.get("section");
      }catch(e){
        print(e);
      }
      try{
        classTimeTable.seventhPeriod = staffTimetable.docs.where((element) => element.get("period") == (multiplier * 8) + 6).first.get("class") +" - "+staffTimetable.docs.where((element) => element.get("period") == (multiplier * 8) + 6).first.get("section");
      }catch(e){
        print(e);
      }
      try{
        classTimeTable.eighthPeriod = staffTimetable.docs.where((element) => element.get("period") == (multiplier * 8) + 7).first.get("class") +" - "+staffTimetable.docs.where((element) => element.get("period") == (multiplier * 8) + 7).first.get("section");
      }catch(e){
        print(e);
      }
      timetable.add(classTimeTable);
    }
    return timetable;
  }



  getvalue() async {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;


    List<p.Widget> widgets = [];
    //container for profile image decoration
    final container = p.Center(
      child: p.Container(
          child: p.Padding(
            padding: p.EdgeInsets.only(top: 5),
            child: p.Row(mainAxisAlignment: p.MainAxisAlignment.start, children: [
              p.Container(
                  width: 60,
                  child: p.Center(
                    child: p.Text("Si.No".toString(),
                        style: p.TextStyle(color: PdfColors.black)),
                  )),
              p.SizedBox(width: width / 273.2),
              p.Container(
                  width: 80,
                  child: p.Center(
                    child: p.Text("Descriptions".toString(),
                        style: p.TextStyle(color: PdfColors.black)),
                  )),
              p.SizedBox(width: width / 273.2),

              p.SizedBox(width: width / 273.2),

              p.SizedBox(width: 200),
              p.Container(
                  width: 60,
                  child: p.Center(
                    child: p.Text("Rate".toString(),
                        style: p.TextStyle(color: PdfColors.black)),
                  )),
              p.SizedBox(width: width / 273.2),

              p.SizedBox(width: width / 273.2),
              p.Container(
                  width: 60,
                  child: p.Center(
                    child: p.Text("Total".toString(),
                        style: p.TextStyle(color: PdfColors.black)),
                  ))
            ]),
          )),
    );
    final container2 = p.Center(
      child: p.Container(
          child: p.Padding(
            padding: p.EdgeInsets.only(top: 5),
            child: p.Row(mainAxisAlignment: p.MainAxisAlignment.start, children: [
              p.Container(
                  width: 60,
                  child: p.Center(
                    child: p.Text("001".toString(),
                        style: p.TextStyle(color: PdfColors.black)),
                  )),
              p.SizedBox(width: width / 273.2),
              p.Container(
                  width: 80,
                  child: p.Center(
                    child: p.Text("First Mid Term Fees".toString(),
                        style: p.TextStyle(color: PdfColors.black)),
                  )),
              p.SizedBox(width: width / 273.2),

              p.SizedBox(width: width / 273.2),

              p.SizedBox(width: 200),
              p.Container(
                  width: 60,
                  child: p.Center(
                    child: p.Text("15000".toString(),
                        style: p.TextStyle(color: PdfColors.black)),
                  )),
              p.SizedBox(width: width / 273.2),

              p.SizedBox(width: width / 273.2),
              p.Container(
                  width: 60,
                  child: p.Center(
                    child: p.Text("1500".toString(),
                        style: p.TextStyle(color: PdfColors.black)),
                  ))
            ]),
          )),
    );

    final container3 = p.Center(
      child: p.Container(
          child: p.Padding(
            padding: p.EdgeInsets.only(top: 5),
            child: p.Row(mainAxisAlignment: p.MainAxisAlignment.start, children: [
              p.Container(
                  width: 60,
                  child: p.Center(
                    child: p.Text("   ".toString(),
                        style: p.TextStyle(color: PdfColors.black)),
                  )),
              p.SizedBox(width: width / 273.2),
              p.Container(
                  width: 80,
                  child: p.Center(
                    child: p.Text("               ".toString(),
                        style: p.TextStyle(color: PdfColors.black)),
                  )),
              p.SizedBox(width: width / 273.2),

              p.SizedBox(width: width / 273.2),

              p.SizedBox(width: 200),
              p.Container(
                  width: 60,
                  child: p.Center(
                    child: p.Text("Total:".toString(),
                        style: p.TextStyle(color: PdfColors.black)),
                  )),
              p.SizedBox(width: width / 273.2),

              p.SizedBox(width: width / 273.2),
              p.Container(
                  width: 60,
                  child: p.Center(
                    child: p.Text("1500".toString(),
                        style: p.TextStyle(color: PdfColors.black)),
                  ))
            ]),
          )),
    );
    final container4 = p.Center(
      //child:
    );

    final profileImage = p.MemoryImage((await rootBundle.load('assets/schoollogo.png')).buffer.asUint8List(),);
    final paid = p.MemoryImage((await rootBundle.load('assets/paid.png')).buffer.asUint8List(),);


    widgets.add(p.SizedBox(height: 5));
    widgets.add(p.SizedBox(height: 5));

    final pdf = p.Document();
    pdf.addPage(
      p.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => widgets, //here goes the widgets list
      ),
    );
    Printing.layoutPdf(

      onLayout: (PdfPageFormat format) async => pdf.save(),
    );


  }
}


class ClassWiseTimeTableModel{
  ClassWiseTimeTableModel({
    required this.staffName,
    required this.firstPeriod,
    required this.secondPeriod,
    required this.thirdPeriod,
    required this.fourthPeriod,
    required this.fifthPeriod,
    required this.sixthPeriod,
    required this.seventhPeriod,
    required this.eighthPeriod,
  });

  String staffName;
  String firstPeriod;
  String secondPeriod;
  String thirdPeriod;
  String fourthPeriod;
  String fifthPeriod;
  String sixthPeriod;
  String seventhPeriod;
  String eighthPeriod;

  String getIndex(int index,int row) {
    switch (index) {
      case 0:
        return staffName;
      case 1:
        return firstPeriod;
      case 2:
        return secondPeriod;
      case 3:
        return thirdPeriod;
      case 4:
        return fourthPeriod;
      case 5:
        return fifthPeriod;
      case 6:
        return sixthPeriod;
      case 7:
        return seventhPeriod;
      case 8:
        return eighthPeriod;
    }
    return '';
  }

}

