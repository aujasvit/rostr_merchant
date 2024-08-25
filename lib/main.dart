import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rostr_merchant/models/relay.dart';
import 'package:rostr_merchant/services/crud/relays_service.dart';
import 'package:rostr_merchant/services/providers/relay_pool_provider.dart';
import 'package:rostr_merchant/ui/relay_list_page.dart';

final initAllRelays = Provider<RelayList>((ref) => throw UnimplementedError());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await handleLocationPermission();
  final relaysService = RelaysService();
  await relaysService.open();

  final relayList = await relaysService.getRelayList();

  runApp(ProviderScope(
    overrides: [initAllRelays.overrideWithValue(relayList)],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EagerInitialization(
      child: MaterialApp(
        title: "Rostr Customer",
        home: RelayListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final relayList = await relaysService.getRelayList();

    ref.watch(relayPoolProvider);
    return child;
  }
}
