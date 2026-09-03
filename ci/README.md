# CI 設定

`github-workflow-ci.yml` は GitHub Actions のワークフロー定義。
このリポジトリを作成した GitHub App には `workflows` 権限がなく `.github/workflows/` に直接置けなかったため、ここに置いてある。

有効にするには手動でコピーしてコミットする:

```sh
mkdir -p .github/workflows
cp ci/github-workflow-ci.yml .github/workflows/ci.yml
git add .github/workflows/ci.yml && git commit -m "Enable CI"
```

内容は `scripts/check-<lang>.sh` を言語ごとのジョブで呼ぶだけで、ローカルの `./scripts/check-all.sh` と同じ検証が走る。
