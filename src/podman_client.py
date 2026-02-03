import os

from podman import PodmanClient


def get_podman_client() -> PodmanClient:
    try:
        return PodmanClient.from_env()
    except Exception:
        uid = os.getuid()
        return PodmanClient(base_url=f"unix:///run/user/{uid}/podman/podman.sock")
