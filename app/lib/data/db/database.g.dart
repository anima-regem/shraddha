// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SubjectsTable extends Subjects with TableInfo<$SubjectsTable, Subject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicsJsonMeta = const VerificationMeta(
    'topicsJson',
  );
  @override
  late final GeneratedColumn<String> topicsJson = GeneratedColumn<String>(
    'topics_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, colorHex, topicsJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('topics_json')) {
      context.handle(
        _topicsJsonMeta,
        topicsJson.isAcceptableOrUnknown(data['topics_json']!, _topicsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_topicsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subject(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      topicsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topics_json'],
      )!,
    );
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }
}

class Subject extends DataClass implements Insertable<Subject> {
  final String id;
  final String name;
  final String icon;
  final String colorHex;
  final String topicsJson;
  const Subject({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    required this.topicsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color_hex'] = Variable<String>(colorHex);
    map['topics_json'] = Variable<String>(topicsJson);
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      colorHex: Value(colorHex),
      topicsJson: Value(topicsJson),
    );
  }

  factory Subject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subject(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      topicsJson: serializer.fromJson<String>(json['topicsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'colorHex': serializer.toJson<String>(colorHex),
      'topicsJson': serializer.toJson<String>(topicsJson),
    };
  }

  Subject copyWith({
    String? id,
    String? name,
    String? icon,
    String? colorHex,
    String? topicsJson,
  }) => Subject(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    colorHex: colorHex ?? this.colorHex,
    topicsJson: topicsJson ?? this.topicsJson,
  );
  Subject copyWithCompanion(SubjectsCompanion data) {
    return Subject(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      topicsJson: data.topicsJson.present
          ? data.topicsJson.value
          : this.topicsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subject(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorHex: $colorHex, ')
          ..write('topicsJson: $topicsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, colorHex, topicsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subject &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.colorHex == this.colorHex &&
          other.topicsJson == this.topicsJson);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<String> colorHex;
  final Value<String> topicsJson;
  final Value<int> rowid;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.topicsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectsCompanion.insert({
    required String id,
    required String name,
    required String icon,
    required String colorHex,
    required String topicsJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       icon = Value(icon),
       colorHex = Value(colorHex),
       topicsJson = Value(topicsJson);
  static Insertable<Subject> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? colorHex,
    Expression<String>? topicsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (colorHex != null) 'color_hex': colorHex,
      if (topicsJson != null) 'topics_json': topicsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<String>? colorHex,
    Value<String>? topicsJson,
    Value<int>? rowid,
  }) {
    return SubjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      topicsJson: topicsJson ?? this.topicsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (topicsJson.present) {
      map['topics_json'] = Variable<String>(topicsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorHex: $colorHex, ')
          ..write('topicsJson: $topicsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FlashcardsTable extends Flashcards
    with TableInfo<$FlashcardsTable, Flashcard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlashcardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frontMeta = const VerificationMeta('front');
  @override
  late final GeneratedColumn<String> front = GeneratedColumn<String>(
    'front',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _backMeta = const VerificationMeta('back');
  @override
  late final GeneratedColumn<String> back = GeneratedColumn<String>(
    'back',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagsJsonMeta = const VerificationMeta(
    'tagsJson',
  );
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
    'tags_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    topic,
    front,
    back,
    tagsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flashcards';
  @override
  VerificationContext validateIntegrity(
    Insertable<Flashcard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('front')) {
      context.handle(
        _frontMeta,
        front.isAcceptableOrUnknown(data['front']!, _frontMeta),
      );
    } else if (isInserting) {
      context.missing(_frontMeta);
    }
    if (data.containsKey('back')) {
      context.handle(
        _backMeta,
        back.isAcceptableOrUnknown(data['back']!, _backMeta),
      );
    } else if (isInserting) {
      context.missing(_backMeta);
    }
    if (data.containsKey('tags_json')) {
      context.handle(
        _tagsJsonMeta,
        tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_tagsJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Flashcard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Flashcard(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
      front: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}front'],
      )!,
      back: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}back'],
      )!,
      tagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags_json'],
      )!,
    );
  }

  @override
  $FlashcardsTable createAlias(String alias) {
    return $FlashcardsTable(attachedDatabase, alias);
  }
}

class Flashcard extends DataClass implements Insertable<Flashcard> {
  final String id;
  final String subjectId;
  final String topic;
  final String front;
  final String back;
  final String tagsJson;
  const Flashcard({
    required this.id,
    required this.subjectId,
    required this.topic,
    required this.front,
    required this.back,
    required this.tagsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject_id'] = Variable<String>(subjectId);
    map['topic'] = Variable<String>(topic);
    map['front'] = Variable<String>(front);
    map['back'] = Variable<String>(back);
    map['tags_json'] = Variable<String>(tagsJson);
    return map;
  }

  FlashcardsCompanion toCompanion(bool nullToAbsent) {
    return FlashcardsCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      topic: Value(topic),
      front: Value(front),
      back: Value(back),
      tagsJson: Value(tagsJson),
    );
  }

  factory Flashcard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Flashcard(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      topic: serializer.fromJson<String>(json['topic']),
      front: serializer.fromJson<String>(json['front']),
      back: serializer.fromJson<String>(json['back']),
      tagsJson: serializer.fromJson<String>(json['tagsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'topic': serializer.toJson<String>(topic),
      'front': serializer.toJson<String>(front),
      'back': serializer.toJson<String>(back),
      'tagsJson': serializer.toJson<String>(tagsJson),
    };
  }

  Flashcard copyWith({
    String? id,
    String? subjectId,
    String? topic,
    String? front,
    String? back,
    String? tagsJson,
  }) => Flashcard(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    topic: topic ?? this.topic,
    front: front ?? this.front,
    back: back ?? this.back,
    tagsJson: tagsJson ?? this.tagsJson,
  );
  Flashcard copyWithCompanion(FlashcardsCompanion data) {
    return Flashcard(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      topic: data.topic.present ? data.topic.value : this.topic,
      front: data.front.present ? data.front.value : this.front,
      back: data.back.present ? data.back.value : this.back,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Flashcard(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('topic: $topic, ')
          ..write('front: $front, ')
          ..write('back: $back, ')
          ..write('tagsJson: $tagsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, subjectId, topic, front, back, tagsJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Flashcard &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.topic == this.topic &&
          other.front == this.front &&
          other.back == this.back &&
          other.tagsJson == this.tagsJson);
}

class FlashcardsCompanion extends UpdateCompanion<Flashcard> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String> topic;
  final Value<String> front;
  final Value<String> back;
  final Value<String> tagsJson;
  final Value<int> rowid;
  const FlashcardsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.topic = const Value.absent(),
    this.front = const Value.absent(),
    this.back = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FlashcardsCompanion.insert({
    required String id,
    required String subjectId,
    required String topic,
    required String front,
    required String back,
    required String tagsJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subjectId = Value(subjectId),
       topic = Value(topic),
       front = Value(front),
       back = Value(back),
       tagsJson = Value(tagsJson);
  static Insertable<Flashcard> custom({
    Expression<String>? id,
    Expression<String>? subjectId,
    Expression<String>? topic,
    Expression<String>? front,
    Expression<String>? back,
    Expression<String>? tagsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (topic != null) 'topic': topic,
      if (front != null) 'front': front,
      if (back != null) 'back': back,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FlashcardsCompanion copyWith({
    Value<String>? id,
    Value<String>? subjectId,
    Value<String>? topic,
    Value<String>? front,
    Value<String>? back,
    Value<String>? tagsJson,
    Value<int>? rowid,
  }) {
    return FlashcardsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      topic: topic ?? this.topic,
      front: front ?? this.front,
      back: back ?? this.back,
      tagsJson: tagsJson ?? this.tagsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (front.present) {
      map['front'] = Variable<String>(front.value);
    }
    if (back.present) {
      map['back'] = Variable<String>(back.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('topic: $topic, ')
          ..write('front: $front, ')
          ..write('back: $back, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $McqsTable extends Mcqs with TableInfo<$McqsTable, Mcq> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $McqsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionMeta = const VerificationMeta(
    'question',
  );
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
    'question',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionsJsonMeta = const VerificationMeta(
    'optionsJson',
  );
  @override
  late final GeneratedColumn<String> optionsJson = GeneratedColumn<String>(
    'options_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerIndexMeta = const VerificationMeta(
    'answerIndex',
  );
  @override
  late final GeneratedColumn<int> answerIndex = GeneratedColumn<int>(
    'answer_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    topic,
    question,
    optionsJson,
    answerIndex,
    explanation,
    difficulty,
    year,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mcqs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Mcq> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('question')) {
      context.handle(
        _questionMeta,
        question.isAcceptableOrUnknown(data['question']!, _questionMeta),
      );
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('options_json')) {
      context.handle(
        _optionsJsonMeta,
        optionsJson.isAcceptableOrUnknown(
          data['options_json']!,
          _optionsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_optionsJsonMeta);
    }
    if (data.containsKey('answer_index')) {
      context.handle(
        _answerIndexMeta,
        answerIndex.isAcceptableOrUnknown(
          data['answer_index']!,
          _answerIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_answerIndexMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mcq map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mcq(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
      question: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question'],
      )!,
      optionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options_json'],
      )!,
      answerIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}answer_index'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
    );
  }

  @override
  $McqsTable createAlias(String alias) {
    return $McqsTable(attachedDatabase, alias);
  }
}

class Mcq extends DataClass implements Insertable<Mcq> {
  final String id;
  final String subjectId;
  final String topic;
  final String question;
  final String optionsJson;
  final int answerIndex;
  final String explanation;
  final String difficulty;
  final int? year;
  const Mcq({
    required this.id,
    required this.subjectId,
    required this.topic,
    required this.question,
    required this.optionsJson,
    required this.answerIndex,
    required this.explanation,
    required this.difficulty,
    this.year,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject_id'] = Variable<String>(subjectId);
    map['topic'] = Variable<String>(topic);
    map['question'] = Variable<String>(question);
    map['options_json'] = Variable<String>(optionsJson);
    map['answer_index'] = Variable<int>(answerIndex);
    map['explanation'] = Variable<String>(explanation);
    map['difficulty'] = Variable<String>(difficulty);
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    return map;
  }

  McqsCompanion toCompanion(bool nullToAbsent) {
    return McqsCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      topic: Value(topic),
      question: Value(question),
      optionsJson: Value(optionsJson),
      answerIndex: Value(answerIndex),
      explanation: Value(explanation),
      difficulty: Value(difficulty),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
    );
  }

  factory Mcq.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mcq(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      topic: serializer.fromJson<String>(json['topic']),
      question: serializer.fromJson<String>(json['question']),
      optionsJson: serializer.fromJson<String>(json['optionsJson']),
      answerIndex: serializer.fromJson<int>(json['answerIndex']),
      explanation: serializer.fromJson<String>(json['explanation']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      year: serializer.fromJson<int?>(json['year']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'topic': serializer.toJson<String>(topic),
      'question': serializer.toJson<String>(question),
      'optionsJson': serializer.toJson<String>(optionsJson),
      'answerIndex': serializer.toJson<int>(answerIndex),
      'explanation': serializer.toJson<String>(explanation),
      'difficulty': serializer.toJson<String>(difficulty),
      'year': serializer.toJson<int?>(year),
    };
  }

  Mcq copyWith({
    String? id,
    String? subjectId,
    String? topic,
    String? question,
    String? optionsJson,
    int? answerIndex,
    String? explanation,
    String? difficulty,
    Value<int?> year = const Value.absent(),
  }) => Mcq(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    topic: topic ?? this.topic,
    question: question ?? this.question,
    optionsJson: optionsJson ?? this.optionsJson,
    answerIndex: answerIndex ?? this.answerIndex,
    explanation: explanation ?? this.explanation,
    difficulty: difficulty ?? this.difficulty,
    year: year.present ? year.value : this.year,
  );
  Mcq copyWithCompanion(McqsCompanion data) {
    return Mcq(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      topic: data.topic.present ? data.topic.value : this.topic,
      question: data.question.present ? data.question.value : this.question,
      optionsJson: data.optionsJson.present
          ? data.optionsJson.value
          : this.optionsJson,
      answerIndex: data.answerIndex.present
          ? data.answerIndex.value
          : this.answerIndex,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      year: data.year.present ? data.year.value : this.year,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mcq(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('topic: $topic, ')
          ..write('question: $question, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('answerIndex: $answerIndex, ')
          ..write('explanation: $explanation, ')
          ..write('difficulty: $difficulty, ')
          ..write('year: $year')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subjectId,
    topic,
    question,
    optionsJson,
    answerIndex,
    explanation,
    difficulty,
    year,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mcq &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.topic == this.topic &&
          other.question == this.question &&
          other.optionsJson == this.optionsJson &&
          other.answerIndex == this.answerIndex &&
          other.explanation == this.explanation &&
          other.difficulty == this.difficulty &&
          other.year == this.year);
}

class McqsCompanion extends UpdateCompanion<Mcq> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String> topic;
  final Value<String> question;
  final Value<String> optionsJson;
  final Value<int> answerIndex;
  final Value<String> explanation;
  final Value<String> difficulty;
  final Value<int?> year;
  final Value<int> rowid;
  const McqsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.topic = const Value.absent(),
    this.question = const Value.absent(),
    this.optionsJson = const Value.absent(),
    this.answerIndex = const Value.absent(),
    this.explanation = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.year = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  McqsCompanion.insert({
    required String id,
    required String subjectId,
    required String topic,
    required String question,
    required String optionsJson,
    required int answerIndex,
    required String explanation,
    required String difficulty,
    this.year = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       subjectId = Value(subjectId),
       topic = Value(topic),
       question = Value(question),
       optionsJson = Value(optionsJson),
       answerIndex = Value(answerIndex),
       explanation = Value(explanation),
       difficulty = Value(difficulty);
  static Insertable<Mcq> custom({
    Expression<String>? id,
    Expression<String>? subjectId,
    Expression<String>? topic,
    Expression<String>? question,
    Expression<String>? optionsJson,
    Expression<int>? answerIndex,
    Expression<String>? explanation,
    Expression<String>? difficulty,
    Expression<int>? year,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (topic != null) 'topic': topic,
      if (question != null) 'question': question,
      if (optionsJson != null) 'options_json': optionsJson,
      if (answerIndex != null) 'answer_index': answerIndex,
      if (explanation != null) 'explanation': explanation,
      if (difficulty != null) 'difficulty': difficulty,
      if (year != null) 'year': year,
      if (rowid != null) 'rowid': rowid,
    });
  }

  McqsCompanion copyWith({
    Value<String>? id,
    Value<String>? subjectId,
    Value<String>? topic,
    Value<String>? question,
    Value<String>? optionsJson,
    Value<int>? answerIndex,
    Value<String>? explanation,
    Value<String>? difficulty,
    Value<int?>? year,
    Value<int>? rowid,
  }) {
    return McqsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      topic: topic ?? this.topic,
      question: question ?? this.question,
      optionsJson: optionsJson ?? this.optionsJson,
      answerIndex: answerIndex ?? this.answerIndex,
      explanation: explanation ?? this.explanation,
      difficulty: difficulty ?? this.difficulty,
      year: year ?? this.year,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (optionsJson.present) {
      map['options_json'] = Variable<String>(optionsJson.value);
    }
    if (answerIndex.present) {
      map['answer_index'] = Variable<int>(answerIndex.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('McqsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('topic: $topic, ')
          ..write('question: $question, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('answerIndex: $answerIndex, ')
          ..write('explanation: $explanation, ')
          ..write('difficulty: $difficulty, ')
          ..write('year: $year, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SrsStatesTable extends SrsStates
    with TableInfo<$SrsStatesTable, SrsState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrsStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _easeFactorMeta = const VerificationMeta(
    'easeFactor',
  );
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
    'ease_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
    'lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<DateTime> due = GeneratedColumn<DateTime>(
    'due',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    cardId,
    easeFactor,
    intervalDays,
    repetitions,
    lapses,
    due,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srs_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrsState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
        _easeFactorMeta,
        easeFactor.isAcceptableOrUnknown(data['ease_factor']!, _easeFactorMeta),
      );
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('lapses')) {
      context.handle(
        _lapsesMeta,
        lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta),
      );
    }
    if (data.containsKey('due')) {
      context.handle(
        _dueMeta,
        due.isAcceptableOrUnknown(data['due']!, _dueMeta),
      );
    } else if (isInserting) {
      context.missing(_dueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardId};
  @override
  SrsState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrsState(
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      easeFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ease_factor'],
      )!,
      intervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_days'],
      )!,
      repetitions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repetitions'],
      )!,
      lapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lapses'],
      )!,
      due: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due'],
      )!,
    );
  }

  @override
  $SrsStatesTable createAlias(String alias) {
    return $SrsStatesTable(attachedDatabase, alias);
  }
}

class SrsState extends DataClass implements Insertable<SrsState> {
  final String cardId;
  final double easeFactor;
  final int intervalDays;
  final int repetitions;
  final int lapses;
  final DateTime due;
  const SrsState({
    required this.cardId,
    required this.easeFactor,
    required this.intervalDays,
    required this.repetitions,
    required this.lapses,
    required this.due,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['card_id'] = Variable<String>(cardId);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['interval_days'] = Variable<int>(intervalDays);
    map['repetitions'] = Variable<int>(repetitions);
    map['lapses'] = Variable<int>(lapses);
    map['due'] = Variable<DateTime>(due);
    return map;
  }

  SrsStatesCompanion toCompanion(bool nullToAbsent) {
    return SrsStatesCompanion(
      cardId: Value(cardId),
      easeFactor: Value(easeFactor),
      intervalDays: Value(intervalDays),
      repetitions: Value(repetitions),
      lapses: Value(lapses),
      due: Value(due),
    );
  }

  factory SrsState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrsState(
      cardId: serializer.fromJson<String>(json['cardId']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      lapses: serializer.fromJson<int>(json['lapses']),
      due: serializer.fromJson<DateTime>(json['due']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardId': serializer.toJson<String>(cardId),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'repetitions': serializer.toJson<int>(repetitions),
      'lapses': serializer.toJson<int>(lapses),
      'due': serializer.toJson<DateTime>(due),
    };
  }

  SrsState copyWith({
    String? cardId,
    double? easeFactor,
    int? intervalDays,
    int? repetitions,
    int? lapses,
    DateTime? due,
  }) => SrsState(
    cardId: cardId ?? this.cardId,
    easeFactor: easeFactor ?? this.easeFactor,
    intervalDays: intervalDays ?? this.intervalDays,
    repetitions: repetitions ?? this.repetitions,
    lapses: lapses ?? this.lapses,
    due: due ?? this.due,
  );
  SrsState copyWithCompanion(SrsStatesCompanion data) {
    return SrsState(
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      easeFactor: data.easeFactor.present
          ? data.easeFactor.value
          : this.easeFactor,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      repetitions: data.repetitions.present
          ? data.repetitions.value
          : this.repetitions,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      due: data.due.present ? data.due.value : this.due,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrsState(')
          ..write('cardId: $cardId, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('repetitions: $repetitions, ')
          ..write('lapses: $lapses, ')
          ..write('due: $due')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(cardId, easeFactor, intervalDays, repetitions, lapses, due);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrsState &&
          other.cardId == this.cardId &&
          other.easeFactor == this.easeFactor &&
          other.intervalDays == this.intervalDays &&
          other.repetitions == this.repetitions &&
          other.lapses == this.lapses &&
          other.due == this.due);
}

class SrsStatesCompanion extends UpdateCompanion<SrsState> {
  final Value<String> cardId;
  final Value<double> easeFactor;
  final Value<int> intervalDays;
  final Value<int> repetitions;
  final Value<int> lapses;
  final Value<DateTime> due;
  final Value<int> rowid;
  const SrsStatesCompanion({
    this.cardId = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.lapses = const Value.absent(),
    this.due = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SrsStatesCompanion.insert({
    required String cardId,
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.lapses = const Value.absent(),
    required DateTime due,
    this.rowid = const Value.absent(),
  }) : cardId = Value(cardId),
       due = Value(due);
  static Insertable<SrsState> custom({
    Expression<String>? cardId,
    Expression<double>? easeFactor,
    Expression<int>? intervalDays,
    Expression<int>? repetitions,
    Expression<int>? lapses,
    Expression<DateTime>? due,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cardId != null) 'card_id': cardId,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (repetitions != null) 'repetitions': repetitions,
      if (lapses != null) 'lapses': lapses,
      if (due != null) 'due': due,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SrsStatesCompanion copyWith({
    Value<String>? cardId,
    Value<double>? easeFactor,
    Value<int>? intervalDays,
    Value<int>? repetitions,
    Value<int>? lapses,
    Value<DateTime>? due,
    Value<int>? rowid,
  }) {
    return SrsStatesCompanion(
      cardId: cardId ?? this.cardId,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      repetitions: repetitions ?? this.repetitions,
      lapses: lapses ?? this.lapses,
      due: due ?? this.due,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (due.present) {
      map['due'] = Variable<DateTime>(due.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrsStatesCompanion(')
          ..write('cardId: $cardId, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('repetitions: $repetitions, ')
          ..write('lapses: $lapses, ')
          ..write('due: $due, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewLogsTable extends ReviewLogs
    with TableInfo<$ReviewLogsTable, ReviewLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<bool> correct = GeneratedColumn<bool>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    itemType,
    subjectId,
    topic,
    correct,
    rating,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('item_type')) {
      context.handle(
        _itemTypeMeta,
        itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      itemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_type'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}correct'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $ReviewLogsTable createAlias(String alias) {
    return $ReviewLogsTable(attachedDatabase, alias);
  }
}

class ReviewLog extends DataClass implements Insertable<ReviewLog> {
  final int id;
  final String itemId;
  final String itemType;
  final String subjectId;
  final String topic;
  final bool correct;
  final int? rating;
  final DateTime timestamp;
  const ReviewLog({
    required this.id,
    required this.itemId,
    required this.itemType,
    required this.subjectId,
    required this.topic,
    required this.correct,
    this.rating,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<String>(itemId);
    map['item_type'] = Variable<String>(itemType);
    map['subject_id'] = Variable<String>(subjectId);
    map['topic'] = Variable<String>(topic);
    map['correct'] = Variable<bool>(correct);
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<int>(rating);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  ReviewLogsCompanion toCompanion(bool nullToAbsent) {
    return ReviewLogsCompanion(
      id: Value(id),
      itemId: Value(itemId),
      itemType: Value(itemType),
      subjectId: Value(subjectId),
      topic: Value(topic),
      correct: Value(correct),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      timestamp: Value(timestamp),
    );
  }

  factory ReviewLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewLog(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      itemType: serializer.fromJson<String>(json['itemType']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      topic: serializer.fromJson<String>(json['topic']),
      correct: serializer.fromJson<bool>(json['correct']),
      rating: serializer.fromJson<int?>(json['rating']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<String>(itemId),
      'itemType': serializer.toJson<String>(itemType),
      'subjectId': serializer.toJson<String>(subjectId),
      'topic': serializer.toJson<String>(topic),
      'correct': serializer.toJson<bool>(correct),
      'rating': serializer.toJson<int?>(rating),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  ReviewLog copyWith({
    int? id,
    String? itemId,
    String? itemType,
    String? subjectId,
    String? topic,
    bool? correct,
    Value<int?> rating = const Value.absent(),
    DateTime? timestamp,
  }) => ReviewLog(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    itemType: itemType ?? this.itemType,
    subjectId: subjectId ?? this.subjectId,
    topic: topic ?? this.topic,
    correct: correct ?? this.correct,
    rating: rating.present ? rating.value : this.rating,
    timestamp: timestamp ?? this.timestamp,
  );
  ReviewLog copyWithCompanion(ReviewLogsCompanion data) {
    return ReviewLog(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      topic: data.topic.present ? data.topic.value : this.topic,
      correct: data.correct.present ? data.correct.value : this.correct,
      rating: data.rating.present ? data.rating.value : this.rating,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLog(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('itemType: $itemType, ')
          ..write('subjectId: $subjectId, ')
          ..write('topic: $topic, ')
          ..write('correct: $correct, ')
          ..write('rating: $rating, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemId,
    itemType,
    subjectId,
    topic,
    correct,
    rating,
    timestamp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewLog &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.itemType == this.itemType &&
          other.subjectId == this.subjectId &&
          other.topic == this.topic &&
          other.correct == this.correct &&
          other.rating == this.rating &&
          other.timestamp == this.timestamp);
}

class ReviewLogsCompanion extends UpdateCompanion<ReviewLog> {
  final Value<int> id;
  final Value<String> itemId;
  final Value<String> itemType;
  final Value<String> subjectId;
  final Value<String> topic;
  final Value<bool> correct;
  final Value<int?> rating;
  final Value<DateTime> timestamp;
  const ReviewLogsCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.itemType = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.topic = const Value.absent(),
    this.correct = const Value.absent(),
    this.rating = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  ReviewLogsCompanion.insert({
    this.id = const Value.absent(),
    required String itemId,
    required String itemType,
    required String subjectId,
    required String topic,
    required bool correct,
    this.rating = const Value.absent(),
    required DateTime timestamp,
  }) : itemId = Value(itemId),
       itemType = Value(itemType),
       subjectId = Value(subjectId),
       topic = Value(topic),
       correct = Value(correct),
       timestamp = Value(timestamp);
  static Insertable<ReviewLog> custom({
    Expression<int>? id,
    Expression<String>? itemId,
    Expression<String>? itemType,
    Expression<String>? subjectId,
    Expression<String>? topic,
    Expression<bool>? correct,
    Expression<int>? rating,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (itemType != null) 'item_type': itemType,
      if (subjectId != null) 'subject_id': subjectId,
      if (topic != null) 'topic': topic,
      if (correct != null) 'correct': correct,
      if (rating != null) 'rating': rating,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  ReviewLogsCompanion copyWith({
    Value<int>? id,
    Value<String>? itemId,
    Value<String>? itemType,
    Value<String>? subjectId,
    Value<String>? topic,
    Value<bool>? correct,
    Value<int?>? rating,
    Value<DateTime>? timestamp,
  }) {
    return ReviewLogsCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      itemType: itemType ?? this.itemType,
      subjectId: subjectId ?? this.subjectId,
      topic: topic ?? this.topic,
      correct: correct ?? this.correct,
      rating: rating ?? this.rating,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (correct.present) {
      map['correct'] = Variable<bool>(correct.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogsCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('itemType: $itemType, ')
          ..write('subjectId: $subjectId, ')
          ..write('topic: $topic, ')
          ..write('correct: $correct, ')
          ..write('rating: $rating, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $QuizResultsTable extends QuizResults
    with TableInfo<$QuizResultsTable, QuizResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
    'subject_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctCountMeta = const VerificationMeta(
    'correctCount',
  );
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
    'correct_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wrongCountMeta = const VerificationMeta(
    'wrongCount',
  );
  @override
  late final GeneratedColumn<int> wrongCount = GeneratedColumn<int>(
    'wrong_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skippedCountMeta = const VerificationMeta(
    'skippedCount',
  );
  @override
  late final GeneratedColumn<int> skippedCount = GeneratedColumn<int>(
    'skipped_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxScoreMeta = const VerificationMeta(
    'maxScore',
  );
  @override
  late final GeneratedColumn<double> maxScore = GeneratedColumn<double>(
    'max_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    mode,
    total,
    correctCount,
    wrongCount,
    skippedCount,
    score,
    maxScore,
    durationSeconds,
    timestamp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('correct_count')) {
      context.handle(
        _correctCountMeta,
        correctCount.isAcceptableOrUnknown(
          data['correct_count']!,
          _correctCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctCountMeta);
    }
    if (data.containsKey('wrong_count')) {
      context.handle(
        _wrongCountMeta,
        wrongCount.isAcceptableOrUnknown(data['wrong_count']!, _wrongCountMeta),
      );
    } else if (isInserting) {
      context.missing(_wrongCountMeta);
    }
    if (data.containsKey('skipped_count')) {
      context.handle(
        _skippedCountMeta,
        skippedCount.isAcceptableOrUnknown(
          data['skipped_count']!,
          _skippedCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_skippedCountMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('max_score')) {
      context.handle(
        _maxScoreMeta,
        maxScore.isAcceptableOrUnknown(data['max_score']!, _maxScoreMeta),
      );
    } else if (isInserting) {
      context.missing(_maxScoreMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_id'],
      ),
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      correctCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_count'],
      )!,
      wrongCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wrong_count'],
      )!,
      skippedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}skipped_count'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      )!,
      maxScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_score'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $QuizResultsTable createAlias(String alias) {
    return $QuizResultsTable(attachedDatabase, alias);
  }
}

class QuizResult extends DataClass implements Insertable<QuizResult> {
  final int id;
  final String? subjectId;
  final String mode;
  final int total;
  final int correctCount;
  final int wrongCount;
  final int skippedCount;
  final double score;
  final double maxScore;
  final int durationSeconds;
  final DateTime timestamp;
  const QuizResult({
    required this.id,
    this.subjectId,
    required this.mode,
    required this.total,
    required this.correctCount,
    required this.wrongCount,
    required this.skippedCount,
    required this.score,
    required this.maxScore,
    required this.durationSeconds,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || subjectId != null) {
      map['subject_id'] = Variable<String>(subjectId);
    }
    map['mode'] = Variable<String>(mode);
    map['total'] = Variable<int>(total);
    map['correct_count'] = Variable<int>(correctCount);
    map['wrong_count'] = Variable<int>(wrongCount);
    map['skipped_count'] = Variable<int>(skippedCount);
    map['score'] = Variable<double>(score);
    map['max_score'] = Variable<double>(maxScore);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  QuizResultsCompanion toCompanion(bool nullToAbsent) {
    return QuizResultsCompanion(
      id: Value(id),
      subjectId: subjectId == null && nullToAbsent
          ? const Value.absent()
          : Value(subjectId),
      mode: Value(mode),
      total: Value(total),
      correctCount: Value(correctCount),
      wrongCount: Value(wrongCount),
      skippedCount: Value(skippedCount),
      score: Value(score),
      maxScore: Value(maxScore),
      durationSeconds: Value(durationSeconds),
      timestamp: Value(timestamp),
    );
  }

  factory QuizResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizResult(
      id: serializer.fromJson<int>(json['id']),
      subjectId: serializer.fromJson<String?>(json['subjectId']),
      mode: serializer.fromJson<String>(json['mode']),
      total: serializer.fromJson<int>(json['total']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      wrongCount: serializer.fromJson<int>(json['wrongCount']),
      skippedCount: serializer.fromJson<int>(json['skippedCount']),
      score: serializer.fromJson<double>(json['score']),
      maxScore: serializer.fromJson<double>(json['maxScore']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subjectId': serializer.toJson<String?>(subjectId),
      'mode': serializer.toJson<String>(mode),
      'total': serializer.toJson<int>(total),
      'correctCount': serializer.toJson<int>(correctCount),
      'wrongCount': serializer.toJson<int>(wrongCount),
      'skippedCount': serializer.toJson<int>(skippedCount),
      'score': serializer.toJson<double>(score),
      'maxScore': serializer.toJson<double>(maxScore),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  QuizResult copyWith({
    int? id,
    Value<String?> subjectId = const Value.absent(),
    String? mode,
    int? total,
    int? correctCount,
    int? wrongCount,
    int? skippedCount,
    double? score,
    double? maxScore,
    int? durationSeconds,
    DateTime? timestamp,
  }) => QuizResult(
    id: id ?? this.id,
    subjectId: subjectId.present ? subjectId.value : this.subjectId,
    mode: mode ?? this.mode,
    total: total ?? this.total,
    correctCount: correctCount ?? this.correctCount,
    wrongCount: wrongCount ?? this.wrongCount,
    skippedCount: skippedCount ?? this.skippedCount,
    score: score ?? this.score,
    maxScore: maxScore ?? this.maxScore,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    timestamp: timestamp ?? this.timestamp,
  );
  QuizResult copyWithCompanion(QuizResultsCompanion data) {
    return QuizResult(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      mode: data.mode.present ? data.mode.value : this.mode,
      total: data.total.present ? data.total.value : this.total,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      wrongCount: data.wrongCount.present
          ? data.wrongCount.value
          : this.wrongCount,
      skippedCount: data.skippedCount.present
          ? data.skippedCount.value
          : this.skippedCount,
      score: data.score.present ? data.score.value : this.score,
      maxScore: data.maxScore.present ? data.maxScore.value : this.maxScore,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizResult(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('mode: $mode, ')
          ..write('total: $total, ')
          ..write('correctCount: $correctCount, ')
          ..write('wrongCount: $wrongCount, ')
          ..write('skippedCount: $skippedCount, ')
          ..write('score: $score, ')
          ..write('maxScore: $maxScore, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    subjectId,
    mode,
    total,
    correctCount,
    wrongCount,
    skippedCount,
    score,
    maxScore,
    durationSeconds,
    timestamp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizResult &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.mode == this.mode &&
          other.total == this.total &&
          other.correctCount == this.correctCount &&
          other.wrongCount == this.wrongCount &&
          other.skippedCount == this.skippedCount &&
          other.score == this.score &&
          other.maxScore == this.maxScore &&
          other.durationSeconds == this.durationSeconds &&
          other.timestamp == this.timestamp);
}

class QuizResultsCompanion extends UpdateCompanion<QuizResult> {
  final Value<int> id;
  final Value<String?> subjectId;
  final Value<String> mode;
  final Value<int> total;
  final Value<int> correctCount;
  final Value<int> wrongCount;
  final Value<int> skippedCount;
  final Value<double> score;
  final Value<double> maxScore;
  final Value<int> durationSeconds;
  final Value<DateTime> timestamp;
  const QuizResultsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.mode = const Value.absent(),
    this.total = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.wrongCount = const Value.absent(),
    this.skippedCount = const Value.absent(),
    this.score = const Value.absent(),
    this.maxScore = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  QuizResultsCompanion.insert({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    required String mode,
    required int total,
    required int correctCount,
    required int wrongCount,
    required int skippedCount,
    required double score,
    required double maxScore,
    required int durationSeconds,
    required DateTime timestamp,
  }) : mode = Value(mode),
       total = Value(total),
       correctCount = Value(correctCount),
       wrongCount = Value(wrongCount),
       skippedCount = Value(skippedCount),
       score = Value(score),
       maxScore = Value(maxScore),
       durationSeconds = Value(durationSeconds),
       timestamp = Value(timestamp);
  static Insertable<QuizResult> custom({
    Expression<int>? id,
    Expression<String>? subjectId,
    Expression<String>? mode,
    Expression<int>? total,
    Expression<int>? correctCount,
    Expression<int>? wrongCount,
    Expression<int>? skippedCount,
    Expression<double>? score,
    Expression<double>? maxScore,
    Expression<int>? durationSeconds,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (mode != null) 'mode': mode,
      if (total != null) 'total': total,
      if (correctCount != null) 'correct_count': correctCount,
      if (wrongCount != null) 'wrong_count': wrongCount,
      if (skippedCount != null) 'skipped_count': skippedCount,
      if (score != null) 'score': score,
      if (maxScore != null) 'max_score': maxScore,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  QuizResultsCompanion copyWith({
    Value<int>? id,
    Value<String?>? subjectId,
    Value<String>? mode,
    Value<int>? total,
    Value<int>? correctCount,
    Value<int>? wrongCount,
    Value<int>? skippedCount,
    Value<double>? score,
    Value<double>? maxScore,
    Value<int>? durationSeconds,
    Value<DateTime>? timestamp,
  }) {
    return QuizResultsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      mode: mode ?? this.mode,
      total: total ?? this.total,
      correctCount: correctCount ?? this.correctCount,
      wrongCount: wrongCount ?? this.wrongCount,
      skippedCount: skippedCount ?? this.skippedCount,
      score: score ?? this.score,
      maxScore: maxScore ?? this.maxScore,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (wrongCount.present) {
      map['wrong_count'] = Variable<int>(wrongCount.value);
    }
    if (skippedCount.present) {
      map['skipped_count'] = Variable<int>(skippedCount.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (maxScore.present) {
      map['max_score'] = Variable<double>(maxScore.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizResultsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('mode: $mode, ')
          ..write('total: $total, ')
          ..write('correctCount: $correctCount, ')
          ..write('wrongCount: $wrongCount, ')
          ..write('skippedCount: $skippedCount, ')
          ..write('score: $score, ')
          ..write('maxScore: $maxScore, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubjectsTable subjects = $SubjectsTable(this);
  late final $FlashcardsTable flashcards = $FlashcardsTable(this);
  late final $McqsTable mcqs = $McqsTable(this);
  late final $SrsStatesTable srsStates = $SrsStatesTable(this);
  late final $ReviewLogsTable reviewLogs = $ReviewLogsTable(this);
  late final $QuizResultsTable quizResults = $QuizResultsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    subjects,
    flashcards,
    mcqs,
    srsStates,
    reviewLogs,
    quizResults,
  ];
}

typedef $$SubjectsTableCreateCompanionBuilder =
    SubjectsCompanion Function({
      required String id,
      required String name,
      required String icon,
      required String colorHex,
      required String topicsJson,
      Value<int> rowid,
    });
typedef $$SubjectsTableUpdateCompanionBuilder =
    SubjectsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> icon,
      Value<String> colorHex,
      Value<String> topicsJson,
      Value<int> rowid,
    });

class $$SubjectsTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topicsJson => $composableBuilder(
    column: $table.topicsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topicsJson => $composableBuilder(
    column: $table.topicsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<String> get topicsJson => $composableBuilder(
    column: $table.topicsJson,
    builder: (column) => column,
  );
}

class $$SubjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubjectsTable,
          Subject,
          $$SubjectsTableFilterComposer,
          $$SubjectsTableOrderingComposer,
          $$SubjectsTableAnnotationComposer,
          $$SubjectsTableCreateCompanionBuilder,
          $$SubjectsTableUpdateCompanionBuilder,
          (Subject, BaseReferences<_$AppDatabase, $SubjectsTable, Subject>),
          Subject,
          PrefetchHooks Function()
        > {
  $$SubjectsTableTableManager(_$AppDatabase db, $SubjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<String> topicsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectsCompanion(
                id: id,
                name: name,
                icon: icon,
                colorHex: colorHex,
                topicsJson: topicsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String icon,
                required String colorHex,
                required String topicsJson,
                Value<int> rowid = const Value.absent(),
              }) => SubjectsCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                colorHex: colorHex,
                topicsJson: topicsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubjectsTable,
      Subject,
      $$SubjectsTableFilterComposer,
      $$SubjectsTableOrderingComposer,
      $$SubjectsTableAnnotationComposer,
      $$SubjectsTableCreateCompanionBuilder,
      $$SubjectsTableUpdateCompanionBuilder,
      (Subject, BaseReferences<_$AppDatabase, $SubjectsTable, Subject>),
      Subject,
      PrefetchHooks Function()
    >;
typedef $$FlashcardsTableCreateCompanionBuilder =
    FlashcardsCompanion Function({
      required String id,
      required String subjectId,
      required String topic,
      required String front,
      required String back,
      required String tagsJson,
      Value<int> rowid,
    });
typedef $$FlashcardsTableUpdateCompanionBuilder =
    FlashcardsCompanion Function({
      Value<String> id,
      Value<String> subjectId,
      Value<String> topic,
      Value<String> front,
      Value<String> back,
      Value<String> tagsJson,
      Value<int> rowid,
    });

class $$FlashcardsTableFilterComposer
    extends Composer<_$AppDatabase, $FlashcardsTable> {
  $$FlashcardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get front => $composableBuilder(
    column: $table.front,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get back => $composableBuilder(
    column: $table.back,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FlashcardsTableOrderingComposer
    extends Composer<_$AppDatabase, $FlashcardsTable> {
  $$FlashcardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get front => $composableBuilder(
    column: $table.front,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get back => $composableBuilder(
    column: $table.back,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagsJson => $composableBuilder(
    column: $table.tagsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FlashcardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FlashcardsTable> {
  $$FlashcardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<String> get front =>
      $composableBuilder(column: $table.front, builder: (column) => column);

  GeneratedColumn<String> get back =>
      $composableBuilder(column: $table.back, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);
}

class $$FlashcardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FlashcardsTable,
          Flashcard,
          $$FlashcardsTableFilterComposer,
          $$FlashcardsTableOrderingComposer,
          $$FlashcardsTableAnnotationComposer,
          $$FlashcardsTableCreateCompanionBuilder,
          $$FlashcardsTableUpdateCompanionBuilder,
          (
            Flashcard,
            BaseReferences<_$AppDatabase, $FlashcardsTable, Flashcard>,
          ),
          Flashcard,
          PrefetchHooks Function()
        > {
  $$FlashcardsTableTableManager(_$AppDatabase db, $FlashcardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FlashcardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FlashcardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FlashcardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<String> front = const Value.absent(),
                Value<String> back = const Value.absent(),
                Value<String> tagsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FlashcardsCompanion(
                id: id,
                subjectId: subjectId,
                topic: topic,
                front: front,
                back: back,
                tagsJson: tagsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subjectId,
                required String topic,
                required String front,
                required String back,
                required String tagsJson,
                Value<int> rowid = const Value.absent(),
              }) => FlashcardsCompanion.insert(
                id: id,
                subjectId: subjectId,
                topic: topic,
                front: front,
                back: back,
                tagsJson: tagsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FlashcardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FlashcardsTable,
      Flashcard,
      $$FlashcardsTableFilterComposer,
      $$FlashcardsTableOrderingComposer,
      $$FlashcardsTableAnnotationComposer,
      $$FlashcardsTableCreateCompanionBuilder,
      $$FlashcardsTableUpdateCompanionBuilder,
      (Flashcard, BaseReferences<_$AppDatabase, $FlashcardsTable, Flashcard>),
      Flashcard,
      PrefetchHooks Function()
    >;
typedef $$McqsTableCreateCompanionBuilder =
    McqsCompanion Function({
      required String id,
      required String subjectId,
      required String topic,
      required String question,
      required String optionsJson,
      required int answerIndex,
      required String explanation,
      required String difficulty,
      Value<int?> year,
      Value<int> rowid,
    });
typedef $$McqsTableUpdateCompanionBuilder =
    McqsCompanion Function({
      Value<String> id,
      Value<String> subjectId,
      Value<String> topic,
      Value<String> question,
      Value<String> optionsJson,
      Value<int> answerIndex,
      Value<String> explanation,
      Value<String> difficulty,
      Value<int?> year,
      Value<int> rowid,
    });

class $$McqsTableFilterComposer extends Composer<_$AppDatabase, $McqsTable> {
  $$McqsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get answerIndex => $composableBuilder(
    column: $table.answerIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );
}

class $$McqsTableOrderingComposer extends Composer<_$AppDatabase, $McqsTable> {
  $$McqsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get answerIndex => $composableBuilder(
    column: $table.answerIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$McqsTableAnnotationComposer
    extends Composer<_$AppDatabase, $McqsTable> {
  $$McqsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get answerIndex => $composableBuilder(
    column: $table.answerIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);
}

class $$McqsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $McqsTable,
          Mcq,
          $$McqsTableFilterComposer,
          $$McqsTableOrderingComposer,
          $$McqsTableAnnotationComposer,
          $$McqsTableCreateCompanionBuilder,
          $$McqsTableUpdateCompanionBuilder,
          (Mcq, BaseReferences<_$AppDatabase, $McqsTable, Mcq>),
          Mcq,
          PrefetchHooks Function()
        > {
  $$McqsTableTableManager(_$AppDatabase db, $McqsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$McqsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$McqsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$McqsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<String> question = const Value.absent(),
                Value<String> optionsJson = const Value.absent(),
                Value<int> answerIndex = const Value.absent(),
                Value<String> explanation = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => McqsCompanion(
                id: id,
                subjectId: subjectId,
                topic: topic,
                question: question,
                optionsJson: optionsJson,
                answerIndex: answerIndex,
                explanation: explanation,
                difficulty: difficulty,
                year: year,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String subjectId,
                required String topic,
                required String question,
                required String optionsJson,
                required int answerIndex,
                required String explanation,
                required String difficulty,
                Value<int?> year = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => McqsCompanion.insert(
                id: id,
                subjectId: subjectId,
                topic: topic,
                question: question,
                optionsJson: optionsJson,
                answerIndex: answerIndex,
                explanation: explanation,
                difficulty: difficulty,
                year: year,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$McqsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $McqsTable,
      Mcq,
      $$McqsTableFilterComposer,
      $$McqsTableOrderingComposer,
      $$McqsTableAnnotationComposer,
      $$McqsTableCreateCompanionBuilder,
      $$McqsTableUpdateCompanionBuilder,
      (Mcq, BaseReferences<_$AppDatabase, $McqsTable, Mcq>),
      Mcq,
      PrefetchHooks Function()
    >;
typedef $$SrsStatesTableCreateCompanionBuilder =
    SrsStatesCompanion Function({
      required String cardId,
      Value<double> easeFactor,
      Value<int> intervalDays,
      Value<int> repetitions,
      Value<int> lapses,
      required DateTime due,
      Value<int> rowid,
    });
typedef $$SrsStatesTableUpdateCompanionBuilder =
    SrsStatesCompanion Function({
      Value<String> cardId,
      Value<double> easeFactor,
      Value<int> intervalDays,
      Value<int> repetitions,
      Value<int> lapses,
      Value<DateTime> due,
      Value<int> rowid,
    });

class $$SrsStatesTableFilterComposer
    extends Composer<_$AppDatabase, $SrsStatesTable> {
  $$SrsStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SrsStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $SrsStatesTable> {
  $$SrsStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cardId => $composableBuilder(
    column: $table.cardId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrsStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrsStatesTable> {
  $$SrsStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cardId =>
      $composableBuilder(column: $table.cardId, builder: (column) => column);

  GeneratedColumn<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<DateTime> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);
}

class $$SrsStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SrsStatesTable,
          SrsState,
          $$SrsStatesTableFilterComposer,
          $$SrsStatesTableOrderingComposer,
          $$SrsStatesTableAnnotationComposer,
          $$SrsStatesTableCreateCompanionBuilder,
          $$SrsStatesTableUpdateCompanionBuilder,
          (SrsState, BaseReferences<_$AppDatabase, $SrsStatesTable, SrsState>),
          SrsState,
          PrefetchHooks Function()
        > {
  $$SrsStatesTableTableManager(_$AppDatabase db, $SrsStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SrsStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SrsStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SrsStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> cardId = const Value.absent(),
                Value<double> easeFactor = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<DateTime> due = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SrsStatesCompanion(
                cardId: cardId,
                easeFactor: easeFactor,
                intervalDays: intervalDays,
                repetitions: repetitions,
                lapses: lapses,
                due: due,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cardId,
                Value<double> easeFactor = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                required DateTime due,
                Value<int> rowid = const Value.absent(),
              }) => SrsStatesCompanion.insert(
                cardId: cardId,
                easeFactor: easeFactor,
                intervalDays: intervalDays,
                repetitions: repetitions,
                lapses: lapses,
                due: due,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SrsStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SrsStatesTable,
      SrsState,
      $$SrsStatesTableFilterComposer,
      $$SrsStatesTableOrderingComposer,
      $$SrsStatesTableAnnotationComposer,
      $$SrsStatesTableCreateCompanionBuilder,
      $$SrsStatesTableUpdateCompanionBuilder,
      (SrsState, BaseReferences<_$AppDatabase, $SrsStatesTable, SrsState>),
      SrsState,
      PrefetchHooks Function()
    >;
typedef $$ReviewLogsTableCreateCompanionBuilder =
    ReviewLogsCompanion Function({
      Value<int> id,
      required String itemId,
      required String itemType,
      required String subjectId,
      required String topic,
      required bool correct,
      Value<int?> rating,
      required DateTime timestamp,
    });
typedef $$ReviewLogsTableUpdateCompanionBuilder =
    ReviewLogsCompanion Function({
      Value<int> id,
      Value<String> itemId,
      Value<String> itemType,
      Value<String> subjectId,
      Value<String> topic,
      Value<bool> correct,
      Value<int?> rating,
      Value<DateTime> timestamp,
    });

class $$ReviewLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReviewLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReviewLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<bool> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$ReviewLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewLogsTable,
          ReviewLog,
          $$ReviewLogsTableFilterComposer,
          $$ReviewLogsTableOrderingComposer,
          $$ReviewLogsTableAnnotationComposer,
          $$ReviewLogsTableCreateCompanionBuilder,
          $$ReviewLogsTableUpdateCompanionBuilder,
          (
            ReviewLog,
            BaseReferences<_$AppDatabase, $ReviewLogsTable, ReviewLog>,
          ),
          ReviewLog,
          PrefetchHooks Function()
        > {
  $$ReviewLogsTableTableManager(_$AppDatabase db, $ReviewLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<String> itemType = const Value.absent(),
                Value<String> subjectId = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<bool> correct = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => ReviewLogsCompanion(
                id: id,
                itemId: itemId,
                itemType: itemType,
                subjectId: subjectId,
                topic: topic,
                correct: correct,
                rating: rating,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String itemId,
                required String itemType,
                required String subjectId,
                required String topic,
                required bool correct,
                Value<int?> rating = const Value.absent(),
                required DateTime timestamp,
              }) => ReviewLogsCompanion.insert(
                id: id,
                itemId: itemId,
                itemType: itemType,
                subjectId: subjectId,
                topic: topic,
                correct: correct,
                rating: rating,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReviewLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewLogsTable,
      ReviewLog,
      $$ReviewLogsTableFilterComposer,
      $$ReviewLogsTableOrderingComposer,
      $$ReviewLogsTableAnnotationComposer,
      $$ReviewLogsTableCreateCompanionBuilder,
      $$ReviewLogsTableUpdateCompanionBuilder,
      (ReviewLog, BaseReferences<_$AppDatabase, $ReviewLogsTable, ReviewLog>),
      ReviewLog,
      PrefetchHooks Function()
    >;
typedef $$QuizResultsTableCreateCompanionBuilder =
    QuizResultsCompanion Function({
      Value<int> id,
      Value<String?> subjectId,
      required String mode,
      required int total,
      required int correctCount,
      required int wrongCount,
      required int skippedCount,
      required double score,
      required double maxScore,
      required int durationSeconds,
      required DateTime timestamp,
    });
typedef $$QuizResultsTableUpdateCompanionBuilder =
    QuizResultsCompanion Function({
      Value<int> id,
      Value<String?> subjectId,
      Value<String> mode,
      Value<int> total,
      Value<int> correctCount,
      Value<int> wrongCount,
      Value<int> skippedCount,
      Value<double> score,
      Value<double> maxScore,
      Value<int> durationSeconds,
      Value<DateTime> timestamp,
    });

class $$QuizResultsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizResultsTable> {
  $$QuizResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wrongCount => $composableBuilder(
    column: $table.wrongCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get skippedCount => $composableBuilder(
    column: $table.skippedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxScore => $composableBuilder(
    column: $table.maxScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuizResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizResultsTable> {
  $$QuizResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wrongCount => $composableBuilder(
    column: $table.wrongCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get skippedCount => $composableBuilder(
    column: $table.skippedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxScore => $composableBuilder(
    column: $table.maxScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuizResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizResultsTable> {
  $$QuizResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wrongCount => $composableBuilder(
    column: $table.wrongCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get skippedCount => $composableBuilder(
    column: $table.skippedCount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<double> get maxScore =>
      $composableBuilder(column: $table.maxScore, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$QuizResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizResultsTable,
          QuizResult,
          $$QuizResultsTableFilterComposer,
          $$QuizResultsTableOrderingComposer,
          $$QuizResultsTableAnnotationComposer,
          $$QuizResultsTableCreateCompanionBuilder,
          $$QuizResultsTableUpdateCompanionBuilder,
          (
            QuizResult,
            BaseReferences<_$AppDatabase, $QuizResultsTable, QuizResult>,
          ),
          QuizResult,
          PrefetchHooks Function()
        > {
  $$QuizResultsTableTableManager(_$AppDatabase db, $QuizResultsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> subjectId = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> wrongCount = const Value.absent(),
                Value<int> skippedCount = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<double> maxScore = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
              }) => QuizResultsCompanion(
                id: id,
                subjectId: subjectId,
                mode: mode,
                total: total,
                correctCount: correctCount,
                wrongCount: wrongCount,
                skippedCount: skippedCount,
                score: score,
                maxScore: maxScore,
                durationSeconds: durationSeconds,
                timestamp: timestamp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> subjectId = const Value.absent(),
                required String mode,
                required int total,
                required int correctCount,
                required int wrongCount,
                required int skippedCount,
                required double score,
                required double maxScore,
                required int durationSeconds,
                required DateTime timestamp,
              }) => QuizResultsCompanion.insert(
                id: id,
                subjectId: subjectId,
                mode: mode,
                total: total,
                correctCount: correctCount,
                wrongCount: wrongCount,
                skippedCount: skippedCount,
                score: score,
                maxScore: maxScore,
                durationSeconds: durationSeconds,
                timestamp: timestamp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuizResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizResultsTable,
      QuizResult,
      $$QuizResultsTableFilterComposer,
      $$QuizResultsTableOrderingComposer,
      $$QuizResultsTableAnnotationComposer,
      $$QuizResultsTableCreateCompanionBuilder,
      $$QuizResultsTableUpdateCompanionBuilder,
      (
        QuizResult,
        BaseReferences<_$AppDatabase, $QuizResultsTable, QuizResult>,
      ),
      QuizResult,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
  $$FlashcardsTableTableManager get flashcards =>
      $$FlashcardsTableTableManager(_db, _db.flashcards);
  $$McqsTableTableManager get mcqs => $$McqsTableTableManager(_db, _db.mcqs);
  $$SrsStatesTableTableManager get srsStates =>
      $$SrsStatesTableTableManager(_db, _db.srsStates);
  $$ReviewLogsTableTableManager get reviewLogs =>
      $$ReviewLogsTableTableManager(_db, _db.reviewLogs);
  $$QuizResultsTableTableManager get quizResults =>
      $$QuizResultsTableTableManager(_db, _db.quizResults);
}
