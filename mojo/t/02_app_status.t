use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $db_version = 0;
foreach my $data_file (<../db/data_v*.mysql>) {
	$data_file =~ /^\.\.\/db\/data_v(\d+)\.mysql$/;
	$db_version = $1 if $1 > $db_version;
}

ok($db_version > 0, "DB version = $db_version");
`mysql -uroot -e "drop database seccubus"`;
`mysql -uroot -e "create database seccubus"`;
`mysql -uroot -e "grant all privileges on seccubus.* to seccubus\@localhost identified by 'seccubus';"`;
`mysql -uroot -e "flush privileges;"`;
`mysql -uroot seccubus < ../db/structure_v$db_version.mysql`;
`mysql -uroot seccubus < ../db/data_v$db_version.mysql`;

my $t = Test::Mojo->new('Seccubus');
$t->get_ok('/appstatus')
	->status_is(200)
	->json_is("/0/name","Configuration file")
	->json_is("/0/result","OK")
	->json_is("/1/name","Path modules")
	->json_is("/1/result","OK")
	->json_is("/2/name","Path scanners")
	->json_is("/2/result","OK")
	->json_is("/3/name","Path bindir")
	->json_is("/3/result","OK")
	->json_is("/4/name","Path configdir")
	->json_is("/4/result","OK")
	->json_is("/5/name","Path dbdir")
	->json_is("/5/result","OK")
	->json_is("/6/name","Database login")
	->json_is("/6/result","OK")
	->json_is("/7/name","Database structure")
	->json_is("/7/result","OK")
	->json_is("/8/name","Database version")
	->json_is("/8/result","OK")
	->json_is("/9/name","HTTP authentication")
	->json_is("/9/result","OK")
	->json_is("/10/name","SMTP configuration")
	->json_is("/10/result","OK")
	->json_hasnt("/11")
	;

pass("Creating empty database");
`mysql -uroot -e "drop database seccubus"`;
`mysql -uroot -e "create database seccubus"`;
`mysql -uroot -e "grant all privileges on seccubus.* to seccubus\@localhost identified by 'seccubus';"`;
`mysql -uroot -e "flush privileges;"`;

$t->get_ok('/appstatus')
	->status_is(500)
	->json_is("/0/name","Configuration file")
	->json_is("/0/result","OK")
	->json_is("/1/name","Path modules")
	->json_is("/1/result","OK")
	->json_is("/2/name","Path scanners")
	->json_is("/2/result","OK")
	->json_is("/3/name","Path bindir")
	->json_is("/3/result","OK")
	->json_is("/4/name","Path configdir")
	->json_is("/4/result","OK")
	->json_is("/5/name","Path dbdir")
	->json_is("/5/result","OK")
	->json_is("/6/name","Database login")
	->json_is("/6/result","OK")
	->json_is("/7/name","Database structure")
	->json_is("/7/result","Error")
	->json_hasnt("/8")
	;

pass("Creating outdated database");
$db_version--;
`mysql -uroot seccubus < ../db/structure_v$db_version.mysql`;
`mysql -uroot seccubus < ../db/data_v$db_version.mysql`;

$t->get_ok('/appstatus')
	->status_is(500)
	->json_is("/0/name","Configuration file")
	->json_is("/0/result","OK")
	->json_is("/1/name","Path modules")
	->json_is("/1/result","OK")
	->json_is("/2/name","Path scanners")
	->json_is("/2/result","OK")
	->json_is("/3/name","Path bindir")
	->json_is("/3/result","OK")
	->json_is("/4/name","Path configdir")
	->json_is("/4/result","OK")
	->json_is("/5/name","Path dbdir")
	->json_is("/5/result","OK")
	->json_is("/6/name","Database login")
	->json_is("/6/result","OK")
	->json_is("/7/name","Database structure")
	->json_is("/7/result","OK")
	->json_is("/8/name","Database version")
	->json_is("/8/result","Error")
	->json_hasnt("/9")
	;


done_testing();