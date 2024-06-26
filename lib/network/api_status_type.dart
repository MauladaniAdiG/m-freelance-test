enum ApiStatusType {
  SUCCESS,
  BAD_REQUEST,
  INTERNAL_SERVER_ERROR,
  OK,
  UNDEFINED,
}

extension ApiStatusTypeExtension on ApiStatusType {
  static ApiStatusType fromString(String? val) {
    if (val?.isEmpty ?? true) return ApiStatusType.UNDEFINED;
    return ApiStatusType.values.firstWhere(
      (element) => element.name == val?.toUpperCase(),
      orElse: () => ApiStatusType.UNDEFINED,
    );
  }
}
