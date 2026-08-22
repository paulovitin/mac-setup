<!-- mac-setup:rtk-caveman:start -->
## Shell output defaults

- Prefix shell commands with `rtk` when an RTK wrapper exists; this is the default command-output optimization.
- Use `rtk proxy <command>` when the raw command output is needed for a baseline or for debugging a filter.
- Do not automatically wrap every command with `caveman tools shrink`: RTK is the default shell layer and double-compression can add overhead.
- Caveman is available for intentionally large JSON, logs, HTML, TOON, memory, or other context-heavy workloads. Measure before enabling its proxy, response skill, or automatic hooks globally.
- Preserve exact errors, changed lines, and required markers. If a compact output is ambiguous, rerun the command with `rtk proxy` or read the original explicitly.
<!-- mac-setup:rtk-caveman:end -->
