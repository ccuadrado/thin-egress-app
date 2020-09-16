#!/usr/bin/env bash

# requirements.txt should be at /depbuild/in/requirements.txt
# output goes /depbuild/out
# DEPENDENCYLAYERFILENAME

export depbuild=${DEPBUILD:-"/depbuild"}
echo "RUNNING dependency_builder.sh"
echo "depbuild: ${depbuild}"
echo "inside dependency building container env:"
printenv

yum update -y
yum install -y zip python3-devel python3-pip


mkdir -p ${depbuild}/pkg/python


cd ${depbuild}/pkg/python || exit

pip3 install --upgrade setuptools
pip3 install -r ${WORKSPACE}/rain-api-core/requirements.txt --target .
pip3 install -r ${WORKSPACE}/lambda/requirements.txt --target .

# get rid of unneeded things to make code zip smaller
rm -rf ./*.dist-info
rm -rf pip
rm -rf docutils
rm -rf chalice/cli # cli in lambda? No way!
rm -rf botocore # included with lambda, just takes up space here
rm -rf setuptools
rm -rf tests
rm -rf easy_install.py
rm -f typing.py # MUST be removed, its presence causes error every time

cd ..
# now in pkg/


mkdir -p "${depbuild}/out"

echo "zipping dependencies to ${depbuild}/out/${DEPENDENCYLAYERFILENAME}."

ls -lah

zip -r9 "${depbuild}/out/${DEPENDENCYLAYERFILENAME}" .



echo "all done"
