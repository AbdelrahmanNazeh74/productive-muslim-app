// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserProfileModelCollection on Isar {
  IsarCollection<UserProfileModel> get userProfileModels => this.collection();
}

const UserProfileModelSchema = CollectionSchema(
  name: r'UserProfileModel',
  id: -8790468936041821297,
  properties: {
    r'calculationMethod': PropertySchema(
      id: 0,
      name: r'calculationMethod',
      type: IsarType.string,
    ),
    r'city': PropertySchema(
      id: 1,
      name: r'city',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'cycleAwareStreaks': PropertySchema(
      id: 3,
      name: r'cycleAwareStreaks',
      type: IsarType.bool,
    ),
    r'dailyQuranPagesGoal': PropertySchema(
      id: 4,
      name: r'dailyQuranPagesGoal',
      type: IsarType.long,
    ),
    r'fitnessActivityIds': PropertySchema(
      id: 5,
      name: r'fitnessActivityIds',
      type: IsarType.stringList,
    ),
    r'gender': PropertySchema(
      id: 6,
      name: r'gender',
      type: IsarType.string,
    ),
    r'gymDays': PropertySchema(
      id: 7,
      name: r'gymDays',
      type: IsarType.longList,
    ),
    r'gymDurationMinutes': PropertySchema(
      id: 8,
      name: r'gymDurationMinutes',
      type: IsarType.long,
    ),
    r'isOnboardingComplete': PropertySchema(
      id: 9,
      name: r'isOnboardingComplete',
      type: IsarType.bool,
    ),
    r'isRamadanMode': PropertySchema(
      id: 10,
      name: r'isRamadanMode',
      type: IsarType.bool,
    ),
    r'latitude': PropertySchema(
      id: 11,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 12,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'madhab': PropertySchema(
      id: 13,
      name: r'madhab',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 14,
      name: r'name',
      type: IsarType.string,
    ),
    r'occupationId': PropertySchema(
      id: 15,
      name: r'occupationId',
      type: IsarType.string,
    ),
    r'occupationLabel': PropertySchema(
      id: 16,
      name: r'occupationLabel',
      type: IsarType.string,
    ),
    r'occupationType': PropertySchema(
      id: 17,
      name: r'occupationType',
      type: IsarType.string,
    ),
    r'prayerBufferMinutes': PropertySchema(
      id: 18,
      name: r'prayerBufferMinutes',
      type: IsarType.long,
    ),
    r'preferredGymTime': PropertySchema(
      id: 19,
      name: r'preferredGymTime',
      type: IsarType.string,
    ),
    r'targetSleepHours': PropertySchema(
      id: 20,
      name: r'targetSleepHours',
      type: IsarType.long,
    ),
    r'timezone': PropertySchema(
      id: 21,
      name: r'timezone',
      type: IsarType.string,
    ),
    r'wakeUpOffsetFromFajrMinutes': PropertySchema(
      id: 22,
      name: r'wakeUpOffsetFromFajrMinutes',
      type: IsarType.long,
    ),
    r'workDays': PropertySchema(
      id: 23,
      name: r'workDays',
      type: IsarType.longList,
    ),
    r'workEndHour': PropertySchema(
      id: 24,
      name: r'workEndHour',
      type: IsarType.long,
    ),
    r'workEndMinute': PropertySchema(
      id: 25,
      name: r'workEndMinute',
      type: IsarType.long,
    ),
    r'workStartHour': PropertySchema(
      id: 26,
      name: r'workStartHour',
      type: IsarType.long,
    ),
    r'workStartMinute': PropertySchema(
      id: 27,
      name: r'workStartMinute',
      type: IsarType.long,
    )
  },
  estimateSize: _userProfileModelEstimateSize,
  serialize: _userProfileModelSerialize,
  deserialize: _userProfileModelDeserialize,
  deserializeProp: _userProfileModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userProfileModelGetId,
  getLinks: _userProfileModelGetLinks,
  attach: _userProfileModelAttach,
  version: '3.1.0+1',
);

int _userProfileModelEstimateSize(
  UserProfileModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.calculationMethod.length * 3;
  bytesCount += 3 + object.city.length * 3;
  bytesCount += 3 + object.fitnessActivityIds.length * 3;
  {
    for (var i = 0; i < object.fitnessActivityIds.length; i++) {
      final value = object.fitnessActivityIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.gender.length * 3;
  bytesCount += 3 + object.gymDays.length * 8;
  bytesCount += 3 + object.madhab.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.occupationId.length * 3;
  bytesCount += 3 + object.occupationLabel.length * 3;
  bytesCount += 3 + object.occupationType.length * 3;
  bytesCount += 3 + object.preferredGymTime.length * 3;
  bytesCount += 3 + object.timezone.length * 3;
  bytesCount += 3 + object.workDays.length * 8;
  return bytesCount;
}

void _userProfileModelSerialize(
  UserProfileModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.calculationMethod);
  writer.writeString(offsets[1], object.city);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeBool(offsets[3], object.cycleAwareStreaks);
  writer.writeLong(offsets[4], object.dailyQuranPagesGoal);
  writer.writeStringList(offsets[5], object.fitnessActivityIds);
  writer.writeString(offsets[6], object.gender);
  writer.writeLongList(offsets[7], object.gymDays);
  writer.writeLong(offsets[8], object.gymDurationMinutes);
  writer.writeBool(offsets[9], object.isOnboardingComplete);
  writer.writeBool(offsets[10], object.isRamadanMode);
  writer.writeDouble(offsets[11], object.latitude);
  writer.writeDouble(offsets[12], object.longitude);
  writer.writeString(offsets[13], object.madhab);
  writer.writeString(offsets[14], object.name);
  writer.writeString(offsets[15], object.occupationId);
  writer.writeString(offsets[16], object.occupationLabel);
  writer.writeString(offsets[17], object.occupationType);
  writer.writeLong(offsets[18], object.prayerBufferMinutes);
  writer.writeString(offsets[19], object.preferredGymTime);
  writer.writeLong(offsets[20], object.targetSleepHours);
  writer.writeString(offsets[21], object.timezone);
  writer.writeLong(offsets[22], object.wakeUpOffsetFromFajrMinutes);
  writer.writeLongList(offsets[23], object.workDays);
  writer.writeLong(offsets[24], object.workEndHour);
  writer.writeLong(offsets[25], object.workEndMinute);
  writer.writeLong(offsets[26], object.workStartHour);
  writer.writeLong(offsets[27], object.workStartMinute);
}

UserProfileModel _userProfileModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserProfileModel();
  object.calculationMethod = reader.readString(offsets[0]);
  object.city = reader.readString(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.cycleAwareStreaks = reader.readBool(offsets[3]);
  object.dailyQuranPagesGoal = reader.readLong(offsets[4]);
  object.fitnessActivityIds = reader.readStringList(offsets[5]) ?? [];
  object.gender = reader.readString(offsets[6]);
  object.gymDays = reader.readLongList(offsets[7]) ?? [];
  object.gymDurationMinutes = reader.readLong(offsets[8]);
  object.id = id;
  object.isOnboardingComplete = reader.readBool(offsets[9]);
  object.isRamadanMode = reader.readBool(offsets[10]);
  object.latitude = reader.readDouble(offsets[11]);
  object.longitude = reader.readDouble(offsets[12]);
  object.madhab = reader.readString(offsets[13]);
  object.name = reader.readString(offsets[14]);
  object.occupationId = reader.readString(offsets[15]);
  object.occupationLabel = reader.readString(offsets[16]);
  object.occupationType = reader.readString(offsets[17]);
  object.prayerBufferMinutes = reader.readLong(offsets[18]);
  object.preferredGymTime = reader.readString(offsets[19]);
  object.targetSleepHours = reader.readLong(offsets[20]);
  object.timezone = reader.readString(offsets[21]);
  object.wakeUpOffsetFromFajrMinutes = reader.readLong(offsets[22]);
  object.workDays = reader.readLongList(offsets[23]) ?? [];
  object.workEndHour = reader.readLong(offsets[24]);
  object.workEndMinute = reader.readLong(offsets[25]);
  object.workStartHour = reader.readLong(offsets[26]);
  object.workStartMinute = reader.readLong(offsets[27]);
  return object;
}

P _userProfileModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readStringList(offset) ?? []) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLongList(offset) ?? []) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readLong(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readLong(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (reader.readLong(offset)) as P;
    case 23:
      return (reader.readLongList(offset) ?? []) as P;
    case 24:
      return (reader.readLong(offset)) as P;
    case 25:
      return (reader.readLong(offset)) as P;
    case 26:
      return (reader.readLong(offset)) as P;
    case 27:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userProfileModelGetId(UserProfileModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userProfileModelGetLinks(UserProfileModel object) {
  return [];
}

void _userProfileModelAttach(
    IsarCollection<dynamic> col, Id id, UserProfileModel object) {
  object.id = id;
}

extension UserProfileModelQueryWhereSort
    on QueryBuilder<UserProfileModel, UserProfileModel, QWhere> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserProfileModelQueryWhere
    on QueryBuilder<UserProfileModel, UserProfileModel, QWhereClause> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause> idBetween(
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

extension UserProfileModelQueryFilter
    on QueryBuilder<UserProfileModel, UserProfileModel, QFilterCondition> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      calculationMethodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calculationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      calculationMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calculationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      calculationMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calculationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      calculationMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calculationMethod',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      calculationMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'calculationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      calculationMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'calculationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      calculationMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'calculationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      calculationMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'calculationMethod',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      calculationMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calculationMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      calculationMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'calculationMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      cityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      cityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      cityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      cityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'city',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      cityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      cityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      cityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      cityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'city',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      cityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      cityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      cycleAwareStreaksEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cycleAwareStreaks',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      dailyQuranPagesGoalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailyQuranPagesGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      dailyQuranPagesGoalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailyQuranPagesGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      dailyQuranPagesGoalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailyQuranPagesGoal',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      dailyQuranPagesGoalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailyQuranPagesGoal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fitnessActivityIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fitnessActivityIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fitnessActivityIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fitnessActivityIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fitnessActivityIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fitnessActivityIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fitnessActivityIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fitnessActivityIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fitnessActivityIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fitnessActivityIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fitnessActivityIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fitnessActivityIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fitnessActivityIdsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fitnessActivityIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fitnessActivityIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fitnessActivityIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fitnessActivityIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fitnessActivityIds',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fitnessActivityIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fitnessActivityIds',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fitnessActivityIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fitnessActivityIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fitnessActivityIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fitnessActivityIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fitnessActivityIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fitnessActivityIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fitnessActivityIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fitnessActivityIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fitnessActivityIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fitnessActivityIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      fitnessActivityIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'fitnessActivityIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      genderEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      genderGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      genderLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      genderBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      genderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      genderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      genderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      genderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gender',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      genderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      genderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      gymDaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gymDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      gymDaysElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gymDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      gymDaysElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gymDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      gymDaysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gymDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      gymDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'gymDays',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      gymDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'gymDays',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      gymDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'gymDays',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      gymDaysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'gymDays',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      gymDaysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'gymDays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      gymDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'gymDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      gymDurationMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gymDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      gymDurationMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gymDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      gymDurationMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gymDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      gymDurationMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gymDurationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      isOnboardingCompleteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isOnboardingComplete',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      isRamadanModeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRamadanMode',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      latitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      latitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      latitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      latitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      longitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      longitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      longitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      longitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      madhabEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'madhab',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      madhabGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'madhab',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      madhabLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'madhab',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      madhabBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'madhab',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      madhabStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'madhab',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      madhabEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'madhab',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      madhabContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'madhab',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      madhabMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'madhab',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      madhabIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'madhab',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      madhabIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'madhab',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      nameEqualTo(
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      nameGreaterThan(
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      nameBetween(
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      nameStartsWith(
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occupationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'occupationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'occupationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'occupationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'occupationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'occupationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'occupationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'occupationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occupationId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'occupationId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occupationLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'occupationLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'occupationLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'occupationLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'occupationLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'occupationLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'occupationLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'occupationLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occupationLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'occupationLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occupationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'occupationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'occupationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'occupationType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'occupationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'occupationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'occupationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'occupationType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occupationType',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      occupationTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'occupationType',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      prayerBufferMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prayerBufferMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      prayerBufferMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prayerBufferMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      prayerBufferMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prayerBufferMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      prayerBufferMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prayerBufferMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      preferredGymTimeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preferredGymTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      preferredGymTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'preferredGymTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      preferredGymTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'preferredGymTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      preferredGymTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'preferredGymTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      preferredGymTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'preferredGymTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      preferredGymTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'preferredGymTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      preferredGymTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'preferredGymTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      preferredGymTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'preferredGymTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      preferredGymTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preferredGymTime',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      preferredGymTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'preferredGymTime',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      targetSleepHoursEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetSleepHours',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      targetSleepHoursGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetSleepHours',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      targetSleepHoursLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetSleepHours',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      targetSleepHoursBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetSleepHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      timezoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      timezoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      timezoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      timezoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timezone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      timezoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'timezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      timezoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'timezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      timezoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'timezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      timezoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'timezone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      timezoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timezone',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      timezoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'timezone',
        value: '',
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      wakeUpOffsetFromFajrMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wakeUpOffsetFromFajrMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      wakeUpOffsetFromFajrMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wakeUpOffsetFromFajrMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      wakeUpOffsetFromFajrMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wakeUpOffsetFromFajrMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      wakeUpOffsetFromFajrMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wakeUpOffsetFromFajrMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workDaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workDaysElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workDaysElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workDays',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workDaysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workDays',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workDays',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workDays',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workDaysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workDays',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workDaysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workDays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workEndHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workEndHour',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workEndHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workEndHour',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workEndHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workEndHour',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workEndHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workEndHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workEndMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workEndMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workEndMinuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workEndMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workEndMinuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workEndMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workEndMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workEndMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workStartHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workStartHour',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workStartHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workStartHour',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workStartHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workStartHour',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workStartHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workStartHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workStartMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'workStartMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workStartMinuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'workStartMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workStartMinuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'workStartMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
      workStartMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'workStartMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserProfileModelQueryObject
    on QueryBuilder<UserProfileModel, UserProfileModel, QFilterCondition> {}

extension UserProfileModelQueryLinks
    on QueryBuilder<UserProfileModel, UserProfileModel, QFilterCondition> {}

extension UserProfileModelQuerySortBy
    on QueryBuilder<UserProfileModel, UserProfileModel, QSortBy> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByCalculationMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calculationMethod', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByCalculationMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calculationMethod', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy> sortByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByCycleAwareStreaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cycleAwareStreaks', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByCycleAwareStreaksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cycleAwareStreaks', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByDailyQuranPagesGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyQuranPagesGoal', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByDailyQuranPagesGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyQuranPagesGoal', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByGymDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gymDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByGymDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gymDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByIsOnboardingComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnboardingComplete', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByIsOnboardingCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnboardingComplete', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByIsRamadanMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRamadanMode', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByIsRamadanModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRamadanMode', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByMadhab() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'madhab', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByMadhabDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'madhab', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByOccupationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occupationId', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByOccupationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occupationId', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByOccupationLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occupationLabel', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByOccupationLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occupationLabel', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByOccupationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occupationType', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByOccupationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occupationType', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByPrayerBufferMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prayerBufferMinutes', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByPrayerBufferMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prayerBufferMinutes', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByPreferredGymTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredGymTime', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByPreferredGymTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredGymTime', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByTargetSleepHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSleepHours', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByTargetSleepHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSleepHours', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByWakeUpOffsetFromFajrMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeUpOffsetFromFajrMinutes', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByWakeUpOffsetFromFajrMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeUpOffsetFromFajrMinutes', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByWorkEndHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workEndHour', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByWorkEndHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workEndHour', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByWorkEndMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workEndMinute', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByWorkEndMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workEndMinute', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByWorkStartHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workStartHour', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByWorkStartHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workStartHour', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByWorkStartMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workStartMinute', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      sortByWorkStartMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workStartMinute', Sort.desc);
    });
  }
}

extension UserProfileModelQuerySortThenBy
    on QueryBuilder<UserProfileModel, UserProfileModel, QSortThenBy> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByCalculationMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calculationMethod', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByCalculationMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calculationMethod', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy> thenByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByCycleAwareStreaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cycleAwareStreaks', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByCycleAwareStreaksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cycleAwareStreaks', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByDailyQuranPagesGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyQuranPagesGoal', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByDailyQuranPagesGoalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailyQuranPagesGoal', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByGymDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gymDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByGymDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gymDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByIsOnboardingComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnboardingComplete', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByIsOnboardingCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnboardingComplete', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByIsRamadanMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRamadanMode', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByIsRamadanModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRamadanMode', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByMadhab() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'madhab', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByMadhabDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'madhab', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByOccupationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occupationId', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByOccupationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occupationId', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByOccupationLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occupationLabel', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByOccupationLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occupationLabel', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByOccupationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occupationType', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByOccupationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occupationType', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByPrayerBufferMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prayerBufferMinutes', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByPrayerBufferMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prayerBufferMinutes', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByPreferredGymTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredGymTime', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByPreferredGymTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredGymTime', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByTargetSleepHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSleepHours', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByTargetSleepHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSleepHours', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByWakeUpOffsetFromFajrMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeUpOffsetFromFajrMinutes', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByWakeUpOffsetFromFajrMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeUpOffsetFromFajrMinutes', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByWorkEndHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workEndHour', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByWorkEndHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workEndHour', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByWorkEndMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workEndMinute', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByWorkEndMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workEndMinute', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByWorkStartHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workStartHour', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByWorkStartHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workStartHour', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByWorkStartMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workStartMinute', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
      thenByWorkStartMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workStartMinute', Sort.desc);
    });
  }
}

extension UserProfileModelQueryWhereDistinct
    on QueryBuilder<UserProfileModel, UserProfileModel, QDistinct> {
  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByCalculationMethod({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calculationMethod',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct> distinctByCity(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'city', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByCycleAwareStreaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cycleAwareStreaks');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByDailyQuranPagesGoal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailyQuranPagesGoal');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByFitnessActivityIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fitnessActivityIds');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct> distinctByGender(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gender', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByGymDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gymDays');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByGymDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gymDurationMinutes');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByIsOnboardingComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOnboardingComplete');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByIsRamadanMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRamadanMode');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct> distinctByMadhab(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'madhab', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByOccupationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'occupationId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByOccupationLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'occupationLabel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByOccupationType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'occupationType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByPrayerBufferMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prayerBufferMinutes');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByPreferredGymTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preferredGymTime',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByTargetSleepHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetSleepHours');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByTimezone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timezone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByWakeUpOffsetFromFajrMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wakeUpOffsetFromFajrMinutes');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByWorkDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workDays');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByWorkEndHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workEndHour');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByWorkEndMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workEndMinute');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByWorkStartHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workStartHour');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
      distinctByWorkStartMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workStartMinute');
    });
  }
}

extension UserProfileModelQueryProperty
    on QueryBuilder<UserProfileModel, UserProfileModel, QQueryProperty> {
  QueryBuilder<UserProfileModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations>
      calculationMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calculationMethod');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations> cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'city');
    });
  }

  QueryBuilder<UserProfileModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<UserProfileModel, bool, QQueryOperations>
      cycleAwareStreaksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cycleAwareStreaks');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations>
      dailyQuranPagesGoalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailyQuranPagesGoal');
    });
  }

  QueryBuilder<UserProfileModel, List<String>, QQueryOperations>
      fitnessActivityIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fitnessActivityIds');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations> genderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gender');
    });
  }

  QueryBuilder<UserProfileModel, List<int>, QQueryOperations>
      gymDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gymDays');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations>
      gymDurationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gymDurationMinutes');
    });
  }

  QueryBuilder<UserProfileModel, bool, QQueryOperations>
      isOnboardingCompleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOnboardingComplete');
    });
  }

  QueryBuilder<UserProfileModel, bool, QQueryOperations>
      isRamadanModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRamadanMode');
    });
  }

  QueryBuilder<UserProfileModel, double, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<UserProfileModel, double, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations> madhabProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'madhab');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations>
      occupationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'occupationId');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations>
      occupationLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'occupationLabel');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations>
      occupationTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'occupationType');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations>
      prayerBufferMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prayerBufferMinutes');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations>
      preferredGymTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preferredGymTime');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations>
      targetSleepHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetSleepHours');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations> timezoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timezone');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations>
      wakeUpOffsetFromFajrMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wakeUpOffsetFromFajrMinutes');
    });
  }

  QueryBuilder<UserProfileModel, List<int>, QQueryOperations>
      workDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workDays');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations> workEndHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workEndHour');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations>
      workEndMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workEndMinute');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations>
      workStartHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workStartHour');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations>
      workStartMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workStartMinute');
    });
  }
}
