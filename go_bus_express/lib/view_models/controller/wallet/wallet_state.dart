import 'package:go_bus_express/core/base/base_ui_state.dart';
import 'package:go_bus_express/models/wallet/wallet_model.dart';
import 'package:go_bus_express/models/wallet/wallet_transaction_model.dart';

class WalletState extends BaseUiState {
  final WalletModel? wallet;
  final String? tempPin;
  final String? errorMessage;
  final List<WalletTransactionModel> transactions;
  final bool isTransactionLoading;
  final String? transactionError;
  final int currentPage;
  final bool hasMorePages;

  const WalletState({
    super.isLoading = false,
    this.wallet,
    this.tempPin,
    this.errorMessage,
    this.transactions = const [],
    this.isTransactionLoading = false,
    this.transactionError,
    this.currentPage = 1,
    this.hasMorePages = true,
  });

  WalletState copyWith({
    bool? isLoading,
    WalletModel? wallet,
    String? tempPin,
    String? errorMessage,
    List<WalletTransactionModel>? transactions,
    bool? isTransactionLoading,
    String? transactionError,
    int? currentPage,
    bool? hasMorePages,
    bool clearError = false,
    bool clearTempPin = false,
    bool clearTransactionError = false,
  }) {
    return WalletState(
      isLoading: isLoading ?? this.isLoading,
      wallet: wallet ?? this.wallet,
      tempPin: clearTempPin ? null : (tempPin ?? this.tempPin),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      transactions: transactions ?? this.transactions,
      isTransactionLoading: isTransactionLoading ?? this.isTransactionLoading,
      transactionError: clearTransactionError
          ? null
          : (transactionError ?? this.transactionError),
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }
}
