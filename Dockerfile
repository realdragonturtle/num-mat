FROM julia:1.6

RUN apt-get -qq update && apt-get -y install git bzip2
WORKDIR /root
COPY *.toml /root/
COPY src/ /root/
RUN julia --project=/root -e 'import Pkg; Pkg.instantiate()'
COPY test/ /root/
RUN julia --project=/root/test/coverage -e 'import Pkg; Pkg.instantiate(); Pkg.build();'
COPY docs/ /root/
RUN julia --project=/root/docs -e 'import Pkg; Pkg.instantiate(); Pkg.build();'