# shell.nix
{
  pkgs,
  inputs,
  system,
  ...
} @ args: let
  # UV stuff
  #inherit (uvBoilerplate) uvShellSet;
  # Input packages
  #quaestor = inputs.quaestor.packages.${system}.default;
  # Default shell
  defaultPackages = with pkgs; [
    nodePackages_latest.nodejs
    beamerpresenter
    args.tex
  ];
  defaultHooks = ''
    # Make our local node packages available to our shell; for mcp's
    export PATH="./node_modules/.bin:$PATH"
  '';
  defaultEnv = {};
in {
  # Default dev shell
  default = pkgs.mkShell {
    packages = defaultPackages;
    env = defaultEnv;
    shellHook = defaultHooks;
  };
}
