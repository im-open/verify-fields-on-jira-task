# verify-fields-on-jira-task

A GitHub Action that will query [Jira](https://www.atlassian.com/software/jira) for a ticket and verify that it has values for the designated fields. It does not check the values themselves, just verifies that values exist.

This action has been customized for `im-open's` needs. Outside users will need to override the default values.

## Index <!-- omit in toc -->

- [verify-fields-on-jira-task](#verify-fields-on-jira-task)
  - [Inputs](#inputs)
  - [Usage Examples](#usage-examples)
  - [Contributing](#contributing)
    - [Incrementing the Version](#incrementing-the-version)
    - [Source Code Changes](#source-code-changes)
    - [Updating the README.md](#updating-the-readmemd)
  - [Code of Conduct](#code-of-conduct)
  - [License](#license)

## Inputs

| Parameter                    | Is Required | Default                              | Description                                                                                                                                                          |
|------------------------------|-------------|--------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `domain-name`                | true        | N/A                                  | The domain name for Jira. |
| `project-names-to-search`    | false       | N/A                                  | A comma separated string of project names to search through for the desired Jira ticket. Spaces will be trimmed. Either this or issue-types-to-search should be set. |
| `fields-to-check-for-values` | true        | customfield_16323, customfield_11506 | A comma separated string of fields that will be checked for values. Spaces will be trimmed. |
| `check-parent-task`          | false       | false                                | A flag determining whether the parent task will be checked in the event a value isn't found on the task itself. |
| `jira-ticket`                | true        | N/A                                  | The Jira Ticket in which to verify that it has values for the designated fields. |

## Usage Examples

**Minimal example using defaults**

```yml
jobs:
  verify-approvals-have-been-given:
    runs-on: ubuntu-20.04
    steps:
      - name: 'Check a Deployment Task for Technical and Stakeholder approvals'
        # You may also reference just the major or major.minor version
        uses: im-open/verify-fields-on-jira-task@v1.0.3
        with:
          domain-name: 'jira.company.com'
          search-value: 'my-repo/releases/tag/v1.0.0'
```

**Full example overriding defaults**

```yml
jobs:
  verify-ticket-has-fields-set:
    runs-on: ubuntu-20.04
    steps:
      - name: 'Check Jira ticket for two mandatory fields'
        uses: im-open/verify-fields-on-jira-task@v1.0.3
        with:
          domain-name: 'jira.company.com'
          project-names-to-search: 'First Project, Second Project'
          fields-to-check-for-values: 'customfield_2345, customfield_3456'
          check-parent-task: 'true'
```

## Contributing

When creating PRs, please review the following guidelines:

- [ ] The action code does not contain sensitive information.
- [ ] At least one of the commit messages contains the appropriate `+semver:` keywords listed under [Incrementing the Version] for major and minor increments.
- [ ] The README.md has been updated with the latest version of the action.  See [Updating the README.md] for details.

### Incrementing the Version

This repo uses [git-version-lite] in its workflows to examine commit messages to determine whether to perform a major, minor or patch increment on merge if [source code] changes have been made.  The following table provides the fragment that should be included in a commit message to active different increment strategies.

| Increment Type | Commit Message Fragment                     |
|----------------|---------------------------------------------|
| major          | +semver:breaking                            |
| major          | +semver:major                               |
| minor          | +semver:feature                             |
| minor          | +semver:minor                               |
| patch          | *default increment type, no comment needed* |

### Source Code Changes

The files and directories that are considered source code are listed in the `files-with-code` and `dirs-with-code` arguments in both the [build-and-review-pr] and [increment-version-on-merge] workflows.  

If a PR contains source code changes, the README.md should be updated with the latest action version.  The [build-and-review-pr] workflow will ensure these steps are performed when they are required.  The workflow will provide instructions for completing these steps if the PR Author does not initially complete them.

If a PR consists solely of non-source code changes like changes to the `README.md` or workflows under `./.github/workflows`, version updates do not need to be performed.

### Updating the README.md

If changes are made to the action's [source code], the [usage examples] section of this file should be updated with the next version of the action.  Each instance of this action should be updated.  This helps users know what the latest tag is without having to navigate to the Tags page of the repository.  See [Incrementing the Version] for details on how to determine what the next version will be or consult the first workflow run for the PR which will also calculate the next version.

## Code of Conduct

This project has adopted the [im-open's Code of Conduct](https://github.com/im-open/.github/blob/main/CODE_OF_CONDUCT.md).

## License

Copyright &copy; 2023, Extend Health, LLC. Code released under the [MIT license](LICENSE).

<!-- Links -->
[Incrementing the Version]: #incrementing-the-version
[Updating the README.md]: #updating-the-readmemd
[source code]: #source-code-changes
[usage examples]: #usage-examples
[build-and-review-pr]: ./.github/workflows/build-and-review-pr.yml
[increment-version-on-merge]: ./.github/workflows/increment-version-on-merge.yml
[git-version-lite]: https://github.com/im-open/git-version-lite
