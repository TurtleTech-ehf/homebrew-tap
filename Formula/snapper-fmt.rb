class SnapperFmt < Formula
  desc "Semantic line break formatter for Org, LaTeX, Markdown, RST, and plaintext"
  homepage "https://snapper.turtletech.us"
  version "0.11.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.11.4/snapper-fmt-aarch64-apple-darwin.tar.xz"
      sha256 "c8c674d2c1dabde45de7ed50f0cb2d15fc2791e492b33fe379bf25049d663622"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.11.4/snapper-fmt-x86_64-apple-darwin.tar.xz"
      sha256 "ef37aa95fe10e8b3f7158bb47544f3ab7ba90eda05acac07ef39f396fab5cfb3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.11.4/snapper-fmt-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "446fa862d439dac27cb8d4ef74fe72424e839fed2543a781d23ff65402c97ed3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/TurtleTech-ehf/snapper/releases/download/v0.11.4/snapper-fmt-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5f503b8531409d5d34bf963087636db9619b27e5a47b7c527e2be068e4ea0c38"
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
