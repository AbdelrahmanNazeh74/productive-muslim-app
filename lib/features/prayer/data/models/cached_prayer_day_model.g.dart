// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_prayer_day_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCachedPrayerDayModelCollection on Isar {
  IsarCollection<CachedPrayerDayModel> get cachedPrayerDayModels =>
      this.collection();
}

const CachedPrayerDayModelSchema = CollectionSchema(
  name: r'CachedPrayerDayModel',
  id: -3950270816906162114,
  properties: {
    r'asr': PropertySchema(
      id: 0,
      name: r'asr',
      type: IsarType.dateTime,
    ),
    r'calculationMethod': PropertySchema(
      id: 1,
      name: r'calculationMethod',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'dhuhr': PropertySchema(
      id: 3,
      name: r'dhuhr',
      type: IsarType.dateTime,
    ),
    r'fajr': PropertySchema(
      id: 4,
      name: r'fajr',
      type: IsarType.dateTime,
    ),
    r'isha': PropertySchema(
      id: 5,
      name: r'isha',
      type: IsarType.dateTime,
    ),
    r'latitude': PropertySchema(
      id: 6,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 7,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'madhab': PropertySchema(
      id: 8,
      name: r'madhab',
      type: IsarType.string,
    ),
    r'maghrib': PropertySchema(
      id: 9,
      name: r'maghrib',
      type: IsarType.dateTime,
    ),
    r'sunrise': PropertySchema(
      id: 10,
      name: r'sunrise',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _cachedPrayerDayModelEstimateSize,
  serialize: _cachedPrayerDayModelSerialize,
  deserialize: _cachedPrayerDayModelDeserialize,
  deserializeProp: _cachedPrayerDayModelDeserializeProp,
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
  links: {},
  embeddedSchemas: {},
  getId: _cachedPrayerDayModelGetId,
  getLinks: _cachedPrayerDayModelGetLinks,
  attach: _cachedPrayerDayModelAttach,
  version: '3.1.0+1',
);

int _cachedPrayerDayModelEstimateSize(
  CachedPrayerDayModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.calculationMethod.length * 3;
  bytesCount += 3 + object.madhab.length * 3;
  return bytesCount;
}

void _cachedPrayerDayModelSerialize(
  CachedPrayerDayModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.asr);
  writer.writeString(offsets[1], object.calculationMethod);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeDateTime(offsets[3], object.dhuhr);
  writer.writeDateTime(offsets[4], object.fajr);
  writer.writeDateTime(offsets[5], object.isha);
  writer.writeDouble(offsets[6], object.latitude);
  writer.writeDouble(offsets[7], object.longitude);
  writer.writeString(offsets[8], object.madhab);
  writer.writeDateTime(offsets[9], object.maghrib);
  writer.writeDateTime(offsets[10], object.sunrise);
}

CachedPrayerDayModel _cachedPrayerDayModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CachedPrayerDayModel();
  object.asr = reader.readDateTime(offsets[0]);
  object.calculationMethod = reader.readString(offsets[1]);
  object.date = reader.readDateTime(offsets[2]);
  object.dhuhr = reader.readDateTime(offsets[3]);
  object.fajr = reader.readDateTime(offsets[4]);
  object.id = id;
  object.isha = reader.readDateTime(offsets[5]);
  object.latitude = reader.readDouble(offsets[6]);
  object.longitude = reader.readDouble(offsets[7]);
  object.madhab = reader.readString(offsets[8]);
  object.maghrib = reader.readDateTime(offsets[9]);
  object.sunrise = reader.readDateTime(offsets[10]);
  return object;
}

P _cachedPrayerDayModelDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cachedPrayerDayModelGetId(CachedPrayerDayModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cachedPrayerDayModelGetLinks(
    CachedPrayerDayModel object) {
  return [];
}

void _cachedPrayerDayModelAttach(
    IsarCollection<dynamic> col, Id id, CachedPrayerDayModel object) {
  object.id = id;
}

extension CachedPrayerDayModelQueryWhereSort
    on QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QWhere> {
  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterWhere>
      anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension CachedPrayerDayModelQueryWhere
    on QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QWhereClause> {
  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterWhereClause>
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

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterWhereClause>
      dateEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterWhereClause>
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

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterWhereClause>
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

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterWhereClause>
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

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterWhereClause>
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

extension CachedPrayerDayModelQueryFilter on QueryBuilder<CachedPrayerDayModel,
    CachedPrayerDayModel, QFilterCondition> {
  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterFilterCondition>
      asrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'asr',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterFilterCondition>
      calculationMethodEqualTo(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calculationMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterFilterCondition>
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

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterFilterCondition>
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

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterFilterCondition>
      madhabEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'madhab',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }
}

extension CachedPrayerDayModelQueryObject on QueryBuilder<CachedPrayerDayModel,
    CachedPrayerDayModel, QFilterCondition> {}

extension CachedPrayerDayModelQueryLinks on QueryBuilder<CachedPrayerDayModel,
    CachedPrayerDayModel, QFilterCondition> {}

extension CachedPrayerDayModelQuerySortBy
    on QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QSortBy> {
  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }
}

extension CachedPrayerDayModelQuerySortThenBy
    on QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QSortThenBy> {
  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension CachedPrayerDayModelQueryWhereDistinct
    on QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QDistinct> {
  QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }
}

extension CachedPrayerDayModelQueryProperty
    on QueryBuilder<CachedPrayerDayModel, CachedPrayerDayModel, QQueryProperty> {
  QueryBuilder<CachedPrayerDayModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CachedPrayerDayModel, DateTime, QQueryOperations>
      asrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'asr');
    });
  }

  QueryBuilder<CachedPrayerDayModel, String, QQueryOperations>
      calculationMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calculationMethod');
    });
  }

  QueryBuilder<CachedPrayerDayModel, DateTime, QQueryOperations>
      dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<CachedPrayerDayModel, DateTime, QQueryOperations>
      dhuhrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dhuhr');
    });
  }

  QueryBuilder<CachedPrayerDayModel, DateTime, QQueryOperations>
      fajrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fajr');
    });
  }

  QueryBuilder<CachedPrayerDayModel, DateTime, QQueryOperations>
      ishaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isha');
    });
  }

  QueryBuilder<CachedPrayerDayModel, double, QQueryOperations>
      latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<CachedPrayerDayModel, double, QQueryOperations>
      longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<CachedPrayerDayModel, String, QQueryOperations>
      madhabProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'madhab');
    });
  }

  QueryBuilder<CachedPrayerDayModel, DateTime, QQueryOperations>
      maghribProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maghrib');
    });
  }

  QueryBuilder<CachedPrayerDayModel, DateTime, QQueryOperations>
      sunriseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sunrise');
    });
  }
}
