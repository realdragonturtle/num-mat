FROM julia:latest

RUN apt-get -qq update && apt-get -y install git bzip2 unzip
WORKDIR /root
COPY *.toml /root/
COPY src/ /root/src
RUN julia --project=@. -e 'import Pkg; Pkg.instantiate()'
COPY test/ /root/test
RUN julia --project=test/coverage -e 'import Pkg; Pkg.develop(Pkg.PackageSpec(path=pwd())); Pkg.instantiate();'
COPY docs/ /root/docs
RUN julia --project=docs -e 'import Pkg; Pkg.develop(Pkg.PackageSpec(path=pwd())); Pkg.instantiate();'