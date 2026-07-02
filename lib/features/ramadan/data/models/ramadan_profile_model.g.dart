// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ramadan_profile_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRamadanProfileModelCollection on Isar {
  IsarCollection<RamadanProfileModel> get ramadanProfileModels =>
      this.collection();
}

const RamadanProfileModelSchema = CollectionSchema(
  name: r'RamadanProfileModel',
  id: -8108466840299407608,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'daySleepMinutes': PropertySchema(
      id: 1,
      name: r'daySleepMinutes',
      type: IsarType.long,
    ),
    r'hasIftarGathering': PropertySchema(
      id: 2,
      name: r'hasIftarGathering',
      type: IsarType.bool,
    ),
    r'hasLaylatAlQadrMode': PropertySchema(
      id: 3,
      name: r'hasLaylatAlQadrMode',
      type: IsarType.bool,
    ),
    r'hasReducedWorkHours': PropertySchema(
      id: 4,
      name: r'hasReducedWorkHours',
      type: IsarType.bool,
    ),
    r'iftarDurationMinutes': PropertySchema(
      id: 5,
      name: r'iftarDurationMinutes',
      type: IsarType.long,
    ),
    r'nightSleepHours': PropertySchema(
      id: 6,
      name: r'nightSleepHours',
      type: IsarType.long,
    ),
    r'praysTarawih': PropertySchema(
      id: 7,
      name: r'praysTarawih',
      type: IsarType.bool,
    ),
    r'praysWitr': PropertySchema(
      id: 8,
      name: r'praysWitr',
      type: IsarType.bool,
    ),
    r'ramadanQuranPagesGoal': PropertySchema(
      id: 9,
      name: r'ramadanQuranPagesGoal',
      type: IsarType.long,
    ),
    r'reducedWorkEndHour': PropertySchema(
      id: 10,
      name: r'reducedWorkEndHour',
      type: IsarType.long,
    ),
    r'reducedWorkEndMinute': PropertySchema(
      id: 11,
      name: r'reducedWorkEndMinute',
      type: IsarType.long,
    ),
    r'suhoorDurationMinutes': PropertySchema(
      id: 12,
      name: r'suhoorDurationMinutes',
      type: IsarType.long,
    ),
    r'suhoorWakeMinutesBeforeFajr': PropertySchema(
      id: 13,
      name: r'suhoorWakeMinutesBeforeFajr',
      type: IsarType.long,
    ),
    r'tarawihDurationMinutes': PropertySchema(
      id: 14,
      name: r'tarawihDurationMinutes',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 15,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _ramadanProfileModelEstimateSize,
  serialize: _ramadanProfileModelSerialize,
  deserialize: _ramadanProfileModelDeserialize,
  deserializeProp: _ramadanProfileModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _ramadanProfileModelGetId,
  getLinks: _ramadanProfileModelGetLinks,
  attach: _ramadanProfileModelAttach,
  version: '3.1.0+1',
);

int _ramadanProfileModelEstimateSize(
  RamadanProfileModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _ramadanProfileModelSerialize(
  RamadanProfileModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.daySleepMinutes);
  writer.writeBool(offsets[2], object.hasIftarGathering);
  writer.writeBool(offsets[3], object.hasLaylatAlQadrMode);
  writer.writeBool(offsets[4], object.hasReducedWorkHours);
  writer.writeLong(offsets[5], object.iftarDurationMinutes);
  writer.writeLong(offsets[6], object.nightSleepHours);
  writer.writeBool(offsets[7], object.praysTarawih);
  writer.writeBool(offsets[8], object.praysWitr);
  writer.writeLong(offsets[9], object.ramadanQuranPagesGoal);
  writer.writeLong(offsets[10], object.reducedWorkEndHour);
  writer.writeLong(offsets[11], object.reducedWorkEndMinute);
  writer.writeLong(offsets[12], object.suhoorDurationMinutes);
  writer.writeLong(offsets[13], object.suhoorWakeMinutesBeforeFajr);
  writer.writeLong(offsets[14], object.tarawihDurationMinutes);
  writer.writeDateTime(offsets[15], object.updatedAt);
}

RamadanProfileModel _ramadanProfileModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RamadanProfileModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.daySleepMinutes = reader.readLong(offsets[1]);
  object.hasIftarGathering = reader.readBool(offsets[2]);
  object.hasLaylatAlQadrMode = reader.readBool(offsets[3]);
  object.hasReducedWorkHours = reader.readBool(offsets[4]);
  object.id = id;
  object.iftarDurationMinutes = reader.readLong(offsets[5]);
  object.nightSleepHours = reader.readLong(offsets[6]);
  object.praysTarawih = reader.readBool(offsets[7]);
  object.praysWitr = reader.readBool(offsets[8]);
  object.ramadanQuranPagesGoal = reader.readLong(offsets[9]);
  object.reducedWorkEndHour = reader.readLong(offsets[10]);
  object.reducedWorkEndMinute = reader.readLong(offsets[11]);
  object.suhoorDurationMinutes = reader.readLong(offsets[12]);
  object.suhoorWakeMinutesBeforeFajr = reader.readLong(offsets[13]);
  object.tarawihDurationMinutes = reader.readLong(offsets[14]);
  object.updatedAt = reader.readDateTime(offsets[15]);
  return object;
}

P _ramadanProfileModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _ramadanProfileModelGetId(RamadanProfileModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _ramadanProfileModelGetLinks(
    RamadanProfileModel object) {
  return [];
}

void _ramadanProfileModelAttach(
    IsarCollection<dynamic> col, Id id, RamadanProfileModel object) {
  object.id = id;
}

extension RamadanProfileModelQueryWhereSort
    on QueryBuilder<RamadanProfileModel, RamadanProfileModel, QWhere> {
  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RamadanProfileModelQueryWhere
    on QueryBuilder<RamadanProfileModel, RamadanProfileModel, QWhereClause> {
  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterWhereClause>
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

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterWhereClause>
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
}

extension RamadanProfileModelQueryFilter on QueryBuilder<RamadanProfileModel,
    RamadanProfileModel, QFilterCondition> {
  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
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

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      daySleepMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'daySleepMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      daySleepMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'daySleepMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      daySleepMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'daySleepMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      daySleepMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'daySleepMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      hasIftarGatheringEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasIftarGathering',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      hasLaylatAlQadrModeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasLaylatAlQadrMode',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      hasReducedWorkHoursEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasReducedWorkHours',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
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

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
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

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
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

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      iftarDurationMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iftarDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      iftarDurationMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iftarDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      iftarDurationMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iftarDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      iftarDurationMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iftarDurationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      nightSleepHoursEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nightSleepHours',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      nightSleepHoursGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nightSleepHours',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      nightSleepHoursLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nightSleepHours',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      nightSleepHoursBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nightSleepHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      praysTarawihEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'praysTarawih',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      praysWitrEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'praysWitr',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      ramadanQuranPagesGoalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ramadanQuranPagesGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      ramadanQuranPagesGoalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ramadanQuranPagesGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      ramadanQuranPagesGoalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ramadanQuranPagesGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      ramadanQuranPagesGoalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ramadanQuranPagesGoal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      reducedWorkEndHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reducedWorkEndHour',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      reducedWorkEndHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reducedWorkEndHour',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      reducedWorkEndHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reducedWorkEndHour',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      reducedWorkEndHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reducedWorkEndHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      reducedWorkEndMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reducedWorkEndMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      reducedWorkEndMinuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reducedWorkEndMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      reducedWorkEndMinuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reducedWorkEndMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      reducedWorkEndMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reducedWorkEndMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      suhoorDurationMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'suhoorDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      suhoorDurationMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'suhoorDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      suhoorDurationMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'suhoorDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      suhoorDurationMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'suhoorDurationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      suhoorWakeMinutesBeforeFajrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'suhoorWakeMinutesBeforeFajr',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      suhoorWakeMinutesBeforeFajrGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'suhoorWakeMinutesBeforeFajr',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      suhoorWakeMinutesBeforeFajrLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'suhoorWakeMinutesBeforeFajr',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      suhoorWakeMinutesBeforeFajrBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'suhoorWakeMinutesBeforeFajr',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      tarawihDurationMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tarawihDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      tarawihDurationMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tarawihDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      tarawihDurationMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tarawihDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      tarawihDurationMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tarawihDurationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RamadanProfileModelQueryObject on QueryBuilder<RamadanProfileModel,
    RamadanProfileModel, QFilterCondition> {}

extension RamadanProfileModelQueryLinks on QueryBuilder<RamadanProfileModel,
    RamadanProfileModel, QFilterCondition> {}

extension RamadanProfileModelQuerySortBy
    on QueryBuilder<RamadanProfileModel, RamadanProfileModel, QSortBy> {
  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByDaySleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daySleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByDaySleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daySleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByHasIftarGathering() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasIftarGathering', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByHasIftarGatheringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasIftarGathering', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByHasLaylatAlQadrMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasLaylatAlQadrMode', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByHasLaylatAlQadrModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasLaylatAlQadrMode', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByHasReducedWorkHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReducedWorkHours', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByHasReducedWorkHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReducedWorkHours', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByIftarDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iftarDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByIftarDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iftarDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByNightSleepHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nightSleepHours', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByNightSleepHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nightSleepHours', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByPraysTarawih() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'praysTarawih', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByPraysTarawihDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'praysTarawih', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByPraysWitr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'praysWitr', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByPraysWitrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'praysWitr', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByRamadanQuranPagesGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ramadanQuranPagesGoal', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByRamadanQuranPagesGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ramadanQuranPagesGoal', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByReducedWorkEndHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reducedWorkEndHour', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByReducedWorkEndHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reducedWorkEndHour', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByReducedWorkEndMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reducedWorkEndMinute', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByReducedWorkEndMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reducedWorkEndMinute', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortBySuhoorDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suhoorDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortBySuhoorDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suhoorDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortBySuhoorWakeMinutesBeforeFajr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suhoorWakeMinutesBeforeFajr', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortBySuhoorWakeMinutesBeforeFajrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suhoorWakeMinutesBeforeFajr', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByTarawihDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tarawihDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByTarawihDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tarawihDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension RamadanProfileModelQuerySortThenBy
    on QueryBuilder<RamadanProfileModel, RamadanProfileModel, QSortThenBy> {
  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByDaySleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daySleepMinutes', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByDaySleepMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'daySleepMinutes', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByHasIftarGathering() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasIftarGathering', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByHasIftarGatheringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasIftarGathering', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByHasLaylatAlQadrMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasLaylatAlQadrMode', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByHasLaylatAlQadrModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasLaylatAlQadrMode', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByHasReducedWorkHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReducedWorkHours', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByHasReducedWorkHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReducedWorkHours', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByIftarDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iftarDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByIftarDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iftarDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByNightSleepHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nightSleepHours', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByNightSleepHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nightSleepHours', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByPraysTarawih() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'praysTarawih', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByPraysTarawihDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'praysTarawih', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByPraysWitr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'praysWitr', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByPraysWitrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'praysWitr', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByRamadanQuranPagesGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ramadanQuranPagesGoal', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByRamadanQuranPagesGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ramadanQuranPagesGoal', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByReducedWorkEndHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reducedWorkEndHour', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByReducedWorkEndHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reducedWorkEndHour', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByReducedWorkEndMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reducedWorkEndMinute', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByReducedWorkEndMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reducedWorkEndMinute', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenBySuhoorDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suhoorDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenBySuhoorDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suhoorDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenBySuhoorWakeMinutesBeforeFajr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suhoorWakeMinutesBeforeFajr', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenBySuhoorWakeMinutesBeforeFajrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'suhoorWakeMinutesBeforeFajr', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByTarawihDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tarawihDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByTarawihDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tarawihDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension RamadanProfileModelQueryWhereDistinct
    on QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct> {
  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct>
      distinctByDaySleepMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'daySleepMinutes');
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct>
      distinctByHasIftarGathering() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasIftarGathering');
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct>
      distinctByHasLaylatAlQadrMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasLaylatAlQadrMode');
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct>
      distinctByHasReducedWorkHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasReducedWorkHours');
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct>
      distinctByIftarDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iftarDurationMinutes');
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct>
      distinctByNightSleepHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nightSleepHours');
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct>
      distinctByPraysTarawih() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'praysTarawih');
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct>
      distinctByPraysWitr() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'praysWitr');
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct>
      distinctByRamadanQuranPagesGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ramadanQuranPagesGoal');
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct>
      distinctByReducedWorkEndHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reducedWorkEndHour');
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct>
      distinctByReducedWorkEndMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reducedWorkEndMinute');
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct>
      distinctBySuhoorDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'suhoorDurationMinutes');
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct>
      distinctBySuhoorWakeMinutesBeforeFajr() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'suhoorWakeMinutesBeforeFajr');
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct>
      distinctByTarawihDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tarawihDurationMinutes');
    });
  }

  QueryBuilder<RamadanProfileModel, RamadanProfileModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension RamadanProfileModelQueryProperty
    on QueryBuilder<RamadanProfileModel, RamadanProfileModel, QQueryProperty> {
  QueryBuilder<RamadanProfileModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RamadanProfileModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<RamadanProfileModel, int, QQueryOperations>
      daySleepMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'daySleepMinutes');
    });
  }

  QueryBuilder<RamadanProfileModel, bool, QQueryOperations>
      hasIftarGatheringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasIftarGathering');
    });
  }

  QueryBuilder<RamadanProfileModel, bool, QQueryOperations>
      hasLaylatAlQadrModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasLaylatAlQadrMode');
    });
  }

  QueryBuilder<RamadanProfileModel, bool, QQueryOperations>
      hasReducedWorkHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasReducedWorkHours');
    });
  }

  QueryBuilder<RamadanProfileModel, int, QQueryOperations>
      iftarDurationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iftarDurationMinutes');
    });
  }

  QueryBuilder<RamadanProfileModel, int, QQueryOperations>
      nightSleepHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nightSleepHours');
    });
  }

  QueryBuilder<RamadanProfileModel, bool, QQueryOperations>
      praysTarawihProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'praysTarawih');
    });
  }

  QueryBuilder<RamadanProfileModel, bool, QQueryOperations>
      praysWitrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'praysWitr');
    });
  }

  QueryBuilder<RamadanProfileModel, int, QQueryOperations>
      ramadanQuranPagesGoalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ramadanQuranPagesGoal');
    });
  }

  QueryBuilder<RamadanProfileModel, int, QQueryOperations>
      reducedWorkEndHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reducedWorkEndHour');
    });
  }

  QueryBuilder<RamadanProfileModel, int, QQueryOperations>
      reducedWorkEndMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reducedWorkEndMinute');
    });
  }

  QueryBuilder<RamadanProfileModel, int, QQueryOperations>
      suhoorDurationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'suhoorDurationMinutes');
    });
  }

  QueryBuilder<RamadanProfileModel, int, QQueryOperations>
      suhoorWakeMinutesBeforeFajrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'suhoorWakeMinutesBeforeFajr');
    });
  }

  QueryBuilder<RamadanProfileModel, int, QQueryOperations>
      tarawihDurationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tarawihDurationMinutes');
    });
  }

  QueryBuilder<RamadanProfileModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
