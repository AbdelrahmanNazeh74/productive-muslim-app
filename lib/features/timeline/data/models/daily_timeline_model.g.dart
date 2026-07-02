// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_timeline_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyTimelineModelCollection on Isar {
  IsarCollection<DailyTimelineModel> get dailyTimelineModels =>
      this.collection();
}

const DailyTimelineModelSchema = CollectionSchema(
  name: r'DailyTimelineModel',
  id: 665248355030224041,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'dayType': PropertySchema(
      id: 1,
      name: r'dayType',
      type: IsarType.string,
    ),
    r'eveningReflection': PropertySchema(
      id: 2,
      name: r'eveningReflection',
      type: IsarType.string,
    ),
    r'generatedAt': PropertySchema(
      id: 3,
      name: r'generatedAt',
      type: IsarType.dateTime,
    ),
    r'morningIntention': PropertySchema(
      id: 4,
      name: r'morningIntention',
      type: IsarType.string,
    )
  },
  estimateSize: _dailyTimelineModelEstimateSize,
  serialize: _dailyTimelineModelSerialize,
  deserialize: _dailyTimelineModelDeserialize,
  deserializeProp: _dailyTimelineModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
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
  links: {
    r'blocks': LinkSchema(
      id: -2146207780629314226,
      name: r'blocks',
      target: r'TimeBlockModel',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _dailyTimelineModelGetId,
  getLinks: _dailyTimelineModelGetLinks,
  attach: _dailyTimelineModelAttach,
  version: '3.1.0+1',
);

int _dailyTimelineModelEstimateSize(
  DailyTimelineModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dayType.length * 3;
  {
    final value = object.eveningReflection;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.morningIntention;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _dailyTimelineModelSerialize(
  DailyTimelineModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeString(offsets[1], object.dayType);
  writer.writeString(offsets[2], object.eveningReflection);
  writer.writeDateTime(offsets[3], object.generatedAt);
  writer.writeString(offsets[4], object.morningIntention);
}

DailyTimelineModel _dailyTimelineModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyTimelineModel();
  object.date = reader.readDateTime(offsets[0]);
  object.dayType = reader.readString(offsets[1]);
  object.eveningReflection = reader.readStringOrNull(offsets[2]);
  object.generatedAt = reader.readDateTime(offsets[3]);
  object.id = id;
  object.morningIntention = reader.readStringOrNull(offsets[4]);
  return object;
}

P _dailyTimelineModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyTimelineModelGetId(DailyTimelineModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyTimelineModelGetLinks(
    DailyTimelineModel object) {
  return [object.blocks];
}

void _dailyTimelineModelAttach(
    IsarCollection<dynamic> col, Id id, DailyTimelineModel object) {
  object.id = id;
  object.blocks
      .attach(col, col.isar.collection<TimeBlockModel>(), r'blocks', id);
}

extension DailyTimelineModelByIndex on IsarCollection<DailyTimelineModel> {
  Future<DailyTimelineModel?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  DailyTimelineModel? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<DailyTimelineModel?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<DailyTimelineModel?> getAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(DailyTimelineModel object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(DailyTimelineModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<DailyTimelineModel> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<DailyTimelineModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension DailyTimelineModelQueryWhereSort
    on QueryBuilder<DailyTimelineModel, DailyTimelineModel, QWhere> {
  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension DailyTimelineModelQueryWhere
    on QueryBuilder<DailyTimelineModel, DailyTimelineModel, QWhereClause> {
  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterWhereClause>
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

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterWhereClause>
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

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterWhereClause>
      dateEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterWhereClause>
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

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterWhereClause>
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

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterWhereClause>
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

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterWhereClause>
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

extension DailyTimelineModelQueryFilter
    on QueryBuilder<DailyTimelineModel, DailyTimelineModel, QFilterCondition> {
  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
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

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
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

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
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

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      dayTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      dayTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      dayTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      dayTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      dayTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dayType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      dayTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dayType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      dayTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dayType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      dayTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dayType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      dayTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayType',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      dayTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dayType',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      eveningReflectionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'eveningReflection',
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      eveningReflectionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'eveningReflection',
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      eveningReflectionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eveningReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      eveningReflectionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eveningReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      eveningReflectionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eveningReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      eveningReflectionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eveningReflection',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      eveningReflectionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'eveningReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      eveningReflectionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'eveningReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      eveningReflectionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'eveningReflection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      eveningReflectionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'eveningReflection',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      eveningReflectionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eveningReflection',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      eveningReflectionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'eveningReflection',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      generatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      generatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      generatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      generatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'generatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
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

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
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

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
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

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      morningIntentionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'morningIntention',
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      morningIntentionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'morningIntention',
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      morningIntentionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'morningIntention',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      morningIntentionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'morningIntention',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      morningIntentionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'morningIntention',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      morningIntentionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'morningIntention',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      morningIntentionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'morningIntention',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      morningIntentionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'morningIntention',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      morningIntentionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'morningIntention',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      morningIntentionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'morningIntention',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      morningIntentionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'morningIntention',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      morningIntentionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'morningIntention',
        value: '',
      ));
    });
  }
}

extension DailyTimelineModelQueryObject
    on QueryBuilder<DailyTimelineModel, DailyTimelineModel, QFilterCondition> {}

extension DailyTimelineModelQueryLinks
    on QueryBuilder<DailyTimelineModel, DailyTimelineModel, QFilterCondition> {
  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      blocks(FilterQuery<TimeBlockModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'blocks');
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      blocksLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'blocks', length, true, length, true);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      blocksIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'blocks', 0, true, 0, true);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      blocksIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'blocks', 0, false, 999999, true);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      blocksLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'blocks', 0, true, length, include);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      blocksLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'blocks', length, include, 999999, true);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterFilterCondition>
      blocksLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'blocks', lower, includeLower, upper, includeUpper);
    });
  }
}

extension DailyTimelineModelQuerySortBy
    on QueryBuilder<DailyTimelineModel, DailyTimelineModel, QSortBy> {
  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      sortByDayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayType', Sort.asc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      sortByDayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayType', Sort.desc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      sortByEveningReflection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eveningReflection', Sort.asc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      sortByEveningReflectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eveningReflection', Sort.desc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      sortByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      sortByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      sortByMorningIntention() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'morningIntention', Sort.asc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      sortByMorningIntentionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'morningIntention', Sort.desc);
    });
  }
}

extension DailyTimelineModelQuerySortThenBy
    on QueryBuilder<DailyTimelineModel, DailyTimelineModel, QSortThenBy> {
  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      thenByDayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayType', Sort.asc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      thenByDayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayType', Sort.desc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      thenByEveningReflection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eveningReflection', Sort.asc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      thenByEveningReflectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eveningReflection', Sort.desc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      thenByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      thenByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      thenByMorningIntention() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'morningIntention', Sort.asc);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QAfterSortBy>
      thenByMorningIntentionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'morningIntention', Sort.desc);
    });
  }
}

extension DailyTimelineModelQueryWhereDistinct
    on QueryBuilder<DailyTimelineModel, DailyTimelineModel, QDistinct> {
  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QDistinct>
      distinctByDayType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QDistinct>
      distinctByEveningReflection({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eveningReflection',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QDistinct>
      distinctByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAt');
    });
  }

  QueryBuilder<DailyTimelineModel, DailyTimelineModel, QDistinct>
      distinctByMorningIntention({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'morningIntention',
          caseSensitive: caseSensitive);
    });
  }
}

extension DailyTimelineModelQueryProperty
    on QueryBuilder<DailyTimelineModel, DailyTimelineModel, QQueryProperty> {
  QueryBuilder<DailyTimelineModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyTimelineModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailyTimelineModel, String, QQueryOperations> dayTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayType');
    });
  }

  QueryBuilder<DailyTimelineModel, String?, QQueryOperations>
      eveningReflectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eveningReflection');
    });
  }

  QueryBuilder<DailyTimelineModel, DateTime, QQueryOperations>
      generatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAt');
    });
  }

  QueryBuilder<DailyTimelineModel, String?, QQueryOperations>
      morningIntentionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'morningIntention');
    });
  }
}
