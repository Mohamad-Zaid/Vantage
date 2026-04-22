import '../models/faq_model.dart';

abstract class SupportLocalDataSource {
  Future<List<FAQModel>> getFAQs();
}

class SupportLocalDataSourceImpl implements SupportLocalDataSource {
  @override
  Future<List<FAQModel>> getFAQs() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      const FAQModel(
        id: '1',
        question: 'support.faq_1_question',
        answer: 'support.faq_1_answer',
      ),
      const FAQModel(
        id: '2',
        question: 'support.faq_2_question',
        answer: 'support.faq_2_answer',
      ),
      const FAQModel(
        id: '3',
        question: 'support.faq_3_question',
        answer: 'support.faq_3_answer',
      ),
      const FAQModel(
        id: '4',
        question: 'support.faq_4_question',
        answer: 'support.faq_4_answer',
      ),
      const FAQModel(
        id: '5',
        question: 'support.faq_5_question',
        answer: 'support.faq_5_answer',
      ),
    ];
  }
}
