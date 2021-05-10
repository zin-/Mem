import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'database.g.dart';

@SqfEntityBuilder(memDbModel)
const memDbModel = SqfEntityModel(
  modelName: 'MemDbModel',
  databaseName: 'mem.db',
  password: null,
  databaseTables: [
    tableMem,
  ],
  bundledDatabasePath: null,
);

const tableMem = SqfEntityTable(
  tableName: 'memTable',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: true,
  modelName: null,
  fields: [
    SqfEntityField('name', DbType.text),
    SqfEntityField('remarks', DbType.text),
  ],
);
