import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  Type get runtimeType => runtimeType;
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkFailure && message == other.message;
  
  @override
  int get hashCode => message.hashCode;
  
  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerFailure && message == other.message;
  
  @override
  int get hashCode => message.hashCode;
  
  @override
  List<Object?> get props => [message];
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationFailure && message == other.message;
  
  @override
  int get hashCode => message.hashCode;
  
  @override
  List<Object?> get props => [message];
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(String message) : super(message);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotFoundFailure && message == other.message;
  
  @override
  int get hashCode => message.hashCode;
  
  @override
  List<Object?> get props => [message];
}

class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure(String message) : super(message);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermissionDeniedFailure && message == other.message;
  
  @override
  int get hashCode => message.hashCode;
  
  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheFailure && message == other.message;
  
  @override
  int get hashCode => message.hashCode;
  
  @override
  List<Object?> get props => [message];
}

class StorageFailure extends Failure {
  const StorageFailure(String message) : super(message);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StorageFailure && message == other.message;
  
  @override
  int get hashCode => message.hashCode;
  
  @override
  List<Object?> get props => [message];
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(String message) : super(message);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthenticationFailure && message == other.message;
  
  @override
  int get hashCode => message.hashCode;
  
  @override
  List<Object?> get props => [message];
}

class UnknownFailure extends Failure {
  const UnknownFailure(String message) : super(message);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnknownFailure && message == other.message;
  
  @override
  int get hashCode => message.hashCode;
  
  @override
  List<Object?> get props => [message];
}
