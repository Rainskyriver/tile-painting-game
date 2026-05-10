# Project Guide

## Structure

```
Scripts/   — one .gd file per scene, named to match
Scenes/    — .tscn files
Assets/    — images and media
Resources/ — .tres material files
```

## Code Style

**Node references** use `@onready` with `get_node()`, not the `$` shorthand:
```gdscript
@onready var grid : GridContainer = get_node("Single Grid")
```

**Type annotations** use a space before the colon on variable declarations:
```gdscript
var stage : int = 0
@onready var camera : Camera3D = get_node("Container/Camera3D")
```

**Functions** are short and single-purpose. No comments — names carry the meaning.

**Signals** are connected in the editor and follow the `_on_[node]_[signal]` naming pattern.

**Loading resources**: use `preload()` for PackedScenes needed at ready time, `load()` for everything else.

## Global State

`Game` is the autoload singleton. Put shared state there (current color, mode flags, win conditions). Scripts read and write `Game.*` directly — no passing it around.

## Naming

- Files and variables: `snake_case`
- Scene node names: `PascalCase` or natural words (e.g. `"Single Grid"`, `"YouWin!"`)
- No abbreviations unless the meaning is obvious in context

## Scene / Script Pairing

Each scene has one script. The script name matches the scene name. Keep scene trees shallow — child nodes are mostly meshes, collision shapes, and UI controls, not nested logic.
