# Instructions générales  : https://github.com/MartinM-dev/Sketchup_Component_Ruby_Dev/blob/master/README.md
# Instructions supplémentaires : 
# 1 - Créez un composant simple
# 2 - Sélectionnez le composant
# 3 - Exécutez le code

SKETCHUP_CONSOLE.clear # nettoie la console ruby

# Importe les fichiers nécessaires
require 'sketchup.rb'
require 'extensions.rb'

model = Sketchup.active_model # Model en cours
entities = model.entities # Toutes les entités du modèle, ajouter .first  pour avoir le premier
selection = model.selection[0] # Current selection

if selection.is_a?( Sketchup::ComponentInstance ) # test si la sélection est une instance de composant
puts "got it"
end

puts "Parent #{selection.parent}" # Retourne dans quel objet est situé la sélection
puts "Typename #{selection.typename}" # Retourne le typename de l'objet

# Les composants peuvent être des instances dans le modèle ou des definition dans la bibliothèque
# Si les attributs du composant présent dans le modèle n'ont pas été éditées par l'utilisateur, il faut chercher dans la définition comme ci desous, si elles ont été modifiées, il faut enlever le definition
puts "name #{selection.definition.name}"
puts "def attrib lenx #{selection.definition.get_attribute('dynamic_attributes', '_lenx_formula', ''.to_s)}"

# Modifie l'attribut dans la definition sélectionnée
selection.definition.set_attribute('dynamic_attributes', 'test', 'bad')
# Modifie l'attribut dans l'instance sélectionnée
selection.set_attribute('dynamic_attributes', 'test', 'badboy')

# Affiche l'attribut de la définition puis de l'instance
puts "Entity attrib test #{selection.get_attribute('dynamic_attributes', 'test', ''.to_s)}"
puts "Def attrib test #{selection.definition.get_attribute('dynamic_attributes', 'test', ''.to_s)}"

# Mcréé l'attribut dans la definition sélectionnée
selection.definition.set_attribute('dynamic_attributes', 'test2', 'DEF ATTRIB')
# Modifie l'attribut dans l'instance sélectionnée
selection.set_attribute('dynamic_attributes', 'test2', 'Entity ATTRIB')

# Affiche l'attribut de la définition puis de l'instance
puts "Entity attrib test2 #{selection.get_attribute('dynamic_attributes', 'test2', ''.to_s)}"
puts "Def attrib test2 #{selection.definition.get_attribute('dynamic_attributes', 'test2', ''.to_s)}"


puts "end"

# https://forums.sketchup.com/t/why-can-not-i-get-the-value-of-the-lenx-leny-and-lenz-dynamic-attributes-in-ruby/62275/2
