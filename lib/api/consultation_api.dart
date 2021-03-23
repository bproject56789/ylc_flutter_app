import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ylc/keys/keys.dart';
import 'package:ylc/models/data_models/consultation_model.dart';
import 'package:ylc/models/enums/consultation_type.dart';
import 'package:ylc/utils/api_result.dart';

class ConsultationApi {
  static String _endPoint = BaseUrl + 'consultations/';
  static Future<ApiResult> createConsultation(ConsultationModel model) async {
    try {
      var result = await http.post(
        _endPoint,
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        },
        body: json.encode(
          {
            "userId": model.userDetails.id,
            "advocateId": model.advocateDetails.id,
            "startTime": model.startTime,
            "endTime": model.endTime,
            "isOver": model.isOver,
            "participants": model.participants,
            "type": model.type.label,
            "paymentId": model.paymentId,
          },
        ),
      );
      print(result.body);
      if (result.statusCode == 201) {
        return ApiResult.successWithNoMessage();
      } else {
        return ApiResult.failure('Something went wrong');
      }
    } catch (e) {
      print(e);
      return ApiResult.failure('Something went wrong');
    }
  }

  static Future<List<ConsultationModel>> fetchAllConsultationsOfUser(
      {String userId}) async {
    try {
      var result = await http.get(
        _endPoint + userId,
      );

      if (result.statusCode == 200) {
        return consultationModelListFromMap(result.body);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
      return null;
    }
  }
}
