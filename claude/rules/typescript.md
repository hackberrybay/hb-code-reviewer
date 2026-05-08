# TypeScript Rules

Team-wide TypeScript best practices. Edit this file via PR — changes apply to the next review automatically.

---

## Type Safety

- TypeScript strict mode MUST be enabled in `tsconfig.json` (`"strict": true`).
- Never use `any`. If the type is truly unknown, use `unknown` and narrow it.
- Every exported function and method MUST have an explicit return type annotation.
- Unsafe type assertions (`as SomeType`) MUST be preceded by a runtime guard or comment explaining why it's safe.
- Non-null assertions (`value!`) MUST NOT be used without a preceding null check.
- Nullable values received from external sources (API responses, DB results) MUST be explicitly handled — do not assume they are defined.

## Async

- Always use `async`/`await`. Never use `.then()`/`.catch()` chains.
- Every `async` call MUST be awaited or explicitly detached with a comment.
- Never let a Promise float without handling its rejection.
- `Promise.all` MUST be used when awaiting multiple independent async operations.

## Error Handling

- Throw typed errors at system boundaries (API calls, DB, external services). Let them propagate naturally inside.
- Never swallow errors silently. An empty `catch` block MUST include at minimum a log statement.
- Do not return `null` to signal failure — throw an error or return a `Result` type.
- User-facing error messages MUST NOT include stack traces or internal implementation details.

## Functions

- Functions MUST be small and single-purpose. If a function needs a comment to explain what it does, split it.
- Functions with more than 4 parameters MUST use a typed options object instead.
- No premature abstractions. Solve the problem at hand — do not generalize for hypothetical future use cases.

## Imports and Exports

- Use named exports. Default exports only for React components and route/page files.
- Import from the public barrel export of a package, not from internal paths.
- Import order: external packages → internal packages → relative imports.
- Never re-export types that are already exported from another module.

## Constants and Configuration

- Magic numbers and strings MUST be named constants.
- Environment-specific values (URLs, ports, credentials) MUST come from environment variables — never hardcoded.
- Environment variables MUST be accessed through a typed config module, not directly via `process.env`.

## React (if applicable)

- `useEffect` dependency arrays MUST include every value read inside the effect.
- Never mutate state directly — always use the setter.
- Avoid re-creating objects or functions inside render — use `useMemo` or `useCallback` when the value is a dependency.

---

## Auto-promoted

<!-- Rules promoted by /improve-rules appear here. Do not edit manually. -->
