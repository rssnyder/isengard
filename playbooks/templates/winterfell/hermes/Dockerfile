FROM nousresearch/hermes-agent:latest

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        calibre \
        ffmpeg \
        libopus0 \
    && rm -rf /var/lib/apt/lists/*

# Discord voice support (PyNaCl and opus bindings are pulled by discord.py[voice]).
RUN uv pip install --python /opt/hermes/.venv/bin/python --no-cache \
    "discord.py[voice]>=2.7.1,<3" \
    "aiohttp>=3.13.3,<4"
