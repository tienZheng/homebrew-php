class Dartsim < Formula
  desc "Dynamic Animation and Robotics Toolkit"
  homepage "https://dartsim.github.io/"
  url "https://github.com/dartsim/dart/archive/v6.6.2.tar.gz"
  sha256 "3ac648fdac0633a2ea4dac37f78e37e5ced6edc2d82c3e2e9b7d8b7793df0845"
  revision 3

  bottle do
    sha256 "76e85e3cf561b0a00af06478a1089f6b87257ca3aeb0cf942c349997b7dfabf5" => :mojave
    sha256 "45e0844026b669163df72541fb289853159fe0013819499fcaab27e367d2e5cb" => :high_sierra
    sha256 "5ab2c876c2469b9071155e27f936a83b15d101df886e98f88a76479aef8a7a3b" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "boost"
  depends_on "bullet"
  depends_on "eigen"
  depends_on "fcl"
  depends_on "flann"
  depends_on "libccd"
  depends_on "nlopt"
  depends_on "ode"
  depends_on "open-scene-graph"
  depends_on "tinyxml2"
  depends_on "urdfdom"

  needs :cxx11

  def install
    ENV.cxx11

    # Force to link to system GLUT (see: https://cmake.org/Bug/view.php?id=16045)
    system "cmake", ".", "-DGLUT_glut_LIBRARY=/System/Library/Frameworks/GLUT.framework",
                         *std_cmake_args
    system "make", "install"

    # Avoid revision bumps whenever fcl's or libccd's Cellar paths change
    inreplace share/"dart/cmake/dart_dartTargets.cmake" do |s|
      s.gsub! Formula["fcl"].prefix.realpath, Formula["fcl"].opt_prefix
      s.gsub! Formula["libccd"].prefix.realpath, Formula["libccd"].opt_prefix
    end

    # Avoid revision bumps whenever urdfdom's or urdfdom_headers's Cellar paths change
    inreplace share/"dart/cmake/dart_utils-urdfTargets.cmake" do |s|
      s.gsub! Formula["urdfdom"].prefix.realpath, Formula["urdfdom"].opt_prefix
      s.gsub! Formula["urdfdom_headers"].prefix.realpath, Formula["urdfdom_headers"].opt_prefix
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <dart/dart.hpp>
      int main() {
        auto world = std::make_shared<dart::simulation::World>();
        assert(world != nullptr);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{Formula["eigen"].include}/eigen3",
                    "-I#{include}", "-L#{lib}", "-ldart",
                    "-L#{Formula["assimp"].opt_lib}", "-lassimp",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_system",
                    "-std=c++11", "-o", "test"
    system "./test"
  end
end
