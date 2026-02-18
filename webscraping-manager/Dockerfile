# Dockerfile para desenvolvimento
FROM ruby:3.4.1-slim

WORKDIR /app

# Instala dependências do sistema + Node.js
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
      gnupg \
    && rm -rf /var/lib/apt/lists/*

# Instala Node.js 20 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Configura ambiente de desenvolvimento
ENV RAILS_ENV=development \
    BUNDLE_PATH=/usr/local/bundle \
    VITE_RUBY_HOST=0.0.0.0

# Copia Gemfile primeiro para cache de layers
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia package.json e instala dependências JS
COPY package.json package-lock.json ./
RUN npm ci

# Copia o resto da aplicação
COPY . .

# Expõe portas do Rails e Vite
EXPOSE 3000 3036

# Comando padrão
CMD ["bin/docker-startup", "bin/dev"]
