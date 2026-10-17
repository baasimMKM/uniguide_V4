"""Bound the provider transport while preserving native byLLM generation.

byLLM 0.6.19 builds a fixed nonstreaming SDK parameter dictionary and does
not forward timeout or num_retries from Model.call_params. This project
subclass uses its public parameter extension point; installed packages
and the generated prompt, schema and response handling remain untouched.
The planner retains its independent twenty-second session deadline.
"""
import from byllm.lib { Model, MTRuntime }

obj BoundedGeminiModel(Model) {
    override def make_model_params(mt_run: MTRuntime) -> dict {
        params = super.make_model_params(mt_run);
        params["timeout"] = 8.0;
        params["num_retries"] = 0;
        return params;
    }
}
