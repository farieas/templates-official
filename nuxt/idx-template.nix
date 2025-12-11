{ pkgs, packageManager, template,... }: {
   channel = "stable-25.05";
     packages =
    [
      pkgs.nodejs 
      pkgs.j2cli
      pkgs.nixfmt
    ]
    ++ (
      if packageManager == "pnpm" then
        [ pkgs.nodePackages.pnpm ]
      else if packageManager == "yarn" then
        [ pkgs.yarn ]
      else if packageManager == "bun" then
        [ pkgs.bun ]
      else
        [ ]   # npm → no extra packages
    );

    # Available options as of 1/17/2024
    # https://github.com/nuxt/cli/blob/f113a083f000d19c9ae7f35ae2534ac5c0dba77b/src/commands/init.ts
    # npx nuxi@latest init nuxt-idx --package-manager bun --install true --git-init true --force true

    # To test this configuration:
    # /nix/store/mvr5wczap3ga80iq548n2griy8kx9ksx-idx-template/bin/idx-template ~/Monospace/workspace/nix_templates/public/nuxt --output-dir ~ --workspace-name foo -a '{"packageManager": "bun"}'
    # npx --yes nuxi@latest init nuxiapp --template ui --package-manager npm --no-questions --no-install
    bootstrap = ''
      npx -yes nuxi@latest -y init "$out"  \
        --template ${template} \
        --package-manager ${packageManager} \
        --no-install \
        --git-init no

      mkdir "$out"/.idx
      packageManager=${packageManager} j2 ${./devNix.j2} -o "$out/.idx/dev.nix"
      nixfmt "$out"/.idx/dev.nix
      chmod -R +w "$out"
      
      cp -rf ${./.idx/airules.md} "$out/.idx/airules.md"
      cp -rf "$out/.idx/airules.md" "$out/GEMINI.md"
      chmod -R u+w "$out"
    '';
}
