

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/features/success_story/presentation/cubit/edit_success_story_cubit.dart';
import 'package:pawnav/features/success_story/presentation/cubit/edit_success_story_state.dart';
import 'package:pawnav/features/success_story/presentation/widgets/people_row.dart';
import 'package:pawnav/features/success_story/presentation/widgets/pet_context_card.dart';
import 'package:pawnav/features/success_story/presentation/widgets/profile_picker_sheet.dart';

class EditSuccessStoryPage extends StatefulWidget {
  final String storyId;

  const EditSuccessStoryPage({super.key, required this.storyId});

  @override
  State<EditSuccessStoryPage> createState() => _EditSuccessStoryPageState();
}

class _EditSuccessStoryPageState extends State<EditSuccessStoryPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickHero(
      BuildContext context,
      EditSuccessStoryLoaded s,
      ) async {
    final cubit = context.read<EditSuccessStoryCubit>();

    final ProfilePickerResult? picked =
    await showModalBottomSheet<ProfilePickerResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ProfilePickerSheet(
        title: 'Select Hero / Finder',
        onSearch: cubit.searchPeople,
      ),

    );

    if (!mounted) return;

    if (picked != null) {
      cubit.setHero(picked.profile);
    }

  }



  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double width = screenInfo.size.width;

    return BlocConsumer<EditSuccessStoryCubit, EditSuccessStoryState>(
      listener: (context, state) {
        if (state is EditSuccessStorySuccess) {
          context.pop(true); // detail page’e geri dön
        }

        if (state is EditSuccessStoryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is EditSuccessStoryLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is EditSuccessStoryError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Edit Success Story')),
            body: Center(child: Text(state.message)),
          );
        }

        if (state is! EditSuccessStoryLoaded) {
          return const SizedBox.shrink();
        }

        final s = state;

        // controller sync
        if (_controller.text != s.story) {
          _controller.value = _controller.value.copyWith(
            text: s.story,
            selection: TextSelection.collapsed(offset: s.story.length),
          );
        }

        final chars = s.story.length;

        return Scaffold(
          backgroundColor: Colors.white,

          // APP BAR (write ile aynı)
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            centerTitle: true,
            title: const Text(
              'Edit Success Story',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Cancel'),
              )
            ],
          ),

          //  BOTTOM SAVE BUTTON (write ile aynı stil)
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: (s.canSave && !s.isSaving)
                      ? () => context.read<EditSuccessStoryCubit>().save()
                      : null,
                  icon: const Icon(Icons.save),
                  label: Text(
                    s.isSaving ? 'Saving...' : 'Save Changes',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF18B394),
                    disabledBackgroundColor:
                    const Color(0xFF6DB2A4).withOpacity(0.4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // BODY (write ile birebir)
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
                  style: TextStyle(
                    fontSize: width * 0.052,
                    fontWeight: FontWeight.w800,
                  ),
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
                        onChanged: context
                            .read<EditSuccessStoryCubit>()
                            .onStoryChanged,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText:
                          'Share the happy news with the community! Tell us about the reunion or the moment your pet found home...',
                          hintStyle: TextStyle(
                            color: Color(0xFF9AA3AF),
                            fontSize: 18,
                            height: 1.4,
                          ),
                          counterText: '',
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '$chars/${s.maxChars}',
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),
                const Text(
                  'PEOPLE INVOLVED',
                  style: TextStyle(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),

                // OWNER (locked)
                PeopleRow(
                  roleLabel: 'OWNER',
                  name: s.owner.displayName,
                  photoUrl: s.owner.photoUrl,
                  trailing: const _LockedBadge(),
                  onTap: null,
                ),
                const SizedBox(height: 10),

                // HERO (editable)
                PeopleRow(
                  roleLabel: 'HERO / FINDER',
                  name: s.hero?.displayName ?? 'Select user',
                  photoUrl: s.hero?.photoUrl,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (s.hero != null)
                        IconButton(
                          onPressed: () =>
                              context.read<EditSuccessStoryCubit>().setHero(null),
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
                // const Text(
                //   'Add the person who helped reunite or adopt this pet.',
                //   style: TextStyle(color: Color(0xFF6B7280)),
                // ),
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
        style: TextStyle(
          color: Color(0xFF1D4ED8),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
