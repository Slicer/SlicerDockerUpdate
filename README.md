SlicerDockerUpdate
==================

These scripts allow to:
* update the Slicer revision associated with the docker images
* build and publish the docker images

References
----------

* https://github.com/thewtex/SlicerDocker
* https://hub.docker.com/u/slicer/


Usage
-----

1. Download scripts

```
git clone git://github.com/Slicer/SlicerDockerUpdate
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

License
-------

It is covered by the Apache License, Version 2.0:

http://www.apache.org/licenses/LICENSE-2.0
