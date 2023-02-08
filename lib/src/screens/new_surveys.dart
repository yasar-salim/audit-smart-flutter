import 'package:combos/combos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orison/src/blocs/app_navigator_cubit.dart';
import 'package:orison/src/blocs/location_audit_cubit.dart';
import 'package:orison/src/models/audit_type_response.dart';
import 'package:orison/src/models/location_response.dart';
import 'package:orison/src/utils/app_config.dart';
import 'package:orison/src/utils/constants.dart';
import 'package:orison/src/widgets/dashboard_item.dart';
import 'package:orison/src/widgets/error_message.dart';
import 'package:orison/src/widgets/loadng.dart';
import 'package:orison/src/widgets/round_app_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orison/src/widgets/title.dart';

class NewSurveysScreen extends StatefulWidget {
  @override
  _NewSurveysScreenState createState() => _NewSurveysScreenState();
}

class _NewSurveysScreenState extends State<NewSurveysScreen> {
  LocationAuditCubit _locationAuditCubit;
  Location _selectedLocation;
  AuditType _selectedAuditType;

  List<Location> _locations;
  List<AuditType> _auditTypes;

  @override
  void initState() {
    _locationAuditCubit = LocationAuditCubit();
    _locationAuditCubit.getLocationsAndAuditTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener(
          bloc: _locationAuditCubit,
          listener: (BuildContext context, state) {
            if (state is LocationAuditSurveyValidationError) {
              String message = 'Please fill all fields to get survey';
              switch (state.field) {
                case 1:
                  message = 'Please select a location';
                  break;
                case 2:
                  message = 'Please select a audit type';
                  break;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    message,
                    style: TextStyle(color: AppConfig.white),
                  ),
                  backgroundColor: AppConfig.primaryColor,
                ),
              );
            }

            if (state is LocationAuditSurveySuccess) {
              setState(() {
                _selectedAuditType = null;
              });
              BlocProvider.of<AppNavigatorCubit>(context)
                  .routeToSurveyStart(response: state.response);
            }
          },
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageTitle(
              title: 'New Audit',
            ),
            Divider(
              thickness: 0.5,
            ),
            BlocBuilder(
                bloc: _locationAuditCubit,
                builder: (context, state) {
                  if (state is LocationAuditSuccess) {
                    _locations = state.locations;
                    _auditTypes = state.auditTypes;
                  }
                  if (_locations != null && _auditTypes != null) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: const Color(0xff707070),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TypeaheadCombo<Location>(
                            minTextLength: 0,
                            selected: _selectedLocation,
                            getList: (text) async {
                              return _locations
                                  .where((location) => location.name
                                      .toLowerCase()
                                      .contains((text ?? '').toLowerCase()))
                                  .toList();
                              return state.locations;
                            },
                            onSelectedChanged: (value) {
                              FocusScope.of(context).unfocus();
                              setState(() => _selectedLocation = value);
                            },
                            itemBuilder:
                                (context, parameters, item, selected, text) =>
                                    Container(
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                /*border: Border(
                                  bottom: BorderSide(
                                      width: 0.5, color: AppConfig.grey),
                                ),*/
                              ),
                              child: ListTile(
                                  selected: selected,
                                  title: Text(
                                    item.name ?? '',
                                    style: TextStyle(
                                        color: selected
                                            ? AppConfig.primaryColor
                                            : AppConfig.primaryTextColor),
                                  )),
                            ),
                            onItemTapped: (item) {
                              FocusScope.of(context).unfocus();
                              setState(() => _selectedLocation = item);
                            },
                            getItemText: (item) => item.name,
                            decoration: new InputDecoration(
                                suffixIcon:
                                    Icon(Icons.keyboard_arrow_down_rounded),
                                border: new OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(15.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: AppConfig.textFieldFillColor)),
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(15.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: AppConfig.textFieldFillColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(15.0),
                                    ),
                                    borderSide: BorderSide(
                                        color: AppConfig.textFieldFillColor)),
                                filled: true,
                                hintStyle: new TextStyle(
                                    color: AppConfig.hintTextColor
                                        .withOpacity(0.5),
                                    fontSize: 14.sp),
                                hintText: "Set Location",
                                fillColor: AppConfig.textFieldFillColor,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15)),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Audit Type',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: const Color(0xff707070),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 1),
                            decoration: BoxDecoration(
                                color: AppConfig.textFieldFillColor,
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(15.0),
                                ),
                                border: Border.all(
                                    color: AppConfig.textFieldFillColor)),
                            child: DropdownButton<AuditType>(
                              dropdownColor: AppConfig.white,
                              icon: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 20,
                                  )),
                              hint: Text(
                                "Set Audit Type",
                                style: TextStyle(
                                    color: AppConfig.hintTextColor
                                        .withOpacity(0.5),
                                    fontSize: 14.sp),
                              ),
                              isExpanded: true,
                              value: _selectedAuditType,
                              underline: Container(), // this is the magic
                              items: _auditTypes
                                  .map<DropdownMenuItem<AuditType>>(
                                      (AuditType type) {
                                return DropdownMenuItem<AuditType>(
                                  value: type,
                                  child: Text(type.name),
                                );
                              }).toList(),
                              onChanged: (AuditType value) {
                                setState(() {
                                  _selectedAuditType = value;
                                });
                              },
                            ),
                          ),
                          /*ComboContext(
                            parameters: ComboParameters(
                              childDecoratorBuilder: (context, parameters, controller, child) => Container(
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                        width: 0.5, color: AppConfig.grey,
                                  ),
                                ),
                                child: child,
                              ),
                              childContentDecoratorBuilder: (context, parameters, controller, child) => Container(
                                decoration: new BoxDecoration(
                                  color: AppConfig.textFieldFillColor,
                                ),
                                child: child,
                              ),
                            ),
                            child: SelectorCombo<AuditType>(
                             // minTextLength: 0,
                              selected: _selectedAuditType,
                              getList: () async {
                                return _auditTypes.toList();
                                    */ /*.where((location) => location.name
                                        .toLowerCase()
                                        .contains((text ?? '').toLowerCase()))*/ /*
                                    //.toList();
                              },
                              onSelectedChanged: (value) {
                                FocusScope.of(context).unfocus();
                                setState(() => _selectedAuditType = value);
                              },
                              itemBuilder:
                                  (context, parameters, item, selected) =>
                                      Container(
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 0.5, color: AppConfig.grey),
                                  ),
                                ),
                                child: ListTile(
                                    selected: selected,
                                    title: Text(
                                      item.name ?? '',
                                      style: TextStyle(
                                          color: selected
                                              ? AppConfig.primaryColor
                                              : AppConfig.primaryTextColor),
                                    )),
                              ),
                              childBuilder: (context, parameters, item) => ListTile(
                                 // enabled: properties.enabled.value,
                                  title: Text(item.name ?? 'Selector Combo')),
                              onItemTapped: (item) {
                                FocusScope.of(context).unfocus();
                                setState(() => _selectedAuditType = item);
                              },
                              */ /*getItemText: (item) => item.name,
                              decoration: new InputDecoration(
                                  suffixIcon:
                                      Icon(Icons.keyboard_arrow_down_rounded),
                                  border: new OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                          color: AppConfig.textFieldFillColor)),
                                  enabledBorder: const OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                          color: AppConfig.textFieldFillColor)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(
                                          color: AppConfig.textFieldFillColor)),
                                  filled: true,
                                  hintStyle: new TextStyle(
                                      color: AppConfig.hintTextColor
                                          .withOpacity(0.5),
                                      fontSize: 14.sp),
                                  hintText: "Set Audit Type",
                                  fillColor: AppConfig.textFieldFillColor,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15)),*/ /*
                            ),
                          ),*/
                          SizedBox(
                            height: 40,
                          ),
                          BlocBuilder(
                            bloc: _locationAuditCubit,
                            builder: (context, state) {
                              bool buttonEnabled =
                                  !(state is LocationAuditSurveyBusy);

                              return RoundAppButton(
                                title: "START AUDIT",
                                isBusy: !buttonEnabled,
                                onPressed: () {
                                  _locationAuditCubit.getSurvey(
                                      location: _selectedLocation,
                                      auditType: _selectedAuditType);
                                },
                                padding: 0.0,
                              );
                            },
                          )
                        ],
                      ),
                    );
                  }
                  if (state is LocationAuditError) {
                    return Center(
                      child: ErrorMessage(
                        title: 'Failed to fetch new survey!',
                        message: 'Please try again',
                        buttonTitle: 'Retry',
                        onButtonPressed: () {
                          _locationAuditCubit.getLocationsAndAuditTypes();
                        },
                      ),
                    );
                  }
                  return LoaderAnimation();
                })
          ],
        ),
      ),
    );
  }
}
