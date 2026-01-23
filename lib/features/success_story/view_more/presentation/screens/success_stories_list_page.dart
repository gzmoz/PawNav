import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/success_stories_list_remote_ds.dart';
import '../cubit/success_stories_list_cubit.dart';
import '../cubit/success_stories_list_state.dart';
import '../widgets/success_story_filter_chips.dart';
import '../widgets/success_story_list_card.dart';
import '../widgets/success_story_search_bar.dart';

class SuccessStoriesListPage extends StatelessWidget {
  const SuccessStoriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SuccessStoriesListCubit(
        SuccessStoriesListRemoteDS(Supabase.instance.client),
      )..init(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Center(
            child: Text(
              'Success Stories',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            ),
          ),
          leading: const BackButton(color: Colors.black),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share, color: Colors.black),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<SuccessStoriesListCubit, SuccessStoriesListState>(
            builder: (context, state) {
              if (state is SuccessStoriesListLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is SuccessStoriesListError) {
                return Center(child: Text(state.message));
              }

              final s = state as SuccessStoriesListLoaded;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Search
                    SuccessStorySearchBar(
                      onChanged: context.read<SuccessStoriesListCubit>().onSearchChanged,
                    ),

                    const SizedBox(height: 12),

                    // Chips
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SuccessStoryFilterChips(
                        selected: s.filter,
                        onChanged: context.read<SuccessStoriesListCubit>().onFilterChanged,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // List
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: s.stories.length + 1, // + bottom section
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, i) {
                          if (i == s.stories.length) {
                            // Bottom: View Older Stories
                            if (!s.hasMore) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                child: Center(
                                  child: Text(
                                    'No more stories',
                                    style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              );
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Center(
                                child: TextButton(
                                  onPressed: s.isLoadingMore
                                      ? null
                                      : () => context.read<SuccessStoriesListCubit>().loadMore(),
                                  child: s.isLoadingMore
                                      ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                      : const Text(
                                    'View Older Stories',
                                    style: TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            );
                          }

                          final item = s.stories[i];
                          return SuccessStoryListCard(
                            item: item,
                            onTap: () {
                              context.push('/success-story/${item.id}');
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
