# EMQX OSS security backport

Baseline: ninenines/cowlib c6553f8308a2ca5dcd69d845f0a7d098c40c3363 (2.8.0).
Backport: a4b8039ce8c93ab00867ef6b7e888822c09f4369 (CVE-2026-7790).
Additional change: reject overlong all-zero chunk lengths too.
The public API remains unchanged. The original ISC license is retained.
Validation: make ERLC_OPTS=+debug_info; escript test/chunk_length_security.escript.
