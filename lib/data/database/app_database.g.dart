// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, Settings> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _bedtimeHourMeta = const VerificationMeta(
    'bedtimeHour',
  );
  @override
  late final GeneratedColumn<int> bedtimeHour = GeneratedColumn<int>(
    'bedtime_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bedtimeMinuteMeta = const VerificationMeta(
    'bedtimeMinute',
  );
  @override
  late final GeneratedColumn<int> bedtimeMinute = GeneratedColumn<int>(
    'bedtime_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wakeHourMeta = const VerificationMeta(
    'wakeHour',
  );
  @override
  late final GeneratedColumn<int> wakeHour = GeneratedColumn<int>(
    'wake_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wakeMinuteMeta = const VerificationMeta(
    'wakeMinute',
  );
  @override
  late final GeneratedColumn<int> wakeMinute = GeneratedColumn<int>(
    'wake_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bedtimeNotifEnabledMeta =
      const VerificationMeta('bedtimeNotifEnabled');
  @override
  late final GeneratedColumn<bool> bedtimeNotifEnabled = GeneratedColumn<bool>(
    'bedtime_notif_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("bedtime_notif_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _wakeNotifEnabledMeta = const VerificationMeta(
    'wakeNotifEnabled',
  );
  @override
  late final GeneratedColumn<bool> wakeNotifEnabled = GeneratedColumn<bool>(
    'wake_notif_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("wake_notif_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _reminderOffsetMinutesMeta =
      const VerificationMeta('reminderOffsetMinutes');
  @override
  late final GeneratedColumn<int> reminderOffsetMinutes = GeneratedColumn<int>(
    'reminder_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bedtimeHour,
    bedtimeMinute,
    wakeHour,
    wakeMinute,
    bedtimeNotifEnabled,
    wakeNotifEnabled,
    reminderOffsetMinutes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<Settings> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bedtime_hour')) {
      context.handle(
        _bedtimeHourMeta,
        bedtimeHour.isAcceptableOrUnknown(
          data['bedtime_hour']!,
          _bedtimeHourMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bedtimeHourMeta);
    }
    if (data.containsKey('bedtime_minute')) {
      context.handle(
        _bedtimeMinuteMeta,
        bedtimeMinute.isAcceptableOrUnknown(
          data['bedtime_minute']!,
          _bedtimeMinuteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bedtimeMinuteMeta);
    }
    if (data.containsKey('wake_hour')) {
      context.handle(
        _wakeHourMeta,
        wakeHour.isAcceptableOrUnknown(data['wake_hour']!, _wakeHourMeta),
      );
    } else if (isInserting) {
      context.missing(_wakeHourMeta);
    }
    if (data.containsKey('wake_minute')) {
      context.handle(
        _wakeMinuteMeta,
        wakeMinute.isAcceptableOrUnknown(data['wake_minute']!, _wakeMinuteMeta),
      );
    } else if (isInserting) {
      context.missing(_wakeMinuteMeta);
    }
    if (data.containsKey('bedtime_notif_enabled')) {
      context.handle(
        _bedtimeNotifEnabledMeta,
        bedtimeNotifEnabled.isAcceptableOrUnknown(
          data['bedtime_notif_enabled']!,
          _bedtimeNotifEnabledMeta,
        ),
      );
    }
    if (data.containsKey('wake_notif_enabled')) {
      context.handle(
        _wakeNotifEnabledMeta,
        wakeNotifEnabled.isAcceptableOrUnknown(
          data['wake_notif_enabled']!,
          _wakeNotifEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_offset_minutes')) {
      context.handle(
        _reminderOffsetMinutesMeta,
        reminderOffsetMinutes.isAcceptableOrUnknown(
          data['reminder_offset_minutes']!,
          _reminderOffsetMinutesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Settings map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Settings(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bedtimeHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bedtime_hour'],
      )!,
      bedtimeMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bedtime_minute'],
      )!,
      wakeHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wake_hour'],
      )!,
      wakeMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wake_minute'],
      )!,
      bedtimeNotifEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}bedtime_notif_enabled'],
      )!,
      wakeNotifEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}wake_notif_enabled'],
      )!,
      reminderOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_offset_minutes'],
      )!,
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class Settings extends DataClass implements Insertable<Settings> {
  final int id;
  final int bedtimeHour;
  final int bedtimeMinute;
  final int wakeHour;
  final int wakeMinute;
  final bool bedtimeNotifEnabled;
  final bool wakeNotifEnabled;
  final int reminderOffsetMinutes;
  const Settings({
    required this.id,
    required this.bedtimeHour,
    required this.bedtimeMinute,
    required this.wakeHour,
    required this.wakeMinute,
    required this.bedtimeNotifEnabled,
    required this.wakeNotifEnabled,
    required this.reminderOffsetMinutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bedtime_hour'] = Variable<int>(bedtimeHour);
    map['bedtime_minute'] = Variable<int>(bedtimeMinute);
    map['wake_hour'] = Variable<int>(wakeHour);
    map['wake_minute'] = Variable<int>(wakeMinute);
    map['bedtime_notif_enabled'] = Variable<bool>(bedtimeNotifEnabled);
    map['wake_notif_enabled'] = Variable<bool>(wakeNotifEnabled);
    map['reminder_offset_minutes'] = Variable<int>(reminderOffsetMinutes);
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(
      id: Value(id),
      bedtimeHour: Value(bedtimeHour),
      bedtimeMinute: Value(bedtimeMinute),
      wakeHour: Value(wakeHour),
      wakeMinute: Value(wakeMinute),
      bedtimeNotifEnabled: Value(bedtimeNotifEnabled),
      wakeNotifEnabled: Value(wakeNotifEnabled),
      reminderOffsetMinutes: Value(reminderOffsetMinutes),
    );
  }

  factory Settings.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Settings(
      id: serializer.fromJson<int>(json['id']),
      bedtimeHour: serializer.fromJson<int>(json['bedtimeHour']),
      bedtimeMinute: serializer.fromJson<int>(json['bedtimeMinute']),
      wakeHour: serializer.fromJson<int>(json['wakeHour']),
      wakeMinute: serializer.fromJson<int>(json['wakeMinute']),
      bedtimeNotifEnabled: serializer.fromJson<bool>(
        json['bedtimeNotifEnabled'],
      ),
      wakeNotifEnabled: serializer.fromJson<bool>(json['wakeNotifEnabled']),
      reminderOffsetMinutes: serializer.fromJson<int>(
        json['reminderOffsetMinutes'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bedtimeHour': serializer.toJson<int>(bedtimeHour),
      'bedtimeMinute': serializer.toJson<int>(bedtimeMinute),
      'wakeHour': serializer.toJson<int>(wakeHour),
      'wakeMinute': serializer.toJson<int>(wakeMinute),
      'bedtimeNotifEnabled': serializer.toJson<bool>(bedtimeNotifEnabled),
      'wakeNotifEnabled': serializer.toJson<bool>(wakeNotifEnabled),
      'reminderOffsetMinutes': serializer.toJson<int>(reminderOffsetMinutes),
    };
  }

  Settings copyWith({
    int? id,
    int? bedtimeHour,
    int? bedtimeMinute,
    int? wakeHour,
    int? wakeMinute,
    bool? bedtimeNotifEnabled,
    bool? wakeNotifEnabled,
    int? reminderOffsetMinutes,
  }) => Settings(
    id: id ?? this.id,
    bedtimeHour: bedtimeHour ?? this.bedtimeHour,
    bedtimeMinute: bedtimeMinute ?? this.bedtimeMinute,
    wakeHour: wakeHour ?? this.wakeHour,
    wakeMinute: wakeMinute ?? this.wakeMinute,
    bedtimeNotifEnabled: bedtimeNotifEnabled ?? this.bedtimeNotifEnabled,
    wakeNotifEnabled: wakeNotifEnabled ?? this.wakeNotifEnabled,
    reminderOffsetMinutes: reminderOffsetMinutes ?? this.reminderOffsetMinutes,
  );
  Settings copyWithCompanion(SettingsTableCompanion data) {
    return Settings(
      id: data.id.present ? data.id.value : this.id,
      bedtimeHour: data.bedtimeHour.present
          ? data.bedtimeHour.value
          : this.bedtimeHour,
      bedtimeMinute: data.bedtimeMinute.present
          ? data.bedtimeMinute.value
          : this.bedtimeMinute,
      wakeHour: data.wakeHour.present ? data.wakeHour.value : this.wakeHour,
      wakeMinute: data.wakeMinute.present
          ? data.wakeMinute.value
          : this.wakeMinute,
      bedtimeNotifEnabled: data.bedtimeNotifEnabled.present
          ? data.bedtimeNotifEnabled.value
          : this.bedtimeNotifEnabled,
      wakeNotifEnabled: data.wakeNotifEnabled.present
          ? data.wakeNotifEnabled.value
          : this.wakeNotifEnabled,
      reminderOffsetMinutes: data.reminderOffsetMinutes.present
          ? data.reminderOffsetMinutes.value
          : this.reminderOffsetMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Settings(')
          ..write('id: $id, ')
          ..write('bedtimeHour: $bedtimeHour, ')
          ..write('bedtimeMinute: $bedtimeMinute, ')
          ..write('wakeHour: $wakeHour, ')
          ..write('wakeMinute: $wakeMinute, ')
          ..write('bedtimeNotifEnabled: $bedtimeNotifEnabled, ')
          ..write('wakeNotifEnabled: $wakeNotifEnabled, ')
          ..write('reminderOffsetMinutes: $reminderOffsetMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bedtimeHour,
    bedtimeMinute,
    wakeHour,
    wakeMinute,
    bedtimeNotifEnabled,
    wakeNotifEnabled,
    reminderOffsetMinutes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Settings &&
          other.id == this.id &&
          other.bedtimeHour == this.bedtimeHour &&
          other.bedtimeMinute == this.bedtimeMinute &&
          other.wakeHour == this.wakeHour &&
          other.wakeMinute == this.wakeMinute &&
          other.bedtimeNotifEnabled == this.bedtimeNotifEnabled &&
          other.wakeNotifEnabled == this.wakeNotifEnabled &&
          other.reminderOffsetMinutes == this.reminderOffsetMinutes);
}

class SettingsTableCompanion extends UpdateCompanion<Settings> {
  final Value<int> id;
  final Value<int> bedtimeHour;
  final Value<int> bedtimeMinute;
  final Value<int> wakeHour;
  final Value<int> wakeMinute;
  final Value<bool> bedtimeNotifEnabled;
  final Value<bool> wakeNotifEnabled;
  final Value<int> reminderOffsetMinutes;
  const SettingsTableCompanion({
    this.id = const Value.absent(),
    this.bedtimeHour = const Value.absent(),
    this.bedtimeMinute = const Value.absent(),
    this.wakeHour = const Value.absent(),
    this.wakeMinute = const Value.absent(),
    this.bedtimeNotifEnabled = const Value.absent(),
    this.wakeNotifEnabled = const Value.absent(),
    this.reminderOffsetMinutes = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required int bedtimeHour,
    required int bedtimeMinute,
    required int wakeHour,
    required int wakeMinute,
    this.bedtimeNotifEnabled = const Value.absent(),
    this.wakeNotifEnabled = const Value.absent(),
    this.reminderOffsetMinutes = const Value.absent(),
  }) : bedtimeHour = Value(bedtimeHour),
       bedtimeMinute = Value(bedtimeMinute),
       wakeHour = Value(wakeHour),
       wakeMinute = Value(wakeMinute);
  static Insertable<Settings> custom({
    Expression<int>? id,
    Expression<int>? bedtimeHour,
    Expression<int>? bedtimeMinute,
    Expression<int>? wakeHour,
    Expression<int>? wakeMinute,
    Expression<bool>? bedtimeNotifEnabled,
    Expression<bool>? wakeNotifEnabled,
    Expression<int>? reminderOffsetMinutes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bedtimeHour != null) 'bedtime_hour': bedtimeHour,
      if (bedtimeMinute != null) 'bedtime_minute': bedtimeMinute,
      if (wakeHour != null) 'wake_hour': wakeHour,
      if (wakeMinute != null) 'wake_minute': wakeMinute,
      if (bedtimeNotifEnabled != null)
        'bedtime_notif_enabled': bedtimeNotifEnabled,
      if (wakeNotifEnabled != null) 'wake_notif_enabled': wakeNotifEnabled,
      if (reminderOffsetMinutes != null)
        'reminder_offset_minutes': reminderOffsetMinutes,
    });
  }

  SettingsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? bedtimeHour,
    Value<int>? bedtimeMinute,
    Value<int>? wakeHour,
    Value<int>? wakeMinute,
    Value<bool>? bedtimeNotifEnabled,
    Value<bool>? wakeNotifEnabled,
    Value<int>? reminderOffsetMinutes,
  }) {
    return SettingsTableCompanion(
      id: id ?? this.id,
      bedtimeHour: bedtimeHour ?? this.bedtimeHour,
      bedtimeMinute: bedtimeMinute ?? this.bedtimeMinute,
      wakeHour: wakeHour ?? this.wakeHour,
      wakeMinute: wakeMinute ?? this.wakeMinute,
      bedtimeNotifEnabled: bedtimeNotifEnabled ?? this.bedtimeNotifEnabled,
      wakeNotifEnabled: wakeNotifEnabled ?? this.wakeNotifEnabled,
      reminderOffsetMinutes:
          reminderOffsetMinutes ?? this.reminderOffsetMinutes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bedtimeHour.present) {
      map['bedtime_hour'] = Variable<int>(bedtimeHour.value);
    }
    if (bedtimeMinute.present) {
      map['bedtime_minute'] = Variable<int>(bedtimeMinute.value);
    }
    if (wakeHour.present) {
      map['wake_hour'] = Variable<int>(wakeHour.value);
    }
    if (wakeMinute.present) {
      map['wake_minute'] = Variable<int>(wakeMinute.value);
    }
    if (bedtimeNotifEnabled.present) {
      map['bedtime_notif_enabled'] = Variable<bool>(bedtimeNotifEnabled.value);
    }
    if (wakeNotifEnabled.present) {
      map['wake_notif_enabled'] = Variable<bool>(wakeNotifEnabled.value);
    }
    if (reminderOffsetMinutes.present) {
      map['reminder_offset_minutes'] = Variable<int>(
        reminderOffsetMinutes.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('bedtimeHour: $bedtimeHour, ')
          ..write('bedtimeMinute: $bedtimeMinute, ')
          ..write('wakeHour: $wakeHour, ')
          ..write('wakeMinute: $wakeMinute, ')
          ..write('bedtimeNotifEnabled: $bedtimeNotifEnabled, ')
          ..write('wakeNotifEnabled: $wakeNotifEnabled, ')
          ..write('reminderOffsetMinutes: $reminderOffsetMinutes')
          ..write(')'))
        .toString();
  }
}

class $TasksTableTable extends TasksTable
    with TableInfo<$TasksTableTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routineTypeMeta = const VerificationMeta(
    'routineType',
  );
  @override
  late final GeneratedColumn<String> routineType = GeneratedColumn<String>(
    'routine_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, routineType, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('routine_type')) {
      context.handle(
        _routineTypeMeta,
        routineType.isAcceptableOrUnknown(
          data['routine_type']!,
          _routineTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_routineTypeMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      routineType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_type'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $TasksTableTable createAlias(String alias) {
    return $TasksTableTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final String id;
  final String title;
  final String routineType;
  final int sortOrder;
  const Task({
    required this.id,
    required this.title,
    required this.routineType,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['routine_type'] = Variable<String>(routineType);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  TasksTableCompanion toCompanion(bool nullToAbsent) {
    return TasksTableCompanion(
      id: Value(id),
      title: Value(title),
      routineType: Value(routineType),
      sortOrder: Value(sortOrder),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      routineType: serializer.fromJson<String>(json['routineType']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'routineType': serializer.toJson<String>(routineType),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? routineType,
    int? sortOrder,
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    routineType: routineType ?? this.routineType,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Task copyWithCompanion(TasksTableCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      routineType: data.routineType.present
          ? data.routineType.value
          : this.routineType,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('routineType: $routineType, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, routineType, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.title == this.title &&
          other.routineType == this.routineType &&
          other.sortOrder == this.sortOrder);
}

class TasksTableCompanion extends UpdateCompanion<Task> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> routineType;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const TasksTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.routineType = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksTableCompanion.insert({
    required String id,
    required String title,
    required String routineType,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       routineType = Value(routineType),
       sortOrder = Value(sortOrder);
  static Insertable<Task> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? routineType,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (routineType != null) 'routine_type': routineType,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? routineType,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return TasksTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      routineType: routineType ?? this.routineType,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (routineType.present) {
      map['routine_type'] = Variable<String>(routineType.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('routineType: $routineType, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LogsTableTable extends LogsTable with TableInfo<$LogsTableTable, Log> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LogsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateKeyMeta = const VerificationMeta(
    'dateKey',
  );
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
    'date_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedTaskIdsMeta = const VerificationMeta(
    'completedTaskIds',
  );
  @override
  late final GeneratedColumn<String> completedTaskIds = GeneratedColumn<String>(
    'completed_task_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eveningCompletedMeta = const VerificationMeta(
    'eveningCompleted',
  );
  @override
  late final GeneratedColumn<bool> eveningCompleted = GeneratedColumn<bool>(
    'evening_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("evening_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _morningCompletedMeta = const VerificationMeta(
    'morningCompleted',
  );
  @override
  late final GeneratedColumn<bool> morningCompleted = GeneratedColumn<bool>(
    'morning_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("morning_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _eveningCompletedAtMeta =
      const VerificationMeta('eveningCompletedAt');
  @override
  late final GeneratedColumn<DateTime> eveningCompletedAt =
      GeneratedColumn<DateTime>(
        'evening_completed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _morningCompletedAtMeta =
      const VerificationMeta('morningCompletedAt');
  @override
  late final GeneratedColumn<DateTime> morningCompletedAt =
      GeneratedColumn<DateTime>(
        'morning_completed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _napTakenMeta = const VerificationMeta(
    'napTaken',
  );
  @override
  late final GeneratedColumn<bool> napTaken = GeneratedColumn<bool>(
    'nap_taken',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("nap_taken" IN (0, 1))',
    ),
  );
  static const VerificationMeta _daytimeSleepinessMeta = const VerificationMeta(
    'daytimeSleepiness',
  );
  @override
  late final GeneratedColumn<bool> daytimeSleepiness = GeneratedColumn<bool>(
    'daytime_sleepiness',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("daytime_sleepiness" IN (0, 1))',
    ),
  );
  static const VerificationMeta _feltIrritableMeta = const VerificationMeta(
    'feltIrritable',
  );
  @override
  late final GeneratedColumn<bool> feltIrritable = GeneratedColumn<bool>(
    'felt_irritable',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("felt_irritable" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    dateKey,
    completedTaskIds,
    eveningCompleted,
    morningCompleted,
    eveningCompletedAt,
    morningCompletedAt,
    napTaken,
    daytimeSleepiness,
    feltIrritable,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'logs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<Log> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('completed_task_ids')) {
      context.handle(
        _completedTaskIdsMeta,
        completedTaskIds.isAcceptableOrUnknown(
          data['completed_task_ids']!,
          _completedTaskIdsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedTaskIdsMeta);
    }
    if (data.containsKey('evening_completed')) {
      context.handle(
        _eveningCompletedMeta,
        eveningCompleted.isAcceptableOrUnknown(
          data['evening_completed']!,
          _eveningCompletedMeta,
        ),
      );
    }
    if (data.containsKey('morning_completed')) {
      context.handle(
        _morningCompletedMeta,
        morningCompleted.isAcceptableOrUnknown(
          data['morning_completed']!,
          _morningCompletedMeta,
        ),
      );
    }
    if (data.containsKey('evening_completed_at')) {
      context.handle(
        _eveningCompletedAtMeta,
        eveningCompletedAt.isAcceptableOrUnknown(
          data['evening_completed_at']!,
          _eveningCompletedAtMeta,
        ),
      );
    }
    if (data.containsKey('morning_completed_at')) {
      context.handle(
        _morningCompletedAtMeta,
        morningCompletedAt.isAcceptableOrUnknown(
          data['morning_completed_at']!,
          _morningCompletedAtMeta,
        ),
      );
    }
    if (data.containsKey('nap_taken')) {
      context.handle(
        _napTakenMeta,
        napTaken.isAcceptableOrUnknown(data['nap_taken']!, _napTakenMeta),
      );
    }
    if (data.containsKey('daytime_sleepiness')) {
      context.handle(
        _daytimeSleepinessMeta,
        daytimeSleepiness.isAcceptableOrUnknown(
          data['daytime_sleepiness']!,
          _daytimeSleepinessMeta,
        ),
      );
    }
    if (data.containsKey('felt_irritable')) {
      context.handle(
        _feltIrritableMeta,
        feltIrritable.isAcceptableOrUnknown(
          data['felt_irritable']!,
          _feltIrritableMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dateKey};
  @override
  Log map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Log(
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_key'],
      )!,
      completedTaskIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completed_task_ids'],
      )!,
      eveningCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}evening_completed'],
      )!,
      morningCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}morning_completed'],
      )!,
      eveningCompletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}evening_completed_at'],
      ),
      morningCompletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}morning_completed_at'],
      ),
      napTaken: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}nap_taken'],
      ),
      daytimeSleepiness: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}daytime_sleepiness'],
      ),
      feltIrritable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}felt_irritable'],
      ),
    );
  }

  @override
  $LogsTableTable createAlias(String alias) {
    return $LogsTableTable(attachedDatabase, alias);
  }
}

class Log extends DataClass implements Insertable<Log> {
  final String dateKey;
  final String completedTaskIds;
  final bool eveningCompleted;
  final bool morningCompleted;
  final DateTime? eveningCompletedAt;
  final DateTime? morningCompletedAt;
  final bool? napTaken;
  final bool? daytimeSleepiness;
  final bool? feltIrritable;
  const Log({
    required this.dateKey,
    required this.completedTaskIds,
    required this.eveningCompleted,
    required this.morningCompleted,
    this.eveningCompletedAt,
    this.morningCompletedAt,
    this.napTaken,
    this.daytimeSleepiness,
    this.feltIrritable,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date_key'] = Variable<String>(dateKey);
    map['completed_task_ids'] = Variable<String>(completedTaskIds);
    map['evening_completed'] = Variable<bool>(eveningCompleted);
    map['morning_completed'] = Variable<bool>(morningCompleted);
    if (!nullToAbsent || eveningCompletedAt != null) {
      map['evening_completed_at'] = Variable<DateTime>(eveningCompletedAt);
    }
    if (!nullToAbsent || morningCompletedAt != null) {
      map['morning_completed_at'] = Variable<DateTime>(morningCompletedAt);
    }
    if (!nullToAbsent || napTaken != null) {
      map['nap_taken'] = Variable<bool>(napTaken);
    }
    if (!nullToAbsent || daytimeSleepiness != null) {
      map['daytime_sleepiness'] = Variable<bool>(daytimeSleepiness);
    }
    if (!nullToAbsent || feltIrritable != null) {
      map['felt_irritable'] = Variable<bool>(feltIrritable);
    }
    return map;
  }

  LogsTableCompanion toCompanion(bool nullToAbsent) {
    return LogsTableCompanion(
      dateKey: Value(dateKey),
      completedTaskIds: Value(completedTaskIds),
      eveningCompleted: Value(eveningCompleted),
      morningCompleted: Value(morningCompleted),
      eveningCompletedAt: eveningCompletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(eveningCompletedAt),
      morningCompletedAt: morningCompletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(morningCompletedAt),
      napTaken: napTaken == null && nullToAbsent
          ? const Value.absent()
          : Value(napTaken),
      daytimeSleepiness: daytimeSleepiness == null && nullToAbsent
          ? const Value.absent()
          : Value(daytimeSleepiness),
      feltIrritable: feltIrritable == null && nullToAbsent
          ? const Value.absent()
          : Value(feltIrritable),
    );
  }

  factory Log.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Log(
      dateKey: serializer.fromJson<String>(json['dateKey']),
      completedTaskIds: serializer.fromJson<String>(json['completedTaskIds']),
      eveningCompleted: serializer.fromJson<bool>(json['eveningCompleted']),
      morningCompleted: serializer.fromJson<bool>(json['morningCompleted']),
      eveningCompletedAt: serializer.fromJson<DateTime?>(
        json['eveningCompletedAt'],
      ),
      morningCompletedAt: serializer.fromJson<DateTime?>(
        json['morningCompletedAt'],
      ),
      napTaken: serializer.fromJson<bool?>(json['napTaken']),
      daytimeSleepiness: serializer.fromJson<bool?>(json['daytimeSleepiness']),
      feltIrritable: serializer.fromJson<bool?>(json['feltIrritable']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dateKey': serializer.toJson<String>(dateKey),
      'completedTaskIds': serializer.toJson<String>(completedTaskIds),
      'eveningCompleted': serializer.toJson<bool>(eveningCompleted),
      'morningCompleted': serializer.toJson<bool>(morningCompleted),
      'eveningCompletedAt': serializer.toJson<DateTime?>(eveningCompletedAt),
      'morningCompletedAt': serializer.toJson<DateTime?>(morningCompletedAt),
      'napTaken': serializer.toJson<bool?>(napTaken),
      'daytimeSleepiness': serializer.toJson<bool?>(daytimeSleepiness),
      'feltIrritable': serializer.toJson<bool?>(feltIrritable),
    };
  }

  Log copyWith({
    String? dateKey,
    String? completedTaskIds,
    bool? eveningCompleted,
    bool? morningCompleted,
    Value<DateTime?> eveningCompletedAt = const Value.absent(),
    Value<DateTime?> morningCompletedAt = const Value.absent(),
    Value<bool?> napTaken = const Value.absent(),
    Value<bool?> daytimeSleepiness = const Value.absent(),
    Value<bool?> feltIrritable = const Value.absent(),
  }) => Log(
    dateKey: dateKey ?? this.dateKey,
    completedTaskIds: completedTaskIds ?? this.completedTaskIds,
    eveningCompleted: eveningCompleted ?? this.eveningCompleted,
    morningCompleted: morningCompleted ?? this.morningCompleted,
    eveningCompletedAt: eveningCompletedAt.present
        ? eveningCompletedAt.value
        : this.eveningCompletedAt,
    morningCompletedAt: morningCompletedAt.present
        ? morningCompletedAt.value
        : this.morningCompletedAt,
    napTaken: napTaken.present ? napTaken.value : this.napTaken,
    daytimeSleepiness: daytimeSleepiness.present
        ? daytimeSleepiness.value
        : this.daytimeSleepiness,
    feltIrritable: feltIrritable.present
        ? feltIrritable.value
        : this.feltIrritable,
  );
  Log copyWithCompanion(LogsTableCompanion data) {
    return Log(
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      completedTaskIds: data.completedTaskIds.present
          ? data.completedTaskIds.value
          : this.completedTaskIds,
      eveningCompleted: data.eveningCompleted.present
          ? data.eveningCompleted.value
          : this.eveningCompleted,
      morningCompleted: data.morningCompleted.present
          ? data.morningCompleted.value
          : this.morningCompleted,
      eveningCompletedAt: data.eveningCompletedAt.present
          ? data.eveningCompletedAt.value
          : this.eveningCompletedAt,
      morningCompletedAt: data.morningCompletedAt.present
          ? data.morningCompletedAt.value
          : this.morningCompletedAt,
      napTaken: data.napTaken.present ? data.napTaken.value : this.napTaken,
      daytimeSleepiness: data.daytimeSleepiness.present
          ? data.daytimeSleepiness.value
          : this.daytimeSleepiness,
      feltIrritable: data.feltIrritable.present
          ? data.feltIrritable.value
          : this.feltIrritable,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Log(')
          ..write('dateKey: $dateKey, ')
          ..write('completedTaskIds: $completedTaskIds, ')
          ..write('eveningCompleted: $eveningCompleted, ')
          ..write('morningCompleted: $morningCompleted, ')
          ..write('eveningCompletedAt: $eveningCompletedAt, ')
          ..write('morningCompletedAt: $morningCompletedAt, ')
          ..write('napTaken: $napTaken, ')
          ..write('daytimeSleepiness: $daytimeSleepiness, ')
          ..write('feltIrritable: $feltIrritable')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    dateKey,
    completedTaskIds,
    eveningCompleted,
    morningCompleted,
    eveningCompletedAt,
    morningCompletedAt,
    napTaken,
    daytimeSleepiness,
    feltIrritable,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Log &&
          other.dateKey == this.dateKey &&
          other.completedTaskIds == this.completedTaskIds &&
          other.eveningCompleted == this.eveningCompleted &&
          other.morningCompleted == this.morningCompleted &&
          other.eveningCompletedAt == this.eveningCompletedAt &&
          other.morningCompletedAt == this.morningCompletedAt &&
          other.napTaken == this.napTaken &&
          other.daytimeSleepiness == this.daytimeSleepiness &&
          other.feltIrritable == this.feltIrritable);
}

class LogsTableCompanion extends UpdateCompanion<Log> {
  final Value<String> dateKey;
  final Value<String> completedTaskIds;
  final Value<bool> eveningCompleted;
  final Value<bool> morningCompleted;
  final Value<DateTime?> eveningCompletedAt;
  final Value<DateTime?> morningCompletedAt;
  final Value<bool?> napTaken;
  final Value<bool?> daytimeSleepiness;
  final Value<bool?> feltIrritable;
  final Value<int> rowid;
  const LogsTableCompanion({
    this.dateKey = const Value.absent(),
    this.completedTaskIds = const Value.absent(),
    this.eveningCompleted = const Value.absent(),
    this.morningCompleted = const Value.absent(),
    this.eveningCompletedAt = const Value.absent(),
    this.morningCompletedAt = const Value.absent(),
    this.napTaken = const Value.absent(),
    this.daytimeSleepiness = const Value.absent(),
    this.feltIrritable = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LogsTableCompanion.insert({
    required String dateKey,
    required String completedTaskIds,
    this.eveningCompleted = const Value.absent(),
    this.morningCompleted = const Value.absent(),
    this.eveningCompletedAt = const Value.absent(),
    this.morningCompletedAt = const Value.absent(),
    this.napTaken = const Value.absent(),
    this.daytimeSleepiness = const Value.absent(),
    this.feltIrritable = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : dateKey = Value(dateKey),
       completedTaskIds = Value(completedTaskIds);
  static Insertable<Log> custom({
    Expression<String>? dateKey,
    Expression<String>? completedTaskIds,
    Expression<bool>? eveningCompleted,
    Expression<bool>? morningCompleted,
    Expression<DateTime>? eveningCompletedAt,
    Expression<DateTime>? morningCompletedAt,
    Expression<bool>? napTaken,
    Expression<bool>? daytimeSleepiness,
    Expression<bool>? feltIrritable,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dateKey != null) 'date_key': dateKey,
      if (completedTaskIds != null) 'completed_task_ids': completedTaskIds,
      if (eveningCompleted != null) 'evening_completed': eveningCompleted,
      if (morningCompleted != null) 'morning_completed': morningCompleted,
      if (eveningCompletedAt != null)
        'evening_completed_at': eveningCompletedAt,
      if (morningCompletedAt != null)
        'morning_completed_at': morningCompletedAt,
      if (napTaken != null) 'nap_taken': napTaken,
      if (daytimeSleepiness != null) 'daytime_sleepiness': daytimeSleepiness,
      if (feltIrritable != null) 'felt_irritable': feltIrritable,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LogsTableCompanion copyWith({
    Value<String>? dateKey,
    Value<String>? completedTaskIds,
    Value<bool>? eveningCompleted,
    Value<bool>? morningCompleted,
    Value<DateTime?>? eveningCompletedAt,
    Value<DateTime?>? morningCompletedAt,
    Value<bool?>? napTaken,
    Value<bool?>? daytimeSleepiness,
    Value<bool?>? feltIrritable,
    Value<int>? rowid,
  }) {
    return LogsTableCompanion(
      dateKey: dateKey ?? this.dateKey,
      completedTaskIds: completedTaskIds ?? this.completedTaskIds,
      eveningCompleted: eveningCompleted ?? this.eveningCompleted,
      morningCompleted: morningCompleted ?? this.morningCompleted,
      eveningCompletedAt: eveningCompletedAt ?? this.eveningCompletedAt,
      morningCompletedAt: morningCompletedAt ?? this.morningCompletedAt,
      napTaken: napTaken ?? this.napTaken,
      daytimeSleepiness: daytimeSleepiness ?? this.daytimeSleepiness,
      feltIrritable: feltIrritable ?? this.feltIrritable,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (completedTaskIds.present) {
      map['completed_task_ids'] = Variable<String>(completedTaskIds.value);
    }
    if (eveningCompleted.present) {
      map['evening_completed'] = Variable<bool>(eveningCompleted.value);
    }
    if (morningCompleted.present) {
      map['morning_completed'] = Variable<bool>(morningCompleted.value);
    }
    if (eveningCompletedAt.present) {
      map['evening_completed_at'] = Variable<DateTime>(
        eveningCompletedAt.value,
      );
    }
    if (morningCompletedAt.present) {
      map['morning_completed_at'] = Variable<DateTime>(
        morningCompletedAt.value,
      );
    }
    if (napTaken.present) {
      map['nap_taken'] = Variable<bool>(napTaken.value);
    }
    if (daytimeSleepiness.present) {
      map['daytime_sleepiness'] = Variable<bool>(daytimeSleepiness.value);
    }
    if (feltIrritable.present) {
      map['felt_irritable'] = Variable<bool>(feltIrritable.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogsTableCompanion(')
          ..write('dateKey: $dateKey, ')
          ..write('completedTaskIds: $completedTaskIds, ')
          ..write('eveningCompleted: $eveningCompleted, ')
          ..write('morningCompleted: $morningCompleted, ')
          ..write('eveningCompletedAt: $eveningCompletedAt, ')
          ..write('morningCompletedAt: $morningCompletedAt, ')
          ..write('napTaken: $napTaken, ')
          ..write('daytimeSleepiness: $daytimeSleepiness, ')
          ..write('feltIrritable: $feltIrritable, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTableTable extends AchievementsTable
    with TableInfo<$AchievementsTableTable, Achievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
    'unlocked_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<Achievement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Achievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Achievement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
      )!,
    );
  }

  @override
  $AchievementsTableTable createAlias(String alias) {
    return $AchievementsTableTable(attachedDatabase, alias);
  }
}

class Achievement extends DataClass implements Insertable<Achievement> {
  final String id;
  final DateTime unlockedAt;
  const Achievement({required this.id, required this.unlockedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    return map;
  }

  AchievementsTableCompanion toCompanion(bool nullToAbsent) {
    return AchievementsTableCompanion(
      id: Value(id),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory Achievement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Achievement(
      id: serializer.fromJson<String>(json['id']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
    };
  }

  Achievement copyWith({String? id, DateTime? unlockedAt}) =>
      Achievement(id: id ?? this.id, unlockedAt: unlockedAt ?? this.unlockedAt);
  Achievement copyWithCompanion(AchievementsTableCompanion data) {
    return Achievement(
      id: data.id.present ? data.id.value : this.id,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Achievement(')
          ..write('id: $id, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Achievement &&
          other.id == this.id &&
          other.unlockedAt == this.unlockedAt);
}

class AchievementsTableCompanion extends UpdateCompanion<Achievement> {
  final Value<String> id;
  final Value<DateTime> unlockedAt;
  final Value<int> rowid;
  const AchievementsTableCompanion({
    this.id = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementsTableCompanion.insert({
    required String id,
    required DateTime unlockedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       unlockedAt = Value(unlockedAt);
  static Insertable<Achievement> custom({
    Expression<String>? id,
    Expression<DateTime>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementsTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? unlockedAt,
    Value<int>? rowid,
  }) {
    return AchievementsTableCompanion(
      id: id ?? this.id,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsTableCompanion(')
          ..write('id: $id, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  late final $TasksTableTable tasksTable = $TasksTableTable(this);
  late final $LogsTableTable logsTable = $LogsTableTable(this);
  late final $AchievementsTableTable achievementsTable =
      $AchievementsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    settingsTable,
    tasksTable,
    logsTable,
    achievementsTable,
  ];
}

typedef $$SettingsTableTableCreateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      required int bedtimeHour,
      required int bedtimeMinute,
      required int wakeHour,
      required int wakeMinute,
      Value<bool> bedtimeNotifEnabled,
      Value<bool> wakeNotifEnabled,
      Value<int> reminderOffsetMinutes,
    });
typedef $$SettingsTableTableUpdateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      Value<int> bedtimeHour,
      Value<int> bedtimeMinute,
      Value<int> wakeHour,
      Value<int> wakeMinute,
      Value<bool> bedtimeNotifEnabled,
      Value<bool> wakeNotifEnabled,
      Value<int> reminderOffsetMinutes,
    });

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
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

  ColumnFilters<int> get bedtimeHour => $composableBuilder(
    column: $table.bedtimeHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bedtimeMinute => $composableBuilder(
    column: $table.bedtimeMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakeHour => $composableBuilder(
    column: $table.wakeHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakeMinute => $composableBuilder(
    column: $table.wakeMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get bedtimeNotifEnabled => $composableBuilder(
    column: $table.bedtimeNotifEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get wakeNotifEnabled => $composableBuilder(
    column: $table.wakeNotifEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderOffsetMinutes => $composableBuilder(
    column: $table.reminderOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
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

  ColumnOrderings<int> get bedtimeHour => $composableBuilder(
    column: $table.bedtimeHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bedtimeMinute => $composableBuilder(
    column: $table.bedtimeMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakeHour => $composableBuilder(
    column: $table.wakeHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakeMinute => $composableBuilder(
    column: $table.wakeMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get bedtimeNotifEnabled => $composableBuilder(
    column: $table.bedtimeNotifEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wakeNotifEnabled => $composableBuilder(
    column: $table.wakeNotifEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderOffsetMinutes => $composableBuilder(
    column: $table.reminderOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get bedtimeHour => $composableBuilder(
    column: $table.bedtimeHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bedtimeMinute => $composableBuilder(
    column: $table.bedtimeMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wakeHour =>
      $composableBuilder(column: $table.wakeHour, builder: (column) => column);

  GeneratedColumn<int> get wakeMinute => $composableBuilder(
    column: $table.wakeMinute,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get bedtimeNotifEnabled => $composableBuilder(
    column: $table.bedtimeNotifEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get wakeNotifEnabled => $composableBuilder(
    column: $table.wakeNotifEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderOffsetMinutes => $composableBuilder(
    column: $table.reminderOffsetMinutes,
    builder: (column) => column,
  );
}

class $$SettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTableTable,
          Settings,
          $$SettingsTableTableFilterComposer,
          $$SettingsTableTableOrderingComposer,
          $$SettingsTableTableAnnotationComposer,
          $$SettingsTableTableCreateCompanionBuilder,
          $$SettingsTableTableUpdateCompanionBuilder,
          (
            Settings,
            BaseReferences<_$AppDatabase, $SettingsTableTable, Settings>,
          ),
          Settings,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> bedtimeHour = const Value.absent(),
                Value<int> bedtimeMinute = const Value.absent(),
                Value<int> wakeHour = const Value.absent(),
                Value<int> wakeMinute = const Value.absent(),
                Value<bool> bedtimeNotifEnabled = const Value.absent(),
                Value<bool> wakeNotifEnabled = const Value.absent(),
                Value<int> reminderOffsetMinutes = const Value.absent(),
              }) => SettingsTableCompanion(
                id: id,
                bedtimeHour: bedtimeHour,
                bedtimeMinute: bedtimeMinute,
                wakeHour: wakeHour,
                wakeMinute: wakeMinute,
                bedtimeNotifEnabled: bedtimeNotifEnabled,
                wakeNotifEnabled: wakeNotifEnabled,
                reminderOffsetMinutes: reminderOffsetMinutes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int bedtimeHour,
                required int bedtimeMinute,
                required int wakeHour,
                required int wakeMinute,
                Value<bool> bedtimeNotifEnabled = const Value.absent(),
                Value<bool> wakeNotifEnabled = const Value.absent(),
                Value<int> reminderOffsetMinutes = const Value.absent(),
              }) => SettingsTableCompanion.insert(
                id: id,
                bedtimeHour: bedtimeHour,
                bedtimeMinute: bedtimeMinute,
                wakeHour: wakeHour,
                wakeMinute: wakeMinute,
                bedtimeNotifEnabled: bedtimeNotifEnabled,
                wakeNotifEnabled: wakeNotifEnabled,
                reminderOffsetMinutes: reminderOffsetMinutes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTableTable,
      Settings,
      $$SettingsTableTableFilterComposer,
      $$SettingsTableTableOrderingComposer,
      $$SettingsTableTableAnnotationComposer,
      $$SettingsTableTableCreateCompanionBuilder,
      $$SettingsTableTableUpdateCompanionBuilder,
      (Settings, BaseReferences<_$AppDatabase, $SettingsTableTable, Settings>),
      Settings,
      PrefetchHooks Function()
    >;
typedef $$TasksTableTableCreateCompanionBuilder =
    TasksTableCompanion Function({
      required String id,
      required String title,
      required String routineType,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$TasksTableTableUpdateCompanionBuilder =
    TasksTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> routineType,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$TasksTableTableFilterComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routineType => $composableBuilder(
    column: $table.routineType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routineType => $composableBuilder(
    column: $table.routineType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get routineType => $composableBuilder(
    column: $table.routineType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$TasksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTableTable,
          Task,
          $$TasksTableTableFilterComposer,
          $$TasksTableTableOrderingComposer,
          $$TasksTableTableAnnotationComposer,
          $$TasksTableTableCreateCompanionBuilder,
          $$TasksTableTableUpdateCompanionBuilder,
          (Task, BaseReferences<_$AppDatabase, $TasksTableTable, Task>),
          Task,
          PrefetchHooks Function()
        > {
  $$TasksTableTableTableManager(_$AppDatabase db, $TasksTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> routineType = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion(
                id: id,
                title: title,
                routineType: routineType,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String routineType,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion.insert(
                id: id,
                title: title,
                routineType: routineType,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTableTable,
      Task,
      $$TasksTableTableFilterComposer,
      $$TasksTableTableOrderingComposer,
      $$TasksTableTableAnnotationComposer,
      $$TasksTableTableCreateCompanionBuilder,
      $$TasksTableTableUpdateCompanionBuilder,
      (Task, BaseReferences<_$AppDatabase, $TasksTableTable, Task>),
      Task,
      PrefetchHooks Function()
    >;
typedef $$LogsTableTableCreateCompanionBuilder =
    LogsTableCompanion Function({
      required String dateKey,
      required String completedTaskIds,
      Value<bool> eveningCompleted,
      Value<bool> morningCompleted,
      Value<DateTime?> eveningCompletedAt,
      Value<DateTime?> morningCompletedAt,
      Value<bool?> napTaken,
      Value<bool?> daytimeSleepiness,
      Value<bool?> feltIrritable,
      Value<int> rowid,
    });
typedef $$LogsTableTableUpdateCompanionBuilder =
    LogsTableCompanion Function({
      Value<String> dateKey,
      Value<String> completedTaskIds,
      Value<bool> eveningCompleted,
      Value<bool> morningCompleted,
      Value<DateTime?> eveningCompletedAt,
      Value<DateTime?> morningCompletedAt,
      Value<bool?> napTaken,
      Value<bool?> daytimeSleepiness,
      Value<bool?> feltIrritable,
      Value<int> rowid,
    });

class $$LogsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LogsTableTable> {
  $$LogsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completedTaskIds => $composableBuilder(
    column: $table.completedTaskIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get eveningCompleted => $composableBuilder(
    column: $table.eveningCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get morningCompleted => $composableBuilder(
    column: $table.morningCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get eveningCompletedAt => $composableBuilder(
    column: $table.eveningCompletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get morningCompletedAt => $composableBuilder(
    column: $table.morningCompletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get napTaken => $composableBuilder(
    column: $table.napTaken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get daytimeSleepiness => $composableBuilder(
    column: $table.daytimeSleepiness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get feltIrritable => $composableBuilder(
    column: $table.feltIrritable,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LogsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LogsTableTable> {
  $$LogsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completedTaskIds => $composableBuilder(
    column: $table.completedTaskIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get eveningCompleted => $composableBuilder(
    column: $table.eveningCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get morningCompleted => $composableBuilder(
    column: $table.morningCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get eveningCompletedAt => $composableBuilder(
    column: $table.eveningCompletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get morningCompletedAt => $composableBuilder(
    column: $table.morningCompletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get napTaken => $composableBuilder(
    column: $table.napTaken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get daytimeSleepiness => $composableBuilder(
    column: $table.daytimeSleepiness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get feltIrritable => $composableBuilder(
    column: $table.feltIrritable,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LogsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LogsTableTable> {
  $$LogsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<String> get completedTaskIds => $composableBuilder(
    column: $table.completedTaskIds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get eveningCompleted => $composableBuilder(
    column: $table.eveningCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get morningCompleted => $composableBuilder(
    column: $table.morningCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get eveningCompletedAt => $composableBuilder(
    column: $table.eveningCompletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get morningCompletedAt => $composableBuilder(
    column: $table.morningCompletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get napTaken =>
      $composableBuilder(column: $table.napTaken, builder: (column) => column);

  GeneratedColumn<bool> get daytimeSleepiness => $composableBuilder(
    column: $table.daytimeSleepiness,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get feltIrritable => $composableBuilder(
    column: $table.feltIrritable,
    builder: (column) => column,
  );
}

class $$LogsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LogsTableTable,
          Log,
          $$LogsTableTableFilterComposer,
          $$LogsTableTableOrderingComposer,
          $$LogsTableTableAnnotationComposer,
          $$LogsTableTableCreateCompanionBuilder,
          $$LogsTableTableUpdateCompanionBuilder,
          (Log, BaseReferences<_$AppDatabase, $LogsTableTable, Log>),
          Log,
          PrefetchHooks Function()
        > {
  $$LogsTableTableTableManager(_$AppDatabase db, $LogsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LogsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LogsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LogsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> dateKey = const Value.absent(),
                Value<String> completedTaskIds = const Value.absent(),
                Value<bool> eveningCompleted = const Value.absent(),
                Value<bool> morningCompleted = const Value.absent(),
                Value<DateTime?> eveningCompletedAt = const Value.absent(),
                Value<DateTime?> morningCompletedAt = const Value.absent(),
                Value<bool?> napTaken = const Value.absent(),
                Value<bool?> daytimeSleepiness = const Value.absent(),
                Value<bool?> feltIrritable = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LogsTableCompanion(
                dateKey: dateKey,
                completedTaskIds: completedTaskIds,
                eveningCompleted: eveningCompleted,
                morningCompleted: morningCompleted,
                eveningCompletedAt: eveningCompletedAt,
                morningCompletedAt: morningCompletedAt,
                napTaken: napTaken,
                daytimeSleepiness: daytimeSleepiness,
                feltIrritable: feltIrritable,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dateKey,
                required String completedTaskIds,
                Value<bool> eveningCompleted = const Value.absent(),
                Value<bool> morningCompleted = const Value.absent(),
                Value<DateTime?> eveningCompletedAt = const Value.absent(),
                Value<DateTime?> morningCompletedAt = const Value.absent(),
                Value<bool?> napTaken = const Value.absent(),
                Value<bool?> daytimeSleepiness = const Value.absent(),
                Value<bool?> feltIrritable = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LogsTableCompanion.insert(
                dateKey: dateKey,
                completedTaskIds: completedTaskIds,
                eveningCompleted: eveningCompleted,
                morningCompleted: morningCompleted,
                eveningCompletedAt: eveningCompletedAt,
                morningCompletedAt: morningCompletedAt,
                napTaken: napTaken,
                daytimeSleepiness: daytimeSleepiness,
                feltIrritable: feltIrritable,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LogsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LogsTableTable,
      Log,
      $$LogsTableTableFilterComposer,
      $$LogsTableTableOrderingComposer,
      $$LogsTableTableAnnotationComposer,
      $$LogsTableTableCreateCompanionBuilder,
      $$LogsTableTableUpdateCompanionBuilder,
      (Log, BaseReferences<_$AppDatabase, $LogsTableTable, Log>),
      Log,
      PrefetchHooks Function()
    >;
typedef $$AchievementsTableTableCreateCompanionBuilder =
    AchievementsTableCompanion Function({
      required String id,
      required DateTime unlockedAt,
      Value<int> rowid,
    });
typedef $$AchievementsTableTableUpdateCompanionBuilder =
    AchievementsTableCompanion Function({
      Value<String> id,
      Value<DateTime> unlockedAt,
      Value<int> rowid,
    });

class $$AchievementsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTableTable> {
  $$AchievementsTableTableFilterComposer({
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

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AchievementsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTableTable> {
  $$AchievementsTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AchievementsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTableTable> {
  $$AchievementsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );
}

class $$AchievementsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AchievementsTableTable,
          Achievement,
          $$AchievementsTableTableFilterComposer,
          $$AchievementsTableTableOrderingComposer,
          $$AchievementsTableTableAnnotationComposer,
          $$AchievementsTableTableCreateCompanionBuilder,
          $$AchievementsTableTableUpdateCompanionBuilder,
          (
            Achievement,
            BaseReferences<_$AppDatabase, $AchievementsTableTable, Achievement>,
          ),
          Achievement,
          PrefetchHooks Function()
        > {
  $$AchievementsTableTableTableManager(
    _$AppDatabase db,
    $AchievementsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> unlockedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementsTableCompanion(
                id: id,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime unlockedAt,
                Value<int> rowid = const Value.absent(),
              }) => AchievementsTableCompanion.insert(
                id: id,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AchievementsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AchievementsTableTable,
      Achievement,
      $$AchievementsTableTableFilterComposer,
      $$AchievementsTableTableOrderingComposer,
      $$AchievementsTableTableAnnotationComposer,
      $$AchievementsTableTableCreateCompanionBuilder,
      $$AchievementsTableTableUpdateCompanionBuilder,
      (
        Achievement,
        BaseReferences<_$AppDatabase, $AchievementsTableTable, Achievement>,
      ),
      Achievement,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
  $$TasksTableTableTableManager get tasksTable =>
      $$TasksTableTableTableManager(_db, _db.tasksTable);
  $$LogsTableTableTableManager get logsTable =>
      $$LogsTableTableTableManager(_db, _db.logsTable);
  $$AchievementsTableTableTableManager get achievementsTable =>
      $$AchievementsTableTableTableManager(_db, _db.achievementsTable);
}
