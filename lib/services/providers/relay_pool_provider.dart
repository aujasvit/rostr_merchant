import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nostr/nostr.dart';
import 'package:rostr_merchant/main.dart';
import 'package:rostr_merchant/models/relay.dart';
import 'package:rostr_merchant/models/relay_pool.dart';
import 'package:rostr_merchant/services/crud/relays_service.dart';

final StateNotifierProvider<RelayPoolNotifier, RelayPool> relayPoolProvider =
    StateNotifierProvider<RelayPoolNotifier, RelayPool>((ref) {
  final relayPool = RelayPoolNotifier(relayListInit: ref.watch(initAllRelays));
  return relayPool;
});

class RelayPoolNotifier extends StateNotifier<RelayPool> {
  RelayPoolNotifier({required RelayList relayListInit})
      : super(RelayPool(relayList: relayListInit)) {
    final streamController = state.controller;
    final stream = streamController.stream;
    stream.listen((message) {
      if (message.messageType == MessageType.event) {
        final event = message.message;

        if (event.kind == 10001) {
          final content = json.decode(event.content);
          final relayService = RelaysService();
          final newRelayList = RelayList();
          for (final relayString in content[relayListKey]) {
            final relay = Relay.fromJSON(json.decode(relayString));
            newRelayList.upsertRelay(relay);
            relayService.upsertRelay(relay: relay);
          }
          updateRelayList(newRelayList);
        }
      }
    });
  }

  void updateRelayList(RelayList newRelayList) {
    final currentRelayList = state.relayList;
    for (final relay in newRelayList.relayList) {
      currentRelayList.upsertRelay(relay);
    }
    state.relayList = currentRelayList;
    state = state.copyWith();
  }
}

const String relayListKey = 'relayList';
