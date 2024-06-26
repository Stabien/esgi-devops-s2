## Initialiser terraform

Lancer la commande `terraform init`

## Configurer sa clé ssh

Il faut, avant de lancer la fonction, changer l'id de la clé ssh (main.tf:18 et main.tf:67), `id_rsa` en `<votre_clé_ssh>`

## Configurer les credentials AWS

Pour configurer les credentials AWS, il faut remplir la variable "aws_credentials".

Ceci peut être fait de deux manières possibles :

- Décommenter la variable "aws_credentials" dans le fichier "terraform.tfvars" et remplacer les placeholders par les deux clés.
- Utiliser les variables d'environnement du shell pour set "aws_credentials" avec cette commande : `export TF_VAR_aws_credentials='{ access_key = "<your_access_key>", secret_key = "<your_secret_key>" }'`

## Lancer la config terraform

Executer les deux commandes suivantes :

- `terraform plan`
- `terraform apply`

## Accéder au serveur

Une fois que le apply est terminé, vous pouvez vérifier que le serveur est accessible via l'url : `http://<ip_instance_ec2>:3000/swagger/index.html`
Il est possible qu'il y ai une erreur 502 qui s'affiche. Si c'est le cas attendre entre 30s et 1 minute puis refresh et normalement le swagger devrait s'afficher