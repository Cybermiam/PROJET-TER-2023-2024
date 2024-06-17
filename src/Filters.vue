<script setup lang="ts">
	//imports
	import { ref, unref } from 'vue'
	import type {Repository, Resource} from 'st-sparql-explorer'
	import type SparqlJsQuery from './Model/sparqlJsQuery.js';
	import { defineEmits } from 'vue'
	import {NSelect, type SelectOption} from 'naive-ui'

	//props
	interface Properties {
		query : SparqlJsQuery
		explorer: Repository
		types: ArrayLike<Resource>&Iterable<Resource>
	}

	//variables
	const properties 	= defineProps<Properties>()
	const types 		= unref(properties.types)
	const filtersDisplayMap 	= ref<Map<string, SelectOption[]>>(new Map());
	const emit = defineEmits(['propertyChanged'])
	const testVisible = ref<boolean>(false)
	const options		= getTypesObjectsForFirstType()
	const allDataMap = ref<Map<string, Map<string, {value:string|null, options: SelectOption[] }>>>(new Map())
	const firstType = ref<string>("")
	const remainingTypes = ref<{label : string, visible : boolean}[]>([])
	const isFirstTypeSelected = ref<boolean>(false)

	//appel initial pour récupérer les filtres
	getAllfilters()

	//functions

	//fonction pour récupérer les filtres
	async function getAllfilters() {
		var typesString = ref<string[]>([])
		for (var type of types) {
			if (type.label) {
				typesString.value.push(type.label)
			}
		}
		console.log(typesString.value)
		var dataVar = await properties.query.getAllfilters(typesString.value)
		allDataMap.value = dataVar
		testVisible.value = true
	}

	//fonction pour récupérer les types sous forme d'objet pour le select
	function getTypesObjectsForFirstType() {
		const result : {label : string, value : string}[]= []
		for(const type of types) {
			if (type.label) {
				result.push({label : type.label, value : type.label})
			}
		}
		return result;
	}

	//fonction pour mettre a jour le premier type et notifier les autres composants
	function firstTypeSelected(value: string) {
		remainingTypes.value = []
		filtersDisplayMap.value.clear()
		isFirstTypeSelected.value = true
		if (value) {
			firstType.value = value
		}
		console.log(firstType.value)
		for (var type of types) {
			if (type.label != firstType.value) {
				if (type.label){
					remainingTypes.value.push({label : type.label, visible : false})
				}
			}
		}
		emit('propertyChanged', filtersDisplayMap.value, firstType.value);
	}

	//fonction pour enregistrer les actions sur les propriétés
	function onPropertyUpdate(property: string, options : SelectOption[]) {
		if (options == null) {
			return
		}
		filtersDisplayMap.value.set(property, options);
		if (filtersDisplayMap.value.get(property)?.length === 0) {
			filtersDisplayMap.value.delete(property);
		}
		console.log("propertyChanged va faire emit "+filtersDisplayMap.value)
		emit('propertyChanged', filtersDisplayMap.value, firstType.value);
	}

	//fonction pour enregistrer les actions sur les types supplémentaires
	function handleTypeCheckboxUpdate(value: string) {
		for (var type of remainingTypes.value) {
			type.visible = false;
		}
		for (var key of value)
		{
			for (var type of remainingTypes.value) {
				if (type.label === key) {
					type.visible = true;
				} 
			}
		}
		for (var type of remainingTypes.value) {
			if (!type.visible) {
				for (var property of allDataMap.value.get(type.label)!.keys()) {
					filtersDisplayMap.value.delete(property)
				}
			}
		}
		console.log(filtersDisplayMap.value)
	}
</script>

<template>
	<header>
    <div class="container wrapper">
		<h1>filtres</h1>	
		<label for="typeDonnee">Type de données voulu</label>
		<n-select name="typeDonnee" :options="options" @update:value="firstTypeSelected" />
		<div class="grid">
			<div v-for="[property, object] in allDataMap.get(firstType)" :key="firstType+property">
				<label for="property1">{{property}}</label>
				<n-select multiple :max-tag-count="1" :options="object.options" @update:value="(v:string[],o:SelectOption[]) => onPropertyUpdate(property, o)" />
			</div>
		</div>	
			<!-- CE CODE PERMET DE SELECTIONNER DES TYPES SUPPLEMENTAIRES, NE PAS SUPPRIMER, SERVIRA EN CAS DE MISE A JOUR DES REQUETES
				<div v-if="isFirstTypeSelected">
					<p>Types de fltres supplémentaires : </p>
					<n-checkbox-group @update:value="handleTypeCheckboxUpdate" class="is-flex is-flex-direction-row is-flex-wrap-wrap">
						<div v-for="type in remainingTypes">
							<n-checkbox :value="type.label" :label="type.label"></n-checkbox>
						</div>
					</n-checkbox-group>
					

					<div v-for="object in remainingTypes">
						<div v-if="object.visible">
							<h2>Propriétés de {{ object.label }}</h2>
							<div v-for="[property, options] in allDataMap.get(object.label)">
								<label for="property2">{{property}}</label>
								<n-select name="property2" multiple :max-tag-count="1" :options="options.options" @update:value="(v:string[],o:SelectOption[]) => onPropertyUpdate(property, o)" />
							</div>		
						</div>
					</div>
				</div> -->
		</div>
		<div ref="filters" class="is-flex is-flex-direction-row is-flex-wrap-wrap">	
			<div v-for="[property, options] in filtersDisplayMap" class="ml-1">
				<span class="tag is-light mt-1 mb-2 p-4">
					{{ property }} : 
					<span class="tag is-warning is-light ml-1" v-for="line in options">
						{{ line.label }} 
					</span>
				</span>
			</div>
		</div>
	</header>
</template>

<style scoped>
	header {
	line-height: 1.5;
	}
	@media (min-width: 1024px) {
	}
</style>
