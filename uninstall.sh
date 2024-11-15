#!binbash

# Directory waar de kustomize-bestanden zich bevinden
KUSTOMIZE_DIR=kustomize-techlab

# Controleer of de directory bestaat
if [ ! -d $KUSTOMIZE_DIR ]; then
  echo Directory $KUSTOMIZE_DIR bestaat niet.
  exit 1
fi

# Voer kustomize build uit en verwijder de resources
kubectl delete -k $KUSTOMIZE_DIR

# Controleer of de delete opdracht succesvol was
if [ $ -eq 0 ]; then
  echo Resources succesvol verwijderd.
else
  echo Er is een fout opgetreden bij het verwijderen van de resources.
  exit 1
fi
