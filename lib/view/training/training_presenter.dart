import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/training_model.dart';

abstract class TrainingViewContract {
  void onTrainingListLoaded(List<Training> trainings);
  void onError(String message);
}

class TrainingPresenter {
  final TrainingViewContract view;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TrainingPresenter(this.view);

  void loadTrainings() async {
    try {
      final snapshot = await _firestore.collection('training').get();
      print('Documents found: ${snapshot.docs.length}'); //debug

      final trainings = snapshot.docs.map((doc) {
        print('Document: ${doc.data()}'); //debug
        return Training.fromFirestore(doc.data(), doc.id);
      }).toList();

      view.onTrainingListLoaded(trainings);
    } catch (e) {
      print('Error loading trainings: $e'); //debug
      view.onError('Failed to load trainings: $e');
    }
  }
}
