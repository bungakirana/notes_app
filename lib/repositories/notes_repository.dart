import 'package:hive/hive.dart';
import '../models/note.dart';

class NotesRepository {
  final Box<Map> notesBox;

  NotesRepository(this.notesBox);

  // Menyimpan note baru
  Future<void> saveNote(Note note) async {
    // Tambah note baru ke Hive dan dapatkan ID-nya
    final id = await notesBox.add(note.toMap());

    // Buat salinan note dengan ID baru (jika copyWith sudah ada)
    final updatedNote = note.copyWith(id: id);

    // Simpan kembali ke Hive dengan ID tersebut
    await notesBox.put(id, updatedNote.toMap());
  }

  // Mengambil semua note
  List<Note> getAllNotes() {
    return notesBox.values
        .map((map) => Note.fromMap(Map<String, dynamic>.from(map)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Urutkan terbaru
  }

  // Menghapus note berdasarkan ID
  Future<void> deleteNote(int id) async {
    await notesBox.delete(id);
  }
}
