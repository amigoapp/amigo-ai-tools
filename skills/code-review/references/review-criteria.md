# Review Criteria — Universal Code Quality (v1)

Non-security code quality rules applicable across Python, Node.js/Express, and NestJS.

## 1. Error Handling

- **Swallowed errors**: `catch` blocks with an empty body, or that only do `pass` / `// ignore` — errors must be logged or propagated.
- **Missing error propagation**: Async errors not caught or forwarded (e.g., missing `await` on async calls, unhandled promise rejections).
- **Silent failures**: Functions that return `null`, `undefined`, or `false` on failure without logging or throwing, when callers are unlikely to check the return value.

## 2. Code Structure

- **Long functions**: Functions exceeding ~25 lines of substantive logic (excluding comments and blank lines). Flag if the function is doing more than one clear thing.
- **Bloated classes**: Classes with more than ~5 public methods doing clearly unrelated things — likely violating Single Responsibility.
- **Magic values**: Literal numbers or strings used inline without named constants (e.g., `if (status === 3)`, `setTimeout(fn, 86400000)`).

## 3. Naming

- **Non-descriptive names**: Single-letter variable names (outside of loop counters), abbreviations that are not universally understood, or names like `data`, `result`, `temp`, `obj` used for non-trivial values.
- **Boolean naming**: Boolean variables or functions that do not follow `isX`, `hasX`, `canX`, `shouldX` conventions (e.g., `let active` instead of `let isActive`).

## 4. Debug Artifacts

- **Console/print statements**: `console.log`, `console.debug`, `print()`, `debugger` left in production code paths. Fine in test files.
- **Commented-out code**: Blocks of code commented out with no explanation. If it is no longer needed, it should be deleted.

## 5. Documentation

- **Undocumented public APIs**: Public functions, classes, or route handlers with non-obvious parameters or return values and no JSDoc/docstring.
- **Complex logic without comments**: Non-trivial algorithms, regex patterns, or business rules with no inline explanation.

## 6. File Naming

- **Mismatched responsibility**: The file name does not reflect its primary export or responsibility (e.g., a file named `utils.ts` that exclusively defines a `UserAuthService`, or `helpers.js` that contains unrelated domain logic mixed together).
- **Wrong naming convention for the layer**: File names do not follow the expected convention for their role in the project (e.g., a NestJS controller named `user.ts` instead of `user.controller.ts`; a React component file named `userCard.tsx` instead of `UserCard.tsx` or `user-card.tsx` per project convention; a Python module named `UserService.py` instead of `user_service.py`).
- **Vague or generic names**: File names like `index`, `common`, `misc`, `stuff`, or `helpers` used for files that contain cohesive, domain-specific logic that deserves a precise name.
- **Case/format inconsistency**: Mixed casing or delimiter styles across files of the same type in the same directory (e.g., `userService.ts` alongside `product-service.ts` in the same layer; `user_service.py` alongside `UserRepository.py` in the same Python package).

## 7. Testing

- **Untested public functions**: New public functions or methods added without corresponding test coverage. Flag only if a test directory exists in the project (do not flag if no tests exist at all).
- **Assertions missing**: Test files that contain `describe`/`it`/`test` blocks with no assertions inside them (empty or pending tests committed).
