#!/bin/bash

: <<'DISCLAIMER'

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

DISCLAIMER


# Target config
HARDWARE="pi_2"
BUILDROOT_VER="2021.02"
BUILDROOT_PACKAGE="buildroot-${BUILDROOT_VER}"
BUILDROOT_URL="https://buildroot.org/downloads/"
BR2_EXTERNAL="../../external/Lark-Alarm/"

# Target Configuration
LARK_CONFIG="lark_${HARDWARE}_defconfig"

function get_buildroot
{
    # Make sure we have the buildroot tar ball
    if [ ! -e ./${BUILDROOT_PACKAGE}.tar.bz2 ]; then
        # Download buildroot
        wget ${BUILDROOT_URL}/${BUILDROOT_PACKAGE}.tar.bz2
        if [$? -ne 0 ]; then
            echo "Failed to download buildroot package: ${BUILDROOT_PACKAGE}.tar.bz2."
            exit 1
        fi
    fi
}

function extract_buildroot
{
    # Make sure hardware dir exists
    if [ ! -d ${HARDWARE} ]; then
        # Make directory
        mkdir -p ${HARDWARE}
    fi

    # Extract Buildroot into directory
    tar -C ./${HARDWARE} -xf ./${BUILDROOT_PACKAGE}.tar.bz2
    if [ $? -eq 0 ]; then
        echo "Buildroot package: ${BUILDROOT_PACKAGE}-${HARDWARE} extracted."
    fi
}

#
# Main script

# Get desired buildroot tarball
get_buildroot

# Extract the buildroot package
extract_buildroot

# Configure Buildroot
cd ${HARDWARE}/${BUILDROOT_PACKAGE}
make BR2_EXTERNAL=${BR2_EXTERNAL} ${LARK_CONFIG}
if [ $? -ne 0 ]; then
    # Failed
    echo "Failed to configure Buildroot."
    exit $?
fi

# Build the desired Target image
make BR2_EXTERNAL=${BR2_EXTERNAL} all
if [ $? -ne 0 ]; then
    # Failed
    echo
    echo "Failed to build image ${LARK_CONFIG}."
    exit $?
fi

# Finished
echo
echo "Completed building ${LARK_CONFIG}"
echo

