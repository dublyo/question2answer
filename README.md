# Question2Answer — Docker

Dockerized [Question2Answer](http://www.question2answer.org/) (Q2A) 1.8.6, a popular open-source Q&A platform for PHP/MySQL.

Pre-built Docker image with PHP 8.2, Apache, and automatic configuration from environment variables. Used by over 20,000 sites in 40 languages.

## Quick Start

```bash
docker run -d --name q2a \
  -p 80:80 \
  -e QA_MYSQL_HOSTNAME=your-mysql-host \
  -e QA_MYSQL_USERNAME=q2a \
  -e QA_MYSQL_PASSWORD=your-password \
  -e QA_MYSQL_DATABASE=question2answer \
  ghcr.io/dublyo/question2answer:latest
```

Then visit `http://localhost` to complete the setup wizard (creates database tables and admin account).

## Docker Compose

```yaml
services:
  q2a:
    image: ghcr.io/dublyo/question2answer:latest
    depends_on:
      mysql:
        condition: service_healthy
    ports:
      - "80:80"
    environment:
      QA_MYSQL_HOSTNAME: mysql
      QA_MYSQL_USERNAME: q2a
      QA_MYSQL_PASSWORD: changeme123
      QA_MYSQL_DATABASE: question2answer
    volumes:
      - q2a-content:/var/www/html/qa-content
      - q2a-blobs:/var/www/html/qa-blobs

  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: question2answer
      MYSQL_USER: q2a
      MYSQL_PASSWORD: changeme123
    volumes:
      - mysql-data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 5s
      timeout: 3s
      retries: 10

volumes:
  q2a-content:
  q2a-blobs:
  mysql-data:
```

## Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `QA_MYSQL_HOSTNAME` | Yes | — | MySQL hostname or container name |
| `QA_MYSQL_PORT` | No | `3306` | MySQL port |
| `QA_MYSQL_USERNAME` | Yes | — | MySQL user |
| `QA_MYSQL_PASSWORD` | Yes | — | MySQL password |
| `QA_MYSQL_DATABASE` | Yes | — | Database name |
| `QA_MYSQL_TABLE_PREFIX` | No | `qa_` | Table name prefix |

## How It Works

1. **Container starts** — `entrypoint.sh` generates `qa-config.php` from environment variables
2. **MySQL wait** — Waits up to 60s for MySQL to be ready
3. **Apache starts** — PHP 8.2 with MySQLi and mod_rewrite enabled
4. **First visit** — Q2A's setup wizard creates all database tables and asks for admin credentials
5. **Ready** — Your Q&A site is live with clean URLs

## Persistent Data

Mount these volumes to keep data across container restarts:

| Volume | Path | Description |
|--------|------|-------------|
| Content | `/var/www/html/qa-content` | Uploaded files |
| Blobs | `/var/www/html/qa-blobs` | Avatars and attachments |
| MySQL | `/var/lib/mysql` | Database (on MySQL container) |

## Features

- Asking and answering questions with voting and best answer selection
- Categories (up to 4 levels deep) and/or tagging
- Points-based reputation, badges, and user management
- Fast integrated search engine
- RSS feeds, email notifications, personal news feeds
- User avatars (or Gravatar) and private messages
- SEO-friendly URLs, XML Sitemaps
- Extensible with themes and plugins
- Spam protection with captchas, rate-limiting, moderation

## Dublyo PaaS

This template is available on [Dublyo](https://dublyo.com) as a one-click deploy. Deploy it with a managed MySQL database through the dashboard.

## License

GPL v2+ (original Question2Answer license)
