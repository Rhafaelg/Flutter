import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Dados do aluno
const String kStudentName = 'RHAFAEL GONÇALVES DE ALMEIDA';
const String kStudentRa = '1174497-1';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber Tasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050816),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9F2BFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: AuthScreen(taskManager: TaskManager()),
    );
  }
}

/// ==== MODELO DE TAREFA E GERENCIADOR ===============================

class Task {
  Task({required this.title, this.isDone = false});

  String title;
  bool isDone;
}

class TaskManager {
  final Map<String, List<Task>> _tasksByDate = {};

  String _keyFor(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  List<Task> tasksFor(DateTime date) {
    final key = _keyFor(date);
    return _tasksByDate[key] ?? <Task>[];
  }

  void addTask(DateTime date, String title) {
    final key = _keyFor(date);
    final list = _tasksByDate.putIfAbsent(key, () => <Task>[]);
    list.add(Task(title: title));
  }

  void toggleTask(DateTime date, Task task) {
    task.isDone = !task.isDone;
  }

  void removeTask(DateTime date, Task task) {
    final key = _keyFor(date);
    _tasksByDate[key]?.remove(task);
  }
}

/// ==== TELA DE LOGIN / CADASTRO ====================================

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.taskManager});

  final TaskManager taskManager;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginMode = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    // Aqui você poderia validar email/senha.
    // Para o trabalho, basta navegar para o calendário.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CalendarScreen(
          taskManager: widget.taskManager,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF050816),
              Color(0xFF130B2F),
              Color(0xFF2B0B3F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Cartão com RA
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: _StudentCard(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      width: media.size.width * 0.9,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF5A00FF),
                            Color(0xFFE000FF),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xAAE000FF),
                            blurRadius: 18,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                isLoginMode ? 'Entrar' : 'Cadastrar',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Icon(
                                Icons.checklist_rounded,
                                size: 32,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _NeonTextField(
                            label: 'Email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          _NeonTextField(
                            label: 'Senha',
                            controller: _passwordController,
                            obscureText: true,
                          ),
                          if (!isLoginMode) ...[
                            const SizedBox(height: 16),
                            _NeonTextField(
                              label: 'Confirmar senha',
                              controller: _confirmController,
                              obscureText: true,
                            ),
                          ],
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1B0028),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: _submit,
                              child: Text(
                                isLoginMode ? 'Entrar' : 'Cadastrar',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLoginMode = !isLoginMode;
                              });
                            },
                            child: Center(
                              child: RichText(
                                text: TextSpan(
                                  text: isLoginMode
                                      ? 'Não é cadastrado? '
                                      : 'Já possui conta? ',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: isLoginMode
                                          ? 'Cadastre-se'
                                          : 'Entrar',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Cartão com nome e RA (estilo cyberpunk)
class _StudentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Bem-vindo,',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF444444),
            ),
          ),
          SizedBox(height: 4),
          Text(
            kStudentName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111111),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'MEU RA: $kStudentRa',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
            ),
          ),
        ],
      ),
    );
  }
}

class _NeonTextField extends StatelessWidget {
  const _NeonTextField({
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0x33000000),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.white24,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1.6,
          ),
        ),
      ),
    );
  }
}

/// ==== TELA DE CALENDÁRIO ==========================================

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key, required this.taskManager});

  final TaskManager taskManager;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  void _openTasks() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TaskListScreen(
          taskManager: widget.taskManager,
          date: _selectedDate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário'),
        backgroundColor: const Color(0xFF130B2F),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF050816),
              Color(0xFF120B2C),
              Color(0xFF2B0B3F),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bem Vindo,\n${kStudentName.split(' ').first}!',
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'RA: $kStudentRa',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1035),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          'Selecione o dia',
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatDate(_selectedDate),
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: CalendarDatePicker(
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                            onDateChanged: (d) {
                              setState(() {
                                _selectedDate = d;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE000FF),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: _openTasks,
                            child: const Text(
                              'Selecionar o dia',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// ==== TELA DE LISTA DE TAREFAS ====================================

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({
    super.key,
    required this.taskManager,
    required this.date,
  });

  final TaskManager taskManager;
  final DateTime date;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  Future<void> _addTask() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B1035),
          title: const Text(
            'Nova tarefa',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Descrição da tarefa',
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.of(ctx).pop(controller.text.trim());
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        widget.taskManager.addTask(widget.date, result);
      });
    }
  }

  void _toggleTask(Task task) {
    setState(() {
      widget.taskManager.toggleTask(widget.date, task);
    });
  }

  void _removeTask(Task task) {
    setState(() {
      widget.taskManager.removeTask(widget.date, task);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = List<Task>.from(widget.taskManager.tasksFor(widget.date));

    // Ordenação: pendentes primeiro, depois concluídas; dentro de cada grupo, alfabética
    tasks.sort((a, b) {
      if (a.isDone == b.isDone) {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
      return a.isDone ? 1 : -1; // false (pendente) vem antes de true (concluída)
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Dia ${_formatDate(widget.date)}'),
        backgroundColor: const Color(0xFF130B2F),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: const Color(0xFFE000FF),
        child: const Icon(Icons.add),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF050816),
              Color(0xFF120B2C),
              Color(0xFF2B0B3F),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bem Vindo,\n${kStudentName.split(' ').first}!',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Dia ${_formatDate(widget.date)}',
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1035),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: tasks.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhuma tarefa para este dia.\nUse o botão + para adicionar.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (ctx, index) {
                              final task = tasks[index];
                              return Dismissible(
                                key: ValueKey(task.hashCode.toString() +
                                    task.title +
                                    task.isDone.toString()),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) => _removeTask(task),
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 24),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                child: Card(
                                  color: const Color(0xFF25154D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      task.isDone
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      color: task.isDone
                                          ? const Color(0xFF4ADE80) // verde
                                          : const Color(0xFF60A5FA), // azul
                                    ),
                                    title: Text(
                                      task.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        decoration: task.isDone
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                    subtitle: Text(
                                      task.isDone
                                          ? 'Concluída'
                                          : 'Em andamento',
                                      style: TextStyle(
                                        color: task.isDone
                                            ? Colors.greenAccent
                                            : Colors.amberAccent,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      color: Colors.white70,
                                      onPressed: () => _removeTask(task),
                                    ),
                                    onTap: () => _toggleTask(task),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
