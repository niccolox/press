with import <nixpkgs> {};
mkShell {
  nativeBuildInputs = with pkgs; [
    (beam.packagesWith erlang_26).elixir_1_15
      inotify-tools nodejs yarn
  ];
}
