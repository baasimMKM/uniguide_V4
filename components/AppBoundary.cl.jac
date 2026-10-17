import from "react-error-boundary" { ErrorBoundary }
import from .App { App }

def:pub AppFailure(error: any, resetErrorBoundary: Callable[[], None]) -> JsxElement {
    def retry(e: MouseEvent) -> None {
        resetErrorBoundary();
    }
    return
        <main className="unipath">
            <section className="page-shell" role="alert">
                <div className="error">
                    <h1>We could not display this plan.</h1>
                    <p>
                        Your browser encountered a display error. Try loading the planner again.
                    </p>
                    <button type="button" className="secondary-button" onClick={retry}>
                        Reload planner
                    </button>
                </div>
            </section>
        </main>;
}

def:pub AppBoundary() -> JsxElement {
    return
        <ErrorBoundary FallbackComponent={AppFailure}>
            <App/>
        </ErrorBoundary>;
}
