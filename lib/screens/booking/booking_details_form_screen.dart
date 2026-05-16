import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'professional_selection_screen.dart';

class BookingDetailsFormScreen extends StatefulWidget {
  final String eventType;
  final String subType;
  const BookingDetailsFormScreen({super.key, required this.eventType, required this.subType});

  @override
  State<BookingDetailsFormScreen> createState() => _BookingDetailsFormScreenState();
}

class _BookingDetailsFormScreenState extends State<BookingDetailsFormScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shoot Details'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(child: _buildSummaryHeader()),
            const SizedBox(height: 35),
            _buildFieldLabel('Where is the event?'),
            _buildTextField(_locationController, 'Enter location (City/Venue)', Icons.location_on_rounded),
            const SizedBox(height: 25),
            _buildFieldLabel('When is the event?'),
            _buildDatePicker(context),
            const SizedBox(height: 25),
            _buildFieldLabel('Estimated Budget (\u20B9)'),
            _buildTextField(_budgetController, 'Enter your budget range', Icons.account_balance_wallet_rounded, isNumber: true),
            const SizedBox(height: 50),
            FadeInUp(
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfessionalSelectionScreen())),
                child: Container(
                  width: double.infinity, height: 60,
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFFF5252)]), borderRadius: BorderRadius.circular(18)),
                  child: const Center(child: Text('Find Professionals', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome_rounded, color: Color(0xFFE91E63)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.eventType, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(widget.subType, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800)));
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFFE91E63), size: 20),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2030));
        if (date != null) setState(() => _selectedDate = date);
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, color: Color(0xFFE91E63), size: 20),
            const SizedBox(width: 15),
            Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}', style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
