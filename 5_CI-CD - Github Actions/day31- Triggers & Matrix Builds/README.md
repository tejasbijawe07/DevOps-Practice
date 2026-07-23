## Triggers & Matrix Builds

#### Your pipeline runs on push. Today we learn every way to trigger a workflow and how to run jobs across multiple environments at once.

---

Task 1: Trigger on Pull Request
- Create `.github/workflows/pr-check.yml`
- Trigger it only when a pull request is opened or updated against main
- Add a step that prints: `PR check running for branch: <branch name>`
- Create a new branch, push a commit, and open a PR
- Watch the workflow run automatically
- Verify: Does it show up on the PR page?
