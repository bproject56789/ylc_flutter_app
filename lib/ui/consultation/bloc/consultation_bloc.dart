import 'dart:async';

import 'package:rxdart/subjects.dart';
import 'package:ylc/api/consultation_api.dart';
import 'package:ylc/models/data_models/consultation_model.dart';
import 'package:ylc/models/data_models/user_model.dart';
import 'package:ylc/models/enums/consultation_type.dart';
import 'package:ylc/utils/api_result.dart';
import 'package:ylc/utils/helpers.dart';

class ConsultationBloc {
  Timer _timer;
  final _consultations = BehaviorSubject<List<ConsultationModel>>();

  Stream<List<ConsultationModel>> get consultations => _consultations.stream;

  void init(String userId) {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      ConsultationApi.fetchAllConsultationsOfUser(userId: userId).then((event) {
        _consultations.add(event);
      });
    });
  }

  Future<ApiResult> createConsultation({
    String advocateId,
    String userId,
    int time,
    String paymentId,
    ConsultationType type,
  }) async {
    ConsultationModel model = ConsultationModel(
      advocateDetails: UserModel().copyWith(id: advocateId),
      userDetails: UserModel().copyWith(id: userId),
      startTime: timestamp(),
      endTime: DateTime.now().add(Duration(hours: time)).millisecondsSinceEpoch,
      participants: [advocateId, userId],
      isOver: false,
      type: type,
      paymentId: paymentId,
    );

    return ConsultationApi.createConsultation(model);
  }

  void dispose() {
    _timer?.cancel();
    _consultations.close();
  }
}
