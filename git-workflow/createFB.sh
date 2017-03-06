#!/bin/bash -eu

# Create Git Feature Branches for PLF projects

BRANCH=jbosseap-7
ISSUE=SWF-3899
ORIGIN_BRANCH=develop
TARGET_BRANCH=feature/$BRANCH
ORIGIN_VERSION=5.0.x-SNAPSHOT
TARGET_VERSION=5.0.x-$BRANCH-SNAPSHOT
# Maven DEPMGT
DEPMGT_ORIGIN_VERSION=13-SNAPSHOT
DEPMGT_TARGET_VERSION=13.x-$BRANCH-SNAPSHOT

SCRIPTDIR=$(cd $(dirname "$0"); pwd)
CURRENTDIR=$(pwd)

SWF_FB_REPOS=${SWF_FB_REPOS:-$CURRENTDIR}

function createFB(){
  local repo_name=$1
  printf "\e[1;33m########################################\e[m\n"
  printf "\e[1;33m# Repository: %s\e[m\n" "${repo_name}"
  printf "\e[1;33m########################################\e[m\n"
  pushd ${repo_name}

  # Remove all branches but the origin one
#  git checkout ${ORIGIN_BRANCH} && git branch | grep -v "${ORIGIN_BRANCH}" | xargs git branch -d -D
  printf "\e[1;33m# %s\e[m\n" "Cleaning of ${repo_name} repository ..."
  #git checkout $ORIGIN_BRANCH
  #git branch -D $TARGET_BRANCH
  git remote update --prune
  git reset --hard HEAD
  git checkout $ORIGIN_BRANCH
  git reset --hard HEAD
  git pull
  printf "\e[1;33m# %s\e[m\n" "Testing if ${TARGET_BRANCH} branch doesn't already exists and reuse it ..."
  set +e
  git checkout $TARGET_BRANCH
  if [ "$?" -ne "0" ]; then
    git checkout -b $TARGET_BRANCH
  else
    printf "\e[1;35m# %s\e[m\n" "WARNING : the ${TARGET_BRANCH} branch already exists so we will delete it (you have 5 seconds to cancel with CTRL+C) ..."
    sleep 5
    git checkout $ORIGIN_BRANCH
    git branch -D $TARGET_BRANCH
    git checkout -b $TARGET_BRANCH
  fi
  set -e
  printf "\e[1;33m# %s\e[m\n" "Modifying versions in the POMs ..."
  
  # Project version
  $SCRIPTDIR/../replaceInFile.sh "<version>$ORIGIN_VERSION</version>" "<version>$TARGET_VERSION</version>" "pom.xml -not -wholename \"*/target/*\""

  # Project dependencies
  ## GateIn WCI
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.gatein.wci.version>$ORIGIN_VERSION</org.exoplatform.gatein.wci.version>" "<org.exoplatform.gatein.wci.version>$TARGET_VERSION</org.exoplatform.gatein.wci.version>" "pom.xml -not -wholename \"*/target/*\""

  ## CF 
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.kernel.version>$ORIGIN_VERSION</org.exoplatform.kernel.version>" "<org.exoplatform.kernel.version>$TARGET_VERSION</org.exoplatform.kernel.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.core.version>$ORIGIN_VERSION</org.exoplatform.core.version>" "<org.exoplatform.core.version>$TARGET_VERSION</org.exoplatform.core.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.ws.version>$ORIGIN_VERSION</org.exoplatform.ws.version>" "<org.exoplatform.ws.version>$TARGET_VERSION</org.exoplatform.ws.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.jcr.version>$ORIGIN_VERSION</org.exoplatform.jcr.version>" "<org.exoplatform.jcr.version>$TARGET_VERSION</org.exoplatform.jcr.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.jcr-services.version>$ORIGIN_VERSION</org.exoplatform.jcr-services.version>" "<org.exoplatform.jcr-services.version>$TARGET_VERSION</org.exoplatform.jcr-services.version>" "pom.xml -not -wholename \"*/target/*\""
 
  ## GateIn
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.gatein.sso.version>$ORIGIN_VERSION</org.exoplatform.gatein.sso.version>" "<org.exoplatform.gatein.sso.version>$TARGET_VERSION</org.exoplatform.gatein.sso.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.gatein.pc.version>$ORIGIN_VERSION</org.exoplatform.gatein.pc.version>" "<org.exoplatform.gatein.pc.version>$TARGET_VERSION</org.exoplatform.gatein.pc.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.gatein.portal.version>$ORIGIN_VERSION</org.exoplatform.gatein.portal.version>" "<org.exoplatform.gatein.portal.version>$TARGET_VERSION</org.exoplatform.gatein.portal.version>" "pom.xml -not -wholename \"*/target/*\""

  ## PLF
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.depmgt.version>$DEPMGT_ORIGIN_VERSION</org.exoplatform.depmgt.version>" "<org.exoplatform.depmgt.version>$DEPMGT_TARGET_VERSION</org.exoplatform.depmgt.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.doc.doc-style.version>$ORIGIN_VERSION</org.exoplatform.doc.doc-style.version>" "<org.exoplatform.doc.doc-style.version>$TARGET_VERSION</org.exoplatform.doc.doc-style.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.platform-ui.version>$ORIGIN_VERSION</org.exoplatform.platform-ui.version>" "<org.exoplatform.platform-ui.version>$TARGET_VERSION</org.exoplatform.platform-ui.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.commons.version>$ORIGIN_VERSION</org.exoplatform.commons.version>" "<org.exoplatform.commons.version>$TARGET_VERSION</org.exoplatform.commons.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.ecms.version>$ORIGIN_VERSION</org.exoplatform.ecms.version>" "<org.exoplatform.ecms.version>$TARGET_VERSION</org.exoplatform.ecms.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.social.version>$ORIGIN_VERSION</org.exoplatform.social.version>" "<org.exoplatform.social.version>$TARGET_VERSION</org.exoplatform.social.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.wiki.version>$ORIGIN_VERSION</org.exoplatform.wiki.version>" "<org.exoplatform.wiki.version>$TARGET_VERSION</org.exoplatform.wiki.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.forum.version>$ORIGIN_VERSION</org.exoplatform.forum.version>" "<org.exoplatform.forum.version>$TARGET_VERSION</org.exoplatform.forum.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.calendar.version>$ORIGIN_VERSION</org.exoplatform.calendar.version>" "<org.exoplatform.calendar.version>$TARGET_VERSION</org.exoplatform.calendar.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.integ.version>$ORIGIN_VERSION</org.exoplatform.integ.version>" "<org.exoplatform.integ.version>$TARGET_VERSION</org.exoplatform.integ.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.platform.version>$ORIGIN_VERSION</org.exoplatform.platform.version>" "<org.exoplatform.platform.version>$TARGET_VERSION</org.exoplatform.platform.version>" "pom.xml -not -wholename \"*/target/*\""
  $SCRIPTDIR/../replaceInFile.sh "<org.exoplatform.platform.distributions.version>$ORIGIN_VERSION</org.exoplatform.platform.distributions.version>" "<org.exoplatform.platform.distributions.version>$TARGET_VERSION</org.exoplatform.platform.distributions.version>" "pom.xml -not -wholename \"*/target/*\""
  
  printf "\e[1;33m# %s\e[m\n" "Commiting and pushing the new $TARGET_BRANCH branch to origin ..."
  git commit -m "$ISSUE: Create FB $BRANCH and update projects versions/dependencies" -a
  git push origin $TARGET_BRANCH --set-upstream
  #git checkout develop
  popd
}

pushd ${SWF_FB_REPOS}

createFB gatein-wci
createFB kernel
createFB core
createFB ws
createFB jcr
createFB jcr-services
createFB gatein-pc
createFB gatein-sso
createFB gatein-portal
createFB maven-depmgt-pom
createFB docs-style
createFB platform-ui
createFB commons
createFB social
createFB ecms
createFB wiki
createFB forum
createFB calendar
createFB integration
createFB platform
createFB platform-public-distributions
createFB platform-private-distributions
createFB platform-private-trial-distributions

popd
