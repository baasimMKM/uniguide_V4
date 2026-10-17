"""Project-local HTML compatibility hook for the pinned Jac 0.16.7 runtime.

That release's API page renderer emits __jac_root, while its React entry
mounts root. Its API HTML also omits the extracted Vite stylesheet and
viewport metadata. Use the public render_page hook to repair this app's
HTML without modifying installed packages or generated client code.
The send_json hook also sanitizes framework error envelopes before the
default serializer runs. It returns None without doing I/O, so the core
hook sends the response exactly once. Successful application reports
remain unchanged.
The public server factory selects a project subclass whose request handler
applies the same repair to canonical TransportResponse.data dictionaries;
Jac 0.16.7 sends those directly through HTTPTransport, bypassing send_json.
"""
import from importlib.metadata { version }
import from jaclang.jac0core.runtime {
    hookimpl, plugin_manager, JacRuntimeImpl
}
import from jaclang.runtimelib.server { JacAPIServer }

def _sanitize_error_envelope(data: dict) -> None {
    if data.get("error") is not None {
        data["error"] = "Request rejected. Check the submitted fields and try again.";
        data.pop("traceback", None);
    }
    nested = data.get("data");
    if isinstance(nested, dict) and nested.get("error") is not None {
        nested["error"] = "Request rejected. Check the submitted fields and try again.";
        nested.pop("traceback", None);
    }
}

obj _UniPathAPIServer(JacAPIServer) {
    def create_handler() -> type {
        base_handler = super.create_handler();
        original_send: any = getattr(base_handler, "_send_response");
        def safe_send(handler: any, response: any) -> None {
            # Canonical TransportResponse bypasses send_json in this release.
            # Repair structured framework envelopes before normal serialization.
            data: any = getattr(response, "data", None);
            body: any = getattr(response, "body", None);
            if isinstance(data, dict) { _sanitize_error_envelope(data); }
            if isinstance(body, dict) { _sanitize_error_envelope(body); }
            original_send(handler, response);
        }
        return `type(
            "UniPathRequestHandler", (base_handler,), {"_send_response": safe_send}
        );
    }
}

def _repair_app_html(page: str, bundle_hash: str) -> str {
    page = page.replace('<div id="__jac_root">', '<div id="root">');
    page = page.replace('<title>app</title>', '<title>UniPath LK | Education pathways</title>');
    additions = '<meta name="viewport" content="width=device-width,initial-scale=1"/>'
        + '<link rel="stylesheet" href="/static/styles.css?hash='
        + bundle_hash + '"/>';
    return page.replace('</head>', additions + '</head>');
}

class _UniPathPageCompatibility {
    # Jac 0.16.7's hook manager calls the latest registered hook first.
    # Its hookimpl marker takes only the callable; tryfirst is unsupported.
    @hookimpl
    static def get_api_server_class() -> type { return _UniPathAPIServer; }

    @hookimpl
    static def render_page(
        introspector: any, function_name: str, args: dict, username: str
    ) -> dict {
        core_render: any = getattr(JacRuntimeImpl, "render_page");
        payload = core_render(
            introspector, function_name, args, username
        ) as dict;
        if function_name == "app" {
            payload["html"] = _repair_app_html(
                str(payload["html"]), str(payload.get("bundle_hash", ""))
            );
        }
        return payload;
    }

    @hookimpl
    static def send_json(handler: any, status: any, data: dict) -> None {
        _sanitize_error_envelope(data);
        return None;
    }
}

def install_page_compatibility() -> None {
    if version("jaclang") == "0.16.7" {
        # Reloads replace this project's previous hook instead of accumulating it.
        plugin_manager.unregister(name="unipath-lk-page-compatibility");
        plugin_manager.register(
            _UniPathPageCompatibility, name="unipath-lk-page-compatibility"
        );
    }
}

with entry {
    install_page_compatibility();
}
