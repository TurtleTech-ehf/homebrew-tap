class SnapperFmt < Formula
  desc "Semantic line break formatter for Org, LaTeX, Markdown, RST, and plaintext"
  homepage "https://snapper.turtletech.us"
  version "0.11.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.11.5/snapper-fmt-aarch64-apple-darwin.tar.xz"
      sha256 "4a7c39c5abc5027730571a296cf6c042b210b8b20004432bff2f55d423f7e3b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.11.5/snapper-fmt-x86_64-apple-darwin.tar.xz"
      sha256 "7b85d69a5705d1a458c0dbd060eb067f793d10936b2fd482aaf48cb185c0659d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.11.5/snapper-fmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "571d76b865d38fc4f0e67b5afa7b7ec816de3e4e1e43233dea40d3c62beee0d0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.11.5/snapper-fmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "48f2af564bdc681d8da7b4810447a8dcad1cee9994cabed8c0b8df4bfb92efd9"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "snapper", "snapper-fmt", "snapper-gen-docs"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "snapper", "snapper-fmt", "snapper-gen-docs"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "snapper", "snapper-fmt", "snapper-gen-docs"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "snapper", "snapper-fmt", "snapper-gen-docs"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
