import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../inventory/presentation/inventory_provider.dart';
import '../../../shared/glass_container.dart';

class SalesCalendarScreen extends ConsumerWidget {
  const SalesCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = ref.watch(inventoryListProvider).value ?? [];
    final soldArticles = articles.where((a) => a.status == 'Vendu').toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Calendrier des Ventes')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: GlassContainer(
                padding: const EdgeInsets.all(10),
                child: TableCalendar(
                  focusedDay: DateTime.now(),
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(color: Colors.blue.withOpacity(0.3), shape: BoxShape.circle),
                    markerDecoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                  ),
                  eventLoader: (day) {
                    return soldArticles.where((a) => isSameDay(a.updatedAt, day)).toList();
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Ventes du jour', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            ...soldArticles.where((a) => isSameDay(a.updatedAt, DateTime.now())).map((a) => ListTile(
              leading: const Icon(Icons.monetization_on, color: Colors.green),
              title: Text(a.title),
              trailing: Text('${a.sellingPrice}€', style: const TextStyle(fontWeight: FontWeight.bold)),
            )),
          ],
        ),
      ),
    );
  }
}
