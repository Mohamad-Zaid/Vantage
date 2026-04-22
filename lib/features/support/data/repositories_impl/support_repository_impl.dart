import '../../domain/entities/faq_entity.dart';
import '../../domain/repositories/support_repository.dart';
import '../datasources/support_local_datasource.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportLocalDataSource localDataSource;

  SupportRepositoryImpl(this.localDataSource);

  @override
  Future<List<FAQEntity>> getFAQs() async {
    try {
      final faqModels = await localDataSource.getFAQs();
      return faqModels;
    } catch (e) {
      throw Exception('Failed to load FAQs');
    }
  }
}
