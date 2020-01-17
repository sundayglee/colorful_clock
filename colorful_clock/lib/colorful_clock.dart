// Copyright 2020 Godfrey E. Laswai <sundayglee@gmail.com>. 
// All rights reserved.
//
// Use of this source code is governed by a BSD-3-Clause license that can be
// found in the BSD-LICENSE file or see it here <https://opensource.org/licenses/BSD-3-Clause>.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFFEEEEEE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

/// A Colorful digital clock.
///
/// 
class ColorfulClock extends StatefulWidget {
  const ColorfulClock(this.model);

  final ClockModel model;

  @override
  _ColorfulClockState createState() => _ColorfulClockState();
}

class _ColorfulClockState extends State<ColorfulClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(ColorfulClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update every seconds
      _timer = Timer(
        Duration(seconds: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final _hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final _minute = DateFormat('mm').format(_dateTime);
    final _second = DateFormat('ss').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 3.0;
    final _month = DateFormat('MMM').format(_dateTime);
    final _day = _dateTime.day;
    final _dayString = DateFormat('EEEE').format(_dateTime);
    final _temperature = widget.model.temperatureString;
    final _location = widget.model.location;

    IconData _weather = new IconData(null);

    /// A Selection of Icon according to the weatherString from model
    /// Related icons where choosen since Google Material Icons had no dedicated weather icons
    switch (widget.model.weatherString) {
      case 'cloudy':
        _weather = Icons.cloud;
        break;
      case 'foggy':
        _weather = Icons.blur_on;
        break;
      case 'rainy':
        _weather = Icons.beach_access;
        break;
      case 'snowy':
        _weather = Icons.ac_unit;
        break;
      case 'sunny':
        _weather = Icons.wb_sunny;
        break;
      case 'thunderstorm':
        _weather = Icons.flash_on;
        break;
      case 'windy':
        _weather = Icons.toys;
        break;
      case 'default':
        _weather = Icons.error;
    }

    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'SairaExtraCondensed',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(4, 0),
        ),
      ],
    );

    return Container(
      color: colors[_Element.background],
      child: Center(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 2,
                top: 2,
                // Blue Circle and its content
                child: blueCircle(_location, _hour, _minute, _second),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 1.6,
                bottom: 2,
                // Orange Circle with its content
                child: orangeCircle(_day, _month, _dayString),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 1.85,
                top: 2,
                // Red Circle with its content
                child: redCircle(_temperature),
              ),
              Positioned(
                right: MediaQuery.of(context).size.width / 75,
                top: 2,
                // Green Circle with its content
                child: greenCircle(_weather),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  // Widget Definition starts here
  //
  /// Blue Circle Widget definitions including its content
  Widget blueCircle(
      String location, String hour, String minute, String second) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.8,
      height: MediaQuery.of(context).size.width / 1.8,
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            location,
            style: new TextStyle(
              fontSize: MediaQuery.of(context).size.width / 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 2.5,
              shadows: [
                Shadow(
                  blurRadius: 0,
                  color: Colors.black,
                  offset: Offset(2, 0),
                ),
              ],
            ),
          ),
          Text(
            "$hour:$minute",
            style: new TextStyle(
              fontSize: MediaQuery.of(context).size.width / 4.0,
              color: Colors.white,
              height: 1,
            ),
          ),
          Text(
            second,
            style: new TextStyle(
              fontSize: MediaQuery.of(context).size.width / 12.0,
              color: Colors.white,
              height: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  /// Orange Circle Widget definitions including its content
  Widget orangeCircle(day, month, dayString) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.3,
      height: MediaQuery.of(context).size.width / 3.3,
      decoration: BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "$day $month",
            style: new TextStyle(
              fontSize: MediaQuery.of(context).size.width / 17.0,
              color: Colors.black,
              height: 1,
              shadows: [
                Shadow(
                  blurRadius: 0,
                  color: Colors.white60,
                  offset: Offset(2, 0),
                ),
              ],
            ),
          ),
          Text(
            dayString,
            style: new TextStyle(
              fontSize: MediaQuery.of(context).size.width / 14.0,
              color: Colors.black,
              height: 1.5,
              shadows: [
                Shadow(
                  blurRadius: 0,
                  color: Colors.white60,
                  offset: Offset(2, 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Red Circle Widget definitions including its content
  Widget redCircle(temperature) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.9,
      height: MediaQuery.of(context).size.width / 3.9,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          temperature,
          style: new TextStyle(
            fontSize: MediaQuery.of(context).size.width / 10.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Green Circle Widget definitions including its content
  Widget greenCircle(weather) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width / 35),
      width: MediaQuery.of(context).size.width / 7.5,
      height: MediaQuery.of(context).size.width / 7.5,
      // Couldn't find a simpler way to add shadow to the icon.
      // A better alternative is to create an already shadowed icon and import it as asset.
      // But didn't do that because the rules specified (only) Google Material Icon are to be used
      // Well this works but the icon has no shadow.
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Icon(
            weather,
            color: Colors.black,
            size: MediaQuery.of(context).size.width / 3.5,
          ),
        ),
      ),
    );
  }
}
