import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/core/utils/custom_snack.dart';

import '../cubit/write_success_story_cubit.dart';
import '../cubit/write_success_story_state.dart';
import '../widgets/pet_context_card.dart';
import '../widgets/people_row.dart';
import '../widgets/profile_picker_sheet.dart';

class WriteSuccessStoryPage extends StatefulWidget {
  final String postId;
  const WriteSuccessStoryPage({super.key, required this.postId});

  @override
  State<WriteSuccessStoryPage> createState() => _WriteSuccessStoryPageState();
}

class _WriteSuccessStoryPageState extends State<WriteSuccessStoryPage> {
  final _controller = TextEditingController();


  @override
  void initState() {
    super.initState();
    context.read<WriteSuccessStoryCubit>().init(widget.postId);
    _controller.addListener(() {
      context.read<WriteSuccessStoryCubit>().onStoryChanged(_controller.text);
    });
  }


   @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickHero(BuildContext context, WriteSuccessStoryLoaded s) async {
    final picked = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ProfilePickerSheet(
        title: 'Select Hero / Finder',
        onSearch: (q) => context.read<WriteSuccessStoryCubit>().searchPeople(q),
      ),
    );

    if (picked != null && picked is ProfilePickerResult) {
      context.read<WriteSuccessStoryCubit>().setHero(picked.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    return BlocConsumer<WriteSuccessStoryCubit, WriteSuccessStoryState>(
      listener: (context, state) {
          if (state is WriteSuccessStorySuccess) {
            AppSnackbar.success(context, "Success story is created!");
            context.go('/home');
            // context.pushReplacement('/post-detail/${widget.postId}');


            //context.go('/post-detail/${widget.postId}');
          }

          if (state is WriteSuccessStoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

        if (state is WriteSuccessStoryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },


      builder: (context, state) {
        if (state is WriteSuccessStoryLoading || state is WriteSuccessStoryInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is WriteSuccessStoryError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Write Success Story')),
            body: Center(child: Text(state.message)),
          );
        }

        final s = state as WriteSuccessStoryLoaded;

        // controller text sync (init sonrası)
        if (_controller.text != s.story) {
          _controller.value = _controller.value.copyWith(
            text: s.story,
            selection: TextSelection.collapsed(offset: s.story.length),
          );
        }

        final chars = s.story.length;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),

              //onPressed: () => context.go('/home', extra: 4),

              //onPressed: () => context.pop(4),
            ),
            centerTitle: true,
            title: const Text(
              'Write Success Story',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            actions: [
              TextButton(
                onPressed: () => context.go('/home', extra: 4),
                child: const Text('Cancel'),
              )
            ],
          ),

          // Bottom publish button
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: (s.canPublish && !s.isPublishing)
                      ? () => context.read<WriteSuccessStoryCubit>().publish()
                      : null,
                  icon: const Icon(Icons.send),
                  label: Text(s.isPublishing ? 'Publishing...' : 'Publish Success Story'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF18B394),
                    disabledBackgroundColor: const Color(0xFF6DB2A4).withOpacity(0.4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  /*style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC2C3C6),
                    disabledBackgroundColor: const Color(0xFF2B417A).withOpacity(0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),*/
                ),
              ),
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PetContextCard(
                  petName: s.petName,
                  species: s.species,
                  breed: s.breed,
                  imageUrl: s.coverImageUrl,
                  statusLabel: s.statusLabel,
                ),
                const SizedBox(height: 18),

                Text(
                  'How did it happen?',
                  style: TextStyle(fontSize: width * 0.052, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE6E9EF)),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _controller,
                        maxLines: 8,
                        maxLength: s.maxChars,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText:
                          'Share the happy news with the community! Tell us about the reunion or the moment your pet found home...',
                          hintStyle: TextStyle(color: Color(0xFF9AA3AF), fontSize: 18, height: 1.4),
                          counterText: '',
                        ),
                        style: const TextStyle(fontSize: 18, height: 1.5),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '$chars/${s.maxChars}',
                          style: const TextStyle(color: Color(0xFF6B7280)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),
                const Text(
                  'PEOPLE INVOLVED',
                  style: TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),

                // Owner row (locked)
                PeopleRow(
                  roleLabel: 'OWNER',
                  name: s.owner.displayName,
                  photoUrl: s.owner.photoUrl,
                  trailing: const _LockedBadge(),
                  onTap: null,
                ),
                const SizedBox(height: 10),

                // Hero row (selectable)
                PeopleRow(
                  roleLabel: 'HERO / FINDER',
                  name: s.hero?.displayName ?? 'Select user',
                  photoUrl: s.hero?.photoUrl,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (s.hero != null)
                        IconButton(
                          onPressed: () => context.read<WriteSuccessStoryCubit>().setHero(null),
                          icon: const Icon(Icons.close),
                        ),
                      IconButton(
                        onPressed: () => _pickHero(context, s),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  onTap: () => _pickHero(context, s),
                ),

                const SizedBox(height: 8),
                const Text(
                  'Add the person who helped reunite or adopt this pet.',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LockedBadge extends StatelessWidget {
  const _LockedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: const Text(
        'Locked',
        style: TextStyle(color: Color(0xFF1D4ED8), fontWeight: FontWeight.w700),
      ),
    );
  }
}
