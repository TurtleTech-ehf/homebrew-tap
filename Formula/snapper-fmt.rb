class SnapperFmt < Formula
  desc "Semantic line break formatter for Org, LaTeX, Markdown, RST, and plaintext"
  homepage "https://snapper.turtletech.us"
  version "0.11.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.11.9/snapper-fmt-aarch64-apple-darwin.tar.xz"
      sha256 "7fb21120604d38cd293709c1524a8170622411b474c918b18e476236ebb0434c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.11.9/snapper-fmt-x86_64-apple-darwin.tar.xz"
      sha256 "3b4b414bedbc0db53cdb89ca2f122356b6f52d8ed58284868becfcfbfe5a14dd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.11.9/snapper-fmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8a280685a7ffb260d3c4d17efec8b780ac5c38b4630e08ee5b643c77f0a9472a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.11.9/snapper-fmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5b5597271249ff6c8ac2efe74b0f378645b21fc44257b85e576e65a0cdbbe262"
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
