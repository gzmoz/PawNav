import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/features/account/presentations/cubit/account_status_cubit.dart';
import 'package:pawnav/features/success_story/presentation/cubit/account_success_stories_cubit.dart';
import 'package:pawnav/features/success_story/presentation/cubit/account_success_stories_state.dart';
import 'package:pawnav/features/success_story/presentation/widgets/success_story_grid_card.dart';

class SuccessStoriesGrid extends StatelessWidget {
  const SuccessStoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountSuccessStoriesCubit,
        AccountSuccessStoriesState>(
      builder: (context, state) {
        if (state is AccountSuccessStoriesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AccountSuccessStoriesError) {
          return Center(child: Text(state.message));
        }

        if (state is! AccountSuccessStoriesLoaded) {
          return const SizedBox.shrink();
        }

        if (state.stories.isEmpty) {
          return const Center(
            child: Text(
              "Success stories will appear here.",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.fromLTRB(
            12,
            12,
            12,
            12 +
                MediaQuery.of(context).padding.bottom +
                kBottomNavigationBarHeight,
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: state.stories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            final item = state.stories[index];

            return SuccessStoryGridCard(
              imageUrl: item.imageUrl ?? '',
              petName: item.petName,
              subtitle: item.story.story,
              isAdopted: item.isAdopted,
              onTap: () async {
                final result = await context.push<String>(
                  '/success-story/${item.story.id}',
                );

                if (result == 'story_deleted') {
                  context.read<AccountSuccessStoriesCubit>()
                      .loadMySuccessStories();

                  context.read<AccountStatsCubit>().refresh();
                }
              },

              /*onTap: () async {
                final deletedStoryId = await context.push<String>(
                  '/success-story/${item.story.id}',
                );

                if (deletedStoryId != null) {
                  context.read<AccountSuccessStoriesCubit>()
                      .removeStory(deletedStoryId);

                  context.read<AccountStatsCubit>().refresh();
                }
              },*/

              /*onTap: () async {
                final deleted = await context.push<bool>(
                  '/success-story/${item.story.id}',
                );

                if (deleted == true) {
                  context
                      .read<AccountSuccessStoriesCubit>()
                      .loadMySuccessStories();

                  context.read<AccountStatsCubit>().loadStats();
                }

              },*/
            );
          },
        );
      },
    );
  }
}

