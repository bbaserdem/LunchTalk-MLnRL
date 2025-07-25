{
  description = "Presentation on ML and RL to Gauntlet AI folks";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";

    # Python project setup
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    outputs = self;
    projectName = "mlrl-demo";
  in
    flake-utils.lib.eachDefaultSystem (system: let
      # Grab UV stuff
      #uvBoilerplate = import nix/uv.nix {
      #  inherit inputs system projectName projectDir;
      #};
      pkgs = import nixpkgs {inherit system;};
      # LaTeX
      tex = pkgs.texlive.combine {
        inherit
          (pkgs.texlive)
          scheme-basic
          beamer
          booktabs
          hyperref
          amsmath
          graphicxpsd
          latexmk
          ;
        #(setq org-latex-compiler "lualatex")
        #(setq org-preview-latex-default-process 'dvisvgm)
      };
    in {
      #checks = import ./nix/checks.nix {
      #  inherit uvBoilerplate projectName;
      #};
      apps = import ./nix/apps.nix {
        inherit outputs pkgs;
      };
      packages = import ./nix/packages.nix {
        inherit pkgs inputs system;
      };
      devShells = import ./nix/shells.nix {
        inherit pkgs tex inputs system;
      };
    });
}
