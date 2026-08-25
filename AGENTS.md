# Codex Project Rules

## Base branch

- dev 是当前项目整合底座。
- 禁止未经明确要求执行 `git merge main`。
- 禁止 `git reset --hard`。
- 禁止删除用户现有修改。

## Scope discipline

- 只修改当前任务必要文件。
- 禁止因为发现邻近问题自行扩大任务。
- 禁止无关重构。
- 禁止新增依赖，除非任务明确允许。

## Verification policy

Never claim a task is verified without evidence.

Every required check must be classified as:

- PASS: actually executed and succeeded
- FAIL: actually executed and failed
- NOT RUN: not executed

NOT RUN is never PASS.

After modifications always execute when applicable:

`git status --short`
`git diff --name-only`
`git diff --stat`
`git diff --check`

Critical modifications must be read back or searched after writing.

When a relevant build/test command exists, actually execute it.

If execution is impossible because of environment, dependencies or permissions, mark it NOT RUN.

Never describe “looks correct”, “should work”, or “implemented” as verification evidence.

## Final task status

VERIFIED = every mandatory acceptance item PASS

PARTIALLY VERIFIED = implementation exists but one or more mandatory checks are NOT RUN

FAILED = one or more mandatory checks FAIL