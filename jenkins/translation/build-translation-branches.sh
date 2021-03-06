#!/bin/bash -eu
# Script to build Translation branches:
# * X-x.x-translation
# * X-x.x-translation-jipt

set -e
mkdir -p ${WORKSPACE}/sources
arr=("gatein-portal" "platform-ui" "commons" "ecms" "social" "wiki" "forum" "calendar" "integration" "platform")
for project in "${arr[@]}"
do
  echo "Clone git repo $project of origin repository"
  cd ${WORKSPACE}/sources && /usr/bin/git clone git@github.com:exodev/$project.git
  cd ${WORKSPACE}/sources/$project && /usr/bin/git checkout -b ${GIT_PLATFORM_SOURCE_BRANCH} origin/${GIT_PLATFORM_SOURCE_BRANCH}
done

# distributions projects in exoplatform
arr=("platform-public-distributions" "platform-private-distributions")
for project in "${arr[@]}"
do
  echo "Clone git repo $project of origin repository"
  cd ${WORKSPACE}/sources && /usr/bin/git clone git@github.com:exoplatform/$project.git
  cd ${WORKSPACE}/sources/$project && /usr/bin/git checkout -b ${GIT_PLATFORM_SOURCE_BRANCH} origin/${GIT_PLATFORM_SOURCE_BRANCH}
done


SEP="`echo | tr '\n' '\001'`"
replaceInPom(){
  find ${WORKSPACE}/sources -name pom.xml -not -wholename "*/target/*" -exec sed -i "s${SEP}$1${SEP}$2${SEP}g" {} \;
}
replaceInPom "<version>${GATEIN_VERSION_IN_GIT}</version>" "<version>${GATEIN_VERSION_TO_BUILD}</version>"
replaceInPom "<version>${PLATFORM_VERSION_IN_GIT}</version>" "<version>${PLATFORM_VERSION_TO_BUILD}</version>"
replaceInPom "<org.gatein.portal.version>${GATEIN_VERSION_IN_GIT}</org.gatein.portal.version>" "<org.gatein.portal.version>${GATEIN_VERSION_TO_BUILD}</org.gatein.portal.version>"
replaceInPom "<org.exoplatform.platform-ui.version>${PLATFORM_VERSION_IN_GIT}</org.exoplatform.platform-ui.version>" "<org.exoplatform.platform-ui.version>${PLATFORM_VERSION_TO_BUILD}</org.exoplatform.platform-ui.version>"
replaceInPom "<org.exoplatform.commons.version>${PLATFORM_VERSION_IN_GIT}</org.exoplatform.commons.version>" "<org.exoplatform.commons.version>${PLATFORM_VERSION_TO_BUILD}</org.exoplatform.commons.version>"
replaceInPom "<org.exoplatform.ecms.version>${PLATFORM_VERSION_IN_GIT}</org.exoplatform.ecms.version>" "<org.exoplatform.ecms.version>${PLATFORM_VERSION_TO_BUILD}</org.exoplatform.ecms.version>"
replaceInPom "<org.exoplatform.social.version>${PLATFORM_VERSION_IN_GIT}</org.exoplatform.social.version>" "<org.exoplatform.social.version>${PLATFORM_VERSION_TO_BUILD}</org.exoplatform.social.version>"
replaceInPom "<org.exoplatform.wiki.version>${PLATFORM_VERSION_IN_GIT}</org.exoplatform.wiki.version>" "<org.exoplatform.wiki.version>${PLATFORM_VERSION_TO_BUILD}</org.exoplatform.wiki.version>"
replaceInPom "<org.exoplatform.forum.version>${PLATFORM_VERSION_IN_GIT}</org.exoplatform.forum.version>" "<org.exoplatform.forum.version>${PLATFORM_VERSION_TO_BUILD}</org.exoplatform.forum.version>"
replaceInPom "<org.exoplatform.calendar.version>${PLATFORM_VERSION_IN_GIT}</org.exoplatform.calendar.version>" "<org.exoplatform.calendar.version>${PLATFORM_VERSION_TO_BUILD}</org.exoplatform.calendar.version>"
replaceInPom "<org.exoplatform.integ.version>${PLATFORM_VERSION_IN_GIT}</org.exoplatform.integ.version>" "<org.exoplatform.integ.version>${PLATFORM_VERSION_TO_BUILD}</org.exoplatform.integ.version>"
replaceInPom "<org.exoplatform.platform.version>${PLATFORM_VERSION_IN_GIT}</org.exoplatform.platform.version>" "<org.exoplatform.platform.version>${PLATFORM_VERSION_TO_BUILD}</org.exoplatform.platform.version>"
replaceInPom "<org.exoplatform.platform.distributions.version>${PLATFORM_VERSION_IN_GIT}</org.exoplatform.platform.distributions.version>" "<org.exoplatform.platform.distributions.version>${PLATFORM_VERSION_TO_BUILD}</org.exoplatform.platform.distributions.version>"
