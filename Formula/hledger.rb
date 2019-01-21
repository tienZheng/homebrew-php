require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-1.11.1/hledger-1.11.1.tar.gz"
  sha256 "e916a6c898f0dc16a8b0bae3b7872a57eea94faab2ca673a54e0355fb507c633"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d25a91424c80e112d52676b56678f72688c0e58f125506a379fe4c88a930eb5" => :mojave
    sha256 "7a6c1d2174b681f495ecfefa6a6c357d7e76d31d6fd0e254bdb2e5236b3e7d7b" => :high_sierra
    sha256 "e550e642af13f16b2131830a61e807fafa57e6c8dfcd33c74fe23c9594e80346" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    touch ".hledger.journal"
    system "#{bin}/hledger", "test"
  end
end
