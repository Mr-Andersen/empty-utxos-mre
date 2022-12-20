{
  description = "empty-utxos-mre";

  inputs = {
    cardano-transaction-lib.url = github:Plutonomicon/cardano-transaction-lib/db398ab7215fdc0fecb0e0fcdb23f8bc856823c9; # v4.0.0

    nixpkgs.follows = "cardano-transaction-lib/nixpkgs";
    haskell-nix.follows = "cardano-transaction-lib/haskell-nix";

    plutip.follows = "cardano-transaction-lib/plutip";
    iohk-nix.follows = "cardano-transaction-lib/iohk-nix";
    CHaP.follows = "cardano-transaction-lib/CHaP";
  };

  outputs = inputs@{ self, nixpkgs, haskell-nix, CHaP, cardano-transaction-lib, plutip, ... }:
    let
      # GENERAL
      # supportedSystems = with nixpkgs.lib.systems.supported; tier1 ++ tier2 ++ tier3;
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];
      perSystem = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = system: import nixpkgs {
        inherit system;
        overlays = [
          haskell-nix.overlay
          cardano-transaction-lib.overlays.purescript
          cardano-transaction-lib.overlays.runtime
          cardano-transaction-lib.overlays.spago
        ];
        inherit (haskell-nix) config;
      };

      formatCheckFor = system:
        let
          pkgs = nixpkgsFor system;
          nativeBuildInputs = [
            pkgs.cabal-install
            pkgs.fd
            pkgs.git
            pkgs.nixpkgs-fmt
            pkgs.easy-ps.purs-tidy
          ];
          formatCheck = pkgs.runCommand "format-check"
            {
              inherit nativeBuildInputs;
            }
            ''
              cd ${self}
              make format_check
              mkdir $out
            '';
          inherit (pkgs.lib) concatStringsSep;
          otherBuildInputs = [ pkgs.bash pkgs.coreutils pkgs.findutils pkgs.gnumake pkgs.nix ];
          format = pkgs.writeScript "format"
            ''
              export PATH=${concatStringsSep ":" (map (b: "${b}/bin") (otherBuildInputs ++ nativeBuildInputs))}
              make format
            '';
        in
        {
          inherit format formatCheck;
        }
      ;

      # ONCHAIN / Plutarch

      # OFFCHAIN / Testnet, Cardano, ...

      offchain = {
        projectFor = system:
          let
            pkgs = nixpkgsFor system;
          in
          pkgs.purescriptProject {
            inherit pkgs;
            projectName = "empty-utxos-mre";
            strictComp = false; # TODO: this should be eventually removed
            src = ./offchain;
            packageJson = ./offchain/package.json;
            packageLock = ./offchain/package-lock.json;
            shell = {
              packageLockOnly = true;
              packages = with pkgs; [
                bashInteractive
                docker
                fd
                nodePackages.eslint
                nodePackages.prettier
                ogmios
                ogmios-datum-cache
                plutip-server
                postgresql
                easy-ps.purescript-language-server
                nodejs-14_x.pkgs.http-server
              ];
              shellHook =
                ''
                  export LC_CTYPE=C.UTF-8
                  export LC_ALL=C.UTF-8
                  export LANG=C.UTF-8
                '';
            };
          };
      };
    in
    {
      inherit nixpkgsFor;

      offchain = {
        project = perSystem offchain.projectFor;
        flake = perSystem (system: (offchain.projectFor system).flake { });
      };

      checks = perSystem (system:
        {
          empty-utxos-mre = self.offchain.project.${system}.runPlutipTest { testMain = "Test.Main"; };
          inherit (formatCheckFor system) formatCheck;
        }
      );

      devShells = perSystem (system: {
        onchain = self.onchain.flake.${system}.devShell;
        offchain = self.offchain.project.${system}.devShell;
      });

      apps = perSystem (system: {
        docs = self.offchain.project.${system}.launchSearchablePursDocs { };
        ctl-docs = cardano-transaction-lib.apps.${system}.docs;
        format = {
          type = "app";
          program = (formatCheckFor system).format.outPath;
        };
      });

      herculesCI.ciSystems = [ "x86_64-linux" ];
    };
}
