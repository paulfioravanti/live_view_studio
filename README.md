# LiveView Studio

This is my sandbox for [Pragmatic Studio][]'s [Phoenix LiveView course][].

I followed [their instructions][] to upgrade to [Phoenix 1.6][], though I opted
to keep [NodeJS][] out of the application entirely, which meant:

- no usage of custom CSS `@import` statements ([Comment out @import
  directives][])
- no CSS nesting ([Does Tailwind CLI support the nested classes?][])

I can live with that if it means no need for Node. See `assets/css/app.css` for
the changes that needed to be made.

## Dependencies

- Elixir 1.13.3

## Setup

```sh
git clone https://github.com/paulfioravanti/live_view_studio.git
cd live_view_studio
mix setup
```

## Run

```sh
mix phx.server
```

Open <http://localhost:4000>

[Comment out @import directives]: https://github.com/phoenixframework/tailwind/pull/26
[Does Tailwind CLI support the nested classes?]: https://github.com/tailwindlabs/tailwindcss/discussions/7216
[Elixir]: https://elixir-lang.org/
[NodeJS]: https://nodejs.org/en/
[Phoenix 1.6]: https://www.phoenixframework.org/blog/phoenix-1.6-released
[Pragmatic Studio]: https://pragmaticstudio.com/
[Phoenix LiveView course]: https://pragmaticstudio.com/courses/phoenix-liveview-pro
[their instructions]: https://pragmaticstudio.com/tutorials/adding-tailwind-css-to-phoenix
