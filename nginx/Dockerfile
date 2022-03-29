FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY pay.aceitchecripto.com/pay.aceitchecripto.com /etc/nginx/sites-enabled/pay.aceitchecripto.com
COPY pay.aceitchecripto.com/ssl/dhparams.pem /etc/letsencrypt/ssl-dhparams.pem
COPY pay.aceitchecripto.com/ssl/ssl_options.conf /etc/letsencrypt/options-ssl-nginx.conf
COPY pay.aceitchecripto.com/ssl/key.pem /etc/letsencrypt/live/pay.aceitchecripto.com/privkey.pem
COPY pay.aceitchecripto.com/ssl/crt.pem /etc/letsencrypt/live/pay.aceitchecripto.com/fullchain.pem
