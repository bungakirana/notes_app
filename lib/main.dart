import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'repositories/notes_repository.dart';
import 'blocs/notes_list_bloc/notes_list_bloc.dart';
import 'screens/notes_list_screen.dart';

void main() async {
  // ✅ Pastikan Flutter siap sebelum menjalankan async code
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inisialisasi Hive
  await Hive.initFlutter();

  // ✅ Buka box bernama 'notesBox' untuk menyimpan catatan
  await Hive.openBox('notesBox');

  // ✅ Jalankan aplikasi utama
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => NotesRepository(Hive.box('notesBox')),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                NotesListBloc(context.read<NotesRepository>())..add(LoadNotes()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Notes App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const NotesListScreen(),
        ),
      ),
    );
  }
}
