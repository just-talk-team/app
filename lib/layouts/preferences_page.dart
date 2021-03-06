import 'package:auto_size_text/auto_size_text.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_talk/authentication/bloc/authentication_cubit.dart';
import 'package:just_talk/models/preferences.dart';
import 'package:just_talk/models/user_info.dart';
import 'package:just_talk/services/user_service.dart';
import 'package:just_talk/utils/constants.dart';
import 'package:just_talk/utils/enums.dart';
import 'package:just_talk/widgets/badge.dart';

class Preference extends StatefulWidget {
  @override
  _PreferenceState createState() => _PreferenceState();
}

class _PreferenceState extends State<Preference> {
  String userId;
  UserService userService;
  UserInfo userInfo;
  List<String> segments;
  PreferencesChange preferencesChange;

  Future<bool> getData() async {
    userInfo = await userService.getUser(userId, true, false);
    segments = await userService.getSegmentsDomains(userId);
    return true;
  }

  @override
  void initState() {
    super.initState();
    userId = BlocProvider.of<AuthenticationCubit>(context).state.user.id;
    userService = RepositoryProvider.of<UserService>(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!preferencesChange.compare(userInfo.preferences)) {
          await userService.updatePreferences(
              userId, preferencesChange.toPreference());
        }
        Navigator.of(context).pop();
        return;
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              iconSize: 30,
              icon: Icon(Icons.keyboard_arrow_left),
              color: Colors.black,
              onPressed: () async {
                if (!preferencesChange.compare(userInfo.preferences)) {
                  await userService.updatePreferences(
                      userId, preferencesChange.toPreference());
                }
                Navigator.of(context).pop();
              },
            ),
            title: Text('Preferencias'),
          ),
          body: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  preferencesChange =
                      PreferencesChange.fromPreference(userInfo.preferences);
                  return PreferenceData(
                      segments, preferencesChange, userInfo.age);
                }
                return Container();
              })
          //Content
          ),
    );
  }
}

// ignore: must_be_immutable
class PreferenceData extends StatefulWidget {
  PreferenceData(this.userSegments, this.preferences, this.age);

  List<String> userSegments;
  PreferencesChange preferences;
  int age;

  @override
  _PreferenceDataState createState() => _PreferenceDataState();
}

class _PreferenceDataState extends State<PreferenceData> {
  List<String> _multipleChoices = ['Masculino', 'Femenino'];
  String interval = "";
  RangeValues currentRangeValues;
  double minAge;
  double maxAge;

  Iterable<Widget> get segmentsMultipleChip sync* {
    for (String segment in widget.userSegments) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
            showCheckmark: false,
            padding: EdgeInsets.all(10),
            label: Text(
              segment,
              style: (widget.preferences.segments.contains(segment))
                  ? TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.bold,
                      color: Colors.white)
                  : TextStyle(
                      fontFamily: "Roboto", fontWeight: FontWeight.bold),
            ),
            selectedColor: Theme.of(context).accentColor,
            selected: widget.preferences.segments.contains(segment),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  widget.preferences.segments.add(segment);
                } else {
                  widget.preferences.segments
                      .removeWhere((element) => element == segment);
                }
              });
            }),
      );
    }
  }

  Iterable<Widget> get companyWidgets sync* {
    for (String multipleChoice in _multipleChoices) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
            showCheckmark: false,
            padding: EdgeInsets.all(10),
            label: Text(multipleChoice,
                style: (widget.preferences.genders.contains(
                        EnumToString.fromString(Gender.values, multipleChoice)))
                    ? TextStyle(
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.bold,
                        color: Colors.white)
                    : TextStyle(
                        fontFamily: "Roboto", fontWeight: FontWeight.bold)),
            selectedColor: Theme.of(context).accentColor,
            selected: widget.preferences.genders.contains(
                EnumToString.fromString(Gender.values, multipleChoice)),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  widget.preferences.genders.add(
                      EnumToString.fromString(Gender.values, multipleChoice));
                } else {
                  widget.preferences.genders.removeWhere((Gender gender) =>
                      describeEnum(gender) == multipleChoice);
                }
              });
            }),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    minAge = widget.age == MIN_AGE ? MIN_AGE : (widget.age - 3).toDouble();
    maxAge = (widget.age + 3).toDouble();

    double currentMin = widget.preferences.minimunAge.toDouble();
    double currentMax = widget.preferences.maximumAge.toDouble();

    interval = widget.preferences.minimunAge.toString() +
        " - " +
        widget.preferences.maximumAge.toString();
    currentRangeValues = RangeValues(currentMin, currentMax);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //Single choice chip
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AutoSizeText('Segmentos',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: segmentsMultipleChip.toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Multiple choice chips
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AutoSizeText('Sexo',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Container(
                    width: MediaQuery.of(context).size.width,
                    child: Wrap(
                      children: companyWidgets.toList(),
                    )),
              ],
            ),
          ),
          //Age
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AutoSizeText('Edad',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 200,
                        child: RangeSlider(
                          activeColor: Theme.of(context).accentColor,
                          inactiveColor: Theme.of(context).accentColor,
                          values: currentRangeValues,
                          min: minAge,
                          max: maxAge,
                          divisions: 100,
                          labels: RangeLabels(
                            currentRangeValues.start.round().toString(),
                            currentRangeValues.end.round().toString(),
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              currentRangeValues = values;

                              widget.preferences.minimunAge =
                                  currentRangeValues.start.round().toInt();
                              widget.preferences.maximumAge =
                                  currentRangeValues.end.round().toInt();

                              interval = values.start.round().toString() +
                                  " - " +
                                  values.end.round().toString();
                            });
                          },
                        )),
                    Container(
                      child: Center(
                        child: AutoSizeText(
                          interval,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                    )
                  ],
                )),
              ],
            ),
          ),
          //Insignias
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText('Insignias',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(badges.length, (index) {
                      return Badge(
                          selectedColor: Theme.of(context).accentColor,
                          selected: widget.preferences.badgets
                              .contains(badges[index].item1),
                          icon: badges[index].item2,
                          text: badges[index].item1,
                          valueChanged: (bool selected) {
                            if (selected) {
                              widget.preferences.badgets.removeWhere(
                                  (element) => element == badges[index].item1);
                            } else {
                              widget.preferences.badgets
                                  .add(badges[index].item1);
                            }
                          });
                    }))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
