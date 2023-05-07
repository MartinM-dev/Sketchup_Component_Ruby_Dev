#SKETCHUP_CONSOLE.clear()																		#Pour nettoyer la console
require 'csv'																					#Import les fonctions CSV

def analyze(entity)
  
	entityLayerName = entity.layer.name
	
	#On check l'entitée et on traite les données si possible	
	if entityLayerName != "Layer0" && $visible_layers.include?(entityLayerName)												#Si le calque n'est pas Layer0, on regarde si le calque est visible
		ligne = [entityLayerName,entity.definition.name.split("#").first,entity.name.split("#").first,entity.parent.name]	#On insère les données dans une ligne		
		$definitionsInfos << ligne																							#On insère la ligne dans un tableau
		#puts "yes it is (#{entity.definition.name}) (#{entity.name}) (#{entity.layer.name}) "								#On indique dans la console les données insérées
	end
  
	#Si il y'a des entitées nestead, on check l'intérieur
	entity.definition.entities.each{|subentity|													#Pour chaque entity trouvée, on créé un objet subentity
		isGroupOrComponentAnalyse(subentity)													#On regarde si c'est un groupe ou composant et analyse
	}

end

def isVisibleLayerFolder(layerFolder, layerName)
	if layerFolder.visible?																		#Regarde si le dossier de balise est visible
		if layerFolder.folder																	#Regarde si il y'a un dossier de balise dans le dossier de balise
			layerFolder = layerFolder.folder													#Créé une variable avec le dossier de balise en cours d'analyse
			isVisibleLayerFolder(layerFolder, layerName)										#Appelle la fonction d'analyse de dossier de layer et passe en argument le nom du dossier et de la balise	
		else
			$visible_layers<< layerName															#Si il n'y a plus de dossier de balise et que celuici est visible, alors le calque est visible, on insert dans la liste
		end
	end																							#Si le dossier de balise n'est pas visible, on arrête de chercher
end

def exportCSV()

	$definitionsInfos = []																		#On créé une variable pour stocker les infos des definitions (s = array)

	model = Sketchup.active_model																#Raccourcis vers le model
	
	#liste les calques visible
	$visible_layers = []																		#On créé une variable pour stocker les calques visibles
	model.layers.each { |layer| 																#Pour chacun des layers
		if layer.visible?																		#Si le layer est visible
			layerName = layer.name																#Créé une variable avec le nom du layer en cours d'analyse
			if layer.folder																		#On regade si il est dans un dossier de layer
				layerFolder = layer.folder														#Créé une variable avec le dossier de balise en cours d'analyse
				isVisibleLayerFolder(layerFolder, layerName) 									#Appelle la fonction d'analyse de dossier de layer et passe en argument le nom du dossier et de la balise		
			else
				$visible_layers<< layerName														#On stock le nom dans la liste des layer visibles
			end
		end
		}
	
	#On regade chaque entiées
	entities = model.active_entities															#On récupère toutes les entities dans le model
	entities.each{ |entity|  																	#Pour chaque entity trouvée, on créé un objet Entity
		isGroupOrComponentAnalyse(entity)														#On regarde si c'est un groupe ou composant et analyse
	}

	#On génère le CSV
	CSV.open("donnees.csv", "wb") do |csv|													#Création du fichier CSV
		csv << ["Layer","Type","Nom","Localitée"]														#Insertion de l'entête de colonnes
		$definitionsInfos.each do |ligne|													#On récupère chaque entrée de definitionsInfos
			csv << ligne																	#On insère chaque ligne dans le fichier csv
		end
	end 																					# Ferme CSV automatiquement
 
	#on ouvre le fichier csv
	pid = spawn('notepad.exe donnees.csv')													#Permet l'ouverture du fichier créé
	Process.detach(pid)																		#Détache la commande du programme pour que Sketchup n'attende pas la fermeture du notrepad.

end

def isGroupOrComponentAnalyse(subentity)													#Fonction pour savoir si l'entity est un groupe ou composant, et lancer l'analyse si c'est un groupe ou composant

	if subentity.is_a?(Sketchup::ComponentInstance) || subentity.is_a?(Sketchup::Group)		#On cherche à savoir si subentity est un groupe ou un composant
		analyze(subentity)																	#Si oui, on analyze
	end

end

################################
## Creation du menu ############
################################
if( not file_loaded?("test.rb") )															#Si le fichier test.rb n'est pas déjà chargé
	tool_menu = UI.menu("Plugins")															#on va dans le menu Plugins
	tool_menu.add_item("Export CSV") { exportCSV }											#on créé un menu Export CSV qui lance la fonction exportCSV
	file_loaded("test.rb")																	#on indique que test.rb est chargé
end




#https://forums.sketchup.com/t/get-a-list-with-all-the-components-in-component-browser/212896/4

#https://forums.sketchup.com/t/count-and-manipulate-groups-nested-in-a-component/150984
#all_used_compos = model.definitions.find_all{|d| !d.group? && !d.image? && d.instances[0] } 


# https://forums.sketchup.com/t/how-to-get-all-entities-with-the-specific-tag/192624/3
# next unless entity.layer == @active_layer

          # @tag_entities << entity
