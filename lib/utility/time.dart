import 'package:jiffy/jiffy.dart';

/// Add the specified amount of days to `currentDate.`
String addDays(int days, String currentDate) {
  Jiffy jiffy = Jiffy(currentDate);
  jiffy.add(days: days);
  String formattedJiffy = jiffy.format('yyyy-MM-dd');
  return formattedJiffy;
}