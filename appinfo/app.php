<?php

$name = array(
	'de' => 'Umfragen',
	'en' => 'Polls'
);

OCP\App::addNavigationEntry(array(
	'id' => 'dudle',
	'order' => 5,
	'href' => OCP\Util::linkToRoute('dudle_index'),
	'icon' => OCP\Util::linkTo('dudle', 'appinfo/app.svg'),
	'name' => $name[OCP\Util::getL10N('dudle')->getLanguageCode()]
));
