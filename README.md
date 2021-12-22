# verify-jira-deployment-attestations

A GitHub Action that will query [Jira](https://www.atlassian.com/software/jira) for a deployment task and verify that it has all of the necessary approvals. Technical, QA, and Stakeholder approvals can all be checked, but a flag can be set to skip QA approval.

This action has been customized for `im-open's` needs. It uses specific custom field identifiers and assumes a certain approval process is in place. Outside use is not recommended.

## Index

- [verify-jira-deployment-attestations](#verify-jira-deployment-attestations)
  - [Index](#index)
  - [TODOs](#todos)
  - [Inputs](#inputs)
  - [Example](#example)
  - [Contributing](#contributing)
    - [Incrementing the Version](#incrementing-the-version)
  - [Code of Conduct](#code-of-conduct)
  - [License](#license)
  
## TODOs 
- Repository Settings
  - [ ] On the *Options* tab update the repository's visibility
    

## Inputs
| Parameter                          | Is Required | Default | Description                                                                                                                                                          |
| ---------------------------------- | ----------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `domain-name`                      | true        | N/A     | The domain name for Jira.                                                                                                                                            |
| `proposed-build-unique-identifier` | true        | N/A     | A string that will be compared against the proposed build field in order to identify the deployment ticket. This can be the whole value or just a unique part of it. |
| `projects-to-filter-by`            | false       | N/A     | A comma separated string of project names to filter tickets by.                                                                                                      |
| `skip-qa-approval`                 | false       | false   | A flag determining whether or not to skip checking for QA approval. Valid values are "true" and "false".                                                             |
| `check-subtasks`                   | false       | false   | A flag determining whether or not to check for deployment sub-tasks. Valid values are "true" and "false".                                                            |

## Example

```yml
# TODO: Fill in the correct usage
jobs:
  verify-approvals-have-been-given:
    runs-on: ubuntu-20.04
    steps:
      - name: 'Check Jira for Technical, QA, and Stakeholder approvals'
        uses: im-open/verify-jira-deployment-attestations@v1.0.0
        with:
          domain-name: 'jira.company.com'
          proposed-build-unique-identifier: 'my-repo/releases/tag/v1.0.0'
          projects-to-filter-by: 'My Project'
          skip-qa-approval: 'true'
          check-subtasks: 'true'
```

## Contributing

When creating new PRs please ensure:
1. For major or minor changes, at least one of the commit messages contains the appropriate `+semver:` keywords listed under [Incrementing the Version](#incrementing-the-version).
2. The `README.md` example has been updated with the new version.  See [Incrementing the Version](#incrementing-the-version).
3. The action code does not contain sensitive information.

### Incrementing the Version

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