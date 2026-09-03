//! データ構造とパターンマッチ (no_std)。
//! 題材: 在庫 (Item) と、数式 (Expr) の評価器。
//! ヒープなしでどこまで書けるか、alloc を足すと何が増えるかを見る。

#![cfg_attr(not(test), no_std)]

#[cfg(feature = "alloc")]
extern crate alloc;

/// 構造体 (レコード)。`derive` で比較・複製・デバッグ表示を自動実装
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Item {
    pub name: &'static str,
    pub price: u32,
    pub qty: u32,
    pub category: Category,
}

/// 列挙型 (ペイロードなし)
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Category {
    Food,
    Tool,
}

/// 再帰的な代数的データ型。no_std では Box が使えないので参照 + ライフタイムで木を作る
#[derive(Debug, Clone, Copy)]
pub enum Expr<'a> {
    Num(i64),
    Add(&'a Expr<'a>, &'a Expr<'a>),
    Mul(&'a Expr<'a>, &'a Expr<'a>),
}

/// 再帰的なパターンマッチで評価する
pub fn eval(e: &Expr) -> i64 {
    match e {
        Expr::Num(n) => *n,
        Expr::Add(a, b) => eval(a) + eval(b),
        Expr::Mul(a, b) => eval(a) * eval(b),
    }
}

/// スライスとイテレータ。map / filter / sum はすべて core にある
pub fn total_value(items: &[Item]) -> u32 {
    items.iter().map(|i| i.price * i.qty).sum()
}

pub fn in_stock_count(items: &[Item]) -> usize {
    items.iter().filter(|i| i.qty > 0).count()
}

/// Option を返す検索。`find` は core
pub fn find<'a>(items: &'a [Item], name: &str) -> Option<&'a Item> {
    items.iter().find(|i| i.name == name)
}

/// スライスのパターンマッチ: 先頭要素と残り
pub fn first_name(items: &[Item]) -> Option<&'static str> {
    match items {
        [] => None,
        [head, ..] => Some(head.name),
    }
}

/// 固定長配列で「カテゴリ別の集計」。Map がなくても enum をインデックスにすれば集計できる
pub fn value_by_category(items: &[Item]) -> [u32; 2] {
    let mut acc = [0u32; 2];
    for i in items {
        acc[i.category as usize] += i.price * i.qty;
    }
    acc
}

/// alloc があれば Vec / BTreeMap が使える (HashMap は std 専用)
#[cfg(feature = "alloc")]
pub fn names_sorted(items: &[Item]) -> alloc::vec::Vec<&'static str> {
    let mut v: alloc::vec::Vec<_> = items.iter().map(|i| i.name).collect();
    v.sort_unstable();
    v
}

#[cfg(feature = "alloc")]
pub fn qty_map(items: &[Item]) -> alloc::collections::BTreeMap<&'static str, u32> {
    items.iter().map(|i| (i.name, i.qty)).collect()
}

pub const SAMPLE: [Item; 3] = [
    Item { name: "apple", price: 100, qty: 3, category: Category::Food },
    Item { name: "hammer", price: 1500, qty: 0, category: Category::Tool },
    Item { name: "bread", price: 200, qty: 2, category: Category::Food },
];

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn expr_eval() {
        // (1 + 2) * 4
        let one = Expr::Num(1);
        let two = Expr::Num(2);
        let four = Expr::Num(4);
        let sum = Expr::Add(&one, &two);
        let e = Expr::Mul(&sum, &four);
        assert_eq!(eval(&e), 12);
    }

    #[test]
    fn slices() {
        assert_eq!(total_value(&SAMPLE), 700);
        assert_eq!(in_stock_count(&SAMPLE), 2);
        assert_eq!(find(&SAMPLE, "bread").map(|i| i.qty), Some(2));
        assert_eq!(find(&SAMPLE, "milk"), None);
        assert_eq!(first_name(&SAMPLE), Some("apple"));
        assert_eq!(first_name(&[]), None);
        assert_eq!(value_by_category(&SAMPLE), [700, 0]);
    }

    #[test]
    #[cfg(feature = "alloc")]
    fn with_alloc() {
        assert_eq!(names_sorted(&SAMPLE), ["apple", "bread", "hammer"]);
        assert_eq!(qty_map(&SAMPLE)["hammer"], 0);
    }
}
