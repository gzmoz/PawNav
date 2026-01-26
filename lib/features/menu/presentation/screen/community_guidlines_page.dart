import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';

class CommunityGuidelinesPage extends StatelessWidget {
  const CommunityGuidelinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white4,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Community Guidelines',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          children: [
            Text(
              "To keep PawNav a safe and helpful space for every pet and pet parent, we ask all members to follow these core guidelines.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width * 0.038,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 28),

            const _GuidelineCard(
              icon: Icons.people_outline,
              title: 'Respect & Safety',
              description:
              'Be kind and respectful to all community members. Harassment, hate speech, or abuse is strictly not tolerated.',
            ),

            const _GuidelineCard(
              icon: Icons.verified_outlined,
              title: 'Honest & Accurate Posts',
              description:
              'Provide truthful information about lost and found pets. Misleading posts can delay critical reunions.',
            ),

            const _GuidelineCard(
              icon: Icons.pets_outlined,
              title: 'Animal Welfare',
              description:
              'The safety of every animal is our top priority. Treat all pets with care and never put them in dangerous situations.',
            ),

            const _GuidelineCard(
              icon: Icons.lock_outline,
              title: 'Privacy & Security',
              description:
              'Protect your personal data. Only share precise location details when necessary for pet recovery.',
            ),

            const _GuidelineCard(
              icon: Icons.warning_amber_rounded,
              title: 'Enforcement',
              description:
              'Violating these rules may result in content removal, account restrictions, or permanent bans.',
            ),


            const _GuidelineCard(
              icon: Icons.flag_outlined,
              title: 'Reporting',
              description:
              'If you encounter misleading posts, suspicious behavior, or content that violates these guidelines, please report it. Reporting helps keep PawNav safe and trustworthy for everyone.',
              secondary:
              'Reports are reviewed carefully and confidentially.',
            ),
          ],
        ),
      ),
    );
  }
}

class _GuidelineCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? secondary;

  const _GuidelineCard({
    required this.icon,
    required this.title,
    required this.description,
    this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.lightBlue,

              //color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: width * 0.06,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: width * 0.042,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: width * 0.036,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                if (secondary != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    secondary!,
                    style: TextStyle(
                      fontSize: width * 0.032,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

