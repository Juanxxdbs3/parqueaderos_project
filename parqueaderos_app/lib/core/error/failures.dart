import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  // Si todas tus fallas tienen una propiedad 'message', puedes añadirla aquí.
  // O propiedades más específicas en las clases concretas.
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// Fallas Generales
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
 const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

// Podrías tener fallas más específicas si es necesario
// class InvalidInputFailure extends Failure {}
