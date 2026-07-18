{
  description = "Unified DevOps Workspace Construction Kit";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = nixpkgs.legacyPackages.${system};
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          # Shared Core Python packages between Web & ML
          pip virtualenv requests pyyaml toml pytest black flake8 rich click
        ]);
      in {
        devShells = {
          # 🟢 MODE: NODE.JS DEVELOPMENT
          node = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs_22 nodePackages.npm nodePackages.yarn nodePackages.pnpm
              typescript nodePackages.ts-node nodemon nodePackages.eslint 
              nodePackages.prettier nodePackages.vite nodePackages.jest
              nodePackages.webpack nodePackages.webpack-cli
            ];
            shellHook = ''
              echo "⚡ [MODE_ACTIVE: devops] Node.js environment loaded"
              echo "Node: $(node --version) | NPM: $(npm --version)"
              export PROJECT_ROOT=$PWD
              export NPM_CONFIG_CACHE=$PWD/.npm-cache
            '';
          };

          # 🐍 MODE: PYTHON MACHINE LEARNING
          ml = pkgs.mkShell {
            buildInputs = with pkgs; [
              pythonEnv
              python3Packages.numpy python3Packages.scipy python3Packages.pandas
              python3Packages.scikit-learn python3Packages.matplotlib
              python3Packages.seaborn python3Packages.plotly python3Packages.jupyter
              python3Packages.ipython python3Packages.opencv4 python3Packages.pillow
              python3Packages.tqdm python3Packages.h5py python3Packages.openpyxl
            ];
            shellHook = ''
              echo "🧠 [MODE_ACTIVE: devops] Python ML pipeline active"
              echo "Python: $(python --version)"
              export PROJECT_ROOT=$PWD
            '';
          };

          # 🌐 MODE: PYTHON WEB DEVELOPMENT
          web = pkgs.mkShell {
            buildInputs = with pkgs; [
              pythonEnv
              python3Packages.flask python3Packages.django python3Packages.fastapi
              python3Packages.jinja2 python3Packages.aiohttp python3Packages.websockets
              python3Packages.sqlalchemy python3Packages.psycopg2 python3Packages.redis
              python3Packages.pymongo python3Packages.beautifulsoup4 python3Packages.lxml
              postgresql redis
            ];
            shellHook = ''
              echo "🌐 [MODE_ACTIVE: devops] Python Web server runtime ready"
              echo "Services available: PostgreSQL, Redis, MongoDB"
              export PROJECT_ROOT=$PWD
            '';
          };
        };
        
        # Default fallback shell points to Node if no mode specified
        devShells.default = this.devShells.node;
      });
}
