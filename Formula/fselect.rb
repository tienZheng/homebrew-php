class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.5.1.tar.gz"
  sha256 "28af31ce16800d11666c0c6a1d177ab5115339fcaf6c6801b1583be1c19fae5a"

  bottle do
    sha256 "f206c8bda3ecdd5dfb52bb2b1f14c8f5965090c0263821cd6e31ed8360e3385a" => :mojave
    sha256 "a9837ebdf8cfa600b02f151d7a6fd6ad996abb324991162cf2ce04ee0b19061b" => :high_sierra
    sha256 "71bbcead5c2a0292fb47899e245255288484060cb7b777dcc6cd58b303b6e4cc" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
