filter = {}
poems = {}
poemList = {}

module "filter", {
	setup: () ->
		poemList.poe = { meta: {
			Active: false
			Author: 'Edgar Allan Poe'
			Title: 'The Raven'
			Year: '1845'
			Language: 'English'
			Code: 'poe'
		}}
		poemList.vrch = { meta: {
			Active: false
			Author: 'Jaroslav Vrchlický'
			Title: 'Havran'
			Year: '1845'
			Language: 'Czech'
			Code: 'vrch'
		}}
		poemList.muz = { meta: {
			Active: false
			Author: 'Augustin Eugen Mužík'
			Title: 'Havran'
			Year: '1885'
			Language: 'Czech'
			Code: 'muz'
		}}
		poemList.dolu = { meta: {
			Active: false
			Author: 'Karel Dostál Lutinov'
			Title: 'Havran'
			Year: '1918'
			Language: 'Czech'
			Code: 'dolu'
		}}

		angular.module('sideBySide').service('poems', () ->
			@all = [
				poemList.poe
				poemList.vrch
				poemList.muz
				poemList.dolu
			]
			@getActive = () ->
				(poem for poem in @all when poem.meta.Active is true)
			@getInactive = () ->
				(poem for poem in @all when poem.meta.Active is not true)
			@
		)

		filter = angular.injector(['ng', 'sideBySide']).get('filter')
}

test "get filter for poems that share a common property", () ->
	poemList.dolu.meta.Active = true
	poemList.vrch.meta.Active = true
	poemList.muz.meta.Active = true
	filter.update()

	deepEqual filter.getFilter(), {
		'Language': [ 'Czech' ]
	}