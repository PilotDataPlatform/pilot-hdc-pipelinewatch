#!/usr/bin/env python3

# Copyright (C) 2022-2023 Indoc Systems
#
# Licensed under the GNU AFFERO GENERAL PUBLIC LICENSE, Version 3.0 (the "License") available at https://www.gnu.org/licenses/agpl-3.0.en.html.
# You may not use this file except in compliance with the License.

from kubernetes import client
from kubernetes import config
from kubernetes.config import ConfigException

from config import get_settings
from pipelinewatch.stream_watcher import StreamWatcher


def k8s_init():
    try:
        config.load_incluster_config()
    except ConfigException:
        config.load_kube_config()
    return client.Configuration()


def get_k8s_batchapi(configuration):
    return client.BatchV1Api(client.ApiClient(configuration))


def main():
    k8s_configurations = k8s_init()
    batch_api_instance = get_k8s_batchapi(k8s_configurations)
    settings = get_settings()
    stream_watch = StreamWatcher(batch_api_instance, settings)
    stream_watch.run()


if __name__ == '__main__':
    main()
