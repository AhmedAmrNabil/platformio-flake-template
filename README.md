# platformio-flake-template

A Nix flake dev shell that installs PlatformIO into a project-local Python virtualenv and automatically configures VSCode to use it.

## What it does

- Creates a `.platformio/` directory inside your project and installs PlatformIO's virtualenv there, keeping it isolated from your system
- Configures `.vscode/settings.json` to point the PlatformIO VSCode extension at the correct local Python path
- Disables the extension's built-in PIO core so it uses the local venv instead

## Requirements

- [Nix](https://nixos.org/) with flakes enabled
- PlatformIO VSCode extension (for IDE features)

## Usage

### One-off

```bash
nix develop github:AhmedAmrNabil/platformio-flake-template
```

Add `-c fish` or `-c zsh` to use your preferred shell:

```bash
nix develop github:AhmedAmrNabil/platformio-flake-template -c fish
```

### In your project

Copy `flake.nix` into your project root, then enter the shell:

```bash
nix develop
```

Or with [direnv](https://direnv.net/) + [nix-direnv](https://github.com/nix-community/nix-direnv), add to `.envrc`:

```bash
use flake
```

Then run `direnv allow` and the shell will activate automatically whenever you `cd` into the project.

## First run

On first entry, the shell will download and install PlatformIO into `.platformio/penv/`:

```
Initializing PlatformIO environment...
```

## VSCode settings applied

The following keys are written to `.vscode/settings.json` on every shell entry:

| Setting | Value |
|---|---|
| `platformio-ide.customPATH` | Path to the local venv's `bin/` |
| `platformio-ide.useBuiltinPIOCore` | `false` |

Existing keys in `.vscode/settings.json` are preserved; only the above are added or overwritten.

## Project structure after first run

```
your-project/
├── .platformio/
│   └── penv/
├── .vscode/
│   └── settings.json  # auto-configured by the shell
├── flake.nix
└── flake.lock
```

Add `.platformio/` and `.vscode/settings.json` to your `.gitignore`:

```
.platformio/
.vscode/settings.json
```

## Updating

To pull the latest version of the flake from GitHub, pass `--refresh`:

```bash
nix develop --refresh github:AhmedAmrNabil/platformio-flake-template -c fish
```
