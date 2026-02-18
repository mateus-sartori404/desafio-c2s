# Dockerfile para desenvolvimento
FROM ruby:3.4.1-slim

WORKDIR /app

# Instala dependências do sistema + Chromium para scraping
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libpq-dev \
      postgresql-client \
      libyaml-dev \
      pkg-config \
      curl \
      ca-certificates \
      redis-tools \
      # Dependências do Chromium
      chromium \
      fonts-liberation \
      libnss3 \
      libatk1.0-0 \
      libatk-bridge2.0-0 \
      libcups2 \
      libdrm2 \
      libxkbcommon0 \
      libxcomposite1 \
      libxdamage1 \
      libxrandr2 \
      libgbm1 \
      libasound2 \
      libpangocairo-1.0-0 \
      libgtk-3-0 \
      xvfb \
    && rm -rf /var/lib/apt/lists/*

# Configura ambiente de desenvolvimento
ENV RAILS_ENV=development \
    BUNDLE_PATH=/usr/local/bundle

# Copia Gemfile primeiro para cache de layers
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia o resto da aplicação
COPY . .

# Expõe a porta do Rails
EXPOSE 3000

# Comando padrão
CMD ["bin/docker-startup", "bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
