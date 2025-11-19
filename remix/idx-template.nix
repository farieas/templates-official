{ pkgs, ... }: {
  channel = "stable-25.05";
  packages = [
    pkgs.nodejs_24
  ];
  bootstrap = ''
    # Create Remix app directly in output directory
    npx create-remix@latest "$out" --yes --no-install --no-git-init --no-init-script
    
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
