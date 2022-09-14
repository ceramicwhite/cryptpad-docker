#!/bin/sh

set -e

CPAD_HOME="/cryptpad"

  # If cryptad conf isn't provided
   if [ ! -f "$CPAD_CONF" ]; then
  
     cp $CPAD_HOME/config/config.example.js "$CPAD_CONF"

     sed -i  -e "s@\(httpUnsafeOrigin:\).*[^,]@\1 'http://${INTERNAL_MAIN_DOMAIN:-localhost:3000}'@" \
             -e "s@//httpAddress: '::'@httpAddress: '$HTTP_ADDRESS'@" \
             -e "s@installMethod: 'unspecified'@installMethod: '${INSTALL_METHOD:-docker}'@" \
             -e "s@\(^ *\).*\(disableIntegratedEviction:\).*[^,]@\1\2 ${DISABLE_INTEGRATED_EVICTION:-true}@" \
             -e "$ removeDonateButton: true" \
             -e "s@\(^ *\).*\(maxUploadSize:\).*[^,]@\1\2 ${MAX_UPLOAD_SIZE:-100 * 1024 * 1024}@" "$CPAD_CONF"
  fi


    test -f $CPAD_HOME/customize/application_config.js || cp $CPAD_HOME/customize.dist/application_config.js $CPAD_HOME/customize/application_config.js


exec "$@"
