import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawnav/core/utils/postType_chip_enum.dart';
import 'package:pawnav/features/home/presentations/cubit/featured_posts_cubit.dart';
import 'package:pawnav/features/home/presentations/cubit/featured_posts_state.dart';
import 'package:pawnav/features/home/presentations/widgets/most_viewed_pet_card.dart';

class MostViewedPetsPage extends StatefulWidget {
  const MostViewedPetsPage({super.key});

  @override
  State<MostViewedPetsPage> createState() => _MostViewedPetsPageState();
}

extension StringCasing on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}

class _MostViewedPetsPageState extends State<MostViewedPetsPage> {
  PetFilter selectedFilter = PetFilter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Most Viewed Pets",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: PetFilter.values.map((filter) {
          final isSelected = selectedFilter == filter;

          return ChoiceChip(
            label: Text(filter.name.capitalize()),
            selected: isSelected,
            onSelected: (_) {
              setState(() => selectedFilter = filter);
            },
            showCheckmark: false,
            side: BorderSide.none,
            shape: const StadiumBorder(),
            selectedColor: Colors.blueAccent,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildList() {
    return BlocBuilder<FeaturedPostsCubit, FeaturedPostsState>(
      builder: (context, state) {
        if (state is FeaturedPostsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FeaturedPostsLoaded) {
          final posts = state.posts;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return MostViewedPetCard(post: posts[index]);
            },
          );
        }

        if (state is FeaturedPostsError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
