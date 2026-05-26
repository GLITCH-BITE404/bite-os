# BITE-OS Icon Pool

Drop image files here. The executor picks one at random on every shell launch.

## Naming convention (this is the gacha matcher — keep it strict)

| Prefix  | Aspect    | Template auto-selected      |
|---------|-----------|-----------------------------|
| `sq_*`  | square    | `templates/centered.jsonc`  |
| `wd_*`  | wide      | `templates/side-by-side.jsonc` |
| `tl_*`  | tall      | `templates/vertical.jsonc`  |

Examples: `sq_skull.png`, `wd_neon_grid.png`, `tl_tower.png`

> Why a prefix instead of detecting dimensions at runtime?
> Because spawning `identify` / `file` on every prompt costs ~5–15 ms per
> launch. Filename classification is **O(1) and zero-fork**. Sharp as a blade.
