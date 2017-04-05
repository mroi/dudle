<?php

$name_l10n = array(
	'de'    => 'Umfragen',
	'de_DE' => 'Umfragen',
	'en'    => 'Polls',
	'en_US' => 'Polls'
);

$language = \OC::$server->getL10N(null)->getLanguageCode();
$name = array_key_exists($language, $name_l10n) ? $name_l10n[$language] : $name_l10n['en'];

\OC::$server->getNavigationManager()->add(function () use ($name) {
	$urlGenerator = \OC::$server->getURLGenerator();
	return [
		'id' => 'dudle',
		'order' => 6,
		'href' => $urlGenerator->linkToRoute('dudle_iframe'),
		'icon' => $urlGenerator->linkTo('dudle', 'appinfo/app.svg'),
		'name' => $name
	];
});
