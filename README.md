# verify-fields-on-jira-task

A GitHub Action that will query [Jira](https://www.atlassian.com/software/jira) for a ticket and verify that it has values for the designated fields. It does not check the values themselves, just verifies that values exist.

This action has been customized for `im-open's` needs. Outside users will need to override the default values.

## Index

- [verify-fields-on-jira-task](#verify-fields-on-jira-task)
  - [Index](#index)
  - [Inputs](#inputs)
  - [Example](#example)
  - [Contributing](#contributing)
    - [Incrementing the Version](#incrementing-the-version)
  - [Code of Conduct](#code-of-conduct)
  - [License](#license)
    

## Inputs
| Parameter                    | Is Required | Default                              | Description                                                                                                                                                          |
| ---------------------------- | ----------- | ------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `domain-name`                | true        | N/A                                  | The domain name for Jira.                                                                                                                                            |
| `project-names-to-search`    | false       | N/A                                  | A comma separated string of project names to search through for the desired Jira ticket. Spaces will be trimmed. Either this or issue-types-to-search should be set. |
| `issue-types-to-search`      | false       | Deployment Task, Deployment Sub-Task | A comma separated string of issue types to search through for the desired Jira ticket. Spaces will be trimmed. Either this or project-names-to-search should be set. |
| `search-field-id`            | true        | 11902                                | The field id of the field to search by.                                                                                                                              |
| `search-value`               | true        | N/A                                  | The value the field, designated by search-field-id, should be set to on the Jira ticket being searched for.                                                          |
| `fields-to-check-for-values` | true        | customfield_16323, customfield_11506 | A comma separated string of fields that will be checked for values. Spaces will be trimmed.                                                                          |
| `check-parent-task`          | false       | false                                | A flag determining whether the parent task will be checked in the event a value isn't found on the task itself.                                                      |

## Example
**Minimal example using defaults**
```yml
jobs:
  verify-approvals-have-been-given:
    runs-on: ubuntu-20.04
    steps:
      - name: 'Check a Deployment Task for Technical and Stakeholder approvals'
        # You may also reference just the major or major.minor version
        uses: im-open/verify-fields-on-jira-task@v1.0.2
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
        uses: im-open/verify-fields-on-jira-task@v1.0.2
        with:
          domain-name: 'jira.company.com'
          project-names-to-search: 'First Project, Second Project'
          issue-types-to-search: 'Task, Subtask'
          search-field-id: '12345'
          search-value: 'my-repo/releases/tag/v1.0.0'
          fields-to-check-for-values: 'customfield_2345, customfield_3456'
          check-parent-task: 'true'
```

## Contributing

When creating new PRs please ensure:

1. For major or minor changes, at least one of the commit messages contains the appropriate `+semver:` keywords listed under [Incrementing the Version](#incrementing-the-version).
1. The action code does not contain sensitive information.

When a pull request is created and there are changes to code-specific files and folders, the `auto-update-readme` workflow will run.  The workflow will update the action-examples in the README.md if they have not been updated manually by the PR author. The following files and folders contain action code and will trigger the automatic updates:

- `action.yml`
- `src/**`

There may be some instances where the bot does not have permission to push changes back to the branch though so this step should be done manually for those branches. See [Incrementing the Version](#incrementing-the-version) for more details.

### Incrementing the Version

The `auto-update-readme` and PR merge workflows will use the strategies below to determine what the next version will be.  If the `auto-update-readme` workflow was not able to automatically update the README.md action-examples with the next version, the README.md should be updated manually as part of the PR using that calculated version.

This action uses [git-version-lite] to examine commit messages to determine whether to perform a major, minor or patch increment on merge.  The following table provides the fragment that should be included in a commit message to active different increment strategies.
| Increment Type | Commit Message Fragment                     |
| -------------- | ------------------------------------------- |
| major          | +semver:breaking                            |
| major          | +semver:major                               |
| minor          | +semver:feature                             |
| minor          | +semver:minor                               |
| patch          | *default increment type, no comment needed* |

## Code of Conduct

This project has adopted the [im-open's Code of Conduct](https://github.com/im-open/.github/blob/master/CODE_OF_CONDUCT.md).

## License

Copyright &copy; 2021, Extend Health, LLC. Code released under the [MIT license](LICENSE).

[git-version-lite]: https://github.com/im-open/git-version-lite
