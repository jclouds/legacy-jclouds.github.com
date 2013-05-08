jekyll build
if [ ! -d "site-content" ]; then
  svn co https://svn.apache.org/repos/asf/incubator/jclouds/site-content
else
  svn up site-content
fi
cp -r _site/* site-content/
#jekyll copy site-content to _site so remove it
rm -rf site-content/site-content
rm site-content/deploy-site.sh
#add new files
cd site-content
svn st | grep ? | awk '{print $2}'| xargs svn --no-auto-props add {} \;
svn ci --no-auth-cache --username $1 --password $2 -m'deploy jclouds site content'
