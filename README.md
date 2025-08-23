# SlicerDockerUpdate

[![Actions Status][actions-badge]][actions-link]

This repository automates keeping the
[SlicerDocker](https://github.com/Slicer/SlicerDocker) images in sync with the
[Slicer](https://github.com/Slicer/Slicer) source tree.

It provides:

- Scripts to update the Slicer revision used in the Docker images.
- A GitHub Actions workflow to build and publish the images to Docker Hub.
- Legacy cron-based scripts for manual/server-side scheduling.

Published images are available on [Docker Hub](https://hub.docker.com/u/slicer/).

## References

* https://github.com/Slicer/SlicerDocker
* https://hub.docker.com/u/slicer/

## Usage

### Automated (preferred)

The `Build and Publish` workflow in this repository is scheduled to run
daily at **04:30 UTC**, roughly 30 minutes after the
[`update-slicer-preview-branch`](https://github.com/Slicer/Slicer/blob/main/.github/workflows/update-slicer-preview-branch.yml)
workflow in the Slicer repository publishes the `nightly-main` branch.

You can also trigger the workflow manually from the GitHub UI with two inputs:

- `slicer_ref`: The Slicer branch or ref to build from (default: `nightly-main`).
- `force_build`: If `true`, rebuild and publish even if no changes were detected
  in SlicerDocker.

### Legacy scripts (manual/cron)

As an alternative to GitHub Actions, the original scripts can still be
used to run updates manually or with `cron`.

1. Download scripts

  ```
  git clone https://github.com/Slicer/SlicerDockerUpdate
  ```

2. Configure GitHub token used to update Slicer revision

  ```
  cd SlicerDockerUpdate
  echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" > SLICERDOCKER_GITHUB_TOKEN
  ```

3. Initialize

  ```
  ./setup.sh
  ```

4. Add a crontab entry

  ```
  0 21 * * * /bin/bash /home/kitware/Packaging/SlicerDockerUpdate/cronjob.sh >/home/kitware/Packaging/SlicerDockerUpdate/cronjob-log.txt 2>&1
  ```

## License

It is covered by the Apache License, Version 2.0:

http://www.apache.org/licenses/LICENSE-2.0

<!-- prettier-ignore-start -->
[actions-badge]:            https://github.com/Slicer/SlicerDockerUpdate/actions/workflows/build-and-publish.yml/badge.svg?branch=main
[actions-link]:             https://github.com/Slicer/SlicerDockerUpdate/actions/workflows/build-and-publish.yml
<!-- prettier-ignore-end -->
