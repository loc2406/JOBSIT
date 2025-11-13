import 'package:jobsit_mobile/core/services/job_services.dart';
import 'package:jobsit_mobile/core/constants/value_constants.dart';

import '../../data/models/job.dart';

class ConvertConstants {
  
  static String getMessageFromException(String exception){
    final regex = RegExp(r"Exception:\s*(.*)");
    final match = regex.firstMatch(exception);
    return match?.group(1) ?? exception;
  }
  
  static List<JobPosition> convertToListJobPositions(List<dynamic> list) {
    return list
        .map((map) => JobPosition.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  static List<JobSchedule> convertToListJobSchedules(List<dynamic> list) {
    return list
        .map((map) => JobSchedule.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  static List<Job> convertToListJobs(List<dynamic> list) {
    return list
        .map((jobMap) => Job.fromMap(jobMap as Map<String, dynamic>))
        .toList();
  }

  static List<Job> convertToListSavedJobs(List<dynamic> list) {
    return list
        .map((jobMap) => Job.fromSavedMap(jobMap as Map<String, dynamic>))
        .toList();
  }

  static List<Job> convertToListAppliedJobs(List<dynamic> list) {
    return list
        .map((jobMap) => Job.fromAppliedMap(jobMap as Map<String, dynamic>))
        .toList();
  }

  static String getNameById(List<Map<String, dynamic>> map, int id) {
    if (id == -1) return '';
    Map<String, dynamic> element = map.firstWhere(
        (element) => element[JobServices.idKey] == id,
        orElse: () => {} as Map<String, Object>);
    return element.isNotEmpty ? element[JobServices.nameKey].toString() : '';
  }

  static int getIdByName(List<Map<String, dynamic>> map, String name) {
    if (name.isEmpty) return -1;
    Map<String, dynamic> element = map.firstWhere(
            (element) => element[JobServices.nameKey] == name,
        orElse: () => {} as Map<String, Object>);
    return element.isNotEmpty ? (int.tryParse(element[JobServices.idKey].toString()) ?? -1) : -1;
  }

  static Map<String, dynamic> getElementById(
      List<Map<String, dynamic>> map, int id) {
    if (id == -1) return {};
    return map.firstWhere((schedule) => schedule[JobServices.idKey] == id,
        orElse: () => {} as Map<String, Object>);
  }

  static double convertVNDToUSD(double vnd) {
    double usd = vnd / ValueConstants.exchangeRateFromUSDToVND;
    return double.parse(usd.toStringAsFixed(2));
  }
}
