import 'package:uuid/uuid.dart';

abstract interface class IdempotencyKeyGenerator {
  String generate();
}

final class UuidIdempotencyKeyGenerator implements IdempotencyKeyGenerator {
  const UuidIdempotencyKeyGenerator([this._uuid = const Uuid()]);
  final Uuid _uuid;

  @override
  String generate() => _uuid.v4();
}
