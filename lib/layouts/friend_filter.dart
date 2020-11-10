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
import 'package:just_talk/widgets/badget.dart';

class FriendFilter extends StatefulWidget {
  @override
  _FriendFilterState createState() => _FriendFilterState();
}

class _FriendFilterState extends State<FriendFilter> {
  String userId;
  UserService userService;
  UserInfo userInfo;
  List<String> segments;
  PreferencesChange preferencesChange;

  Future<bool> getData() async {
    userInfo = await userService.getUser(userId, false, true);
    segments = await userService.getSegments(userId);
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
          await userService.updateFriendFilters(
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
                if (!preferencesChange.compare(userInfo.filters)) {
                  await userService.updateFriendFilters(
                      userId, preferencesChange.toPreference());
                }
                Navigator.of(context).pop();
              },
            ),
            title: Text('Filtros'),
          ),
          body: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  preferencesChange =
                      PreferencesChange.fromPreference(userInfo.filters);
                  return PreferenceData(segments, preferencesChange);
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
  PreferenceData(this.userSegments, this.preferences);

  List<String> userSegments;
  PreferencesChange preferences;

  @override
  _PreferenceDataState createState() => _PreferenceDataState();
}

class _PreferenceDataState extends State<PreferenceData> {
  List<String> _multipleChoices = ['Masculino', 'Femenino'];
  String interval = "";
  RangeValues currentRangeValues;

  Iterable<Widget> get segmentsMultipleChip sync* {
    for (String segment in widget.userSegments) {
      yield Padding(
        padding: const EdgeInsets.all(6.0),
        child: FilterChip(
            label: Text(segment),
            selectedColor: Color(0xffb3a407),
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
            label: Text(multipleChoice),
            selectedColor: Color(0xffb3a407),
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
    double min = widget.preferences.minimunAge.toDouble();
    double max = widget.preferences.maximumAge.toDouble();

    interval = min.toString() + " - " + max.toString();
    currentRangeValues = RangeValues(min, max);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          //Single choice chip
          Container(
            //color: Colors.amberAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AutoSizeText('Segmentos',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color(0xff666666),
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
            //color: Colors.blueAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AutoSizeText('Sexo',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Color(0xff666666),
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
            //color: Colors.lightGreen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AutoSizeText('Edad',
                    style: TextStyle(
                        color: Color(0xff666666),
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 200,
                        child: Material(
                            child: RangeSlider(
                          activeColor: Color(0xffb3a407),
                          inactiveColor: Color(0xffb3a407),
                          values: currentRangeValues,
                          min: 18,
                          max: 99,
                          divisions: 100,
                          labels: RangeLabels(
                            currentRangeValues.start.round().toString(),
                            currentRangeValues.end.round().toString(),
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              currentRangeValues = values;

                              widget.preferences.minimunAge =
                                  currentRangeValues.start.toInt();
                              widget.preferences.maximumAge =
                                  currentRangeValues.end.toInt();

                              interval = values.start.round().toString() +
                                  " - " +
                                  values.end.round().toString();
                            });
                          },
                        ))),
                    Container(
                      child: Center(
                        child: AutoSizeText(
                          interval,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff666666)),
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
            //color: Colors.cyanAccent,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 30),
                    AutoSizeText('Insignias',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(0xff666666),
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(badgets.length, (index) {
                      return Badget(
                          selected: widget.preferences.badgets
                              .contains(badgets[index].item1),
                          icon: badgets[index].item2,
                          text: badgets[index].item1,
                          valueChanged: (bool selected) {
                            if (selected) {
                              widget.preferences.badgets.removeWhere(
                                  (element) => element == badgets[index].item1);
                            } else {
                              widget.preferences.badgets
                                  .add(badgets[index].item1);
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
