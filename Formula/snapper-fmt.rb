class SnapperFmt < Formula
  desc "Semantic line break formatter for Org, LaTeX, Markdown, and plaintext"
  homepage "https://snapper.turtletech.us"
  version "0.7.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.7.4/snapper-fmt-aarch64-apple-darwin.tar.xz"
      sha256 "adbeaf0940e9c70c3967509c193593839b1a068a9ace954637f38c8f632993ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.7.4/snapper-fmt-x86_64-apple-darwin.tar.xz"
      sha256 "7b3bb220b9b6c614104a6875ded5024b47709dcd8e07b8b68d5565e314e823a9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.7.4/snapper-fmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "111fc966dadd3cbb0fc67573f15b2fcdbba6d200278eb3be22bcfb83d23bf5a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.7.4/snapper-fmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "76e456623a5100c7ad8f40947e5300e1c027f414494842ac591f3faf881d1f49"
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
