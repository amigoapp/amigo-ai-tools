# Security Rules — Universal (v1)

Security checks applicable across Python, Node.js/Express, and NestJS.
Based on OWASP Top 10 + common patterns seen in production codebases.

## 1. Injection

- **SQL Injection**: User input concatenated directly into SQL strings (e.g., `"SELECT * FROM users WHERE id = " + userId`). Flag any raw string interpolation into queries — parameterized queries / ORMs are required.
- **Command Injection**: User-controlled input passed to `exec()`, `eval()`, `spawn()`, `execSync()`, `os.system()`, `subprocess.call()`, or similar shell execution functions.
- **XSS**: User input rendered into HTML responses without escaping (e.g., `res.send("<div>" + userInput + "</div>")`). Also flag template literals rendering unescaped user data into HTML.

## 2. Authentication & Authorization

- **Missing auth checks**: Routes or endpoints that modify data or expose sensitive information with no authentication middleware applied.
- **Hardcoded credentials**: Passwords, API keys, tokens, or connection strings written directly in source code (not in env vars or secrets management).
- **Secrets in source**: Any `SECRET`, `PASSWORD`, `API_KEY`, `TOKEN`, `PRIVATE_KEY` assigned a literal string value in code.
- **Insecure JWT handling**: JWT verification that does not explicitly validate the algorithm; any code that accepts `alg: "none"`; missing signature verification.

## 3. Sensitive Data Exposure

- **Credentials/PII in logs**: Passwords, tokens, emails, SSNs, or credit card data passed to `console.log`, `print`, `logger.*`, or written to log files.
- **Unencrypted sensitive fields**: Database models or schemas storing passwords in plaintext, or sensitive PII fields with no encryption annotation.
- **Secrets in error responses**: Error messages returned to the client that include stack traces, internal paths, DB error details, or credential values.

## 4. Security Misconfiguration

- **Debug mode in production**: `DEBUG=True`, `NODE_ENV` not set to `production`, or dev-only settings (e.g., `app.use(errorHandler())` with stack traces) present in production config files.
- **Permissive CORS**: `cors({ origin: "*" })` or equivalent with no restrictions — flag unless it is a public, read-only API.
- **Missing security headers**: No Helmet (Node.js) or equivalent security header middleware applied to the app. Flag if HTTP security headers (CSP, HSTS, X-Frame-Options) are absent.
- **Stack traces in responses**: Express/NestJS error handlers that return `err.stack` or `err.message` in JSON responses to the client.

## 5. Vulnerable Dependencies

Flag only if a **known CVE** is directly visible in the diff — e.g., a dependency pinned to a specific version known to be vulnerable, or a comment referencing a CVE. Do not flag general "dependency might be outdated" concerns without evidence.

## 6. Broken Access Control

- **Missing ownership checks**: Code that fetches or modifies records by ID from user input without verifying the requesting user owns or has access to that record (e.g., `GET /orders/:id` with no `req.user.id === order.userId` check).
- **Unguarded admin endpoints**: Routes prefixed `/admin` or handling privileged operations with no role/permission guard applied.

## 7. Cryptography

- **Weak hashing**: MD5 or SHA1 used for password hashing. Acceptable algorithms: bcrypt, argon2, scrypt.
- **Insecure random**: `Math.random()` or `random.random()` used to generate security tokens, session IDs, CSRF tokens, or any value that must be unpredictable.
- **Missing salt**: Password hashing performed without a unique salt per user.

## 8. Input Validation

- **Unsanitized DB input**: User-supplied data passed to database queries, filters, or aggregations without validation or sanitization.
- **Unvalidated file uploads**: File upload handlers that do not check MIME type, file extension, or file size limits.
- **Unvalidated external API responses**: Data from third-party APIs used without schema validation before being processed or stored.
