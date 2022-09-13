// Mocks generated by Mockito 5.3.0 from annotations
// in mem/test/mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:mem/database/database.dart' as _i2;
import 'package:mem/repositories/mem_item_repository.dart' as _i4;
import 'package:mem/repositories/mem_repository.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeTable_0 extends _i1.SmartFake implements _i2.Table {
  _FakeTable_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeMemEntity_1 extends _i1.SmartFake implements _i3.MemEntity {
  _FakeMemEntity_1(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

class _FakeMemItemEntity_2 extends _i1.SmartFake implements _i4.MemItemEntity {
  _FakeMemItemEntity_2(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [MemRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockMemRepository extends _i1.Mock implements _i3.MemRepository {
  MockMemRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Table get table => (super.noSuchMethod(Invocation.getter(#table),
      returnValue: _FakeTable_0(this, Invocation.getter(#table))) as _i2.Table);
  @override
  set table(_i2.Table? _table) =>
      super.noSuchMethod(Invocation.setter(#table, _table),
          returnValueForMissingStub: null);
  @override
  _i3.MemEntity fromMap(Map<String, dynamic>? valueMap) => (super.noSuchMethod(
          Invocation.method(#fromMap, [valueMap]),
          returnValue:
              _FakeMemEntity_1(this, Invocation.method(#fromMap, [valueMap])))
      as _i3.MemEntity);
  @override
  _i5.Future<_i3.MemEntity> receive(Map<String, dynamic>? valueMap) =>
      (super.noSuchMethod(Invocation.method(#receive, [valueMap]),
              returnValue: _i5.Future<_i3.MemEntity>.value(_FakeMemEntity_1(
                  this, Invocation.method(#receive, [valueMap]))))
          as _i5.Future<_i3.MemEntity>);
  @override
  _i5.Future<List<_i3.MemEntity>> ship(
          {bool? archived,
          List<String>? whereColumns,
          List<dynamic>? whereArgs}) =>
      (super.noSuchMethod(
              Invocation.method(#ship, [], {
                #archived: archived,
                #whereColumns: whereColumns,
                #whereArgs: whereArgs
              }),
              returnValue:
                  _i5.Future<List<_i3.MemEntity>>.value(<_i3.MemEntity>[]))
          as _i5.Future<List<_i3.MemEntity>>);
  @override
  _i5.Future<_i3.MemEntity> shipById(dynamic id) =>
      (super.noSuchMethod(Invocation.method(#shipById, [id]),
              returnValue: _i5.Future<_i3.MemEntity>.value(
                  _FakeMemEntity_1(this, Invocation.method(#shipById, [id]))))
          as _i5.Future<_i3.MemEntity>);
  @override
  _i5.Future<_i3.MemEntity> update(_i3.MemEntity? entity) =>
      (super.noSuchMethod(Invocation.method(#update, [entity]),
              returnValue: _i5.Future<_i3.MemEntity>.value(
                  _FakeMemEntity_1(this, Invocation.method(#update, [entity]))))
          as _i5.Future<_i3.MemEntity>);
  @override
  _i5.Future<_i3.MemEntity> archive(_i3.MemEntity? entity) =>
      (super.noSuchMethod(Invocation.method(#archive, [entity]),
              returnValue: _i5.Future<_i3.MemEntity>.value(_FakeMemEntity_1(
                  this, Invocation.method(#archive, [entity]))))
          as _i5.Future<_i3.MemEntity>);
  @override
  _i5.Future<_i3.MemEntity> unarchive(_i3.MemEntity? entity) =>
      (super.noSuchMethod(Invocation.method(#unarchive, [entity]),
              returnValue: _i5.Future<_i3.MemEntity>.value(_FakeMemEntity_1(
                  this, Invocation.method(#unarchive, [entity]))))
          as _i5.Future<_i3.MemEntity>);
  @override
  _i5.Future<bool> discardById(dynamic id) =>
      (super.noSuchMethod(Invocation.method(#discardById, [id]),
          returnValue: _i5.Future<bool>.value(false)) as _i5.Future<bool>);
  @override
  _i5.Future<int> discardAll() =>
      (super.noSuchMethod(Invocation.method(#discardAll, []),
          returnValue: _i5.Future<int>.value(0)) as _i5.Future<int>);
}

/// A class which mocks [MemItemRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockMemItemRepository extends _i1.Mock implements _i4.MemItemRepository {
  MockMemItemRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Table get table => (super.noSuchMethod(Invocation.getter(#table),
      returnValue: _FakeTable_0(this, Invocation.getter(#table))) as _i2.Table);
  @override
  set table(_i2.Table? _table) =>
      super.noSuchMethod(Invocation.setter(#table, _table),
          returnValueForMissingStub: null);
  @override
  _i5.Future<List<_i4.MemItemEntity>> shipByMemId(int? memId) =>
      (super.noSuchMethod(Invocation.method(#shipByMemId, [memId]),
          returnValue: _i5.Future<List<_i4.MemItemEntity>>.value(
              <_i4.MemItemEntity>[])) as _i5.Future<List<_i4.MemItemEntity>>);
  @override
  _i5.Future<List<_i4.MemItemEntity>> archiveByMemId(int? memId) =>
      (super.noSuchMethod(Invocation.method(#archiveByMemId, [memId]),
          returnValue: _i5.Future<List<_i4.MemItemEntity>>.value(
              <_i4.MemItemEntity>[])) as _i5.Future<List<_i4.MemItemEntity>>);
  @override
  _i5.Future<List<_i4.MemItemEntity>> unarchiveByMemId(int? memId) =>
      (super.noSuchMethod(Invocation.method(#unarchiveByMemId, [memId]),
          returnValue: _i5.Future<List<_i4.MemItemEntity>>.value(
              <_i4.MemItemEntity>[])) as _i5.Future<List<_i4.MemItemEntity>>);
  @override
  _i5.Future<List<bool>> discardByMemId(int? memId) =>
      (super.noSuchMethod(Invocation.method(#discardByMemId, [memId]),
              returnValue: _i5.Future<List<bool>>.value(<bool>[]))
          as _i5.Future<List<bool>>);
  @override
  _i4.MemItemEntity fromMap(Map<String, dynamic>? valueMap) =>
      (super.noSuchMethod(Invocation.method(#fromMap, [valueMap]),
              returnValue: _FakeMemItemEntity_2(
                  this, Invocation.method(#fromMap, [valueMap])))
          as _i4.MemItemEntity);
  @override
  _i5.Future<_i4.MemItemEntity> receive(Map<String, dynamic>? valueMap) =>
      (super.noSuchMethod(Invocation.method(#receive, [valueMap]),
          returnValue: _i5.Future<_i4.MemItemEntity>.value(_FakeMemItemEntity_2(
              this, Invocation.method(#receive, [valueMap])))) as _i5
          .Future<_i4.MemItemEntity>);
  @override
  _i5.Future<List<_i4.MemItemEntity>> ship(
          {bool? archived,
          List<String>? whereColumns,
          List<dynamic>? whereArgs}) =>
      (super.noSuchMethod(
          Invocation.method(#ship, [], {
            #archived: archived,
            #whereColumns: whereColumns,
            #whereArgs: whereArgs
          }),
          returnValue: _i5.Future<List<_i4.MemItemEntity>>.value(
              <_i4.MemItemEntity>[])) as _i5.Future<List<_i4.MemItemEntity>>);
  @override
  _i5.Future<_i4.MemItemEntity> shipById(dynamic id) => (super.noSuchMethod(
          Invocation.method(#shipById, [id]),
          returnValue: _i5.Future<_i4.MemItemEntity>.value(
              _FakeMemItemEntity_2(this, Invocation.method(#shipById, [id]))))
      as _i5.Future<_i4.MemItemEntity>);
  @override
  _i5.Future<_i4.MemItemEntity> update(_i4.MemItemEntity? entity) =>
      (super.noSuchMethod(Invocation.method(#update, [entity]),
          returnValue: _i5.Future<_i4.MemItemEntity>.value(_FakeMemItemEntity_2(
              this, Invocation.method(#update, [entity])))) as _i5
          .Future<_i4.MemItemEntity>);
  @override
  _i5.Future<_i4.MemItemEntity> archive(_i4.MemItemEntity? entity) =>
      (super.noSuchMethod(Invocation.method(#archive, [entity]),
          returnValue: _i5.Future<_i4.MemItemEntity>.value(_FakeMemItemEntity_2(
              this, Invocation.method(#archive, [entity])))) as _i5
          .Future<_i4.MemItemEntity>);
  @override
  _i5.Future<_i4.MemItemEntity> unarchive(_i4.MemItemEntity? entity) =>
      (super.noSuchMethod(Invocation.method(#unarchive, [entity]),
          returnValue: _i5.Future<_i4.MemItemEntity>.value(_FakeMemItemEntity_2(
              this, Invocation.method(#unarchive, [entity])))) as _i5
          .Future<_i4.MemItemEntity>);
  @override
  _i5.Future<bool> discardById(dynamic id) =>
      (super.noSuchMethod(Invocation.method(#discardById, [id]),
          returnValue: _i5.Future<bool>.value(false)) as _i5.Future<bool>);
  @override
  _i5.Future<int> discardAll() =>
      (super.noSuchMethod(Invocation.method(#discardAll, []),
          returnValue: _i5.Future<int>.value(0)) as _i5.Future<int>);
}
