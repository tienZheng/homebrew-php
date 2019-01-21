class Libav < Formula
  desc "Audio and video processing tools"
  homepage "https://libav.org/"
  url "https://libav.org/releases/libav-12.3.tar.xz"
  sha256 "6893cdbd7bc4b62f5d8fd6593c8e0a62babb53e323fbc7124db3658d04ab443b"
  revision 2
  head "https://git.libav.org/libav.git"

  bottle do
    cellar :any
    sha256 "2ba7f645ee21d7cf659e22d1088b5811b0fb94c5352c12f74bdf76e1b28ea4ae" => :mojave
    sha256 "2ed7f49968fc0dbfd20e2cc176438303ea4440486cb9160719ee8fa582e23a01" => :high_sierra
    sha256 "97188f142c5d4c358f191697c1d9b306594c7e8e0fa8f528e7cd398d9053fa6a" => :sierra
  end

  option "with-openssl", "Enable SSL support"
  option "with-sdl", "Enable avplay"
  option "with-theora", "Enable Theora encoding via libtheora"

  depends_on "pkg-config" => :build
  # manpages won't be built without texi2html
  depends_on "texi2html" => :build if MacOS.version >= :mountain_lion
  depends_on "yasm" => :build

  depends_on "faac"
  depends_on "fdk-aac"
  depends_on "freetype"
  depends_on "lame"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "x264"
  depends_on "xvid"

  depends_on "openssl" => :optional
  depends_on "sdl" => :optional
  depends_on "theora" => :optional

  # https://bugzilla.libav.org/show_bug.cgi?id=1033
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b6e917c/libav/Check-for--no_weak_imports-in-ldflags-on-macOS.patch"
    sha256 "986d748ba2c7c83319a59d76fbb0dca22dcd51f0252b3d1f3b80dbda2cf79742"
  end

  # Upstream patch for x264 version >= 153, should be included in libav > 12.3
  patch do
    url "https://github.com/libav/libav/commit/c6558e8840fbb2386bf8742e4d68dd6e067d262e.patch?full_index=1"
    sha256 "0fcfe69274cccbca33825414f526300a1fbbf0c464ac32577e1cc137b8618820"
  end

  # Upstream patch to fix building with fdk-aac 2
  patch do
    url "https://github.com/libav/libav/commit/141c960e21d2860e354f9b90df136184dd00a9a8.patch?full_index=1"
    sha256 "7081183fed875f71d53cce1e71f6b58fb5d5eee9f30462d35f9367ec2210507b"
  end

  def install
    args = %W[
      --disable-debug
      --disable-shared
      --disable-indev=jack
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-gpl
      --enable-libfaac
      --enable-libfdk-aac
      --enable-libfreetype
      --enable-libmp3lame
      --enable-libopus
      --enable-libvorbis
      --enable-libvpx
      --enable-libx264
      --enable-libxvid
      --enable-nonfree
      --enable-vda
      --enable-version3
    ]

    args << "--enable-libtheora" if build.with? "theora"
    args << "--enable-openssl" if build.with? "openssl"

    system "./configure", *args

    system "make"

    bin.install "avconv", "avprobe"
    man1.install "doc/avconv.1", "doc/avprobe.1"
    if build.with? "sdl"
      bin.install "avplay"
      man1.install "doc/avplay.1"
    end
  end

  test do
    # Create an example mp4 file
    system "#{bin}/avconv", "-y", "-filter_complex",
        "testsrc=rate=1:duration=1", "#{testpath}/video.mp4"
    assert_predicate testpath/"video.mp4", :exist?
  end
end
