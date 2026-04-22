import '../entities/faq_entity.dart';
import '../repositories/support_repository.dart';

final class GetSupportFaqsUseCase {
  GetSupportFaqsUseCase(this._repository);

  final SupportRepository _repository;

  Future<List<FAQEntity>> call() => _repository.getFAQs();
}
