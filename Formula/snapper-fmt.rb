class SnapperFmt < Formula
  desc "Semantic line break formatter for Org, LaTeX, Markdown, and plaintext"
  homepage "https://snapper.turtletech.us"
  version "0.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.9.1/snapper-fmt-aarch64-apple-darwin.tar.xz"
      sha256 "d7f703ad402e7aacfaf4ab5b3c7007e1a1bb440c72cea41b6f0b37317f42fe19"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.9.1/snapper-fmt-x86_64-apple-darwin.tar.xz"
      sha256 "51368ea089748aa2c15ad12ccaa853a8c448deb9de68237c6b3a92af8de75fe7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.9.1/snapper-fmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "683cda1626ec7ea9bacf1f42b94f0a2462d69c9760b0cecda5a0212228dfaea0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.9.1/snapper-fmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9b7b9fec0bc34c8acd51ab144e196a54eb5aa143af460b8c2f3acd4439316505"
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
