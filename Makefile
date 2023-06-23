PREFIX = /home/recoll

install:
		groupadd --gid 5000 recoll-data || exit 0
		useradd --shell /usr/bin/nologin --create-home \
			--home-dir /home/recoll --system \
			--gid 5000 --uid 600 \
			recoll || exit 0
		install --owner recoll --group recoll-data \
		bottle.py conftree.py webui.py webui-standalone.py webui-wsgi.py \
		"${PREFIX}/recoll-webui"
		install --owner recoll --group recoll-data static/* \
		"${PREFIX}/recoll-webui/static"
		install --owner recoll --group recoll-data views/* \
		"${PREFIX}/recoll-webui/views"
