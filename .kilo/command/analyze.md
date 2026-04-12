# Analyze Flutter Code

Run the Flutter analyzer and linter to ensure code quality and adherence to constraints.

## Command
`flutter analyze && flutter format --set-exit-if-changed .`

## Expectations
The agent should fix any missing `const` modifiers, unused imports, or formatting issues found during this command before submitting code.