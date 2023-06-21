import Config

config :vile_cards, core: VileCards.Core.GameMock

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :vile_cards, VileCardsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "g+4vQvtWTIxf94/oz1zAFivyYw7mEmH4RiZAi+i9Wfeu19yjv982E/kw00+pjmUC",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
