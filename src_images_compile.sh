#!/bin/bash
export USER_NAME=marbax
for i in ui post-py comment; do cd src/$i; bash docker_build.sh; cd -; done

#cd src/comment/ && chmod + docker_build.sh && ./docker_build.sh
#cd - && cd src/post-py/ && chmod + docker_build.sh && ./docker_build.sh
#cd - && cd src/ui && chmod + docker_build.sh && ./docker_build.sh
