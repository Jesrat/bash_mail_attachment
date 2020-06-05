#!/usr/bin/env bash

FROM="from@example.com"
TO="to@example.com"
REPLY_TO="replyto@example.com"
SUBJET="Attach example with sendmail"

filepath="/path/to/file/test.csv"
htmlcontent="/path/to/file/message.html"


BOUNDARY=$(date +%s|md5sum)
BOUNDARY=${BOUNDARY:0:32}
filename=$(basename ${filepath})
CONTENT=$(cat <<-END
From: ${FROM}
To: ${TO}
Reply-To: ${REPLY_TO}
Subject: ${SUBJET}
Content-Type: multipart/mixed; boundary="${BOUNDARY}"

This is a MIME formatted message.  If you see this text it means that your
email software does not support MIME formatted messages, but as plain text
encoded you should be ok, with a plain text file.

--${BOUNDARY}
Content-Type: text/html; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

$(cat ${htmlcontent})

--${BOUNDARY}
Content-Type: text/csv; name="${filename}"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="${filename}"

$(cat ${filename})

--${BOUNDARY}--
END
)


echo "$CONTENT" | /usr/sbin/sendmail -t 2>/dev/null


