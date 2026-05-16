import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'booking_details_form_screen.dart';

class EventSubtypeScreen extends StatelessWidget {
  final String eventType;
  const EventSubtypeScreen({super.key, required this.eventType});

  @override
  Widget build(BuildContext context) {
    final List<String> subTypes = ['Photography', 'Videography', 'Music', 'Photos + Videos + Music'];

    return Scaffold(
      appBar: AppBar(
        title: Text(eventType, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: subTypes.length,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Divider(color: Colors.grey[300], height: 1),
            ),
            itemBuilder: (context, index) {
              return FadeInRight(
                delay: Duration(milliseconds: 100 * index),
                child: ListTile(
                  title: Text(
                    subTypes[index],
                    style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => BookingDetailsFormScreen(eventType: eventType, subType: subTypes[index])));
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
