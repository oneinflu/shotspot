import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'combo_selection_screen.dart';

class ComboConfigScreen extends StatefulWidget {
  const ComboConfigScreen({super.key});

  @override
  State<ComboConfigScreen> createState() => _ComboConfigScreenState();
}

class _ComboConfigScreenState extends State<ComboConfigScreen> {
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);
  int duration = 2;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE91E63),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Booking Details',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 20, color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            FadeInDown(
              child: Text(
                'When do you need the team?',
                style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            FadeInDown(
              delay: const Duration(milliseconds: 100),
              child: Text(
                'Select your preferred date and time for the shoot.',
                style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 40),
            
            _buildSelectionTile(
              'Shoot Date',
              DateFormat('EEE, d MMM yyyy').format(selectedDate),
              Icons.calendar_today_rounded,
              () => _selectDate(context),
            ),
            const SizedBox(height: 20),
            _buildSelectionTile(
              'Start Time',
              selectedTime.format(context),
              Icons.access_time_rounded,
              () => _selectTime(context),
            ),
            const SizedBox(height: 40),
            
            Text(
              'Shoot Duration',
              style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            _buildDurationSelector(),
            
            const SizedBox(height: 60),
            FadeInUp(
              child: GestureDetector(
                onTap: () {
                  final timeStr = "${selectedTime.hour.toString().padLeft(2, '0')}:00"; // Simplified for now
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ComboSelectionScreen(
                        date: selectedDate,
                        startTime: timeStr,
                        duration: duration,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFFF5252)]),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE91E63).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Find Available Talents',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionTile(String label, String value, IconData icon, VoidCallback onTap) {
    return FadeInUp(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFE91E63).withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
                child: Icon(icon, color: const Color(0xFFE91E63), size: 22),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800)),
                ],
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [2, 4, 6, 8].map((d) {
        bool isSelected = duration == d;
        return GestureDetector(
          onTap: () => setState(() => duration = d),
          child: Container(
            width: 70,
            height: 50,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE91E63) : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: isSelected ? const Color(0xFFE91E63) : Colors.black.withOpacity(0.05)),
            ),
            child: Center(
              child: Text(
                '${d}h',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
