{ pkgs, ... }: {
  packages = [
    pkgs.nodejs_20
    pkgs.git
  ];

  bootstrap = ''
    mkdir -p "$WS_NAME"
    npx create-remix@latest --template remix-run/remix/templates/remix "$WS_NAME"

    mkdir -p "$WS_NAME/.idx/"
    cp -rf ${./dev.nix} "$WS_NAME/.idx/dev.nix"
    chmod -R +w "$WS_NAME"
    mv "$WS_NAME" "$out"

    chmod -R u+w "$out"
    cd "$out"; npm install --package-lock-only --ignore-scripts
  '';
}
