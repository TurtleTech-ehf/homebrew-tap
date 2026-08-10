class SnapperFmt < Formula
  desc "Semantic line break formatter for Org, LaTeX, Markdown, RST, and plaintext"
  homepage "https://snapper.turtletech.us"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.10.0/snapper-fmt-aarch64-apple-darwin.tar.xz"
      sha256 "4ced3722220c263793cd66a55fd45f0b958bb64fc99ee48c49676289b968c12b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.10.0/snapper-fmt-x86_64-apple-darwin.tar.xz"
      sha256 "06e07b3966d743f41823eee74020f74c22af8a7aec4f57da082e3056261e3c15"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.10.0/snapper-fmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "88fdd1b92a9c937c591715aaa8e1747f4e6b2f6c3d198ed1dea20f4dc91898bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.10.0/snapper-fmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "46c1599863af5b056a7238eb0b5a33c297974b6352c50cb173f69cc647bf07c8"
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
