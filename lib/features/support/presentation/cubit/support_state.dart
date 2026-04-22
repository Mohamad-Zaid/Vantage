import 'package:equatable/equatable.dart';
import '../../domain/entities/faq_entity.dart';

sealed class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object> get props => [];
}

final class SupportInitial extends SupportState {
  const SupportInitial();
}

final class SupportLoading extends SupportState {
  const SupportLoading();
}

final class SupportLoaded extends SupportState {
  const SupportLoaded(this.faqs);

  final List<FAQEntity> faqs;

  @override
  List<Object> get props => [faqs];
}

final class SupportEmpty extends SupportState {
  const SupportEmpty();
}

final class SupportError extends SupportState {
  const SupportError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
