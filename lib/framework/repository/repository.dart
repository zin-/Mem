import 'package:mem/framework/repository/entity.dart';

/// # Repositoryとは
///
/// システムから外部データを扱う
// ## 語源
//
// 「倉庫」、「貯蔵庫」、「資源のありか」
//
// IT分野においては、データ・コード・ドキュメントなどの情報を保管・格納する場所として用いる
//
// ## 関数名について
//
// 一般的には`getById(id)`, `update(entity)`などとされる場合が多いが、ここでは採用しない
//
// ### 理由
// オブジェクト指向プログラミングにおける原理的な解釈において誤りである
//  「倉庫」が`get`（得る）ことはあるだろうか？
//  抽象的には得ると捉える事もできるだろうが、では`update`（更新する）ことはあるだろうか？
//  更新することはないように感じる
//  よって、ここでは`receive`（受け取る）、`replace`（置き換える）などの荷物や事物を扱う際の単語を採用する
abstract class RepositoryV2<E extends EntityV2> {}

mixin Receiver<E extends EntityV2, Result> on RepositoryV2<E> {
  Future<Result> receive(E entity);
}

// FIXME 型指定は不要なはずなので、おかしい？（間違っている気がする
//  というか、mixinの利用自体がなんか変なので辞めたほうが良いかも
mixin Discarder<E extends EntityV2> on RepositoryV2<E> {
  Future<void> discardAll();
}

abstract class RepositoryV1<E extends EntityV1, Result> {
  Future<Result> receive(E entity);
}
