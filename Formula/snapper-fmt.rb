class SnapperFmt < Formula
  desc "Semantic line break formatter for Org, LaTeX, Markdown, and plaintext"
  homepage "https://snapper.turtletech.us"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.8.1/snapper-fmt-aarch64-apple-darwin.tar.xz"
      sha256 "9a62d5c0771058f81dbbf19858c7e8f2af6fb56404ead70fea21c164fb8b4610"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.8.1/snapper-fmt-x86_64-apple-darwin.tar.xz"
      sha256 "900ffe347edf7117d905e0b9abd450e7820980de4722f3db36baf8900f239db0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.8.1/snapper-fmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "115f7713f8018fbca827e0d9ceaf53cfcd4f75f349af1d9a159ce14b08787a91"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.8.1/snapper-fmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "47e9b8cb2de5fcd611c011af2dea9d360f956c0ed6039fcd24f5a46063c50a72"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "snapper", "snapper-fmt", "snapper-gen-docs" if OS.mac? && Hardware::CPU.arm?
    bin.install "snapper", "snapper-fmt", "snapper-gen-docs" if OS.mac? && Hardware::CPU.intel?
    bin.install "snapper", "snapper-fmt", "snapper-gen-docs" if OS.linux? && Hardware::CPU.arm?
    bin.install "snapper", "snapper-fmt", "snapper-gen-docs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
