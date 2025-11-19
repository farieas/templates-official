{ pkgs, ... }: {
  channel = "stable-25.05";
  packages = [
    pkgs.nodejs_24
  ];
  bootstrap = ''
    # Create Remix app in a temporary directory
    npx create-remix@latest remix-app --yes --no-install --no-git-init --no-init-script
    
    # Move all contents from remix-app to $out
    cp -r remix-app/. "$out/"
    
    # Create .idx directory
    mkdir -p "$out/.idx"
    
    # Copy dev.nix
    cp -rf ${./dev.nix} "$out/.idx/dev.nix"
    
    # Copy airules.md if it exists
    if [ -f ${./.idx/airules.md} ]; then
      cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
      cp -rf ${./.idx/airules.md} "$out/GEMINI.md"
    fi
    
    # Set permissions
    chmod -R u+w "$out"
    
    # Install dependencies
    cd "$out" && npm install --package-lock-only --ignore-scripts
  '';
}
