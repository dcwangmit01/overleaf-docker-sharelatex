#!/bin/sh -e

# https://www.hiroom2.com/2018/07/02/ubuntu-1804-plantuml-en/
apt-get update
apt-get install -y graphviz default-jre

mkdir -p /usr/local/plantuml
cd /usr/local/plantuml
UML=http://sourceforge.net/projects/plantuml/files/plantuml.jar/download
curl -JLO ${UML}

cat <<EOF | tee /usr/local/bin/plantuml
#!/bin/sh

java -jar /usr/local/plantuml/plantuml.jar -Djava.awt.headless=true "\$@"
EOF
chmod a+x /usr/local/bin/plantuml
