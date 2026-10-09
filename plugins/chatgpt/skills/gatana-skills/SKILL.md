---
name: gatana-skills
description: Use at the start of any work task, before you plan or act, to check whether your organization has a Gatana skill for it (how to deploy, review, investigate, report and other work done here) and follow it. Also use when the user asks to find, save or change a team skill or "how we do X".
---

# Gatana skills

Your organization keeps its skills in Gatana: Markdown instructions that say how a kind of work is done here. The Gatana tools return only the skills that the signed-in user can read.

## At the start of a task

1. List the skills. Call the Gatana tool `skills_list_skills` (in some clients the name has a prefix, such as `mcp__gatana__skills_list_skills`). Give a short `query` when the task has a clear keyword, or no arguments to list all.
2. Read the list. Each line has a name, a description of when the skill applies, and a date. Skills are grouped by collection.
3. When a skill applies, read it with `skills_get_skill` and its `name`. Follow its instructions for this task. Tell the user which skill you follow.
4. When no skill applies, do the task as usual. Do not mention the check.

List the skills once per task. List them again only when the task changes.

## When the gateway runs in code mode

Some Gatana gateways expose only two tools: `codemode_search_tools` and `codemode_execute_code`. Then call the skills tools from code:

```js
console.log(await codemode.skills.listSkills({}));
console.log(await codemode.skills.getSkill({ name: 'skill-name' }));
```

## Saving a skill

When the user asks to keep "how we did this" for the team, call `skills_create_skill` with:

- `name`: kebab-case, unique in the organization
- `description`: one line that says when the skill applies, written for an agent that decides whether to use it
- `content`: the Markdown instructions, without frontmatter

Every member can read a new skill. To keep it private to some teams, give `team_names`. To change a skill, use `skills_update_skill`.

## When the tools are missing

If no Gatana tools are available, tell the user to connect the Gatana plugin, and do the task without it.
