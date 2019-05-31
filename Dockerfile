FROM sharelatex/sharelatex:latest

# Remove Old TexLive
RUN rm -rf /usr/local/texlive/*

# Install New TexLive
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz; \
	mkdir /install-tl-unx; \
	tar -xvf install-tl-unx.tar.gz -C /install-tl-unx --strip-components=1

# Select Full Installation
RUN echo "selected_scheme scheme-full" >> /install-tl-unx/texlive.profile; \
	/install-tl-unx/install-tl -profile /install-tl-unx/texlive.profile

# Set Links
RUN rm -r /install-tl-unx; \
	rm install-tl-unx.tar.gz && \
	ln -s /usr/local/texlive/20* /usr/local/texlive/latest


RUN apt-get update && apt-get install -y graphviz xpdf

COPY install_plantuml.sh /tmp


# Enable the "dot" and "plantuml" commands
RUN sed -i 's@^shell_escape_commands = \\$@shell_escape_commands = dot,plantuml,bash,sed,gvpr,\\@g' /usr/local/texlive/2019/texmf-dist/web2c/texmf.cnf

RUN /tmp/install_plantuml.sh && \
     rm /tmp/install_plantuml.sh

RUN cd /usr/local/texlive/2019/texmf-dist/tex/latex/graphviz && \
  mv graphviz.sty graphviz.sty.orig && \
  wget https://raw.githubusercontent.com/mprentice/GraphViz-sty/master/graphviz.sty

# Set Paths
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/texlive/latest/bin/x86_64-linux/
ENV PLANTUML_JAR /usr/local/plantuml/plantuml.jar
