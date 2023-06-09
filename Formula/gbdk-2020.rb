class Gbdk2020 < Formula
  desc "Develpment kit for Z80 CPUs like Gameboy"
  homepage "https://gbdk-2020.github.io/gbdk-2020/"
  url "https://github.com/gbdk-2020/gbdk-2020/archive/refs/tags/4.1.1.tar.gz"
  sha256 "70f30b3ea00dd827013dd731cc1dff4e0003fa1e884f8908ccffd025c2a1d19b"
  license all_of: [
    "MIT", # png2asset
    "Zlib", # crashhandler, makebin
    :cannot_represent, # LCC
    "GPL-2.0-only" => { with: "GCC-exception-2.0" }, # GBDK library, SDCC runtime
    any_of: ["Unlicense", :public_domain], # bankpack, gbcompress, ihxcheck, makecom
  ]
  head "https://github.com/gbdk-2020/gbdk-2020.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 ventura:      "653b51ccb71115180058894336b89fdbd49eba99a62aa567d568360dd3d1526b"
    sha256 cellar: :any,                 monterey:     "4631a775e9431e8189dbfc4d5844d7c4005ac6f2d83033853a393678ca3b7cfc"
    sha256 cellar: :any,                 big_sur:      "1d81027ba88b49f27a88d38ea4e5e83aa004d7638ee23ce98edd7679276d0e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ccb15560bc4f215a48bd69d5dc16140d86173d3d14a3b4a15f95e3b761384820"
  end

  keg_only "shadows system headers"

  depends_on "doxygen" => :build
  depends_on "gcc" => :build
  depends_on "gputils" => :build
  depends_on "texinfo" => :build

  fails_with :clang do
    build 1403
    cause "Build errors with clang"
  end

  if OS.mac?
    resource "sdcc" do
      url "https://github.com/gbdk-2020/gbdk-2020-sdcc/releases/download/sdcc-13350-patched-gbdk-4.1.0/sdcc-x86_64-apple-macosx-20220402-13350--sdldz80-patched-at-12539.tar.bz2"
      sha256 "3936898bad8ab8e564b24b7bce4605fb3acb2bfc633329eb7bdac453afda69bc"
    end
  else
    resource "sdcc" do
      url "https://github.com/gbdk-2020/gbdk-2020-sdcc/releases/download/sdcc-13350-patched-gbdk-4.1.0/sdcc-amd64-linux2.5-20220402-13350--sdldz80-patched-at-12539.tar.bz2"
      sha256 "2ce1ff208ddbd7ad1ddfb1770ede48b9cb1a60d13079ba1ca0052ba5c1b51873"
    end
  end

  def install
    sdccdir = ""
    resource("sdcc").stage do |context|
      context.retain!
      sdccdir = "#{context.staging.tmpdir}/sdcc"
    end

    # we can get through most of a parallel build. when it fails, we finish the build de-parallelized
    # this is fixed in HEAD
    begin
      system "make", "SDCCDIR=#{sdccdir}"
    rescue
      ENV.deparallelize
      system "make", "SDCCDIR=#{sdccdir}"
    end

    bin.install Dir["build/gbdk/bin/*"]
    doc.install "build/gbdk/examples"
    include.install Dir["build/gbdk/include/*"]
    lib.install Dir["build/gbdk/lib/*"]
  end

  test do
    system bin/"gbdk", "--help"
  end
end
