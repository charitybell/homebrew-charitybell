class Zeal < Formula
  desc "Offline documentation browser inspired by Dash"
  homepage "https://zealdocs.org"
  url "https://github.com/zealdocs/zeal.git", revision: "3fdeb6616408fa0aed058ee959ae653c0519f733"
  version "3fdeb6616408fa0aed058ee959ae653c0519f733"
  sha256 "76495ab8f23e1b96c34174f0b24d5fa5d85f5a55e7d8ae8c32790fafa2cf4270"
  license "GPL-3.0-only"
  head "https://github.com/zealdocs/zeal.git", branch: "main"

  depends_on xcode: :build
  depends_on "libarchive"
  depends_on "qt@5"
  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "re2" => :build

  def caveats
    s = <<~EOS
      Copy `#{prefix}/Zeal.app` to /Applications to use Zeal from the MacOS Launchpad
    EOS
  end

  def install
    ENV["CMAKE_PREFIX_PATH"] = "#{Formula["qt@5"].prefix}:#{Formula["libarchive"].prefix}:#{Formula["extra-cmake-modules"].prefix}"
    ENV["LD_LIBRARY_PATH"] = Formula["re2"].lib

    Dir.mkdir "build"
    Dir.chdir "build" do
      system "cmake", ".."
      system "make"
      prefix.install "bin/Zeal.app"
      bin.write_exec_script prefix/"Zeal.app/Contents/MacOS/Zeal"
    end
  end

  test do
    system "zeal", "--version"
  end
end
