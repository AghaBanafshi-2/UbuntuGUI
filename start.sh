#!/bin/bash
set -e

# جایگزینی متغیر PORT در nginx (Railway به صورت خودکار تزریق می‌کند)
envsubst '${PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# اجرای supervisor برای مدیریت همزمان ttyd، wede و nginx
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
