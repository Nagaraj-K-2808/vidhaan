import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ExamTimeTable extends StatefulWidget {
  const ExamTimeTable({Key? key}) : super(key: key);

  @override
  State<ExamTimeTable> createState() => _ExamTimeTableState();
}

class _ExamTimeTableState extends State<ExamTimeTable> {


  TextEditingController name = new TextEditingController();
  TextEditingController orderno = new TextEditingController();

  ExamWithSubjects examData = ExamWithSubjects(examName: '',subjects: []);


  getorderno() async {
    var document = await  FirebaseFirestore.instance.collection("SubjectMaster").get();
    setState(() {
      orderno.text="00${document.docs.length+1}";
    });
  }

  addclass() async {
     var document = await FirebaseFirestore.instance.collection("ExamMaster").doc(classid).collection(_typeAheadControllerclass.text).orderBy("timestamp").get();
    for(int i=0;i<document.docs.length;i++) {
      FirebaseFirestore.instance.collection("ExamMaster").doc(classid)
          .collection(_typeAheadControllerclass.text).doc(document.docs[i].id)
          .update({
        "date": textediting[i].text,
        "timestamp2": timestamp[i]
      });
    }

     var docu = await FirebaseFirestore.instance.collection("Students").orderBy("regno").get();
     for(int i=0;i<docu.docs.length;i++){
       if(docu.docs[i]["admitclass"]==_typeAheadControllerclass.text) {
         var docu2 = await FirebaseFirestore.instance.collection("Students").doc(docu.docs[i].id).collection("Exams").doc(classid).collection("Timetable").orderBy("timestamp").get();
         for (int j = 0; j < docu2.docs.length; j++) {
           FirebaseFirestore.instance.collection("Students").doc(docu.docs[i].id).collection("Exams").doc(classid).collection("Timetable").doc(docu2.docs[j].id)
               .update({
             "date": textediting[j].text,
             "timestamp2": timestamp[j]
           });
         }
       }
     }


     Successdialog();
  }



  setvalue() async {

     var document = await FirebaseFirestore.instance.collection("ExamMaster").doc(classid).collection(_typeAheadControllerclass.text).orderBy("timestamp").get();
    for(int i=0;i<document.docs.length;i++) {
     setState(() {
      textediting[i].text= document.docs[i]["date"];
     });
    }

  }
  Successdialog(){
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/3.035555556,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Exam Timetable Assigned Successfully',
      desc: '',
      btnCancelOnPress: () {

      },
      btnOkOnPress: () {

      },
    )..show();
  }
  final TextEditingController _typeAheadControllerclass = TextEditingController();

  final textediting = List<TextEditingController>.generate(200, (int index) => TextEditingController(), growable: true);
  final textediting2 = List<TextEditingController>.generate(200, (int index) => TextEditingController(), growable: true);
  final timestamp = List<int>.generate(200, (int index) => 0, growable: true);

  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  static final List<String> classes = [];
  static List<String> getSuggestionsclass(String query) {
    List<String> matches = <String>[];
    matches.addAll(classes);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
  final TextEditingController _typeAheadControllerexam = TextEditingController();

  static final List<String> exam = [];
  adddropvalue() async {
    setState(() {
      classes.clear();
      exam.clear();
      staffid.clear();
      staffid2.clear();
    });
    var document3 = await  FirebaseFirestore.instance.collection("ClassMaster").orderBy("order").get();
    var document2 = await  FirebaseFirestore.instance.collection("SectionMaster").orderBy("order").get();
    var document8 = await  FirebaseFirestore.instance.collection("ExamMaster").orderBy("order").get();
    setState(() {
      classes.add("Select Option");
      exam.add("Select Option");
    });
    for(int i=0;i<document3.docs.length;i++) {
      setState(() {
        classes.add(document3.docs[i]["name"]);
      });

    }
    var document = await  FirebaseFirestore.instance.collection("Staffs").orderBy("timestamp").get();
    for(int i=0;i<document.docs.length;i++) {
      setState(() {
        staffid.add(document.docs[i]["regno"]);
        staffid2.add(document.docs[i]["stname"]);
      });

    }
    for(int i=0;i<document2.docs.length;i++) {
      setState(() {
        section.add(document2.docs[i]["name"]);
      });

    }
    for(int i=0;i<document8.docs.length;i++) {
      setState(() {
        exam.add(document8.docs[i]["name"]);
      });
    }
  }
  String classid="";
  firstcall() async {
    var document3 = await  FirebaseFirestore.instance.collection("ClassMaster").orderBy("order").get();
    var document = await  FirebaseFirestore.instance.collection("ExamMaster").orderBy("order").get();
    setState(() {
      _typeAheadControllerclass.text=document3.docs[0]["name"];
      _typeAheadControllerexam.text=document.docs[0]["name"];
      classid=document.docs[0].id;
    });
    setvalue();

  }

  setteacher() async {
    var document= await FirebaseFirestore.instance.collection("ClassMaster").doc(classid).collection("Sections").doc("${_typeAheadControllerclass.text}${_typeAheadControllersection.text}").collection("Subjects").orderBy("timestamp").get();

    for(int i=0;i<document.docs.length;i++){

      setState(() {
        textediting[i].text= document.docs[i]["staffid"];
        textediting2[i].text= document.docs[i]["staffname"];
      });
    }


  }



  @override
  void initState() {
    setState(() {
      _typeAheadControllerclass.text="Select Option";
      _typeAheadControllersection.text="Select Option";
    });
    getorderno();
    firstcall();
    adddropvalue();
    // TODO: implement initState
    super.initState();
  }
  getstaffbyid() async {
    print("fdgggggggggg");

    var document = await FirebaseFirestore.instance.collection("ExamMaster").get();
    for(int i=0;i<document.docs.length;i++){
      if(_typeAheadControllerexam.text==document.docs[i]["name"]){
        setState(() {
          classid= document.docs[i].id;
        }
        );
      }
    }
    print("fdgggggggggg");
    setvalue();


  }
  getstaffbyid2(value,index) async {
    print("fdgggggggggg");

    var document = await FirebaseFirestore.instance.collection("Staffs").get();
    for(int i=0;i<document.docs.length;i++){
      if(value==document.docs[i]["regno"]){
        setState(() {
          textediting2[index].text= document.docs[i]["stname"];
        }
        );
      }
    }
    print("fdgggggggggg");


  }
  getstaffbyid3(value,index) async {
    print("fdgggggggggg");

    var document = await FirebaseFirestore.instance.collection("Staffs").get();
    for(int i=0;i<document.docs.length;i++){
      if(value==document.docs[i]["stname"]){
        setState(() {
          textediting[index].text= document.docs[i]["regno"];
        }
        );
      }
    }
    print("fdgggggggggg");


  }
  static final List<String> staffid = [];
  static final List<String> staffid2 = [];

  static List<String> getSuggestionsstaffid(String query) {
    List<String> matches = <String>[];
    matches.addAll(staffid);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
  static List<String> getSuggestionsstaffname(String query) {
    List<String> matches = <String>[];
    matches.addAll(staffid2);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
  static final List<String> section = [];
  final TextEditingController _typeAheadControllersection = TextEditingController();

  static List<String> getSuggestionssection(String query) {
    List<String> matches = <String>[];
    matches.addAll(section);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
  int count =0;


  Error2(){
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      width: width/3.035555556,
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Field Can not Empty',
      btnOkText: "Ok",
      btnOkOnPress: () {},
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: width/68.3
            ),
            child: Container(child: Padding(
              padding: EdgeInsets.only(
                  left: width/35.947368421,
                  top: height/21.7
              ),
              child: Text("Exam Timetable", style: GoogleFonts.poppins(
                  fontSize: width/75.888888889, fontWeight: FontWeight.bold),),
            ),
              //color: Colors.white,
              width: width / 1.050,
              height: height / 8.21,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: width/68.3, top: height/32.55
            ),
            child: Container(
              width: width / 1.050,

              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: width/136.6, top: height/65.1),
                    child: Padding(
                      padding: EdgeInsets.only(left: width/136.6, top: height/65.1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,

                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 0.0),
                                child: Text("Class",
                                    style: GoogleFonts.poppins(fontSize: width/91.066666667,)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 0.0, right: width/54.64),
                                child: Container(child:
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    hint: Row(
                                      children: [
                                        Icon(
                                          Icons.list,
                                          size: width/85.375,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: width/341.5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Select Option',
                                            style: GoogleFonts.poppins(
                                                fontSize: width/91.066666667
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    items: classes
                                        .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: GoogleFonts.poppins(
                                                fontSize: width/91.066666667
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                        .toList(),
                                    value: _typeAheadControllerclass.text,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _typeAheadControllerclass.text = value!;
                                      });
                                      getstaffbyid();
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      height: height/13.02,
                                      width: width/8.5375,
                                      padding: EdgeInsets.only(
                                          left: width/97.571428571,
                                          right: width/97.571428571,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),

                                        color: Color(0xffDDDEEE),
                                      ),

                                    ),
                                    iconStyleData: IconStyleData(
                                      icon: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                      ),
                                      iconSize: width/97.571428571,
                                      iconEnabledColor: Colors.black,
                                      iconDisabledColor: Colors.grey,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: height/3.255,
                                      width: width / 5.464,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Color(0xffDDDEEE),
                                      ),

                                      scrollbarTheme: ScrollbarThemeData(
                                        radius: const Radius.circular(7),
                                        thickness: MaterialStateProperty.all<
                                            double>(6),
                                        thumbVisibility: MaterialStateProperty
                                            .all<bool>(true),
                                      ),
                                    ),
                                    menuItemStyleData:  MenuItemStyleData(
                                      height: height/16.275,
                                      padding: EdgeInsets.only(
                                          left: width/97.571428571,
                                          right: width/97.571428571
                                      ),
                                    ),
                                  ),
                                ),
                                  width: width / 6.902,
                                  height: height / 16.42,
                                  //color: Color(0xffDDDEEE),
                                  decoration: BoxDecoration(
                                      color: Color(0xffDDDEEE),
                                      borderRadius: BorderRadius.circular(5)),

                                ),
                              ),

                            ],

                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 0.0),
                                child: Text("Exam",
                                    style: GoogleFonts.poppins(fontSize: width/91.066666667)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 0.0, right: width/54.64),
                                child: Container(child:

                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    hint: Row(
                                      children: [
                                        Icon(
                                          Icons.list,
                                          size: width/85.375,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: width/341.5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Select Option',
                                            style: GoogleFonts.poppins(
                                                fontSize: width/91.066666667
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    items: exam
                                        .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: GoogleFonts.poppins(
                                                fontSize: width/91.066666667
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                        .toList(),
                                    value: _typeAheadControllerexam.text,
                                    onChanged: (String? value) {
                                      setState(() {
                                        _typeAheadControllerexam.text =
                                        value!;
                                      });
                                      getstaffbyid();
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      height: height/13.02,
                                      width: width/8.5375,
                                      padding: EdgeInsets.only(
                                          left: width/97.571428571, right: width/97.571428571),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),

                                        color: Color(0xffDDDEEE),
                                      ),

                                    ),
                                    iconStyleData: IconStyleData(
                                      icon: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                      ),
                                      iconSize: width/97.571428571,
                                      iconEnabledColor: Colors.black,
                                      iconDisabledColor: Colors.grey,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: height/3.255,
                                      width: width / 5.464,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Color(0xffDDDEEE),
                                      ),

                                      scrollbarTheme: ScrollbarThemeData(
                                        radius: const Radius.circular(7),
                                        thickness: MaterialStateProperty.all<
                                            double>(6),
                                        thumbVisibility: MaterialStateProperty
                                            .all<bool>(true),
                                      ),
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      height: height/16.275,
                                      padding: EdgeInsets.only(
                                          left: width/97.571428571, right: width/97.571428571),
                                    ),
                                  ),
                                ),
                                  width: width / 6.83,
                                  height: height / 16.42,
                                  //color: Color(0xffDDDEEE),
                                  decoration: BoxDecoration(
                                      color: Color(0xffDDDEEE),
                                      borderRadius: BorderRadius.circular(5)),

                                ),
                              ),

                            ],

                          ),



                          Padding(
                            padding:  EdgeInsets.only(
                                left: 0.0, right: width/54.64),
                            child: GestureDetector(
                              onTap: () {
                                addclass();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: width/54.64),
                                child: Container(child: Center(child: Text("Save",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white),)),
                                  width: width / 10.507,
                                  height: height / 16.425,
                                  // color:Color(0xff00A0E3),
                                  decoration: BoxDecoration(
                                      color: Color(0xff00A0E3),
                                      borderRadius: BorderRadius.circular(5)),

                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //addclass();
                            },
                            child: Padding(
                              padding:  EdgeInsets.only(right: width/54.64),
                              child: Container(child: Center(child: Text("Print",
                                style: GoogleFonts.poppins(
                                    color: Colors.white),)),
                                width: width / 10.507,
                                height: height / 16.425,
                                // color:Color(0xff00A0E3),
                                decoration: BoxDecoration(
                                    color: Color(0xff00A0E3),
                                    borderRadius: BorderRadius.circular(5)),

                              ),
                            ),
                          ),



                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: height / 13.14,
                      width: width / 1.241,

                      decoration: BoxDecoration(color: Color(0xff00A0E3),
                          borderRadius: BorderRadius.circular(12)

                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(
                                left: width/170.75, right: width/170.75),
                            child: Text("Si.no", style: GoogleFonts.poppins(
                                fontSize: width/85.375,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: width/23.551724138, right: width/170.75),
                            child: Text("Subjects", style: GoogleFonts.poppins(
                                fontSize: width/85.375,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: width/8.5375, right: width/170.75),
                            child: Text("Date", style: GoogleFonts.poppins(
                                fontSize: width/85.375,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),),
                          ),

                        ],
                      ),

                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("ExamMaster").doc(classid).collection(_typeAheadControllerclass.text).orderBy("timestamp").snapshots(),

                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasData == null) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        examData.examName = _typeAheadControllerexam.text;
                        examData.subjects!.clear();
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var value = snapshot.data!.docs[index];

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(

                                  decoration: BoxDecoration(
                                      color: Colors.white60,
                                      borderRadius: BorderRadius.circular(12)

                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: width/45.533333333, right: width/19.514285714),
                                        child: Container(
                                          width: width / 120.83,
                                          child: Text("${(index + 1).toString()}",
                                            style: GoogleFonts.poppins(
                                                fontSize: width/91.066666667,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),),
                                        ),
                                      ),
                                      Container(
                                        width: width / 6.83,
                                        child: Padding(
                                          padding:  EdgeInsets.only(
                                              left: width/170.75, right: width/170.75),
                                          child: Text(value["name"],
                                            style: GoogleFonts.poppins(
                                                fontSize: width/91.066666667,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),),
                                        ),
                                      ),
                                      Container(
                                        width: width / 6.83,
                                        height: height / 16.425,
                                        //color: Color(0xffDDDEEE),
                                        decoration: BoxDecoration(
                                            color: Color(0xffDDDEEE),
                                            borderRadius: BorderRadius.circular(
                                                5)),

                                        child:TextFormField(
                                          controller:  textediting[index],
                                          style: GoogleFonts.poppins(
                                              fontSize: width/91.066666667
                                          ),
                                          onTap: () async {
                                            DateTime? pickedDate = await showDatePicker(
                                                context: context, initialDate: DateTime.now(),
                                                firstDate: DateTime.now(), //DateTime.now() - not to allow to choose before today.
                                                lastDate: DateTime(2101)
                                            );

                                            if(pickedDate != null ){
                                              print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                                              //String formattedDate = DateFormat('dd / M / yyyy').format(pickedDate);
                                              String formattedDate = "${DateFormat.d().format(pickedDate)} ${DateFormat.MMM().format(pickedDate)} ${DateFormat.y().format(pickedDate)}";
                                              print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                              //you can implement different kind of Date Format here according to your requirement

                                              setState(() {

                                                textediting[index].text = formattedDate;
                                                timestamp[index] = pickedDate.millisecondsSinceEpoch;

                                                //set output date to TextField value.
                                              });




                                            }else{
                                              print("Date is not selected");
                                            }
                                          },
                                          validator: (value) =>
                                          value!.isEmpty ? 'Field Cannot be Empty' : null,
                                          decoration: InputDecoration(contentPadding: EdgeInsets.only(left: width/136.6,bottom: height/81.375),
                                            border: InputBorder.none,
                                            hintText: value["date"]


                                          ),

                                        ),
                                      ),

                                    ],
                                  ),

                                ),
                              );
                            },);
                      },),
                ],
              ),

            ),
          )
        ],
      ),
    );
  }
}

class ExamWithSubjects {
  String? examName;
  List<Subjects>? subjects;

  ExamWithSubjects({this.examName, this.subjects});

  ExamWithSubjects.fromJson(Map<String, dynamic> json) {
    examName = json['examName'];
    if (json['subjects'] != null) {
      subjects = <Subjects>[];
      json['subjects'].forEach((v) {
        subjects!.add(new Subjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['examName'] = this.examName;
    if (this.subjects != null) {
      data['subjects'] = this.subjects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subjects {
  String? examname;
  String? subject;
  String? mark;
  String? totalmark;
  num? timestamp;
  String? date;

  Subjects({this.subject, this.date,this.timestamp, this.examname, this.mark,this.totalmark});

  Subjects.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    date = json['date'];
    date = json['timestamp'];
    date = json['totalmark'];
    date = json['mark'];
    date = json['examname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject'] = this.subject;
    data['date'] = this.date;
    data['date'] = this.date;
    data['date'] = this.date;
    data['date'] = this.date;
    data['date'] = this.date;
    return data;
  }
}

