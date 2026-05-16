import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String time;

  NotificationModel({required this.id, required this.title, required this.body, required this.time});
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> notifications = [
    NotificationModel(id: '1', title: 'Booking Confirmed!', body: 'Your wedding shoot with @director_pro is confirmed for tomorrow.', time: '2m ago'),
    NotificationModel(id: '2', title: 'New Shot Uploaded', body: 'A new cinematic reel has been added to your favorites.', time: '1h ago'),
    NotificationModel(id: '3', title: 'Exclusive Deal', body: 'Get 20% off on your next "Cinematic Combo" package.', time: '5h ago'),
    NotificationModel(id: '4', title: 'Payment Success', body: 'Your payment for "Outdoor Portrait" was successful.', time: 'Yesterday'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
        centerTitle: true,
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () => setState(() => notifications.clear()),
              child: const Text('Clear All', style: TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: FadeIn(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[300]),
                    const SizedBox(height: 20),
                    Text('No notifications yet', style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 16)),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return FadeInUp(
                  delay: Duration(milliseconds: 100 * index),
                  child: Dismissible(
                    key: Key(item.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() => notifications.removeAt(index));
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
                      child: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5)),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: const Color(0xFFE91E63).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.notifications_active_rounded, color: Color(0xFFE91E63), size: 20),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item.title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 15)),
                                    Text(item.time, style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 11)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(item.body, style: GoogleFonts.plusJakartaSans(color: Colors.grey[600], fontSize: 13, height: 1.4)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
