#!/usr/bin/env bash
# ----------------------------------------------------------------------------------------------------------------------
# The MIT License (MIT)
#
# Copyright (c) 2018-2019 Ralph-Gordon Paul. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the 
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit 
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the 
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# ----------------------------------------------------------------------------------------------------------------------

set -e

#=======================================================================================================================
# settings

declare LIBRARY_VERSION=1.70.0

declare CONAN_USER=appcom
declare CONAN_CHANNEL=stable
declare CONAN_REPOSITORY=appcom-oss

#=======================================================================================================================
# globals

declare ABSOLUTE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

declare MACOS_SDK_VERSION=$(xcodebuild -showsdks | grep macosx | awk '{print $4}' | sed 's/[^0-9,\.]*//g')

#=======================================================================================================================

function extractZipArchive()
{
    rm -rf "${ABSOLUTE_DIR}/conan" || true
    mkdir "${ABSOLUTE_DIR}/conan"
    
    echo "Extracting boost-macos-sdk${MACOS_SDK_VERSION}-clang-${LIBRARY_VERSION}.zip ..."
    unzip -q "${ABSOLUTE_DIR}/boost-macos-sdk${MACOS_SDK_VERSION}-clang-${LIBRARY_VERSION}.zip" -d "${ABSOLUTE_DIR}/conan"
}

#=======================================================================================================================

function createThinFiles()
{
	cd "${ABSOLUTE_DIR}/conan/lib"

	for file in *.a; do
		echo "lipo -extract $1 $file -output $file"
		lipo -extract $1 $file -output $file
    done

    cd "${ABSOLUTE_DIR}"
}

#=======================================================================================================================

function createConanPackage()
{
    conan export-pkg . boost/${LIBRARY_VERSION}@${CONAN_USER}/${CONAN_CHANNEL} -s os=Macos \
        -s os.version=${MACOS_SDK_VERSION} -s compiler=apple-clang -s compiler.libcxx=libc++ -s build_type=Release \
        -s arch=$1
}

#=======================================================================================================================

function uploadConanPackages()
{
	conan upload boost/${LIBRARY_VERSION}@${CONAN_USER}/${CONAN_CHANNEL} -r ${CONAN_REPOSITORY} --all
}

#=======================================================================================================================

function cleanup()
{
    rm -r "${ABSOLUTE_DIR}/conan"
}

#=======================================================================================================================

extractZipArchive
#createThinFiles x86_64
createConanPackage x86_64
cleanup

uploadConanPackages
