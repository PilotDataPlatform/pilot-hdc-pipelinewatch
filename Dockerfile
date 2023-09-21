FROM python:3.7-buster
RUN groupadd --gid 1004 deploy && \
    useradd --home-dir /home/deploy \
            --create-home --uid 1004 \
            --gid 1004 --shell /bin/sh \
            --skel /dev/null deploy

ENV PYTHONDONTWRITEBYTECODE=true \
    PYTHONIOENCODING=UTF-8 \
    POETRY_VERSION=1.3.2 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_CREATE=false

ENV PATH="${POETRY_HOME}/bin:${PATH}"

RUN curl -sSL https://install.python-poetry.org | python3 -

WORKDIR /home/deploy
COPY .  ./

RUN poetry install --no-dev --no-root --no-interaction

RUN chown -R deploy:deploy /home/deploy
USER deploy
RUN chmod +x /home/deploy/worker_k8s_job_watch.py

ENV PATH="/home/deploy/.local/bin:${PATH}"

CMD ["/home/deploy/worker_k8s_job_watch.py"]
