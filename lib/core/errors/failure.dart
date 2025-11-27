// Bu sınıf, oluşan hatayı tek bir formatta temsil eder.
// UI gelecekte sadece 'failure.message' kullanır.
//Her hata → Failure sınıfına çevirilir → Uygulama sadece Failure.message kullanır.

abstract class Failure {
  final String message;
  const Failure(this.message);
}

// Her hata türü Failure'dan türetilir çünkü farklı kaynaklardan hata gelebilir.

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
