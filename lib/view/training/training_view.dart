import 'package:deserve/view/training/training_presenter.dart';
import 'package:flutter/material.dart';
import '../../model/training_model.dart';
// import 'training_presenter.dart';
// import 'training_presenter.dart';

class TrainingView extends StatefulWidget {
  const TrainingView({super.key});

  @override
  _TrainingViewState createState() => _TrainingViewState();
}

class _TrainingViewState extends State<TrainingView>
    implements TrainingViewContract {
  late TrainingPresenter _presenter;
  List<Training> _trainings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _presenter = TrainingPresenter(this);
    _presenter.loadTrainings();
  }

  @override
  void onTrainingListLoaded(List<Training> trainings) {
    setState(() {
      _trainings = trainings;
      _isLoading = false;
    });
  }

  @override
  void onError(String message) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Training List')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _trainings.isEmpty
              ? const Center(child: Text('No trainings available.'))
              : ListView.builder(
                  itemCount: _trainings.length,
                  itemBuilder: (context, index) {
                    final training = _trainings[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(training.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(training.description),
                            Text('Date: ${training.date}'),
                            Text(
                                'Time: ${training.startTime} - ${training.endTime}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
