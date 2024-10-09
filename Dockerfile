FROM docker-registry.ebrains.eu/hdc-services-image/base-image:python-3.10.14-v1 AS pipelinewatch-image

ENV PYTHONDONTWRITEBYTECODE=true \
    PYTHONIOENCODING=UTF-8 \
    POETRY_VERSION=1.3.2 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_CREATE=false

ENV PATH="${POETRY_HOME}/bin:${PATH}"

RUN curl -sSL https://install.python-poetry.org | python3 -

COPY .  ./

RUN poetry install --no-dev --no-root --no-interaction

RUN chown -R app:app /app
USER app

RUN chmod +x /app/worker_k8s_job_watch.py

ENV PATH="/app/.local/bin:${PATH}"

CMD ["/app/worker_k8s_job_watch.py"]
