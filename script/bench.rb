$:.unshift "./lib"
require 'stockfish'


def print_elapsed(elapsed)
  puts "Time elapsed #{"%0.3f" % elapsed}s"
end

def time_elapsed(&block)
  t0 = Time.now
  block.call
  elapsed = Time.now - t0
  print_elapsed elapsed
  elapsed
end


t = 0

t += time_elapsed do
  fen = "2rq1rk1/1b1nppbp/pp3np1/2ppN3/P2P1B2/2P1P2P/1P1NBPP1/R2Q1RK1 w - - 2 12"
  Stockfish::Engine.new.analyze fen, { :depth => 20 }
end

t += time_elapsed do
  fen = "2r2rk1/5q1p/pp3ppb/P2b4/3Pp3/1NP4P/2Q2PPB/R3R1K1 w - - 1 27"
  Stockfish::Engine.new.analyze fen, { :depth => 20 }
end

t += time_elapsed do
  fen = "3q1rk1/1b1rbppp/p2ppn2/1p6/3BPP2/P1NB2Q1/1PP3PP/4RR1K w - - 5 17"
  Stockfish::Engine.new.analyze fen, { :depth => 16 }
end

t += time_elapsed do
  fen = "3qr1k1/1b1rbp2/p2p1np1/1p2p3/4P3/P1NBB2Q/1PP3PP/4RR1K w - - 0 21"
  Stockfish::Engine.new.analyze fen, { :depth => 16 }
end

t += time_elapsed do
  fen = "r2qk2r/ppp1p1bp/5np1/3p2B1/6b1/3BQN2/PPP2PPP/R4RK1 b kq - 0 14"
  Stockfish::Engine.new.analyze fen, { :depth => 14 }
end

t += time_elapsed do
  fen = "rnbqk2r/ppppppbp/6p1/2n1P3/2BP4/5N2/PPP2PPP/RNBQK2R b KQkq - 0 6"
  Stockfish::Engine.new.analyze fen, { :depth => 14 }
end

t += time_elapsed do
  fen = "3qr3/1b1r1Q2/p2p1bp1/1p2p3/4k3/P3B3/1PP3PP/4R2K w - - 6 29"
  Stockfish::Engine.new.analyze fen, { :depth => 12 }
end

t += time_elapsed do
  fen = "r1bq1rk1/ppp1n1b1/3p1n1p/1PP1ppp1/8/2NP1NP1/P2BPPBP/1R1Q1RK1 b - - 0 12"
  Stockfish::Engine.new.analyze fen, { :depth => 12 }
end

t += time_elapsed do
  fen = "3q1rk1/1p4b1/r2pbnnp/4p3/4P1p1/2NPBpP1/P2Q1P1P/1R2NRKB b - - 3 20"
  Stockfish::Engine.new.analyze fen, { :depth => 10 }
end

t += time_elapsed do
  fen = "8/5bbk/6np/r2np3/6p1/P2PBpPP/2N2P2/1N3RKB b - - 0 28"
  Stockfish::Engine.new.analyze fen, { :depth => 10 }
end

t += time_elapsed do
  fen = "2k2r2/3bb1p1/pBqpp3/Pp5p/4P1n1/2NB4/1PP1Q1PP/R6K b - - 11 25"
  Stockfish::Engine.new.analyze fen, { :depth => 16, :multipv => 3 }
end

t += time_elapsed do
  fen = "2k4r/3b2p1/p4b2/Pp1pq2p/6n1/2PB4/NP2Q1PP/5RBK w - - 1 31"
  Stockfish::Engine.new.analyze fen, { :depth => 16, :multipv => 3 }
end

t += time_elapsed do
  fen = "8/5bbk/r2p1nnp/q3p3/4P1p1/P1NPBpP1/2NQ1P1P/5RKB b - - 0 24"
  Stockfish::Engine.new.analyze fen, { :depth => 12, :multipv => 3 }
end

t += time_elapsed do
  fen = "8/8/4N2k/4n2p/6p1/r4pPP/4bP2/4R1KB w - - 8 39"
  Stockfish::Engine.new.analyze fen, { :depth => 12, :multipv => 3 }
end


puts
puts "Total time elapsed"
print_elapsed(t)
