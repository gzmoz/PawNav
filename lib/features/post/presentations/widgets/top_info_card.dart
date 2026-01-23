import 'package:flutter/material.dart';

class TopInfoCard extends StatelessWidget {
  final String name;
  final String breed;
  final int views;
  final String postDate;
  final String postedAgo;

  const TopInfoCard(
      {super.key,
      required this.name,
      required this.breed,
      required this.views,
      required this.postedAgo, required this.postDate});

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    // final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: width * 0.065,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.remove_red_eye_outlined,
                      size: 15,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      views.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                        fontSize: width * 0.028,

                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            breed,
            style: TextStyle(
              color: Colors.black54,
              fontSize: width * 0.04,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined, size: 16, color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    postDate,
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600,
                      fontSize: width * 0.03,

                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  const Icon(
                    Icons.access_time, size: 16, color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    postedAgo,
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600,
                      fontSize: width * 0.03,

                    ),
                  ),
                ],
              ),


            ],
          ),
        ],
      ),
    );
  }
}
