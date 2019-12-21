import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:intl/intl.dart';
import 'package:legalpedia/judgementbody.dart';
import 'package:legalpedia/models/summarymodel.dart';
import 'package:legalpedia/models/ratiosmodel.dart';
import 'package:legalpedia/models/coramsmodel.dart';

import 'package:sqflite/sqflite.dart';

import 'package:legalpedia/utils/database_helper.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;


class JudgementDetail extends StatefulWidget{

  final List<SummaryModel> summary;
   final List<RatioModel> ratio;

  final String  suitNo;
  List<SummaryModel> filteredsummary = List();

  JudgementDetail(this.summary, this.suitNo, this.ratio);
//

  @override
  _JudgementDetail createState()=> _JudgementDetail(this.summary, this.suitNo, this.ratio);

}

class _JudgementDetail extends State<JudgementDetail>{

  final List<SummaryModel> summary;
   final List<RatioModel> ratio;
  final String  suitNo;
  List<SummaryModel> filteredsummary = List();
   List<RatioModel> filteredRatio = List();
  List<CoramModel> corams = List();
  List<CoramModel> filteredcorams = List();

   DatabaseHelper databaseHelper = DatabaseHelper();

  _JudgementDetail(this.summary, this.suitNo, this.ratio);

     updateCoram() async{
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<CoramModel>> coramListFuture =
          databaseHelper.getCoramList();
      coramListFuture.then((coramList) {
       setState(() {
          this.corams = coramList;
          
        // this.filteredsummary = summaryList;
        // this.count = filteredsummary.length;
      });
      });
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {

      filteredsummary = summary.where((u)=>
      (u.suitNo.toLowerCase().contains(suitNo.toLowerCase()))).toList();

       filteredRatio = ratio.where((u)=>
      (u.suitNo.toLowerCase().contains(suitNo.toLowerCase()))).toList();

      updateCoram();

     /* var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd');
      String formatted = formatter.format(now);*/

    });


  }

  String getDate(str){

    try{
    var parsedDate = DateTime.parse(str);

    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(parsedDate);

    return formatted;
    } 
    catch(e){
      return 'Invalid Date';
    }
  }

  double getHeight(height){

    String ht = height.toString();
    double ht2 = double.parse(ht);
    return ht2 * 25.0;

  }

  @override
  Widget build(BuildContext context) {
    
      filteredcorams = corams.where((u)=>
      (u.suitNo.toLowerCase().contains(suitNo.toLowerCase()))).toList();

    return new Scaffold(
        appBar: new AppBar(iconTheme: new IconThemeData(color: Colors.white),
          elevation: 7.0,
          actionsIconTheme: new IconThemeData(color:  Colors.white),
          title: Text('Judgement Details', style: TextStyle(
              fontWeight:  FontWeight.bold,
              fontSize: 16.0,
              fontFamily: 'Monseratti',
              color: Colors.white

          ),),

        
          backgroundColor: Colors.red,

        ),
        body:
        Column(
          children: <Widget>[

            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.all(5.0),
                  itemCount:1,
                  itemBuilder: (BuildContext context, int index){
                    return  Card(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 10.0),
                                Text(filteredsummary[index].title==null || filteredsummary[index].title=='null'?'Not Available': filteredsummary[index].title, textAlign: TextAlign.center, style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    fontFamily: 'Monseratti'

                                ),),
                                SizedBox(height: 20.0),
                                Text(filteredsummary[index].legalpediaCitation==null||filteredsummary[index].legalpediaCitation=='null'?'Not Available':filteredsummary[index].legalpediaCitation, textAlign: TextAlign.center, style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Monseratti',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green
                                ),),

                                SizedBox(height: 20.0),
                                Text(filteredsummary[index].court==null||filteredsummary[index].court=='null'?'Not Available': filteredsummary[index].court, textAlign: TextAlign.center, style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Monseratti',
                                    fontWeight: FontWeight.bold,

                                ),),

                                Text( filteredsummary[index].judgementDate==null||filteredsummary[index].judgementDate=='null'?'Not Available': getDate(filteredsummary[index].judgementDate) , textAlign: TextAlign.center, style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Monseratti',


                                ),),
                                SizedBox(height: 40.0),
                                Text('SUIT NUMBER', textAlign: TextAlign.center, style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Monseratti',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent

                                ),),
                                Text(filteredsummary[index].suitNo==null||filteredsummary[index].suitNo=='null'?'Not Available:':filteredsummary[index].suitNo, textAlign: TextAlign.center, style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Monseratti',
                                  fontWeight: FontWeight.bold

                                ),),
                                SizedBox(height: 30.0),
                                Text('CORAMS', textAlign: TextAlign.center, style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Monseratti',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent

                                ),),

                             Container(
                               
                                alignment: Alignment.center,
                                child:  ListView.builder(
                                   
                                    shrinkWrap: true,
                                     physics: ClampingScrollPhysics(),
                                    itemCount: filteredcorams.length,
                                    itemBuilder: (BuildContext context, int count){
                                      return  Text(filteredcorams[count].coram==null||filteredcorams[count].coram=='null'?'Not Available':filteredcorams[count].coram, textAlign: TextAlign.center, style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Monseratti',

                                      ),);

                                    }

                                ),

                              ),
                                SizedBox(height: 20.0,),

                               
                                Text(filteredsummary[index].partyAType==null||filteredsummary[index].partyAType=='null'?'Not Available':filteredsummary[index].partyAType, textAlign: TextAlign.center, style : TextStyle(
                                 fontSize: 16.0,
                                    fontFamily: 'Monseratti',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent

                                ),),
                                SizedBox(height: 20.0),

                              /*  Text('NAME', textAlign: TextAlign.center, style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Monseratti',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green

                                ),),*/
                                Text(filteredsummary[index].partiesA==null||filteredsummary[index].partiesA=='null'?'Not Available':filteredsummary[index].partiesA, textAlign: TextAlign.center, style : TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Monseratti',

                                ),),

                                SizedBox(height: 20.0,),

                             
                                Text(filteredsummary[index].partyBType==null||filteredsummary[index].partyBType=='null'?'Not Available':filteredsummary[index].partyBType, textAlign: TextAlign.center, style : TextStyle(
                                   fontSize: 16.0,
                                    fontFamily: 'Monseratti',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent
                                ),),
                                SizedBox(height: 20.0),

                               /* Text('NAME', textAlign: TextAlign.center, style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Monseratti',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green

                                ),),*/
                                Text(filteredsummary[index].partiesB==null||filteredsummary[index].partiesB=='null'?'Not Availble':filteredsummary[index].partiesB, textAlign: TextAlign.center, style : TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Monseratti',

                                ),),

                                SizedBox(height: 30.0),

                                Text('SUMMARY OF FACTS', textAlign: TextAlign.center, style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Monseratti',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent

                                ),),
                                SizedBox(height: 10,),
                                Text(filteredsummary[index].summaryOfFacts==null||filteredsummary[index].partiesB=='null'?'Not Available':filteredsummary[index].summaryOfFacts, textAlign: TextAlign.left, style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Monseratti',
                                 

                                ),),
                                SizedBox(height: 30.0,),

                                Text('HELD', textAlign: TextAlign.center, style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Monseratti',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent

                                ),),
                                SizedBox(height: 10,),
                                Text(filteredsummary[index].held==null||filteredsummary[index].held=='null'?'Not Available':filteredsummary[index].held , textAlign: TextAlign.left, style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Monseratti',


                                ),),
                                SizedBox(height: 30.0,),

                                Text('ISSUE', textAlign: TextAlign.center, style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Monseratti',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent

                                ),),
                                SizedBox(height: 10,),
                                Text(filteredsummary[index].issues==null||filteredsummary[index].issues=='null'?'Not Available':filteredsummary[index].issues, textAlign: TextAlign.left, style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Monseratti',


                                ),),
                                SizedBox(height: 30.0,),

                                Text('RATIO', textAlign: TextAlign.center, style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Monseratti',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent

                                ),),
                                SizedBox(height: 10.0,),
                               Column(
                                children: <Widget>[
                                  Container(
                                   
                                    child:  ListView.builder(
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        itemCount: filteredRatio.length,
                                        itemBuilder: (BuildContext context, int count){
                                          return Column(
                                            children: <Widget>[
                                              Text(filteredRatio[count].heading==null||filteredRatio[count].heading=='null'?'Not Available':filteredRatio[count].heading, style: TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: 'Monseratti',
                                                fontWeight: FontWeight.bold

                                              ),
                                              ),
                                              SizedBox(height: 5.0,),
                                              Text(filteredRatio[count].body==null||filteredRatio[count].body=='null'?'Not Available':filteredRatio[count].body, style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: 'Monseratti',

                                              ),

                                              ),
                                              SizedBox(height: 10.0,),
                                            ],
                                          )  ;

                                        }

                                    ),

                                  ),
                                ],
                              ),

                                SizedBox(height: 30.0,),
                                Text('CASES SITED', textAlign: TextAlign.center, style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Monseratti',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent

                                ),),
                                SizedBox(height: 10,),
                                 Html(
                              data: filteredsummary[index].casesCited,
                              customTextAlign: (dom.Node node) {
                                if (node is dom.Element) {
                                  switch (node.localName) {
                                    case "p":
                                      return TextAlign.center;
                                  }
                                }
                                return null;
                              },
                              customTextStyle: (dom.Node node, TextStyle baseStyle) {
                                if (node is dom.Element) {
                                  switch (node.localName) {
                                    case "p":
                                      return baseStyle.merge(TextStyle(height: 2, fontSize: 16, fontFamily: 'Monseratti',));
                                  }
                                }
                                return baseStyle;
                              },

                             
                            ),
                                /*Text(filteredsummary[index].casesCited==null||filteredsummary[index].casesCited=='null'?'Not Available': filteredsummary[index].casesCited , textAlign: TextAlign.left, style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Monseratti',


                                ),),*/
                                SizedBox(height: 30.0,),
                                Text('STATUS SITED', textAlign: TextAlign.center, style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: 'Monseratti',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent

                                ),),
                                SizedBox(height: 10,),
                                Text(filteredsummary[index].statusCited==null||filteredsummary[index].statusCited=='null'?'Not Available': filteredsummary[index].statusCited , textAlign: TextAlign.left, style: TextStyle(
                                  fontSize: 16.0,
                                  fontFamily: 'Monseratti',


                                ),),
                                SizedBox(height: 50,),
                                Container(
                                  height: 40.0,
                                  child: Material(
                                      borderRadius: BorderRadius.circular(20.0),
                                      shadowColor: Colors.redAccent,
                                      color: Colors.red,
                                      elevation: 7.0,
                                      child: GestureDetector(
                                        onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                          return JudegementBody(filteredsummary[index].suitNo);
                                            }));
                                        },
                                        child: Center(
                                          child: Text(
                                            'READ FULL JUDGEMENT',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'MontSerrat'
                                            ),
                                          ),
                                        ),
                                      )
                                  ),

                                ),
                                SizedBox(height: 50,)
                              ],
                            ),
                          ),
                        );
                  }),
            )
          ],
        )
    );
  }


}