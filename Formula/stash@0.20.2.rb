class StashAT0202 < Formula
  desc "Organizer for your porn, written in Go"
  homepage "https://github.com/stashapp/stash"
  url "https://github.com/stashapp/stash/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "1eaef744ce856afe71857381fb832c29fc0c43eefc6336c60c30be36b929c71b"
  license "AGPL-3.0-only"
  revision 1
  head "https://github.com/stashapp/stash.git", branch: "develop"

  bottle do
    root_url "https://github.com/charitybell/homebrew-charitybell/releases/download/stash/"
    sha256 cellar: :any_skip_relocation, ventura:      "51595549299ee4378f8301f58892a84a83f3b632d5803bbe78af65387c89eb9d"
    sha256 cellar: :any_skip_relocation, monterey:     "9ef3f4011136f0a319ae043664642a01b8d04869bdc04b947cebe6a846dc1c9a"
    sha256 cellar: :any_skip_relocation, big_sur:      "3ddf18ab6052f6efbd2bb85c4a50a47a77854da1a425325b29481104c2ee6af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d5d300abc7a609eeccd30e3ab8bc22c649e4b32e7245463f73837e717b74a82d"
  end

  depends_on "gcc" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "ffmpeg"

  service do
    run [opt_bin/"stash"]
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
