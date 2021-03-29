import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class LangChange  {
 StreamController<Locale>   controller = BehaviorSubject<Locale>();
 Stream<Locale> get out=>controller.stream;

}