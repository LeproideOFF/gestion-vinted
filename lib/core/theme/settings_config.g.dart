// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_config.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSettingsConfigCollection on Isar {
  IsarCollection<SettingsConfig> get settingsConfigs => this.collection();
}

const SettingsConfigSchema = CollectionSchema(
  name: r'SettingsConfig',
  id: -1288917970289873311,
  properties: {
    r'defaultMarket': PropertySchema(
      id: 0,
      name: r'defaultMarket',
      type: IsarType.string,
    ),
    r'discordBotAvatar': PropertySchema(
      id: 1,
      name: r'discordBotAvatar',
      type: IsarType.string,
    ),
    r'discordBotName': PropertySchema(
      id: 2,
      name: r'discordBotName',
      type: IsarType.string,
    ),
    r'discordDailyReport': PropertySchema(
      id: 3,
      name: r'discordDailyReport',
      type: IsarType.bool,
    ),
    r'discordEnabled': PropertySchema(
      id: 4,
      name: r'discordEnabled',
      type: IsarType.bool,
    ),
    r'discordNotifyFiscal': PropertySchema(
      id: 5,
      name: r'discordNotifyFiscal',
      type: IsarType.bool,
    ),
    r'discordNotifySales': PropertySchema(
      id: 6,
      name: r'discordNotifySales',
      type: IsarType.bool,
    ),
    r'discordNotifySync': PropertySchema(
      id: 7,
      name: r'discordNotifySync',
      type: IsarType.bool,
    ),
    r'discordWebhookUrl': PropertySchema(
      id: 8,
      name: r'discordWebhookUrl',
      type: IsarType.string,
    ),
    r'theme': PropertySchema(
      id: 9,
      name: r'theme',
      type: IsarType.string,
    ),
    r'useBiometrics': PropertySchema(
      id: 10,
      name: r'useBiometrics',
      type: IsarType.bool,
    )
  },
  estimateSize: _settingsConfigEstimateSize,
  serialize: _settingsConfigSerialize,
  deserialize: _settingsConfigDeserialize,
  deserializeProp: _settingsConfigDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _settingsConfigGetId,
  getLinks: _settingsConfigGetLinks,
  attach: _settingsConfigAttach,
  version: '3.1.0+1',
);

int _settingsConfigEstimateSize(
  SettingsConfig object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.defaultMarket.length * 3;
  {
    final value = object.discordBotAvatar;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.discordBotName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.discordWebhookUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.theme.length * 3;
  return bytesCount;
}

void _settingsConfigSerialize(
  SettingsConfig object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.defaultMarket);
  writer.writeString(offsets[1], object.discordBotAvatar);
  writer.writeString(offsets[2], object.discordBotName);
  writer.writeBool(offsets[3], object.discordDailyReport);
  writer.writeBool(offsets[4], object.discordEnabled);
  writer.writeBool(offsets[5], object.discordNotifyFiscal);
  writer.writeBool(offsets[6], object.discordNotifySales);
  writer.writeBool(offsets[7], object.discordNotifySync);
  writer.writeString(offsets[8], object.discordWebhookUrl);
  writer.writeString(offsets[9], object.theme);
  writer.writeBool(offsets[10], object.useBiometrics);
}

SettingsConfig _settingsConfigDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SettingsConfig(
    defaultMarket: reader.readStringOrNull(offsets[0]) ?? 'Vinted',
    discordBotAvatar: reader.readStringOrNull(offsets[1]),
    discordBotName: reader.readStringOrNull(offsets[2]),
    discordDailyReport: reader.readBoolOrNull(offsets[3]) ?? false,
    discordEnabled: reader.readBoolOrNull(offsets[4]) ?? false,
    discordNotifyFiscal: reader.readBoolOrNull(offsets[5]) ?? true,
    discordNotifySales: reader.readBoolOrNull(offsets[6]) ?? true,
    discordNotifySync: reader.readBoolOrNull(offsets[7]) ?? true,
    discordWebhookUrl: reader.readStringOrNull(offsets[8]),
    id: id,
    theme: reader.readStringOrNull(offsets[9]) ?? 'frost',
    useBiometrics: reader.readBoolOrNull(offsets[10]) ?? true,
  );
  return object;
}

P _settingsConfigDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? 'Vinted') as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 6:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 7:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset) ?? 'frost') as P;
    case 10:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _settingsConfigGetId(SettingsConfig object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _settingsConfigGetLinks(SettingsConfig object) {
  return [];
}

void _settingsConfigAttach(
    IsarCollection<dynamic> col, Id id, SettingsConfig object) {
  object.id = id;
}

extension SettingsConfigQueryWhereSort
    on QueryBuilder<SettingsConfig, SettingsConfig, QWhere> {
  QueryBuilder<SettingsConfig, SettingsConfig, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SettingsConfigQueryWhere
    on QueryBuilder<SettingsConfig, SettingsConfig, QWhereClause> {
  QueryBuilder<SettingsConfig, SettingsConfig, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SettingsConfigQueryFilter
    on QueryBuilder<SettingsConfig, SettingsConfig, QFilterCondition> {
  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      defaultMarketEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultMarket',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      defaultMarketGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultMarket',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      defaultMarketLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultMarket',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      defaultMarketBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultMarket',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      defaultMarketStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'defaultMarket',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      defaultMarketEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'defaultMarket',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      defaultMarketContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'defaultMarket',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      defaultMarketMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'defaultMarket',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      defaultMarketIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultMarket',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      defaultMarketIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'defaultMarket',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotAvatarIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'discordBotAvatar',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotAvatarIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'discordBotAvatar',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotAvatarEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discordBotAvatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotAvatarGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'discordBotAvatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotAvatarLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'discordBotAvatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotAvatarBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'discordBotAvatar',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotAvatarStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'discordBotAvatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotAvatarEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'discordBotAvatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotAvatarContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'discordBotAvatar',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotAvatarMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'discordBotAvatar',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotAvatarIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discordBotAvatar',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotAvatarIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'discordBotAvatar',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'discordBotName',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'discordBotName',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discordBotName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'discordBotName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'discordBotName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'discordBotName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'discordBotName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'discordBotName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'discordBotName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'discordBotName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discordBotName',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordBotNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'discordBotName',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordDailyReportEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discordDailyReport',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discordEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordNotifyFiscalEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discordNotifyFiscal',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordNotifySalesEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discordNotifySales',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordNotifySyncEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discordNotifySync',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordWebhookUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'discordWebhookUrl',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordWebhookUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'discordWebhookUrl',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordWebhookUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discordWebhookUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordWebhookUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'discordWebhookUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordWebhookUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'discordWebhookUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordWebhookUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'discordWebhookUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordWebhookUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'discordWebhookUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordWebhookUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'discordWebhookUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordWebhookUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'discordWebhookUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordWebhookUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'discordWebhookUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordWebhookUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discordWebhookUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      discordWebhookUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'discordWebhookUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      themeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      themeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      themeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      themeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'theme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      themeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      themeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      themeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      themeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'theme',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      themeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'theme',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      themeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'theme',
        value: '',
      ));
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterFilterCondition>
      useBiometricsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useBiometrics',
        value: value,
      ));
    });
  }
}

extension SettingsConfigQueryObject
    on QueryBuilder<SettingsConfig, SettingsConfig, QFilterCondition> {}

extension SettingsConfigQueryLinks
    on QueryBuilder<SettingsConfig, SettingsConfig, QFilterCondition> {}

extension SettingsConfigQuerySortBy
    on QueryBuilder<SettingsConfig, SettingsConfig, QSortBy> {
  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDefaultMarket() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultMarket', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDefaultMarketDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultMarket', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDiscordBotAvatar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordBotAvatar', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDiscordBotAvatarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordBotAvatar', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDiscordBotName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordBotName', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDiscordBotNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordBotName', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDiscordDailyReport() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordDailyReport', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDiscordDailyReportDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordDailyReport', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDiscordEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordEnabled', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDiscordEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordEnabled', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDiscordNotifyFiscal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordNotifyFiscal', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDiscordNotifyFiscalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordNotifyFiscal', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDiscordNotifySales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordNotifySales', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDiscordNotifySalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordNotifySales', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDiscordNotifySync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordNotifySync', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDiscordNotifySyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordNotifySync', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDiscordWebhookUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordWebhookUrl', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByDiscordWebhookUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordWebhookUrl', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy> sortByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy> sortByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByUseBiometrics() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useBiometrics', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      sortByUseBiometricsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useBiometrics', Sort.desc);
    });
  }
}

extension SettingsConfigQuerySortThenBy
    on QueryBuilder<SettingsConfig, SettingsConfig, QSortThenBy> {
  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDefaultMarket() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultMarket', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDefaultMarketDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultMarket', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDiscordBotAvatar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordBotAvatar', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDiscordBotAvatarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordBotAvatar', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDiscordBotName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordBotName', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDiscordBotNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordBotName', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDiscordDailyReport() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordDailyReport', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDiscordDailyReportDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordDailyReport', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDiscordEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordEnabled', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDiscordEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordEnabled', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDiscordNotifyFiscal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordNotifyFiscal', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDiscordNotifyFiscalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordNotifyFiscal', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDiscordNotifySales() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordNotifySales', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDiscordNotifySalesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordNotifySales', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDiscordNotifySync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordNotifySync', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDiscordNotifySyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordNotifySync', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDiscordWebhookUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordWebhookUrl', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByDiscordWebhookUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discordWebhookUrl', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy> thenByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy> thenByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByUseBiometrics() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useBiometrics', Sort.asc);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QAfterSortBy>
      thenByUseBiometricsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useBiometrics', Sort.desc);
    });
  }
}

extension SettingsConfigQueryWhereDistinct
    on QueryBuilder<SettingsConfig, SettingsConfig, QDistinct> {
  QueryBuilder<SettingsConfig, SettingsConfig, QDistinct>
      distinctByDefaultMarket({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultMarket',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QDistinct>
      distinctByDiscordBotAvatar({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discordBotAvatar',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QDistinct>
      distinctByDiscordBotName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discordBotName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QDistinct>
      distinctByDiscordDailyReport() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discordDailyReport');
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QDistinct>
      distinctByDiscordEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discordEnabled');
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QDistinct>
      distinctByDiscordNotifyFiscal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discordNotifyFiscal');
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QDistinct>
      distinctByDiscordNotifySales() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discordNotifySales');
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QDistinct>
      distinctByDiscordNotifySync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discordNotifySync');
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QDistinct>
      distinctByDiscordWebhookUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discordWebhookUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QDistinct> distinctByTheme(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'theme', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SettingsConfig, SettingsConfig, QDistinct>
      distinctByUseBiometrics() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useBiometrics');
    });
  }
}

extension SettingsConfigQueryProperty
    on QueryBuilder<SettingsConfig, SettingsConfig, QQueryProperty> {
  QueryBuilder<SettingsConfig, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SettingsConfig, String, QQueryOperations>
      defaultMarketProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultMarket');
    });
  }

  QueryBuilder<SettingsConfig, String?, QQueryOperations>
      discordBotAvatarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discordBotAvatar');
    });
  }

  QueryBuilder<SettingsConfig, String?, QQueryOperations>
      discordBotNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discordBotName');
    });
  }

  QueryBuilder<SettingsConfig, bool, QQueryOperations>
      discordDailyReportProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discordDailyReport');
    });
  }

  QueryBuilder<SettingsConfig, bool, QQueryOperations>
      discordEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discordEnabled');
    });
  }

  QueryBuilder<SettingsConfig, bool, QQueryOperations>
      discordNotifyFiscalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discordNotifyFiscal');
    });
  }

  QueryBuilder<SettingsConfig, bool, QQueryOperations>
      discordNotifySalesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discordNotifySales');
    });
  }

  QueryBuilder<SettingsConfig, bool, QQueryOperations>
      discordNotifySyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discordNotifySync');
    });
  }

  QueryBuilder<SettingsConfig, String?, QQueryOperations>
      discordWebhookUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discordWebhookUrl');
    });
  }

  QueryBuilder<SettingsConfig, String, QQueryOperations> themeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'theme');
    });
  }

  QueryBuilder<SettingsConfig, bool, QQueryOperations> useBiometricsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useBiometrics');
    });
  }
}
