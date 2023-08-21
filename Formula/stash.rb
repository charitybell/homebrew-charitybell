class Stash < Formula
  desc "Organizer for your porn, written in Go"
  homepage "https://github.com/stashapp/stash"
  url "https://github.com/stashapp/stash/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "dd8496742ef7a59611ac8c6b0ef8c993d019b54db22d2b37b172ce82076afc4c"
  license "AGPL-3.0-only"
  head "https://github.com/stashapp/stash.git", branch: "develop"

  depends_on "gcc" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "ffmpeg"

  service do
    run [bin/"stash"]
    keep_alive crashed: true
  end

  def install
    ENV.deparallelize
    system "make"

    bin.install "stash"
  end

  test do
    system "#{bin}/stash", "--help"
  end
end
