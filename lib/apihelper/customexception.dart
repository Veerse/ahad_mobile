
class CustomException implements Exception {
  final _message;
  final _prefix;
  final int _httpCode;

  CustomException([this._message, this._prefix, this._httpCode]);

  String toString() {
    return "$_prefix $_message";
  }

  int GetCode() {
    return _httpCode;
  }

  int get httpCode => _httpCode;
}

class FetchDataException extends CustomException {
  FetchDataException([String message])
      : super(message, "Error During Communication:");
}

// 400
class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request", 400);
}

// 401
class UnauthenticatedException extends CustomException {
  UnauthenticatedException([message]) : super(message, "Authentication requested", 401);
}

// 403
class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Not granted on resource", 403);
}

// 404
class NotFoundException extends CustomException {
  NotFoundException([message]) : super(message, "Resource not found", 404);
}

// 409
class ConflictException extends CustomException {
  ConflictException([message]) : super(message, "Conflict on resource: 409", 409);
}

class InvalidInputException extends CustomException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}