import 'package:finalproject/app/constants/shared_pref_constants.dart';
import 'package:finalproject/app/storage/shared_preferences.dart';
import 'package:finalproject/core/widgets/custom_dialogue.dart';
import 'package:finalproject/features/practice/presentation/state/practice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PracticeTaskView extends ConsumerStatefulWidget {
  const PracticeTaskView({super.key});

  @override
  ConsumerState<PracticeTaskView> createState() => _PracticeTaskViewState();
}

class _PracticeTaskViewState extends ConsumerState<PracticeTaskView> {
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _answerController.addListener(() {
      ref.read(practiceStateProvider.notifier).updateWordCount(_answerController.text);
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _resetCurrentQuestion() {
    _answerController.clear();
    ref.read(practiceStateProvider.notifier).resetCurrentQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final practiceState = ref.watch(practiceStateProvider);
    final practiceNotifier = ref.watch(practiceStateProvider.notifier);

    if (practiceState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (practiceState.errorMessage.isNotEmpty) {
      return Center(child: Text(practiceState.errorMessage));
    }

    final task = practiceState.tasks.isNotEmpty ? practiceState.tasks[practiceState.currentIndex] : null;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Practice Task'),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: practiceNotifier.nextQuestion,
            ),
          ],
        ),
        body: task != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Task: ${task.taskType}',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            practiceState.formattedTimer,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Image.network('http://192.168.0.105:3000/uploads/${task.imageUrl}'),
                      const SizedBox(height: 16),
                      const Text('Write one or more sentences about the image'),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(
                          hintText: 'Type Here...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 8),
                      Text('Word Count: ${practiceState.wordCount}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          practiceNotifier.submitAnswer(_answerController.text);
                          _answerController.clear();
                        },
                        child: const Text('Submit'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        onPressed: _resetCurrentQuestion,
                        label: const Text('Retry'),
                      ),
                      if (practiceState.submitted && practiceState.currentExplanation != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'Your Answer: ${practiceState.userAnswer}',
                                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'Example Answer: ${practiceState.currentExplanation}',
                                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SharedPref.sharedPref.getStringList(Constants.pricingCardValue)?.isNotEmpty ?? false
                                ? _buildProgressReport(practiceState)
                                : showCustomPremiumDialogue(
                                    title: 'Please subscribe to be a premium user to view progress report',
                                    context: context),
                          ],
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: practiceNotifier.nextQuestion,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next Question'),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8.0,
                        children: List<Widget>.generate(
                          practiceState.tasks.length,
                          (index) => ChoiceChip(
                            label: Text('${index + 1}'),
                            selected: practiceState.currentIndex == index,
                            onSelected: (selected) {
                              if (selected) {
                                practiceNotifier.goToQuestion(index);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const Center(child: Text('No tasks available')),
      ),
    );
  }

  Widget _buildProgressReport(PracticeState practiceState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progress Report:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildAnimatedBar('Overall Score', practiceState.overallScore),
        const SizedBox(height: 8),
        _buildAnimatedBar('Grammar Score', practiceState.grammarScore),
        const SizedBox(height: 8),
        _buildAnimatedBar('Spelling Score', practiceState.spellingScore),
      ],
    );
  }

  Widget _buildAnimatedBar(String label, double score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${score.toStringAsFixed(2)}%',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth; // The available width
            return Stack(
              children: [
                Container(
                  height: 20,
                  width: maxWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: 20,
                  width: maxWidth * (score / 100), // Adjust the width based on the percentage
                  decoration: BoxDecoration(
                    color: score < 40 ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
