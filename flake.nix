{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

    outputs = inputs:
    let
        system = "x86_64-linux";
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        llvmPackages = pkgs.llvmPackages_18;
        pythonPackages = pkgs.python310Packages;
        stdenv = llvmPackages.stdenv;
    in
    {
        devShells.${system}.default = stdenv.mkDerivation {
            name = "atom-doc";
            src = ./.;

            nativeBuildInputs = with pkgs; [
                doxygen
                graphviz
                git
            ];

            ATOM_DOC_DOXYFILE_DIR = ./.;
        };

        packages.${system}.default = stdenv.mkDerivation {
            name = "atom-doc";
            src = ./.;

            propagatedBuildInputs = with pkgs; [
                doxygen
                graphviz
                git
            ];

            installPhase = ''
                mkdir -p $out;
                cp Doxyfile $out/Doxyfile;
                cp -r doxygen-awesome-css $out;
            '';
        };
    };
}
