# Utilitaire de gestion de serveur

## Commandes disponibles

* logrotate
  * `logrotate:consumer:add` &rarr; Ajout de la configuration logrotate pour un consumer
  * `logrotate:php:add` &rarr; Ajout de la configuration logrotate pour un pool PHP
* mysql
  * `mysql:db:create` &rarr; Création d'une base de données MySQL
  * `mysql:user:add` &rarr; Ajout d'un utilisateur MySQL
  * `mysql:user:allow` &rarr; Donne tous les droits à un utilisateur MySQL sur une base de données
* php
  * `php:pool` &rarr; Ajout d'un pool PHP
* postgresql
  * `postgresql:db:create` &rarr; Création d'une base de données PostgreSQL
  * `postgresql:user:add` &rarr; Ajout d'un utilisateur PostgreSQL
* systemd
  * `systemd:symfony:consumer` &rarr; Ajout d'un consumer Symfony
* user
  * `user:add` &rarr; Ajout d'un utilisateur système
  * `user:remove` &rarr; Suppression d'un utilisateur système

## Initialisation d'un projet global

* Créer un fichier de projet dans `config/` en le nommant `[nom du projet].ini`
* lancer la commande `./server-utils project:init [nom du projet]`

## Mise à jour d'un projet

* Modifier le fichier de projet dans `config/[nom du projet].ini`
* lancer la commande `./server-utils project:update [nom du projet]`

## Fonctionnement

### Logrotate

### MySQL

### PHP

### PostgreSQL

### SystemD

### Utilisateur
