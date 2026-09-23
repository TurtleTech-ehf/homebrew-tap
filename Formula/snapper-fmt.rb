class SnapperFmt < Formula
  desc "Semantic line break formatter for Org, LaTeX, Markdown, RST, and plaintext"
  homepage "https://snapper.turtletech.us"
  version "0.11.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.11.7/snapper-fmt-aarch64-apple-darwin.tar.xz"
      sha256 "9626a190b42684a2602aeda2983dbf9004f7d54d0de611ce32eb136d327ad06d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.11.7/snapper-fmt-x86_64-apple-darwin.tar.xz"
      sha256 "497782cce4a19da4ddcb1fa3ee88e20cf88008067f6a455a1a91f64f917336a9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.11.7/snapper-fmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7e8b6d96b72f0fcd60e880c9c5a55e6b4895ba1778901ebf7758271c277f00d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.11.7/snapper-fmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "19dfa83a42e5e9901d6efd7918dd7d3fa16fcf9e8a24d8069bd379d64b5597de"
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
