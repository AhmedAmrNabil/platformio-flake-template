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
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          platformio
        ];
        shellHook = ''
          export PLATFORMIO_CORE_DIR=$PWD/.platformio
        '';
      };
    };

}
