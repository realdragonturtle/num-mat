FROM julia:latest

RUN apt-get -qq update && apt-get -y install git bzip2
WORKDIR /root
COPY *.toml /root/
COPY src/ /root/
RUN julia --project=@. -e 'import Pkg; Pkg.instantiate()'
COPY test/ /root/
RUN julia --project=test/coverage -e 'import Pkg; Pkg.instantiate(); Pkg.build();'
COPY docs/ /root/
RUN julia --project=docs -e 'import Pkg; Pkg.instantiate(); Pkg.build();'