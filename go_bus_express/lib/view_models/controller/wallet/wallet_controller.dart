import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_bus_express/core/storage/local_repository.dart';
import 'package:go_bus_express/models/wallet/wallet_model.dart';
import 'package:go_bus_express/models/wallet/wallet_transaction_model.dart';
import 'package:go_bus_express/repository/wallet_repository.dart';
import 'package:go_bus_express/resources/routes/app_routes.dart';
import 'package:go_bus_express/view_models/controller/base/base_controller.dart';
import 'package:go_bus_express/view_models/controller/profile/profile_controller.dart';
import 'package:go_bus_express/view_models/controller/wallet/wallet_state.dart';
import 'package:shared_package/network/x_result.dart';

class WalletController extends BaseController<WalletState> {
  final WalletRepository _walletRepository;
  final LocalRepository _localRepository;

  WalletController(this._walletRepository, this._localRepository)
      : super(const WalletState());

  // ─── Navigation entry point ────────────────────────────────────────────────

  /// Single entry point for all wallet navigation.
  /// Skips PIN if a valid cached session exists (< 30 min old).
  void navigateToWallet({required bool isWalletExist}) {
    if (!isWalletExist) {
      Get.toNamed(AppRoutes.walletCreatePin);
      return;
    }

    if (_localRepository.isWalletSessionValid()) {
      final cachedToken = _localRepository.getWalletSessionToken()!;
      final cachedHash = _localRepository.getWalletHash();
      // Ensure in-memory state has the token + hash so WalletView and
      // top-up KHQR generation work correctly without a fresh PIN login.
      if (state.wallet?.walletSessionToken == null) {
        updateState((s) => s.copyWith(
          wallet: WalletModel(walletSessionToken: cachedToken, hash: cachedHash),
        ));
      }
      Get.toNamed(AppRoutes.wallet);
    } else {
      // Stale or missing session — force re-auth
      _localRepository.clearWalletSession();
      Get.toNamed(AppRoutes.walletEnterPin);
    }
  }

  // ─── PIN setup ─────────────────────────────────────────────────────────────

  void setTempPin(String pin) {
    updateState((s) => s.copyWith(tempPin: pin, clearError: true));
    Get.toNamed(AppRoutes.walletConfirmPin);
  }

  Future<void> createAndLogin(String confirmPin) async {
    if (state.tempPin != confirmPin) {
      updateState(
        (s) => s.copyWith(errorMessage: 'PINs do not match. Try again.'),
      );
      return;
    }

    updateState((s) => s.copyWith(isLoading: true, clearError: true));

    final createResult = await _walletRepository.createWallet(
      pinCode: state.tempPin!,
    );

    switch (createResult) {
      case Success<WalletModel?>():
        await _loginAfterCreate(state.tempPin!);
      case Error<WalletModel?>():
        log('❌ Create wallet error: ${createResult.error.displayMessage}');
        updateState((s) => s.copyWith(
          isLoading: false,
          errorMessage: createResult.error.displayMessage,
        ));
    }
  }

  // ─── Login ─────────────────────────────────────────────────────────────────

  Future<void> loginWallet(String pinCode) async {
    updateState((s) => s.copyWith(isLoading: true, clearError: true));

    final result = await _walletRepository.loginWallet(pinCode: pinCode);

    switch (result) {
      case Success<WalletModel?>():
        final sessionToken = result.data?.walletSessionToken;
        final walletHash = result.data?.hash;
        updateState((s) => s.copyWith(wallet: result.data, clearError: true));
        if (sessionToken != null) {
          await _localRepository.saveWalletSession(sessionToken);
        }
        if (walletHash != null) {
          await _localRepository.saveWalletHash(walletHash);
        }
        await _fetchWalletMe(sessionToken, includeTransactions: true);
        Get.offNamedUntil(
          AppRoutes.wallet,
          ModalRoute.withName(AppRoutes.mainNavigation),
        );
      case Error<WalletModel?>():
        log('❌ Wallet login error: ${result.error.displayMessage}');
        updateState((s) => s.copyWith(
          isLoading: false,
          errorMessage: result.error.displayMessage,
        ));
    }
  }

  // ─── Wallet data ───────────────────────────────────────────────────────────

  /// Called from WalletView on entry — always refreshes balance from API.
  /// Set [includeTransactions] to true to also fetch transaction history.
  Future<void> fetchWalletMe({bool includeTransactions = false}) async {
    await _fetchWalletMe(
      state.wallet?.walletSessionToken,
      includeTransactions: includeTransactions,
    );
  }

  Future<void> fetchTransactions({bool reset = false}) async {
    final token = state.wallet?.walletSessionToken;
    if (token == null) return;

    if (!state.hasMorePages && !reset) return;

    final page = reset ? 1 : state.currentPage;
    updateState((s) => s.copyWith(
      isTransactionLoading: true,
      clearTransactionError: true,
    ));

    final result = await _walletRepository.getTransactions(
      sessionToken: token,
      page: page,
    );

    switch (result) {
      case Success<WalletTransactionPage?>():
        final page_ = result.data;
        final newItems = page_?.content ?? [];
        final existing = reset ? <WalletTransactionModel>[] : state.transactions;
        final nextPage = page + 1;
        // API uses 1-based pages; totalPages tells us how many pages exist.
        // e.g. page=1, totalPages=3 → nextPage=2, 2<=3 → hasMore=true
        final totalPages = page_?.totalPages ?? 1;
        updateState((s) => s.copyWith(
          isTransactionLoading: false,
          transactions: [...existing, ...newItems],
          currentPage: nextPage,
          hasMorePages: nextPage <= totalPages,
        ));
      case Error<WalletTransactionPage?>():
        log('❌ Wallet transactions error: ${result.error.displayMessage}');
        updateState((s) => s.copyWith(
          isTransactionLoading: false,
          transactionError: result.error.displayMessage,
        ));
    }
  }

  Future<void> _fetchWalletMe(
    String? token, {
    bool includeTransactions = false,
  }) async {
    if (token == null) {
      updateState((s) => s.copyWith(isLoading: false));
      return;
    }

    updateState((s) => s.copyWith(isLoading: true));
    final result = await _walletRepository.getWalletMe(sessionToken: token);

    switch (result) {
      case Success<WalletModel?>():
        final refreshed = result.data;
        if (refreshed != null) {
          // /wallets/me returns walletSessionToken and hash as null —
          // preserve both from the original login response.
          updateState((s) => s.copyWith(
            isLoading: false,
            wallet: refreshed.copyWith(
              walletSessionToken: token,
              hash: refreshed.hash ?? s.wallet?.hash,
            ),
          ));
          if (includeTransactions) {
            await fetchTransactions(reset: true);
          }
        } else {
          updateState((s) => s.copyWith(isLoading: false));
        }
      case Error<WalletModel?>():
        log('❌ Wallet me error: ${result.error.displayMessage}');
        updateState((s) => s.copyWith(isLoading: false));
    }
  }

  // ─── Utilities ─────────────────────────────────────────────────────────────

  void clearError() {
    updateState((s) => s.copyWith(clearError: true));
  }

  Future<void> clearSession() async {
    await _localRepository.clearWalletSession();
    emit(const WalletState());
  }

  Future<void> _loginAfterCreate(String pinCode) async {
    final result = await _walletRepository.loginWallet(pinCode: pinCode);

    switch (result) {
      case Success<WalletModel?>():
        await _markWalletExistsInCache();
        final sessionToken = result.data?.walletSessionToken;
        final walletHash = result.data?.hash;
        updateState((s) => s.copyWith(
          wallet: result.data,
          clearTempPin: true,
          clearError: true,
        ));
        if (sessionToken != null) {
          await _localRepository.saveWalletSession(sessionToken);
        }
        if (walletHash != null) {
          await _localRepository.saveWalletHash(walletHash);
        }
        await _fetchWalletMe(sessionToken, includeTransactions: true);
        Get.offNamedUntil(
          AppRoutes.wallet,
          ModalRoute.withName(AppRoutes.mainNavigation),
        );
      case Error<WalletModel?>():
        log('❌ Auto-login after create error: ${result.error.displayMessage}');
        updateState((s) => s.copyWith(
          isLoading: false,
          errorMessage: result.error.displayMessage,
        ));
    }
  }

  Future<void> _markWalletExistsInCache() async {
    final cached = _localRepository.getProfile();
    if (cached == null) return;
    try {
      final map = jsonDecode(cached) as Map<String, dynamic>;
      map['isWalletExist'] = true;
      await _localRepository.saveProfile(jsonEncode(map));
      try {
        Get.find<ProfileController>().refreshProfile();
      } catch (_) {}
    } catch (e) {
      log('Failed to update wallet cache: $e');
    }
  }
}
