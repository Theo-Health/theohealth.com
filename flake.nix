{
  description = "theohealth.com Website";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {
        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];

        imports = [
        ];

        flake = { };

        perSystem =
          {
            config,
            pkgs,
            system,
            ...
          }:
          let
            pkgs = import nixpkgs {
              inherit system;
              config = {
                # Allow all android-sdk packages since there's no other option.
                allowUnfreePredicate =
                  pkg:
                  let
                    name = nixpkgs.lib.getName pkg;
                  in (builtins.elem (pkgs.lib.getName pkg) [
                    # Unfree packages go here
                  ]);
              };
            };

          in {
            devShells.default = pkgs.mkShell {
              packages = with pkgs; [
                tailwindcss_4
              ];
            };
          };
      }
    );
}
