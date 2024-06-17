<script setup lang="ts">
	//imports
	import { computed, ref, unref } from 'vue'
	import type {Repository, Resource} from 'st-sparql-explorer'
	import {StsResourceSelector as MaListe} from 'st-sparql-explorer/components'
	import {NSelect, type SelectOption} from 'naive-ui'

	//props
	interface Properties {
		explorer: Repository
		types: ArrayLike<Resource>&Iterable<Resource>
	}

	//variables
	const properties 	= defineProps<Properties>()
	const explorer 		= unref(properties.explorer)
	const types 		= unref(properties.types)
	type TypeOption 	= SelectOption & {resource:Resource}
	const options		= computed<TypeOption[]>(() => {
		const result : TypeOption[]= []
		for(const type of types) {
			result.push({
				label: type.label || type.iri,
				value: type.iri,
				resource: type
			})
		}
		return result;
	})
	const selected		= ref<Resource>(types[0])
	const clicked 		= ref<String>("je ne sais pas")

	//functions
	//fonction pour envoyer l'element selectionné
	function onSelect(resource : Resource) {
		console.log('selected '+resource.iri)
		clicked.value = resource.label || resource.iri
	}

	//fonction pour mettre a jour les resultats
	function onUpdate(value: string, option: TypeOption) {
		selected.value = option.resource
	}
</script>

<template>
	<header>
		<div class="wrapper">
			<hr>
			<h1>filtres</h1>
			<n-select v-model="selected.iri" :options="options" @update:value="onUpdate" />
			<ma-liste :explorer="explorer" :type="selected" @selected="onSelect">
				<template #header>
					<h1>Les resultats</h1>
				</template>
			</ma-liste>
		</div>
    </header>
</template>

<style scoped>
	header {
	line-height: 1.5;
	}

	@media (min-width: 1024px) {
		header {
			display: flex;
			place-items: center;
			padding-right: calc(var(--section-gap) / 2);
		}

		header .wrapper {
			display: flex;
			place-items: flex-start;
			flex-wrap: nowrap;
			flex-direction: column;
		}
	}
</style>
