export 'domain.dart';
export 'cart.dart';
export 'domain_shared.dart';
export 'domain_search.dart';
export 'domain_suggestion.dart';
export 'user_domain.dart';
export '../repository/cart_repository.dart';
export '../utils/domain_converter.dart';

// Domain Extension Model
class DomainExtension {
  final String extension;
  final String description;

  DomainExtension(this.extension, this.description);
}
