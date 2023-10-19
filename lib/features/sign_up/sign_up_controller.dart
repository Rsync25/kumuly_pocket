import 'package:kumuly_pocket/entities/account_entity.dart';
import 'package:kumuly_pocket/enums/app_network.dart';
import 'package:kumuly_pocket/enums/mnemonic_language.dart';
import 'package:kumuly_pocket/environment_variables.dart';
import 'package:kumuly_pocket/features/sign_up/sign_up_state.dart';
import 'package:kumuly_pocket/services/account_service.dart';
import 'package:kumuly_pocket/services/authentication_service.dart';
import 'package:kumuly_pocket/services/lightning_node_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_controller.g.dart';

@riverpod
class SignUpController extends _$SignUpController {
  @override
  SignUpState build(
    AuthenticationService authenticationService,
    AccountService accountService,
    LightningNodeService lightningNodeService,
  ) {
    return const SignUpState();
  }

  void setAccountRecoveryLanguage(MnemonicLanguage language) {
    state = state.copyWith(language: language);
  }

  void setAlias(String alias) {
    state = state.copyWith(alias: alias);
  }

  void addNumberToPin(String number) {
    if (state.pin.length < 4) {
      state = state.copyWith(pin: state.pin + number);
    }
  }

  void removeNumberFromPin() {
    if (state.pin.isNotEmpty) {
      state = state.copyWith(pin: state.pin.substring(0, state.pin.length - 1));
    }
  }

  void addNumberToPinConfirmation(String number) {
    if (state.pinConfirmation.length < 4) {
      state = state.copyWith(pinConfirmation: state.pinConfirmation + number);
    }
  }

  void removeNumberFromPinConfirmation() {
    if (state.pinConfirmation.isNotEmpty) {
      state = state.copyWith(
          pinConfirmation: state.pinConfirmation
              .substring(0, state.pinConfirmation.length - 1));
    }
  }

  Future<void> createAccount() async {
    // Todo: Error handling and loading state
    print('Creating account...');
    // Create a new wallet for the account.
    // FOR PRODUCTION >>>>>>>>>>
    // Todo: In prod use the following instead of the developmentMnemonics:
    /*final mnemonicWords = await _accountService.generateAccountWallet(
      state.language,
    );*/
    // <<<<<<<<<<<<<<< FOR PRODUCTION
    // ONLY FOR DEVELOPMENT >>>>>>>>>>
    // Use some pre-generated mnemonics and invite codes for development.
    String mnemonic;
    String inviteCode;
    switch (accountService.accounts.length) {
      case 0:
        mnemonic = mnemonic0;
        inviteCode = breezSdkInviteCode0;
        break;
      case 1:
        mnemonic = mnemonic1;
        inviteCode = breezSdkInviteCode1;
        break;
      case 2:
        mnemonic = mnemonic2;
        inviteCode = breezSdkInviteCode2;
        break;
      case 3:
        mnemonic = mnemonic3;
        inviteCode = breezSdkInviteCode3;
        break;
      default:
        throw Exception('No more Breez SDK invite codes available');
    }

    final mnemonicWords = mnemonic.split(',');
    print('Mnemonic words: $mnemonicWords');
    print('Invite code: $inviteCode');

    // <<<<<<<<<<<<<<< ONLY FOR DEVELOPMENT

    // Setup a new node for the account.
    final (nodeId, workingDirPath) = await lightningNodeService.newNodeConnect(
      state.alias,
      mnemonicWords,
      AppNetwork.bitcoin, // Todo: Get network from App Network Provider
      breezSdkApiKey,
      inviteCode: inviteCode,
    );
    print(
      'New node set up with id: $nodeId and working dir path: $workingDirPath',
    );

    // Save the new account on the device.
    await accountService.addAccount(
      AccountEntity(
        nodeId: nodeId,
        alias: state.alias,
        workingDirPath: workingDirPath,
      ),
      mnemonicWords,
      state.pin,
    );
    print('Account added with alias: ${state.alias}');

    // Log in the new user.
    await authenticationService.logIn(nodeId);
    print('User logged in to account with id: $nodeId');
  }
}
