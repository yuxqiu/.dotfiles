---
name: review
description: Code review and improvement guidelines for any codebase. Use when asked to review code, then improve it based on findings.
---

# Code Review & Improvement Skill

## When to Use This Skill

Use this skill when:
- You need to review code changes or PRs
- You are asked to "review and improve" code
- You want systematic feedback on code structure, security, or patterns
- You need to make improvements after reviewing code

## Workflow

### Phase 1: Review

Follow the checklist below to thoroughly review the code:

### Review Checklist

#### 1. Correctness & Logic
- Does the code do what it's supposed to do?
- Are there edge cases or corner cases not handled?
- Are there potential null/undefined accesses?
- Are error cases handled properly?

#### 2. Security
- Are any user inputs validated/sanitized?
- Are secrets, API keys, or credentials properly handled?
- Are there any injection vulnerabilities (SQL, command, etc.)?
- Are file operations secure (path traversal, etc.)?
- Is authentication/authorization properly implemented?

#### 3. Performance
- Are there unnecessary loops or O(n²) algorithms?
- Are database queries optimized with proper indexes/joins?
- Is there redundant computation that could be cached?
- Are large data structures loaded into memory efficiently?

#### 4. Code Structure & Design
- Does the code follow single responsibility principle?
- Is there proper separation of concerns?
- Are related functions grouped logically?
- Is there code duplication that should be extracted?

#### 5. Maintainability
- Are variable/function names descriptive?
- Are complex sections commented?
- Is the code testable?
- Are there appropriate abstractions?

#### 6. Error Handling
- Are errors caught and handled appropriately?
- Is there proper logging?
- Are error messages user-friendly?

#### 7. Dependencies
- Are only necessary dependencies included?
- Is the code tied to unnecessary external services?
- Are version constraints reasonable?

#### 8. Testing
- Are there adequate tests for the code?
- Do tests cover happy path and edge cases?
- Are tests isolated and reproducible?

### Phase 2: Improve

After completing the review, implement improvements following this priority order:

1. **Correctness** - Fix bugs and logic errors first
2. **Security** - Fix any security vulnerabilities
3. **Performance** - Profile before optimizing, focus on hot paths
4. **Structure** - Refactor for clarity and maintainability
5. **Tests** - Add or improve tests to verify behavior
6. **Documentation** - Add comments for complex logic

When improving code:
- Make one logical change at a time
- Commit each improvement with a descriptive message
- Run tests after making changes to ensure nothing breaks
- Verify the improvements actually solve the identified issues

## Output Format

When reviewing, structure your feedback:

```
## Summary
[Brief overview of what the code does and overall quality]

## Issues Found
### Critical
- [Issue description and fix]

### Major
- [Issue description and fix]

### Minor
- [Issue description and fix]

## Improvements Made
- [List of improvements applied after review]
```

Be specific with code references (file:line) and provide concrete fix suggestions.
