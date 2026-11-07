MONTAIGNE ECG V2 — compte + synchronisation

1) Supabase (offre Free)
- Crée un projet sur https://supabase.com
- Project Settings > API : copie Project URL et anon/public key.
- Colle-les dans config.js (NE JAMAIS utiliser service_role).
- SQL Editor : exécute supabase-schema.sql.
- Authentication > URL Configuration : ajoute https://matthieumrtd-tech.github.io/ECG/ aux Redirect URLs.
- Authentication > Providers > Email : active Email. Si confirmation email activée, confirme l'adresse avant connexion.

2) GitHub
- Dans le dépôt ECG, remplace index.html, app.js, style.css, manifest.json par ceux du ZIP.
- Ajoute config.js et supabase-schema.sql.
- Commit changes : Pages redéploie automatiquement.

3) Sur le site : Se connecter > Créer un compte. Utilise le même compte sur Mac et iPhone.
Les flashcards, tâches et compteur de révisions sont synchronisés.

Tout est utilisable dans les quotas gratuits GitHub Pages + Supabase Free. Supabase Free peut mettre en pause un projet après une période d'inactivité. La clé anon/public est prévue pour le navigateur, les règles RLS protègent les données par utilisateur.
