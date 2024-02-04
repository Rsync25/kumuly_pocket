import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kumuly_pocket/constants.dart';
import 'package:kumuly_pocket/features/onboarding/onboarding_controller.dart';
import 'package:kumuly_pocket/theme/palette.dart';
import 'package:kumuly_pocket/widgets/dialogs/transition_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:kumuly_pocket/widgets/screens/pin_input_screen.dart';

class RecoveryPinSetupConfirmationScreen extends ConsumerWidget {
  const RecoveryPinSetupConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter.of(context);
    final copy = AppLocalizations.of(context)!;
    final pageController = ref.read(
      pageViewControllerProvider(
        kRecoveryFlowPageViewId,
      ).notifier,
    );

    final state = ref.watch(onboardingControllerProvider);
    final notifier = ref.read(
      onboardingControllerProvider.notifier,
    );
    final pinConfirmation = state.pinConfirmation;
    final pin = state.pin;

    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) => pageController.previousPage(),
      child: PinInputScreen(
        leading: BackButton(
          color: Palette.neutral[100],
          onPressed: pageController.previousPage,
        ),
        title: copy.confirmPIN,
        subtitle: copy.confirmPINDescription,
        pin: pinConfirmation,
        isValidPin: pin == pinConfirmation,
        errorMessage: copy.pinDoesNotMatch,
        onNumberSelectHandler: notifier.addNumberToPinConfirmation,
        onBackspaceHandler: notifier.removeNumberFromPinConfirmation,
        confirmButtonText: copy.confirmPIN,
        confirmHandler: () async {
          try {
            final confirming = notifier.confirmPin();
            showTransitionDialog(context, copy.oneMomentPlease);
            await confirming;
            await notifier.connectNode();
            await notifier.storeMnemonic();

            router.pop(); // pop the transition dialog
            router.pop(); // pop the onboarding flow that was pushed
            router.goNamed('pocket');
          } catch (e) {
            if (e is CouldNotConnectToNodeException) {
              print('Could not connect to node');
            } else if (e is CouldNotStoreMnemonicException) {
              print('Could not store mnemonic');
            } else {
              print('Unknown error: $e');
            }
            router.pop();
          }
        },
      ),
    );
  }
}
