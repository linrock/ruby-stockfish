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

Look at multiple variations by setting a multipv option

```ruby
Stockfish.analyze fen, { :depth => 12, :multipv => 3 }
```


## Communicating with the engine

You can also send [UCI](https://en.wikipedia.org/wiki/Universal_Chess_Interface) commands to Stockfish directly

```ruby
engine = Stockfish::Engine.new
engine.execute "position fen q3r3/3r4/p2p2p1/1p2p1b1/8/P6k/1PP1Q2P/4BRK1 b - - 8 36"
engine.execute "setoption name MultiPV value 3"
engine.execute "go depth 10"
```


## Requirements

Stockfish 6+ must be installed and available in your `$PATH`

```bash
$ which stockfish
```

Or you can load a Stockfish binary directly

```ruby
engine = Stockfish::Engine.new("/usr/local/bin/stockfish")
engine.multipv(3)
engine.analyze fen, { :depth => 12 }
```
