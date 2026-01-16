import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/core/utils/time_ago.dart';
import 'package:pawnav/features/home/presentations/cubit/recent_activity_cubit.dart';
import 'package:pawnav/features/home/presentations/cubit/recent_activity_state.dart';
import 'package:pawnav/features/home/presentations/widgets/recent_activity_card.dart';

class RecentActivityPage extends StatelessWidget {
  const RecentActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Recent Activity",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<RecentActivityCubit, RecentActivityState>(
        builder: (context, state) {
          if (state is RecentActivityLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RecentActivityLoaded) {
            if (state.posts.isEmpty) {
              return const Center(
                child: Text("No recent activity yet."),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];

                return RecentActivityCard(
                  imageUrl: post.imageUrl,
                  title: "${post.postType}: ${post.name}",
                  subtitle:
                  "${post.location} • ${timeAgo(post.createdAt)}",
                  onTap: () {
                    context.push('/post-detail/${post.id}');
                  },
                );
              },
            );
          }

          if (state is RecentActivityError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
