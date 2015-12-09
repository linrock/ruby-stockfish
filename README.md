# Ruby Stockfish

A ruby client for the [Stockfish](https://stockfishchess.org/) chess engine

## Installation

```
$ gem install stockfish
```

Or add it to your application's Gemfile and install via bundler

```
gem 'stockfish'
```

## Analyzing positions

Load a position in [FEN](https://en.wikipedia.org/wiki/Forsyth%E2%80%93Edwards_Notation) notation that you want to analyze

```ruby
fen = "3qr3/1b1rb2Q/p2pk1p1/1p1np3/4P3/P2BB3/1PP3PP/4R2K w - - 2 24"
```

Set the search depth (in number of half-moves) you want to use

```ruby
Stockfish.analyze fen, { :depth => 12 }
```

And request multiple variations if you'd like

```ruby
Stockfish.analyze fen, { :depth => 6, :multipv => 3 }
```

## Requirements

Stockfish 6+ must be installed and available in your $PATH

```bash
$ which stockfish
```

If Stockfish is not in your $PATH, you can pass the path to the Stockfish binary directly

```ruby
engine = Stockfish::Engine.new("/usr/local/bin/stockfish")
engine.multipv(3)
engine.analyze fen, { :depth => 6 }
```
