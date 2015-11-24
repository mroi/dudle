<?php

$name_l10n = array(
	'de'    => 'Umfragen',
	'de_DE' => 'Umfragen',
	'en'    => 'Polls',
	'en_US' => 'Polls'
);

$language = OCP\Util::getL10N('dudle')->getLanguageCode();
$name = array_key_exists($language, $name_l10n) ? $name_l10n[$language] : $name_l10n['en'];

OCP\App::addNavigationEntry(array(
	'id' => 'dudle',
	'order' => 5,
	'href' => OCP\Util::linkToRoute('dudle_index'),
	'icon' => OCP\Util::linkTo('dudle', 'appinfo/app.svg'),
	'name' => $name
));
