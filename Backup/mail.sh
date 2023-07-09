#!/bin/bash

MAIL_ACCESS='info@jingga.app'
MAIL_SECRET="$1"
MAIL_FROMNAME="JINGGA SERVER"
MAIL_FROMADDRESS="info@jingga.app"
MAIL_TONAME="Jingga Admin"
MAIL_TOADDRESS="info@jingga.app"
MAIL_SUBJECT="Log reports"
MAIL_SMTP="mail.privateemail.com"
MAIL_PORT="587"
MAIL_MESSAGE=$'This email contains automatically generated content.'
MAIL_FILE="$2"
MAIL_MIMETYPE=`file --mime-type "$MAIL_FILE" | sed 's/.*: //'`

curl                                                           \
    -v                                                         \
    --url smtps://$MAIL_SMTP:$MAIL_PORT                        \
    --ssl-reqd                                                 \
    --mail-from $MAIL_FROMADDRESS                              \
    --mail-rcpt $MAIL_TOADDRESS                                \
    --user $MAIL_ACCESS:$MAIL_SECRET                           \
    -F '=(;type=multipart/mixed'                               \
    -F "=$MAIL_MESSAGE;type=text/plain"                        \
    -F "file=@$MAIL_FILE;type=$MAIL_MIMETYPE;encoder=base64"   \
    -F '=)'                                                    \
    -H "Subject: $MAIL_SUBJECT"                                \
    -H "From: $MAIL_FROMNAME <$MAIL_FROMADDRESS>"              \
    -H "To: $MAIL_TONAME <$MAIL_TOADDRESS>"
