import '../../domain/entities/faq_entity.dart';

class FAQModel extends FAQEntity {
  const FAQModel({
    required super.id,
    required super.question,
    required super.answer,
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) {
    return FAQModel(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
    };
  }
}
