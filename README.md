# Assembled

Quick launch:

```bash
git clone https://base.bingo/code/press
cd press
cp sample.env .call
nix-shell --command 'mix setup && mix phx.server'

# or one by one...
nix-shell --command 'mix setup'
nix-shell --command 'mix phx.server'

# or in a running shell.
nix-shell
mix setup
mix phx.server
```

## Phoenix Background

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
