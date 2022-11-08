import 'package:docudi/palette.dart';
import 'package:docudi/provider/dataProvider.dart';
import 'package:docudi/user_api.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SymptomsScreen extends StatefulWidget {
  static const routeName = "/symptoms";

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  List<String> symptoms = [
    'itching',
    'skin rash',
    'nodal skin eruptions',
    'continuous sneezing',
    'shivering',
    'chills',
    'joint pain',
    'stomach pain',
    'acidity',
    'ulcers on tongue',
    'muscle wasting',
    'vomiting',
    'burning micturition',
    'spotting  urination',
    'fatigue',
    'weight gain',
    'anxiety',
    'cold hands and feets',
    'mood swings',
    'weight loss',
    'restlessness',
    'lethargy',
    'patches in throat',
    'irregular sugar level',
    'cough',
    'high fever',
    'sunken eyes',
    'breathlessness',
    'sweating',
    'dehydration',
    'indigestion',
    'headache',
    'yellowish skin',
    'dark urine',
    'nausea',
    'loss of appetite',
    'pain behind the eyes',
    'back pain',
    'constipation',
    'abdominal pain',
    'diarrhoea',
    'mild fever',
    'yellow urine',
    'yellowing of eyes',
    'acute liver failure',
    'fluid overload',
    'swelling of stomach',
    'swelled lymph nodes',
    'malaise',
    'blurred and distorted vision',
    'phlegm',
    'throat irritation',
    'redness of eyes',
    'sinus pressure',
    'runny nose',
    'congestion',
    'chest pain',
    'weakness in limbs',
    'fast heart rate',
    'pain during bowel movements',
    'pain in anal region',
    'bloody stool',
    'irritation in anus',
    'neck pain',
    'dizziness',
    'cramps',
    'bruising',
    'obesity',
    'swollen legs',
    'swollen blood vessels',
    'puffy face and eyes',
    'enlarged thyroid',
    'brittle nails',
    'swollen extremeties',
    'excessive hunger',
    'extra marital contacts',
    'drying and tingling lips',
    'slurred speech',
    'knee pain',
    'hip joint pain',
    'muscle weakness',
    'stiff neck',
    'swelling joints',
    'movement stiffness',
    'spinning movements',
    'loss of balance',
    'unsteadiness',
    'weakness of one body side',
    'loss of smell',
    'bladder discomfort',
    'foul smell of urine',
    'continuous feel of urine',
    'passage of gases',
    'internal itching',
    'toxic look (typhos)',
    'depression',
    'irritability',
    'muscle pain',
    'altered sensorium',
    'red spots over body',
    'belly pain',
    'abnormal menstruation',
    'dischromic  patches',
    'watering from eyes',
    'increased appetite',
    'polyuria',
    'family history',
    'mucoid sputum',
    'rusty sputum',
    'lack of concentration',
    'visual disturbances',
    'receiving blood transfusion',
    'receiving unsterile injections',
    'coma',
    'stomach bleeding',
    'distention of abdomen',
    'history of alcohol consumption',
    'fluid overload',
    'blood in sputum',
    'prominent veins on calf',
    'palpitations',
    'painful walking',
    'pus filled pimples',
    'blackheads',
    'scurring',
    'skin peeling',
    'silver like dusting',
    'small dents in nails',
    'inflammatory nails',
    'blister',
    'red sore around nose',
    'yellow crust ooze',
    'prognosis'
  ];
  List<String> selectedSymptoms = [];
  bool search = false;
  late String disease;

  Future<void> getData() async {
    if (selectedSymptoms.length == 0) {
      Provider.of<DataProvider>(context, listen: false).symptoms = selectedSymptoms;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your symptoms!')),
      );
      return;
    }
    Provider.of<DataProvider>(context, listen: false).symptoms = selectedSymptoms;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please wait, predicting disease!')),
    );
    try {
      String res = await predictDisease(selectedSymptoms);
      setState(() {
        disease = res;
        search = true;
      });
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Internal error. Please try again later!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 5),
                    child: Center(
                      child: Text(
                        "Select Symptoms",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Icon(
                        Icons.arrow_back,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                height: 400,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 5 / 2.5,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                  ),
                  padding: EdgeInsets.all(0),
                  itemBuilder: (ctx, i) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedSymptoms.contains(symptoms[i]))
                            selectedSymptoms.remove(symptoms[i]);
                          else
                            selectedSymptoms.add(symptoms[i]);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedSymptoms.contains(symptoms[i]) ? primaryColor : secondaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                            child: Text(
                          symptoms[i],
                          style: TextStyle(
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        )),
                      ),
                    );
                  },
                  itemCount: symptoms.length,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: Divider(
                  thickness: 2,
                ),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    getData();
                  },
                  style: ElevatedButton.styleFrom(elevation: 0),
                  child: Container(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              search
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Predicted Disease: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              search
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          disease,
                          style: TextStyle(color: primaryColor),
                        )
                      ],
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
