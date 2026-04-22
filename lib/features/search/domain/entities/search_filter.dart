import 'package:equatable/equatable.dart';

enum SortBy { recommended, newest, lowestHighest, highestLowest }

enum GenderFilter { men, women, kids }

enum DealFilter { onSale, freeShipping }

class SearchFilter extends Equatable {
  const SearchFilter({
    this.sortBy = SortBy.recommended,
    this.gender,
    this.deal,
    this.minPrice,
    this.maxPrice,
  });

  final SortBy sortBy;
  final GenderFilter? gender;
  final DealFilter? deal;
  final double? minPrice;
  final double? maxPrice;

  int get activeCount {
    int n = 0;
    if (sortBy != SortBy.recommended) n++;
    if (gender != null) n++;
    if (deal != null) n++;
    if (minPrice != null || maxPrice != null) n++;
    return n;
  }

  SearchFilter copyWith({
    SortBy? sortBy,
    Object? gender = _sentinel,
    Object? deal = _sentinel,
    Object? minPrice = _sentinel,
    Object? maxPrice = _sentinel,
  }) {
    return SearchFilter(
      sortBy: sortBy ?? this.sortBy,
      gender: identical(gender, _sentinel) ? this.gender : gender as GenderFilter?,
      deal: identical(deal, _sentinel) ? this.deal : deal as DealFilter?,
      minPrice: identical(minPrice, _sentinel) ? this.minPrice : minPrice as double?,
      maxPrice: identical(maxPrice, _sentinel) ? this.maxPrice : maxPrice as double?,
    );
  }

  @override
  List<Object?> get props => [sortBy, gender, deal, minPrice, maxPrice];
}

const _sentinel = Object();
