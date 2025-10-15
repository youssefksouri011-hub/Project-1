# MVP Banking — Étude de cas Data Analytics

## 1) Contexte & objectifs
- **Contexte** : Mise en place rapide d’un reporting banque/assurance avec données synthétiques.
- **Objectifs** : O1. Modèle BigQuery propre ; O2. 10 KPIs clés ; O3. Dashboard Looker 1 page.

## 2) Données & schéma
- **Tables** : `demo.dim_customer`, `demo.fact_events_part`
- **Grain** : événement/transaction
- **Schéma cible** : voir `docs/schema.png`

## 3) Démarrage rapide
1. Créer dataset **demo**.
2. Exécuter `sql/00_create_data.sql`.
3. Exécuter `sql/10_views.sql`.
4. Connecter Looker Studio à `demo.v_events_metrics` et `demo.v_events_details`.

## 4) Résultats attendus
- GMV, Nb events, Conversion, Avg ticket + tableaux par segment/région.
- 1 page Looker Studio (filtres Date/Segment/Région).

## 5) Stack
BigQuery · SQL · Looker Studio

## 6) Licence & données
MIT · Données synthétiques (aucune donnée perso)
