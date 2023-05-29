class StashBox < Formula
  desc "OpenSource video indexing and Perceptual Hashing MetaData API"
  homepage "https://github.com/stashapp/stash-box"
  url "https://github.com/stashapp/stash-box/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "28b929a03bb2abb3a141f33fd5c811a450c976ca325934f9c9cfcdfec6b65f30"
  license "MIT"
  head "https://github.com/stashapp/stash-box.git", branch: "master"

  depends_on "gcc" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "postgresql@15"

  def install
    ENV.deparallelize
    system "make"

    bin.install "stash-box"
  end
end
