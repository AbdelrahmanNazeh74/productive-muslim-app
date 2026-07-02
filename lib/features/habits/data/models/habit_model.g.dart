// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHabitModelCollection on Isar {
  IsarCollection<HabitModel> get habitModels => this.collection();
}

const HabitModelSchema = CollectionSchema(
  name: r'HabitModel',
  id: -414673950888729972,
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'currentStreak': PropertySchema(
      id: 2,
      name: r'currentStreak',
      type: IsarType.long,
    ),
    r'description': PropertySchema(
      id: 3,
      name: r'description',
      type: IsarType.string,
    ),
    r'emoji': PropertySchema(
      id: 4,
      name: r'emoji',
      type: IsarType.string,
    ),
    r'habitId': PropertySchema(
      id: 5,
      name: r'habitId',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 6,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'isSystemHabit': PropertySchema(
      id: 7,
      name: r'isSystemHabit',
      type: IsarType.bool,
    ),
    r'lastCompletedDate': PropertySchema(
      id: 8,
      name: r'lastCompletedDate',
      type: IsarType.dateTime,
    ),
    r'lastExcusedDate': PropertySchema(
      id: 9,
      name: r'lastExcusedDate',
      type: IsarType.dateTime,
    ),
    r'longestStreak': PropertySchema(
      id: 10,
      name: r'longestStreak',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 11,
      name: r'name',
      type: IsarType.string,
    ),
    r'notificationsEnabled': PropertySchema(
      id: 12,
      name: r'notificationsEnabled',
      type: IsarType.bool,
    ),
    r'scheduledDays': PropertySchema(
      id: 13,
      name: r'scheduledDays',
      type: IsarType.longList,
    ),
    r'streakPauseOnCycle': PropertySchema(
      id: 14,
      name: r'streakPauseOnCycle',
      type: IsarType.bool,
    ),
    r'targetFrequencyPerWeek': PropertySchema(
      id: 15,
      name: r'targetFrequencyPerWeek',
      type: IsarType.long,
    ),
    r'timeAnchor': PropertySchema(
      id: 16,
      name: r'timeAnchor',
      type: IsarType.string,
    )
  },
  estimateSize: _habitModelEstimateSize,
  serialize: _habitModelSerialize,
  deserialize: _habitModelDeserialize,
  deserializeProp: _habitModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'habitId': IndexSchema(
      id: 1000409552522198739,
      name: r'habitId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'habitId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _habitModelGetId,
  getLinks: _habitModelGetLinks,
  attach: _habitModelAttach,
  version: '3.1.0+1',
);

int _habitModelEstimateSize(
  HabitModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.emoji.length * 3;
  bytesCount += 3 + object.habitId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.scheduledDays.length * 8;
  bytesCount += 3 + object.timeAnchor.length * 3;
  return bytesCount;
}

void _habitModelSerialize(
  HabitModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.category);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.currentStreak);
  writer.writeString(offsets[3], object.description);
  writer.writeString(offsets[4], object.emoji);
  writer.writeString(offsets[5], object.habitId);
  writer.writeBool(offsets[6], object.isActive);
  writer.writeBool(offsets[7], object.isSystemHabit);
  writer.writeDateTime(offsets[8], object.lastCompletedDate);
  writer.writeDateTime(offsets[9], object.lastExcusedDate);
  writer.writeLong(offsets[10], object.longestStreak);
  writer.writeString(offsets[11], object.name);
  writer.writeBool(offsets[12], object.notificationsEnabled);
  writer.writeLongList(offsets[13], object.scheduledDays);
  writer.writeBool(offsets[14], object.streakPauseOnCycle);
  writer.writeLong(offsets[15], object.targetFrequencyPerWeek);
  writer.writeString(offsets[16], object.timeAnchor);
}

HabitModel _habitModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HabitModel();
  object.category = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.currentStreak = reader.readLong(offsets[2]);
  object.description = reader.readStringOrNull(offsets[3]);
  object.emoji = reader.readString(offsets[4]);
  object.habitId = reader.readString(offsets[5]);
  object.id = id;
  object.isActive = reader.readBool(offsets[6]);
  object.isSystemHabit = reader.readBool(offsets[7]);
  object.lastCompletedDate = reader.readDateTimeOrNull(offsets[8]);
  object.lastExcusedDate = reader.readDateTimeOrNull(offsets[9]);
  object.longestStreak = reader.readLong(offsets[10]);
  object.name = reader.readString(offsets[11]);
  object.notificationsEnabled = reader.readBool(offsets[12]);
  object.scheduledDays = reader.readLongList(offsets[13]) ?? [];
  object.streakPauseOnCycle = reader.readBool(offsets[14]);
  object.targetFrequencyPerWeek = reader.readLong(offsets[15]);
  object.timeAnchor = reader.readString(offsets[16]);
  return object;
}

P _habitModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readLongList(offset) ?? []) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _habitModelGetId(HabitModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _habitModelGetLinks(HabitModel object) {
  return [];
}

void _habitModelAttach(IsarCollection<dynamic> col, Id id, HabitModel object) {
  object.id = id;
}

extension HabitModelByIndex on IsarCollection<HabitModel> {
  Future<HabitModel?> getByHabitId(String habitId) {
    return getByIndex(r'habitId', [habitId]);
  }

  HabitModel? getByHabitIdSync(String habitId) {
    return getByIndexSync(r'habitId', [habitId]);
  }

  Future<bool> deleteByHabitId(String habitId) {
    return deleteByIndex(r'habitId', [habitId]);
  }

  bool deleteByHabitIdSync(String habitId) {
    return deleteByIndexSync(r'habitId', [habitId]);
  }

  Future<List<HabitModel?>> getAllByHabitId(List<String> habitIdValues) {
    final values = habitIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'habitId', values);
  }

  List<HabitModel?> getAllByHabitIdSync(List<String> habitIdValues) {
    final values = habitIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'habitId', values);
  }

  Future<int> deleteAllByHabitId(List<String> habitIdValues) {
    final values = habitIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'habitId', values);
  }

  int deleteAllByHabitIdSync(List<String> habitIdValues) {
    final values = habitIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'habitId', values);
  }

  Future<Id> putByHabitId(HabitModel object) {
    return putByIndex(r'habitId', object);
  }

  Id putByHabitIdSync(HabitModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'habitId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByHabitId(List<HabitModel> objects) {
    return putAllByIndex(r'habitId', objects);
  }

  List<Id> putAllByHabitIdSync(List<HabitModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'habitId', objects, saveLinks: saveLinks);
  }
}

extension HabitModelQueryWhereSort
    on QueryBuilder<HabitModel, HabitModel, QWhere> {
  QueryBuilder<HabitModel, HabitModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HabitModelQueryWhere
    on QueryBuilder<HabitModel, HabitModel, QWhereClause> {
  QueryBuilder<HabitModel, HabitModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<HabitModel, HabitModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<HabitModel, HabitModel, QAfterWhereClause> habitIdEqualTo(
      String habitId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'habitId',
        value: [habitId],
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterWhereClause> habitIdNotEqualTo(
      String habitId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId',
              lower: [],
              upper: [habitId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId',
              lower: [habitId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId',
              lower: [habitId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId',
              lower: [],
              upper: [habitId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension HabitModelQueryFilter
    on QueryBuilder<HabitModel, HabitModel, QFilterCondition> {
  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> categoryContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> categoryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      currentStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      currentStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      currentStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      currentStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> emojiEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> emojiGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> emojiLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> emojiBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emoji',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> emojiStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'emoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> emojiEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'emoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> emojiContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'emoji',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> emojiMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'emoji',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> emojiIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emoji',
        value: '',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      emojiIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emoji',
        value: '',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> habitIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      habitIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> habitIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> habitIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'habitId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> habitIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> habitIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> habitIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> habitIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'habitId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> habitIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'habitId',
        value: '',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      habitIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'habitId',
        value: '',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
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

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> idLessThan(
    Id value, {
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

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> isActiveEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      isSystemHabitEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSystemHabit',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      lastCompletedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastCompletedDate',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      lastCompletedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastCompletedDate',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      lastCompletedDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastCompletedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      lastCompletedDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastCompletedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      lastCompletedDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastCompletedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      lastCompletedDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastCompletedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      lastExcusedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastExcusedDate',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      lastExcusedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastExcusedDate',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      lastExcusedDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastExcusedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      lastExcusedDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastExcusedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      lastExcusedDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastExcusedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      lastExcusedDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastExcusedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      longestStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      longestStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      longestStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      longestStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longestStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      notificationsEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationsEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      scheduledDaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledDays',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      scheduledDaysElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledDays',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      scheduledDaysElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledDays',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      scheduledDaysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      scheduledDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledDays',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      scheduledDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledDays',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      scheduledDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledDays',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      scheduledDaysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledDays',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      scheduledDaysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledDays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      scheduledDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      streakPauseOnCycleEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'streakPauseOnCycle',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      targetFrequencyPerWeekEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetFrequencyPerWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      targetFrequencyPerWeekGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetFrequencyPerWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      targetFrequencyPerWeekLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetFrequencyPerWeek',
        value: value,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      targetFrequencyPerWeekBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetFrequencyPerWeek',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> timeAnchorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeAnchor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      timeAnchorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeAnchor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      timeAnchorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeAnchor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> timeAnchorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeAnchor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      timeAnchorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'timeAnchor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      timeAnchorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'timeAnchor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      timeAnchorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'timeAnchor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition> timeAnchorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'timeAnchor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      timeAnchorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeAnchor',
        value: '',
      ));
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterFilterCondition>
      timeAnchorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'timeAnchor',
        value: '',
      ));
    });
  }
}

extension HabitModelQueryObject
    on QueryBuilder<HabitModel, HabitModel, QFilterCondition> {}

extension HabitModelQueryLinks
    on QueryBuilder<HabitModel, HabitModel, QFilterCondition> {}

extension HabitModelQuerySortBy
    on QueryBuilder<HabitModel, HabitModel, QSortBy> {
  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByEmoji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoji', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByEmojiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoji', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByIsSystemHabit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSystemHabit', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByIsSystemHabitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSystemHabit', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByLastCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy>
      sortByLastCompletedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByLastExcusedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastExcusedDate', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy>
      sortByLastExcusedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastExcusedDate', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByLongestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy>
      sortByNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy>
      sortByNotificationsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy>
      sortByStreakPauseOnCycle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakPauseOnCycle', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy>
      sortByStreakPauseOnCycleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakPauseOnCycle', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy>
      sortByTargetFrequencyPerWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetFrequencyPerWeek', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy>
      sortByTargetFrequencyPerWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetFrequencyPerWeek', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByTimeAnchor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeAnchor', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> sortByTimeAnchorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeAnchor', Sort.desc);
    });
  }
}

extension HabitModelQuerySortThenBy
    on QueryBuilder<HabitModel, HabitModel, QSortThenBy> {
  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByEmoji() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoji', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByEmojiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emoji', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByIsSystemHabit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSystemHabit', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByIsSystemHabitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSystemHabit', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByLastCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy>
      thenByLastCompletedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByLastExcusedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastExcusedDate', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy>
      thenByLastExcusedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastExcusedDate', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByLongestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy>
      thenByNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy>
      thenByNotificationsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy>
      thenByStreakPauseOnCycle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakPauseOnCycle', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy>
      thenByStreakPauseOnCycleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streakPauseOnCycle', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy>
      thenByTargetFrequencyPerWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetFrequencyPerWeek', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy>
      thenByTargetFrequencyPerWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetFrequencyPerWeek', Sort.desc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByTimeAnchor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeAnchor', Sort.asc);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QAfterSortBy> thenByTimeAnchorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeAnchor', Sort.desc);
    });
  }
}

extension HabitModelQueryWhereDistinct
    on QueryBuilder<HabitModel, HabitModel, QDistinct> {
  QueryBuilder<HabitModel, HabitModel, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<HabitModel, HabitModel, QDistinct> distinctByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStreak');
    });
  }

  QueryBuilder<HabitModel, HabitModel, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QDistinct> distinctByEmoji(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emoji', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QDistinct> distinctByHabitId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'habitId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<HabitModel, HabitModel, QDistinct> distinctByIsSystemHabit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSystemHabit');
    });
  }

  QueryBuilder<HabitModel, HabitModel, QDistinct>
      distinctByLastCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCompletedDate');
    });
  }

  QueryBuilder<HabitModel, HabitModel, QDistinct> distinctByLastExcusedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastExcusedDate');
    });
  }

  QueryBuilder<HabitModel, HabitModel, QDistinct> distinctByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longestStreak');
    });
  }

  QueryBuilder<HabitModel, HabitModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitModel, HabitModel, QDistinct>
      distinctByNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificationsEnabled');
    });
  }

  QueryBuilder<HabitModel, HabitModel, QDistinct> distinctByScheduledDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledDays');
    });
  }

  QueryBuilder<HabitModel, HabitModel, QDistinct>
      distinctByStreakPauseOnCycle() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streakPauseOnCycle');
    });
  }

  QueryBuilder<HabitModel, HabitModel, QDistinct>
      distinctByTargetFrequencyPerWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetFrequencyPerWeek');
    });
  }

  QueryBuilder<HabitModel, HabitModel, QDistinct> distinctByTimeAnchor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeAnchor', caseSensitive: caseSensitive);
    });
  }
}

extension HabitModelQueryProperty
    on QueryBuilder<HabitModel, HabitModel, QQueryProperty> {
  QueryBuilder<HabitModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HabitModel, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<HabitModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<HabitModel, int, QQueryOperations> currentStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStreak');
    });
  }

  QueryBuilder<HabitModel, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<HabitModel, String, QQueryOperations> emojiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emoji');
    });
  }

  QueryBuilder<HabitModel, String, QQueryOperations> habitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitId');
    });
  }

  QueryBuilder<HabitModel, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<HabitModel, bool, QQueryOperations> isSystemHabitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSystemHabit');
    });
  }

  QueryBuilder<HabitModel, DateTime?, QQueryOperations>
      lastCompletedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCompletedDate');
    });
  }

  QueryBuilder<HabitModel, DateTime?, QQueryOperations>
      lastExcusedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastExcusedDate');
    });
  }

  QueryBuilder<HabitModel, int, QQueryOperations> longestStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longestStreak');
    });
  }

  QueryBuilder<HabitModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<HabitModel, bool, QQueryOperations>
      notificationsEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificationsEnabled');
    });
  }

  QueryBuilder<HabitModel, List<int>, QQueryOperations>
      scheduledDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledDays');
    });
  }

  QueryBuilder<HabitModel, bool, QQueryOperations>
      streakPauseOnCycleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streakPauseOnCycle');
    });
  }

  QueryBuilder<HabitModel, int, QQueryOperations>
      targetFrequencyPerWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetFrequencyPerWeek');
    });
  }

  QueryBuilder<HabitModel, String, QQueryOperations> timeAnchorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeAnchor');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStreakRecordModelCollection on Isar {
  IsarCollection<StreakRecordModel> get streakRecordModels => this.collection();
}

const StreakRecordModelSchema = CollectionSchema(
  name: r'StreakRecordModel',
  id: 7091987595418901744,
  properties: {
    r'completed': PropertySchema(
      id: 0,
      name: r'completed',
      type: IsarType.bool,
    ),
    r'completedAt': PropertySchema(
      id: 1,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'excused': PropertySchema(
      id: 3,
      name: r'excused',
      type: IsarType.bool,
    ),
    r'habitId': PropertySchema(
      id: 4,
      name: r'habitId',
      type: IsarType.string,
    ),
    r'note': PropertySchema(
      id: 5,
      name: r'note',
      type: IsarType.string,
    ),
    r'pauseReason': PropertySchema(
      id: 6,
      name: r'pauseReason',
      type: IsarType.string,
    ),
    r'recordId': PropertySchema(
      id: 7,
      name: r'recordId',
      type: IsarType.string,
    )
  },
  estimateSize: _streakRecordModelEstimateSize,
  serialize: _streakRecordModelSerialize,
  deserialize: _streakRecordModelDeserialize,
  deserializeProp: _streakRecordModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'recordId': IndexSchema(
      id: 907839981883940929,
      name: r'recordId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'recordId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'habitId': IndexSchema(
      id: 1000409552522198739,
      name: r'habitId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'habitId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _streakRecordModelGetId,
  getLinks: _streakRecordModelGetLinks,
  attach: _streakRecordModelAttach,
  version: '3.1.0+1',
);

int _streakRecordModelEstimateSize(
  StreakRecordModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.habitId.length * 3;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.pauseReason.length * 3;
  bytesCount += 3 + object.recordId.length * 3;
  return bytesCount;
}

void _streakRecordModelSerialize(
  StreakRecordModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.completed);
  writer.writeDateTime(offsets[1], object.completedAt);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeBool(offsets[3], object.excused);
  writer.writeString(offsets[4], object.habitId);
  writer.writeString(offsets[5], object.note);
  writer.writeString(offsets[6], object.pauseReason);
  writer.writeString(offsets[7], object.recordId);
}

StreakRecordModel _streakRecordModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StreakRecordModel();
  object.completed = reader.readBool(offsets[0]);
  object.completedAt = reader.readDateTimeOrNull(offsets[1]);
  object.date = reader.readDateTime(offsets[2]);
  object.excused = reader.readBool(offsets[3]);
  object.habitId = reader.readString(offsets[4]);
  object.id = id;
  object.note = reader.readStringOrNull(offsets[5]);
  object.pauseReason = reader.readString(offsets[6]);
  object.recordId = reader.readString(offsets[7]);
  return object;
}

P _streakRecordModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _streakRecordModelGetId(StreakRecordModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _streakRecordModelGetLinks(
    StreakRecordModel object) {
  return [];
}

void _streakRecordModelAttach(
    IsarCollection<dynamic> col, Id id, StreakRecordModel object) {
  object.id = id;
}

extension StreakRecordModelQueryWhereSort
    on QueryBuilder<StreakRecordModel, StreakRecordModel, QWhere> {
  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension StreakRecordModelQueryWhere
    on QueryBuilder<StreakRecordModel, StreakRecordModel, QWhereClause> {
  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterWhereClause>
      recordIdEqualTo(String recordId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'recordId',
        value: [recordId],
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterWhereClause>
      recordIdNotEqualTo(String recordId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recordId',
              lower: [],
              upper: [recordId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recordId',
              lower: [recordId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recordId',
              lower: [recordId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'recordId',
              lower: [],
              upper: [recordId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterWhereClause>
      habitIdEqualTo(String habitId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'habitId',
        value: [habitId],
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterWhereClause>
      habitIdNotEqualTo(String habitId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId',
              lower: [],
              upper: [habitId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId',
              lower: [habitId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId',
              lower: [habitId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'habitId',
              lower: [],
              upper: [habitId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterWhereClause>
      dateEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterWhereClause>
      dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterWhereClause>
      dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterWhereClause>
      dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterWhereClause>
      dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StreakRecordModelQueryFilter
    on QueryBuilder<StreakRecordModel, StreakRecordModel, QFilterCondition> {
  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      completedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completed',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      excusedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'excused',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      habitIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      habitIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      habitIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      habitIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'habitId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      habitIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      habitIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      habitIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'habitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      habitIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'habitId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      habitIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'habitId',
        value: '',
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      habitIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'habitId',
        value: '',
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
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

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      idLessThan(
    Id value, {
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

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      noteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      noteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      pauseReasonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pauseReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      pauseReasonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pauseReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      pauseReasonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pauseReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      pauseReasonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pauseReason',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      pauseReasonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pauseReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      pauseReasonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pauseReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      pauseReasonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pauseReason',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      pauseReasonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pauseReason',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      pauseReasonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pauseReason',
        value: '',
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      pauseReasonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pauseReason',
        value: '',
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      recordIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      recordIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      recordIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      recordIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recordId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      recordIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      recordIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      recordIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recordId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      recordIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recordId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      recordIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recordId',
        value: '',
      ));
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterFilterCondition>
      recordIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recordId',
        value: '',
      ));
    });
  }
}

extension StreakRecordModelQueryObject
    on QueryBuilder<StreakRecordModel, StreakRecordModel, QFilterCondition> {}

extension StreakRecordModelQueryLinks
    on QueryBuilder<StreakRecordModel, StreakRecordModel, QFilterCondition> {}

extension StreakRecordModelQuerySortBy
    on QueryBuilder<StreakRecordModel, StreakRecordModel, QSortBy> {
  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      sortByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      sortByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      sortByExcused() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'excused', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      sortByExcusedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'excused', Sort.desc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      sortByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      sortByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.desc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      sortByPauseReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pauseReason', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      sortByPauseReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pauseReason', Sort.desc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      sortByRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      sortByRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.desc);
    });
  }
}

extension StreakRecordModelQuerySortThenBy
    on QueryBuilder<StreakRecordModel, StreakRecordModel, QSortThenBy> {
  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completed', Sort.desc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByExcused() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'excused', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByExcusedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'excused', Sort.desc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.desc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByPauseReason() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pauseReason', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByPauseReasonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pauseReason', Sort.desc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.asc);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QAfterSortBy>
      thenByRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.desc);
    });
  }
}

extension StreakRecordModelQueryWhereDistinct
    on QueryBuilder<StreakRecordModel, StreakRecordModel, QDistinct> {
  QueryBuilder<StreakRecordModel, StreakRecordModel, QDistinct>
      distinctByCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completed');
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QDistinct>
      distinctByExcused() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'excused');
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QDistinct>
      distinctByHabitId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'habitId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QDistinct>
      distinctByPauseReason({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pauseReason', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StreakRecordModel, StreakRecordModel, QDistinct>
      distinctByRecordId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recordId', caseSensitive: caseSensitive);
    });
  }
}

extension StreakRecordModelQueryProperty
    on QueryBuilder<StreakRecordModel, StreakRecordModel, QQueryProperty> {
  QueryBuilder<StreakRecordModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StreakRecordModel, bool, QQueryOperations> completedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completed');
    });
  }

  QueryBuilder<StreakRecordModel, DateTime?, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<StreakRecordModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<StreakRecordModel, bool, QQueryOperations> excusedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'excused');
    });
  }

  QueryBuilder<StreakRecordModel, String, QQueryOperations> habitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitId');
    });
  }

  QueryBuilder<StreakRecordModel, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<StreakRecordModel, String, QQueryOperations>
      pauseReasonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pauseReason');
    });
  }

  QueryBuilder<StreakRecordModel, String, QQueryOperations> recordIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recordId');
    });
  }
}
