class IgnitionTransport < Formula
  desc "Transport middleware for robotics"
  homepage "http://ignitionrobotics.org"
  url "http://gazebosim.org/distributions/ign-transport/releases/ignition-transport-1.4.0.tar.bz2"
  sha256 "bc612e9781f9cab81cc4111ed0de07c4838303f67c25bc8b663d394b40a8f5d4"
  revision 1

  head "https://bitbucket.org/ignitionrobotics/ign-transport", :branch => "ign-transport1", :using => :hg

  bottle do
    #root_url "http://gazebosim.org/distributions/ign-math/releases"
    root_url "http://px4-travis.s3.amazonaws.com/toolchain/bottles"
    cellar :any
    sha256 "78e60436cc225404e2545ba98e759320d4bc99406efb16d1d58c4492b59eee0d" => :el_capitan
    sha256 "bee72083247413b7ccb888820a5c6e832a549656d70decf9ac9ad86cc7367cdd" => :yosemite
    rebuild 1
    sha256 "ac779bcb5d7fdefd44e69f2e038c98a48f400f7e6bb69bd369b385cd9007894a" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => [:build, :optional]
  depends_on "pkg-config" => :run

  depends_on "ignition-tools"
  depends_on "protobuf"
  depends_on "protobuf-c" => :build
  depends_on "ossp-uuid"
  depends_on "zeromq"
  depends_on "cppzmq"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <ignition/transport.hh>
      int main() {
        ignition::transport::Node node;
        return 0;
      }
    EOS
    system "pkg-config", "ignition-transport1"
    cflags = `pkg-config --cflags ignition-transport1`.split(" ")
    system ENV.cc, "test.cpp",
                   *cflags,
                   "-L#{lib}",
                   "-lignition-transport1",
                   "-lc++",
                   "-o", "test"
    system "./test"
  end
end
