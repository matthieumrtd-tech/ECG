# Montaigne ECG

Application personnelle de révisions ECG. Le dépôt d’origine était un prototype local avec répétition inspirée de SM-2 et une interface de compte sans synchronisation fonctionnelle.

## Préparation réalisée

- PWA : manifeste, cache hors ligne, icônes SVG/PNG, métadonnées iOS.
- Matières : mathématiques appliquées, ESH, anglais, allemand, culture générale.
- Import JSON/CSV/TXT/Markdown avec ajout et déduplication des cartes.
- Connexion Supabase par email, sauvegarde locale hors ligne, envoi au retour en ligne, fusion par identifiant et écoute temps réel.
- Schéma SQL prévu avec RLS, accès propriétaire et fusion atomique par RPC.

## Avant d’utiliser le cloud

Le client est configuré avec l’URL du projet et sa clé publishable. Le schéma `supabase-schema.sql` a été exécuté sur le projet Supabase Montaigne ECG. Une vérification HTTP anonyme a confirmé que la table et la fonction RPC sont refusées au rôle `anon`. Aucun mot de passe de base ni clé secrète n’est présent dans les fichiers.

Créer un compte depuis **Compte & synchro**. Si Supabase demande la confirmation email, confirmer l’adresse avant la première connexion. Les données locales sont fusionnées avec celles du compte ; exporte un JSON avant une première synchronisation si tu veux garder une sauvegarde supplémentaire.

## Limites actuelles

- Répétition espacée : variante simplifiée de SM-2, pas FSRS.
- PDF/DOCX et création automatique de cartes à partir des cours ne sont pas implémentés.
- Le déploiement GitHub Pages de cette copie n’a pas été effectué. Le flux de synchronisation n’a pas encore été testé avec un compte utilisateur authentifié.
