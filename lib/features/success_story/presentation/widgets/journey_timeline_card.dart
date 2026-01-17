import 'package:flutter/material.dart';

class _JourneyTimelineCard extends StatelessWidget {
  final DateTime lostDate;
  final DateTime reunitedDate;
  final String location;

  const _JourneyTimelineCard({
    required this.lostDate,
    required this.reunitedDate,
    required this.location,
  });

  int get totalDays =>
      reunitedDate.difference(lostDate).inDays.abs();

  String _format(DateTime d) {
    return "${_month(d.month)} ${d.day}";
  }

  String _month(int m) {
    const months = [
      "JANUARY","FEBRUARY","MARCH","APRIL","MAY","JUNE",
      "JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER"
    ];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              const Text(
                "Journey Timeline",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Color(0xFF4B3FAF),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4B3FAF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "$totalDays DAYS TOTAL",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// TIMELINE ITEM 1
          _TimelineRow(
            dotColor: Colors.grey,
            date: _format(lostDate),
            text: "Reported Lost in $location",
          ),

          const SizedBox(height: 12),

          /// TIMELINE ITEM 2
          _TimelineRow(
            dotColor: const Color(0xFF2ECC71),
            date: _format(reunitedDate),
            text: "Safely Reunited with Family",
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final Color dotColor;
  final String date;
  final String text;
  final bool isLast;

  const _TimelineRow({
    required this.dotColor,
    required this.date,
    required this.text,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 28,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

