#!/bin/bash -xe

# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

TAG=$1

# Only merge release tag if it's not on a stable branch
if $(git branch -r --contains "$TAG" | grep "stable/" >/dev/null)
then
    echo "Tag $TAG was pushed to a stable branch, ignoring."
else
    git config user.name "OpenStack Proposal Bot"
    git config user.email "openstack-infra@lists.openstack.org"
    git config gitreview.username "proposal-bot"

    git review -s
    git checkout master
    git reset --hard origin/master
    git merge --no-edit -s ours $TAG
    # Get a Change-Id
    GIT_EDITOR=true git commit --amend
    git review -R -y -t merge/release-tag
fi
