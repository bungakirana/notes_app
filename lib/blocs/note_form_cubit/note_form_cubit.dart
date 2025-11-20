import 'package:bloc/bloc.dart';
import '../../models/note.dart';

class NoteFormCubit extends Cubit<Note> {
  NoteFormCubit()
      : super(Note(
          title: '',
          content: '',
          createdAt: DateTime.now(),
        ));

  /// 🔹 Update judul catatan
  void updateTitle(String title) {
    emit(state.copyWith(title: title));
  }

  /// 🔹 Update isi catatan
  void updateContent(String content) {
    emit(state.copyWith(content: content));
  }

  /// 🔹 Reset form untuk catatan baru
  void reset() {
    emit(Note(
      title: '',
      content: '',
      createdAt: DateTime.now(),
    ));
  }

  /// 🔹 Load catatan yang sudah ada (untuk edit)
  void loadNote(Note note) {
    emit(note);
  }
}
