import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nostr/nostr.dart';
import 'package:rostr_merchant/models/relay.dart';
import 'package:rostr_merchant/services/providers/relay_pool_provider.dart';
import 'package:rostr_merchant/ui/relay_base_card.dart';

class RelayListPage extends ConsumerWidget {
  const RelayListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relayList = ref.watch(relayPoolProvider).relayList;
    // log(merchantList.merchantList.toString());
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Rostr',
            style: TextStyle(
              fontFamily: 'Brand-Bold',
              fontSize: 22,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () {
                // log(ref.read(merchantListProvider).merchantList.toString());
                final relayGroup = ref.read(relayPoolProvider);
                final relayListFilter = Filter(kinds: <int>[10000]);
                relayGroup.connectAndSub(<Filter>[relayListFilter]);
                // relayGroup.connect().then((value) {
                //   ref.read(merchantListProvider.notifier).clear();
                //   final merchantListFilter = Filter(kinds: <int>[11001]);
                //   relayGroup.sub(<Filter>[merchantListFilter]);
                // });
              },
            ),
          ],
        ),
        body: ListView(children: [
          for (Relay m in relayList.relayList) RelayBaseCard(relay: m),
        ]),
      ),
    );
  }
}
