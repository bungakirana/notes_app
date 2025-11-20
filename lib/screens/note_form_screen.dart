import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/note_form_cubit/note_form_cubit.dart';
import '../repositories/notes_repository.dart';
import '../models/note.dart';

class NoteFormScreen extends StatefulWidget {
  const NoteFormScreen({super.key});
  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  StreamSubscription<Note>? _cubitSub;

  @override
  void initState() {
    super.initState();

    // Ambil cubit dari context — diasumsikan NoteFormCubit
    // sudah disediakan oleh BlocProvider di parent (Navigator.push builder).
    final cubit = context.read<NoteFormCubit>();

    // Set initial nilai controller dari state cubit (berguna untuk edit)
    _titleController.text = cubit.state.title;
    _contentController.text = cubit.state.content;

    // Subscribe agar controller ter-update jika cubit mengemit perubahan (misal loadNote)
    _cubitSub = cubit.stream.listen((note) {
      // Hanya set jika berbeda untuk menghindari loop
      if (_titleController.text != note.title) {
        _titleController.text = note.title;
      }
      if (_contentController.text != note.content) {
        _contentController.text = note.content;
      }
    });
  }

  @override
  void dispose() {
    _cubitSub?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Catatan Baru'),
        actions: [IconButton(onPressed: _saveNote, icon: const Icon(Icons.save))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Judul'),
              onChanged: (value) {
                // Update cubit state saat user mengetik
                context.read<NoteFormCubit>().updateTitle(value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(hintText: 'Tulis catatanmu di sini...'),
                maxLines: null,
                expands: true,
                onChanged: (value) {
                  context.read<NoteFormCubit>().updateContent(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Simpan note ke repository lalu kembali ke list
  void _saveNote() async {
    final noteCubit = context.read<NoteFormCubit>();
    final noteRepository = context.read<NotesRepository>();

    // noteCubit.state diasumsikan bertipe Note
    await noteRepository.saveNote(noteCubit.state);
    // Setelah simpan, kembali
    if (mounted) Navigator.pop(context);
  }
}
