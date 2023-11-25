import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:kumuly_pocket/enums/payment_direction.dart';

@immutable
class ContactListItem extends Equatable {
  final String contactName;
  final String? contactImagePath;
  final String? description;
  final int? timestamp;
  final PaymentDirection? direction;
  final bool isNewContact;
  final bool hasUnreadMessage;

  const ContactListItem({
    required this.contactName,
    this.contactImagePath,
    this.description,
    this.timestamp,
    this.direction,
    this.isNewContact = false,
    this.hasUnreadMessage = false,
  });

  String get dateTime {
    if (timestamp == null) return '';

    final DateTime date =
        DateTime.fromMillisecondsSinceEpoch(timestamp! * 1000);
    final DateTime now = DateTime.now();

    // Check if the date is today
    final bool isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    if (isToday) {
      // Return only the hour if it's today
      return DateFormat.jm().format(date);
    } else {
      // Return only the date if it's not today
      return DateFormat.yMd().format(date);
    }
  }

  @override
  List<Object?> get props => [
        contactName,
        contactImagePath,
        description,
        timestamp,
        direction,
        isNewContact,
        hasUnreadMessage,
      ];
}
