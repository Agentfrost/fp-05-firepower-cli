{
  description = "flake for python dev";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells."${system}".default = pkgs.mkShell {
        packages = with pkgs; [
          python312Full
          python312Packages.python-lsp-server
          python312Packages.python-lsp-black
          python312Packages.python-lsp-ruff
        ];

        LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";

        shellHook = ''
          export PATH="$PWD/node_modules/.bin:$PATH";
          if [ ! -d ".venv" ]; then
            python -m venv ./.venv
            chmod +x ./.venv/bin/activate
          fi
          source .venv/bin/activate
          zsh
          exit
        '';
      };
    };
}
