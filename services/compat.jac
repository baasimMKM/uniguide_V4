"""Jac 0.34.23 build: the 0.16.7 runtime-repair hooks are not needed and not ported.

The 0.16.7 adapter patched that release's page renderer, binary static files and
HTTP handler. Jac 0.34 serves assets/ at /static natively and uses a different server,
so this module keeps only the public entry point. The 0.16.7 transport hardening
(body caps, origin checks, account-route denial) is NOT re-implemented here; rely on
the hosting platform's controls and treat that as an open deployment item.
"""

def install_page_compatibility() -> None {}
