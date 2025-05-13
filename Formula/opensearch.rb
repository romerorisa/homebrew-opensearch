class Opensearch < Formula
  desc "Open-source distributed and RESTful search engine"
  homepage "https://opensearch.org/"
  url "https://github.com/romerorisa/OpenSearch/archive/refs/heads/opensearch-2.19.1.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
  license "Apache-2.0"

  depends_on "openjdk@21"
  depends_on "gradle" => :build

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix
    system "./gradlew", "assemble"
    tarball = Dir["distribution/archives/tar/build/distributions/opensearch-*.tar.gz"].first
    odie "Could not find OpenSearch tarball!" unless tarball
    mkdir "stage"
    system "tar", "-xzf", tarball, "-C", "stage", "--strip-components=1"
    libexec.install Dir["stage/*"]
    bin.install_symlink libexec/"bin/opensearch"
  end

  test do
    system "#{bin}/opensearch", "--version"
  end
end