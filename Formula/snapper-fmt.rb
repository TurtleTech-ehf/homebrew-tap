class SnapperFmt < Formula
  desc "Semantic line break formatter for Org, LaTeX, Markdown, and plaintext"
  homepage "https://snapper.turtletech.us"
  version "0.7.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.7.8/snapper-fmt-aarch64-apple-darwin.tar.xz"
      sha256 "2f93c474907d6f7bf1b230a887612472f005cb92554db467567b1e0cde6002f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.7.8/snapper-fmt-x86_64-apple-darwin.tar.xz"
      sha256 "2ced45a9eadd056fedd25b81adef0c1d2d2b555a76d87da8cbe95fdf6055da7d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.7.8/snapper-fmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a7b4e4d16b814708048ba48c94cc2d7ca319b8576c17c83bd4e02a76c69ad2ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.7.8/snapper-fmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a1df1fbb23b5c7cc08821da1456a51072a90ee8d59e4e91209551475d10af00a"
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
