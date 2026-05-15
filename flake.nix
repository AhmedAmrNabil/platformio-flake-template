{
  description = "A flake for development with platformio";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };

      configureVscodeSettings = pkgs.writeShellScript "configure-vscode-settings" ''
        #bash
        SETTINGS_FILE=.vscode/settings.json
        TMP=$(mktemp)
        # create empty json if missing
        [ -f "$SETTINGS_FILE" ] || echo '{}' > "$SETTINGS_FILE"

        ${pkgs.jq}/bin/jq \
          --arg path "$PLATFORMIO_VENV_DIR/bin" \
          '.["platformio-ide.customPATH"] = $path |
          .["platformio-ide.useBuiltinPIOCore"] = false' \
          "$SETTINGS_FILE" > "$TMP"

        mv "$TMP" "$SETTINGS_FILE"
      '';
    in
    {
      devShells.${system}.default = pkgs.mkShell {

        packages = with pkgs; [
          curl
          python3
          jq
        ];

        shellHook = ''
          #bash
          # set pio code to current dir
          # so venv is installed in project and not globally

          PLATFORMIO_CORE_DIR=$PWD/.platformio
          export PLATFORMIO_VENV_DIR="$PLATFORMIO_CORE_DIR/penv"

          ${configureVscodeSettings}

          if [ ! -f $PLATFORMIO_VENV_DIR/bin/activate ]|| ! "$PLATFORMIO_VENV_DIR/bin/python" --version &>/dev/null; then
            echo "Initializing PlatformIO environment..."
            curl -fsSL -o get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
            python3 get-platformio.py
            rm get-platformio.py
          fi

          # return PLATFORMIO_CORE_DIR to default
          # so it uses the global pio dir for toolchain
          # but uses local venv pio package
          PLATFORMIO_CORE_DIR="$HOME/.platformio"

          if [ -f $PLATFORMIO_VENV_DIR/bin/activate ]; then
            source $PLATFORMIO_VENV_DIR/bin/activate
          fi
        '';
      };
    };

}
