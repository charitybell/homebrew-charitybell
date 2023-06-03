class ExtractXiso < Formula
  desc "Xbox ISO Creation/Extraction utility"
  homepage "https://github.com/XboxDev/extract-xiso"
  url "https://github.com/XboxDev/extract-xiso/archive/refs/tags/build-202303040307.tar.gz"
  sha256 "6b40a0114fb9f79d9e75a4d6c80efce68e2cb0da3e93fe575ea2c7e30aa5ed57"
  license "BSD-4-Clause"
  head "https://github.com/XboxDev/extract-xiso.git", branch: "master"

  depends_on "cmake" => :build
  if OS.mac?
    depends_on xcode: :build
  else
    depends_on "gcc" => :build
    depends_on "make" => :build
  end

  def install
    Dir.mkdir "build"
    Dir.chdir("build") do
      system "cmake", ".."
      system "make"
      bin.install "extract-xiso"
    end
  end

  test do
    system "#{bin}/extract-xiso", "-h"
  end
end
