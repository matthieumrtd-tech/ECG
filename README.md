# Montaigne ECG — Study OS
Prototype V2 : dashboard, flashcards avec répétition espacée (SM-2 simplifié), rappels adaptatifs, suivi des sessions, tâches, statistiques, import/export JSON et interface responsive.

## Publication GitHub Pages
1. Remplace les fichiers du dépôt par ceux du ZIP (racine).
2. Vérifie Settings → Pages → `main` / `/root`.
3. Attends le déploiement puis recharge le site.

## Supabase (facultatif, à configurer)
Dans `config.js`, ajoute l'URL du projet et la clé **publishable/anon**. Ne mets jamais une clé `service_role` dans le site.
Le prototype prépare l'authentification, mais la synchronisation cloud des cartes nécessite encore une table et le code de sauvegarde associé. Les données restent dans le navigateur et sont exportables.
## Mention
Créé par Matthieu Martin.
