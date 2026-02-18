# Dockerfile para desenvolvimento
FROM ruby:3.4.1-slim

WORKDIR /app

# Instala todas as dependências de uma vez
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
