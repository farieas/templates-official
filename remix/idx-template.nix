{ pkgs, ... }: {
  packages = [
    pkgs.nodejs_20
    pkgs.git
  ];

  bootstrap = ''
    npx --prefer-offline create-remix@latest --yes --template remix --no-install --no-git-init "$WS_NAME"


    mkdir -p "$WS_NAME/.idx"
    cp ${./dev.nix} "$WS_NAME/.idx/dev.nix"

    chmod -R u+w "$WS_NAME"
    mv "$WS_NAME" "$out"

    mkdir -p "$out/.idx"
    cp ${./.idx/airules.md} "$out/.idx/airules.md"
    cp "$out/.idx/airules.md" "$out/GEMINI.md"

    cd "$out"
    npm install --package-lock-only --ignore-scripts
  '';
}
