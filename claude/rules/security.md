# Security Rules

OWASP-aligned security rules for the team. Edit via PR. Apply before any major release or security-critical feature.

---

## Secrets and Credentials

- Never hardcode API keys, passwords, tokens, or connection strings in source code.
- Never commit `.env` files containing real credentials. Use `.env.example` with placeholder values.
- Secrets MUST be loaded from environment variables through a typed config module.
- Secrets MUST NOT appear in logs, error messages, or API responses.

## Authentication and Authorization

- Every endpoint that performs a write or reads private data MUST verify the caller's identity.
- Never trust client-supplied user IDs or resource IDs for ownership checks — always verify on the server.
- JWT tokens MUST have their signature verified before trusting any claims.
- Session tokens MUST have an expiry. Tokens without expiry MUST NOT be issued.
- Authentication failures MUST be logged (without logging the attempted credential).

## Input Validation

- All external input (request bodies, query params, headers, URL params) MUST be validated at the boundary before use.
- Use a typed schema validator (Zod, class-validator, Joi) — never cast raw input to a typed value directly.
- File uploads MUST validate MIME type and file size on the server, not only on the client.

## Injection Prevention

- Never construct SQL by string concatenation or template literals. Always use parameterized queries or an ORM's query builder.
- Never pass user-supplied values directly to `exec`, `spawn`, `eval`, or `Function()`.
- Never use user-supplied values in `fs.readFile`, `fs.writeFile`, or `path.join` without sanitization and path validation.

## Data Exposure

- API responses MUST NOT include fields the caller is not authorized to see.
- Error responses returned to clients MUST NOT include stack traces, internal file paths, or DB error messages.
- Sensitive fields (passwords, tokens, internal IDs) MUST be explicitly excluded from serialized responses.

## Network and CORS

- CORS `origin: '*'` MUST NOT be used on any authenticated API endpoint.
- Outbound HTTP requests to user-supplied URLs MUST validate the destination against an allowlist.
- All production traffic MUST be served over HTTPS.

## Dependency Safety

- Dependencies MUST be kept up to date. Outdated packages with known CVEs MUST be updated before release.
- Never install packages from untrusted sources or with suspicious install scripts.

---

## Auto-promoted

<!-- Rules promoted by /improve-rules appear here. Do not edit manually. -->
