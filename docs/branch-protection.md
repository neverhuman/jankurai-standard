# Branch protection

GitHub is authoritative for `neverhuman/jankurai-standard`. Protected `main`
settings verified on September 9, 2026 require both `quality` and
`jankurai-standard/required`, each bound to GitHub Actions app 15368. The
aggregate accepts exactly one successful `quality` result; missing, renamed,
failed, cancelled, or skipped lanes fail it.

Strict checks require an up-to-date PR branch. Administrator enforcement,
linear history, and conversation resolution are enabled. Force pushes and
branch deletion are disabled. Merge through a PR after reviewing the complete
final diff and actual checks for its exact head; qualify resulting main and
its immutable `ci-<full-sha>` tag before selecting it downstream.

The existing approval count is zero; stale reviews are dismissed, while code
owner approval, last-push approval, and signed commits are not currently
required by GitHub. This is a factual settings record, not a substitute for
review or a claim of independent approval. Preserve the existing settings
during repairs. The wider program's independent deployment approval remains a
separate acceptance requirement.

`ci.yml` publishes an immutable qualification tag after successful resulting-main
checks. It does not publish a versioned product release. Verify the selected
commit and evidence before creating a release tag, then retain the tag and
assets unchanged. See [release process](release.md).

Changes to the accepted baseline and its provenance require the same complete
diff review and checks as other source changes. A badge documents its linked
audited revision; it is not a claim that every later commit has passed.
