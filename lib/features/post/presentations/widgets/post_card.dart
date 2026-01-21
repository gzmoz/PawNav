import 'package:flutter/material.dart';

class PostCardComponent extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String location;
  final String description;
  final String status;
  final String timeAgoText;
  final VoidCallback? onTap;

  const PostCardComponent(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.location,
      required this.description,
      required this.status,
      required this.timeAgoText,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double width = screenInfo.size.width;
    final double height = screenInfo.size.height;

    Color statusColor;
    switch (status) {
      case "Lost":
        statusColor = Colors.red.shade300;
        break;
      case "Found":
        statusColor = Colors.green.shade400;
        break;
      case "Adoption":
        statusColor = Colors.orange.shade400;
        break;
      default:
        statusColor = Colors.grey;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.black.withOpacity(0.05),
        highlightColor: Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.02),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: height * 0.23,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //title + tag
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.grey),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(fontSize: width * 0.03),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          timeAgoText,
                          style: TextStyle(
                              fontSize: width * 0.032, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
