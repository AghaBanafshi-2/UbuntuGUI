FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    nginx \
    ttyd \
    supervisor \
    curl \
    ca-certificates \
    gettext-base \
    apache2-utils \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# نصب wede (اسکریپت رسمی، باینری را در ~/.local/bin قرار می‌دهد)
RUN curl -fsSL https://raw.githubusercontent.com/vul-os/wede/main/install.sh | bash

# انتقال باینری wede به مسیر استاندارد
RUN cp /root/.local/bin/wede /usr/local/bin/wede && chmod +x /usr/local/bin/wede

# ایجاد کاربر dev و دایرکتوری داده
RUN useradd -m -s /bin/bash dev && mkdir -p /data && chown -R dev:dev /data

# کپی فایل‌های پیکربندی
COPY nginx.conf /etc/nginx/nginx.conf.template
COPY supervisor.conf /etc/supervisor/conf.d/supervisord.conf
COPY .htpasswd /etc/nginx/.htpasswd
COPY www/ /var/www/html/
COPY start.sh /start.sh
RUN chmod +x /start.sh

# کپی پیکربندی wede به دایرکتوری خانگی dev
COPY wede.config.json /home/dev/.config/wede/wede.config.json
RUN chown -R dev:dev /home/dev/.config

EXPOSE 8080

CMD ["/start.sh"]
