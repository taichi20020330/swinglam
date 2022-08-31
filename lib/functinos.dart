
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;


String createTimeAgoString (DateTime postDateTime){
  final now = DateTime.now();
  final difference = now.difference(postDateTime);
  return timeago.format(now.subtract(difference), locale: "ja");
}