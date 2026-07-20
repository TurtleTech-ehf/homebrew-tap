class SnapperFmt < Formula
  desc "Semantic line break formatter for Org, LaTeX, Markdown, and plaintext"
  homepage "https://snapper.turtletech.us"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.8.0/snapper-fmt-aarch64-apple-darwin.tar.xz"
      sha256 "4b713b430e3a4834a1bbee4035f682cdea9a20009c1faa79cc7d8259c05b6606"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.8.0/snapper-fmt-x86_64-apple-darwin.tar.xz"
      sha256 "b83098a04a0191f474c8ab62cb21f090c27f030f4267ab731131c2bfb73341de"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.8.0/snapper-fmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "978eb9c9ab527bbbeb9539e56ee9ce8927d06ca1fc8c4dd0d0fe14610f773459"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.8.0/snapper-fmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e556895951371a8c45cddb9e570aef21c9d9f49cf19e0332d23c6e38dcdc5fbf"
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
    bin.install "snapper", "snapper-gen-docs" if OS.mac? && Hardware::CPU.arm?
    bin.install "snapper", "snapper-gen-docs" if OS.mac? && Hardware::CPU.intel?
    bin.install "snapper", "snapper-gen-docs" if OS.linux? && Hardware::CPU.arm?
    bin.install "snapper", "snapper-gen-docs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
