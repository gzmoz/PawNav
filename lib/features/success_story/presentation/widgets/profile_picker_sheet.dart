import 'package:flutter/material.dart';
import '../../data/models/profile_model.dart';

class ProfilePickerResult {
  final ProfileModel profile;
  ProfilePickerResult(this.profile);
}

class ProfilePickerSheet extends StatefulWidget {
  final String title;
  final Future<List<ProfileModel>> Function(String query) onSearch;

  const ProfilePickerSheet({
    super.key,
    required this.title,
    required this.onSearch,
  });

  @override
  State<ProfilePickerSheet> createState() => _ProfilePickerSheetState();
}

class _ProfilePickerSheetState extends State<ProfilePickerSheet> {
  final _controller = TextEditingController();
  bool _loading = false;
  List<ProfileModel> _results = [];

  Future<void> _runSearch(String q) async {
    setState(() => _loading = true);
    try {
      _results = await widget.onSearch(q);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _runSearch(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 10, 16, 16 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Search by name or username',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 12),
          if (_loading) const LinearProgressIndicator(),
          const SizedBox(height: 8),
          SizedBox(
            height: 360,
            child: ListView.separated(
              itemCount: _results.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final p = _results[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: (p.photoUrl == null || p.photoUrl!.isEmpty) ? null : NetworkImage(p.photoUrl!),
                    child: (p.photoUrl == null || p.photoUrl!.isEmpty) ? const Icon(Icons.person) : null,
                  ),
                  title: Text(p.displayName),
                  subtitle: Text(p.username ?? ''),
                  onTap: () => Navigator.pop(context, ProfilePickerResult(p)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
