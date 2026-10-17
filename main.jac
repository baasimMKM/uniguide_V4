"""UniPath LK server entry and native Jac client mount."""
import from services.compat { install_page_compatibility }
import from services.api {
    get_app_info, plan_pathways, run_stress_test,
    get_catalogue_projection, get_evidence, health, evaluate_retake, ask_guide
}

cl {
    import ".styles.global.css";
    import from .components.AppBoundary { AppBoundary }
    def:pub app() -> JsxElement { return <AppBoundary />; }
}
