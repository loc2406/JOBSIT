class GetCandidateDetailRequestModel {
  final int candidateId;

  const GetCandidateDetailRequestModel(
      {required this.candidateId});

  Map<String, dynamic> toJson() {
    return {
      "candidateId": candidateId,
    };
  }
}
