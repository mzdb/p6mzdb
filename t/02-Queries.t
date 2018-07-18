use v6;
use lib '../lib';
use NativeCall;
use Test;

use MzDb;
use MzDb::NativeTypes;
use MzDb::Queries;

my DbPtr $db = DbPtr.new();
my MzDBEntityCachePtr $entity_cache_ptr = MzDBEntityCachePtr.new();
my Pointer[Str] $err_msg = Pointer[Str].new();

plan 6;

my $mzdb = MzDb.new();

subtest {
    plan 1;

	lives-ok( {$mzdb.open("D:/Dev/libmzdb/qtcreator_workspace/data/OVEMB150205_12.raw.mzDB")}, "open the DB" );

}, "Open";

subtest {
    plan 2;

	is($mzdb.get_model_version(), "0.7", "check the model version");

	is($mzdb.get_pwiz_mzdb_version(), "0.9.10-beta", "check the pwiz version");

}, "Versions";

subtest {
	plan 16;

	is-approx($mzdb.get_last_time(), 240.863494873047, "check the last time");

	is($mzdb.get_max_ms_level(), 2, "check get_max_ms_level");

	is($mzdb.get_bounding_boxes_count_from_sequence(), 3406, "check the bbox count from sequence");

	is($mzdb.get_bounding_boxes_count(1), 1035, "check the bbox count w/ spectrum id: 1");

	is($mzdb.get_cycles_count(), 158, "check the cycle count");

	is($mzdb.get_data_encodings_count_from_sequence(), 7, "check the data encodings count from sequence");

	is($mzdb.get_spectra_count_from_sequence(), 1193, "check the spectrum count from sequence");

	is($mzdb.get_spectra_count(1), 158, "check the spectra count w/ ms_level: 1");
	
	is($mzdb.get_spectra_count(2), 1035, "check the spectra count w/ ms_level: 2");

	is($mzdb.get_run_slices_count_from_sequence(), 161, "check the run slices count from sequence");

	is($mzdb.get_table_records_count("run_slice"), 161, "check the table count w/ table: run_slice");

	# TODO: get_chromatogram_data_points(int32 $chromato_id)

	is($mzdb.get_bounding_box_first_spectrum_id(1024), 1009, "check the bbox first spectrum id count w/ first id: 1024");

	# TODO: is($mzdb.get_mz_range(1), @values, "check the mz range of the spectrum id : 1");

	# TODO: get_bounding_box_min_mz(int32 $bb_rtree_id) => bb rtree ?

	# TODO: get_bounding_box_min_mz(int32 $bb_rtree_id) => bb rtree ?

	# TODO: get_bounding_box_min_time(int32 $bb_rtree_id) => bb rtree ?

	is($mzdb.get_run_slice_id(777), 23, "check the run slice id w/ bb id: 777");

	is($mzdb.get_ms_level_from_run_slice_id_manually(45), 1, "check the ms level from a run slice id w/ run slice id: 45");

	is($mzdb.get_bounding_box_ms_level(72), 1, "check the bbox ms level w/ bb id: 72");

	is($mzdb.get_data_encoding_id(3), 2, "check the bbox data encoding id w/ bb id: 3");

}, "Simple Getter";

subtest {

	plan 1;

	lives-ok( {$mzdb.get_spectrum_headers()}, "check if the function get spectrum header process without crashing");

	#lives-ok( {$mzdb.get_spectrum(1)}, "check if the function get spectrum process without crashing");

}, "Spectrum Getter";

subtest {
	plan 0;

	# TODO: lives-ok( {$mzdb.get_param_tree_chromatogram()}, "request the param tree chromatogram");

	# TODO: lives-ok ( {$mzdb.get_param_tree_spectrum(1)}, "request the param tree spectrum w/ spectrum_id = 1");

	# TODO: lives-ok( {$mzdb.get_param_tree_mzdb()}, "request the param tree mzdb");

	}, "Tree Getter";

subtest {
    plan 1;

	lives-ok( {$mzdb.close()}, "close the DB" );

}, "Close";



# subtest {
#     plan 3;

# 	nok( open_mzdb_file("D:/Dev/libmzdb/qtcreator_workspace/data/OVEMB150205_12.raw.mzDB", $db), "open the DB" );

# 	nok( create_entity_cache($db, $entity_cache_ptr, $err_msg), "create the entity cache");

# 	nok( close_mzdb_file($db), "close the DB" ); #deref doesn't work

# }, "Open/Close";

# subtest {
#     plan 4;

# 	my Pointer[Str] $model_version = Pointer[Str].new();
# 	nok(get_model_version($db, $model_version, $err_msg), "try to get the model version");
# 	is($model_version.deref, "0.7", "check the model version");


# 	my Pointer[Str] $pwiz_version = Pointer[Str].new();
# 	nok(get_pwiz_mzdb_version($db, $pwiz_version, $err_msg), "try to get the pwiz version");
# 	is($pwiz_version.deref, "0.9.10-beta", "check the pwiz version");

# }, "Versions";

