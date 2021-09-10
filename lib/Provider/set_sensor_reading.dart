import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SensorSchema {

  ///Auth client
  ValueNotifier<GraphQLClient> getClient() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: HttpLink('https://medikal-backend.herokuapp.com/query'),
        // The default cache is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(store: HiveStore()),
      ),
    );

    return client;
  }
}