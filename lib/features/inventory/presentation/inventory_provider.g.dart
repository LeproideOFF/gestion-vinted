// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isarServiceHash() => r'387dee19a962ae3db2a26dfa59c946285a539ac1';

/// See also [isarService].
@ProviderFor(isarService)
final isarServiceProvider = Provider<IsarService>.internal(
  isarService,
  name: r'isarServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isarServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsarServiceRef = ProviderRef<IsarService>;
String _$inventoryListHash() => r'4f78c41499ff4b4ef7145b8c8c749e7a6679e0f0';

/// See also [inventoryList].
@ProviderFor(inventoryList)
final inventoryListProvider =
    AutoDisposeStreamProvider<List<VintedArticle>>.internal(
  inventoryList,
  name: r'inventoryListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef InventoryListRef = AutoDisposeStreamProviderRef<List<VintedArticle>>;
String _$inventoryNotifierHash() => r'cb3e3c0884b965f03e3ec118398efd2399a453c9';

/// See also [InventoryNotifier].
@ProviderFor(InventoryNotifier)
final inventoryNotifierProvider =
    AutoDisposeAsyncNotifierProvider<InventoryNotifier, void>.internal(
  InventoryNotifier.new,
  name: r'inventoryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$InventoryNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
