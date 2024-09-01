class Gap < Formula
  desc "System for computational discrete algebra"
  homepage "https://www.gap-system.org/"
  url "https://github.com/gap-system/gap/releases/download/v4.13.1/gap-4.13.1.tar.gz"
  sha256 "9794dbdba6fb998e0a2d0aa8ce21fc8848ad3d3f9cc9993b0b8e20be7e1dbeba"
  license "GPL-2.0-or-later"

  # Note: options are not allowed in Homebrew/homebrew-core as they
  # are not tested by CI.
  option "with-singular", "Install singular, and all packages using it"
  if build.with? "singular"
    depends_on "singular"
  end

  option "with-pari", "Install pari/gp, and all packages using it"
  if build.with? "pari"
    depends_on "pari"
  end

  option "with-xgap", "Install xgap, and all dependencies"
  if build.with? "xgap"
    depends_on "xquartz-wm"
    depends_on "libx11"
    depends_on "libxt"
    depends_on "libxaw"
  end

  # Required by some packages
  option "with-autogen", "Run autogen.sh if available"
  if build.with? "autogen"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  head do
    url "https://github.com/gap-system/gap.git", branch: "master"
    depends_on "autoconf" => :build # required by packages below
  end


  depends_on "gmp"
  # GAP cannot be built against the native macOS version of readline
  # it requires either GNU readline, or no readline at all; but
  # the latter leads to an inferior user experience.
  # So we depend on GNU readline here.
  depends_on "readline"

  # for packages
  depends_on "cddlib"   # CddInterface
  depends_on "curl"     # curlInterface
  depends_on "fplll"    # float
  depends_on "libmpc"   # float
  depends_on "mpfi"     # float
  depends_on "mpfr"     # float, normalizinterface
  depends_on "ncurses"  # browse
  depends_on "zeromq"   # ZeroMQInterface
  depends_on "singular" # many packages
  depends_on "pari"     # many packages

  def install

    # # Run special commands after installation
    # special_packages = {
    #   # Even with x11 installed, it doesn't seem to work
    #   # "xgap" => "cp bin/xgap.sh $GAPROOT/bin/xgap.sh",
    # }

    # These two packages either don't build or don't work
    # "cddinterface", "xgap",
    exclude_packages = [ "xgap", "cddinterface", ]

    # Start actually building GAP
    if build.head?
      system "./autogen.sh"
    end

    libexec.install Dir["pkg"]

    system "./configure", "--prefix", libexec/"gap", "--with-readline=#{Formula["readline"].opt_prefix}"
    if build.head?
      system "make", "bootstrap-pkg-full"
      # system "make", "doc"      # Do we need this?
    end
    system "make", "install"

    # Create a symlink `bin/gap` from the `gap` binary
    bin.install_symlink libexec/"gap/bin/gap" => "gap"

    ohai "Building included packages. Please be patient, it may take a while"
    pkg_dir = "#{libexec}/pkg"

    cd libexec/"pkg" do

      all_packages = Dir.glob("*")

      system "mkdir", "#{libexec}/gap/lib/gap/pkg/"

      # The makefiles appear to only be used for docs...
      # The BuildPackages.sh script didn't call them
      all_packages.each do |pkg|

        if exclude_packages.include?(pkg)
          ohai "Skiping package #{pkg} b/c it's in #{exclude_packages}"
          next
        else
          ohai "Installing package #{pkg}"
        end

        system "cp", "-R", pkg, "#{libexec}/gap/lib/gap/pkg/"
        cd pkg do
          if File.exist?("./prerequisites.sh")
            system "./prerequisites.sh", "#{libexec}/gap/lib/gap"
          end
          if File.exist?("./configure")
            system "./configure", "--with-gaproot=#{libexec}/gap/lib/gap"
            system "make"
            system "cp", "-R", "bin/", "#{libexec}/gap/lib/gap/pkg/#{pkg}"
          end
        end
      end

    end
  end

  test do
    ENV["LC_CTYPE"] = "en_GB.UTF-8"
    system bin/"gap", "-r", "-A", "#{libexec}/tst/testinstall.g"
  end

end
