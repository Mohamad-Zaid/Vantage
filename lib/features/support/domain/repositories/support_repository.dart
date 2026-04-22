import '../entities/faq_entity.dart';

abstract class SupportRepository {
  Future<List<FAQEntity>> getFAQs();
}
