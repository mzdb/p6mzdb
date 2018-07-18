use v6;

use NativeCall;
use MzDb::NativeTypes;
use MzDb::Queries;

class MzDb {

    has DbPtr $!db = DbPtr.new();
	has Pointer[MzDBEntityCache] $!entity_cache_ptr = Pointer[MzDBEntityCache].new();
	has $!err_msg_ptr = Pointer[Str].new(); # TODO: check potential memory leak (it maybe safer to not reuse this pointer)
	
    # Here are the actual NativeCall functions. 
    #sub Foo_init() returns FooHandle is native("foo") { * }
    #sub Foo_free(FooHandle) is native("foo") { * }
    #sub Foo_query(FooHandle, Str) returns int8 is native("foo") { * }
    #sub Foo_close(FooHandle) returns int8 is native("foo") { * }

    #TODO: private

	submethod !_check_rc_with_msg(Int $rc, Pointer $!err_msg_ptr) {
		if ($rc != SQLITE_OK) {
			die "An error occurred (RC= $rc): " ~ $!err_msg_ptr.deref;
		}
	}

	submethod !_check_rc(Int $rc) {
		if ($rc != SQLITE_OK) {
			die "An error occurred (RC= $rc)";
		}
	}
 
    # Here are the methods we use to expose it to the outside world. 
    method open(Str $mzDbFilePath) {
        my $open_rc = libmzdb_open_mzdb_file($mzDbFilePath, $!db);
        self!_check_rc($open_rc);

        libmzdb_create_entity_cache($!db, $!entity_cache_ptr, $!err_msg_ptr);

        my $rc = libmzdb_create_entity_cache($!db, $!entity_cache_ptr, $!err_msg_ptr);
        self!_check_rc_with_msg($rc, $!err_msg_ptr);

        #say "count=" ~$!entity_cache_ptr.deref.spectrum_header_count;

        #say "mzDB file opened!";
    }
    
    method close() {
        libmzdb_close_mzdb_file($!db);
    }

    # Free data when the object is garbage collected. 
    submethod DESTROY {
        libmzdb_close_mzdb_file($!db);
    }

    method get_model_version() {
		my $model_version_ptr = StrPtr.new();
		my $rc = libmzdb_get_model_version($!db, $model_version_ptr, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $model_version_ptr.deref;
    }

#     sub get_param_tree_chromatogram(
#   DbPtr $db,
#   Pointer[Str] $chromato_param_tree_ptr,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_param_tree_chromatogram() {
		my Pointer[Str] $chromato_param_tree_ptr = Pointer[Str].new();
		my $rc = libmzdb_get_param_tree_chromatogram($!db, $chromato_param_tree_ptr, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $chromato_param_tree_ptr;
	}

# sub get_param_tree_spectrum(
#   DbPtr $db,
#   int32 $spectrum_id,
#   Pointer[Str] $spectrum_param_tree_ptr,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_param_tree_spectrum(int32 $spectrum_id) {
		my Pointer[Str] $param_tree_ptr = Pointer[Str].new();
		my $rc = libmzdb_get_param_tree_spectrum($!db, $spectrum_id, $param_tree_ptr, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $param_tree_ptr;
	}


# sub get_param_tree_mzdb(
#   DbPtr $db,
#   MzDbParamTreePtr $param_tree_ptr, 
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_param_tree_mzdb() {
		my MzDbParamTreePtr $param_tree_ptr = Pointer[Str].new();
		my $rc = libmzdb_get_param_tree_mzdb($!db, $param_tree_ptr, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $param_tree_ptr;
	}


# sub get_pwiz_mzdb_version(
#   DbPtr $db,
#   Pointer[Str] $mzdb_version_ptr is rw,
#   Pointer[Str] $!err_msg_ptr is rw
#   ) returns int32 is export is native(LIB) { * };
	method get_pwiz_mzdb_version() {
		my $mzdb_version_ptr = StrPtr.new();
		my $rc = libmzdb_get_pwiz_mzdb_version($!db, $mzdb_version_ptr, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $mzdb_version_ptr.deref;
	}


# sub get_last_time(
#   DbPtr $db,
#   num64 $last_time is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_last_time() {
		my num64 $last_time;
		my $rc = libmzdb_get_last_time($!db, $last_time, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $last_time;
	}

# sub get_max_ms_level(
#   DbPtr $db,
#   int32 $max_ms_level is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_max_ms_level() {
		my int32 $max_ms_level;
		my $rc = libmzdb_get_max_ms_level($!db, $max_ms_level, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $max_ms_level;
	}

# sub get_bounding_boxes_count_from_sequence(
#   DbPtr $db,
#   int32 $bb_count is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_bounding_boxes_count_from_sequence() {
		my int32 $bb_count;
		my $rc = libmzdb_get_bounding_boxes_count_from_sequence($!db, $bb_count, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $bb_count;
	}

# sub get_mz_range(
#   DbPtr $db,
#   int32 $ms_level,
#   CArray[int32] $min_max_mz is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_mz_range(int32 $ms_level) {
		my CArray[int32] $min_max_mz = CArray[int32].new();
		my $rc = libmzdb_get_last_time($!db, $ms_level, $min_max_mz, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $min_max_mz; #deref, cpl ?
	}

# sub get_bounding_boxes_count(
#   DbPtr $db,
#   int32 $bb_run_slice_id,
#   int32 $bb_count is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_bounding_boxes_count(int32 $bb_run_slice_id) {
		my int32 $bb_count;
		my $rc =  libmzdb_get_bounding_boxes_count($!db, $bb_run_slice_id, $bb_count, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $bb_count;
	}

# sub get_cycles_count(
#   DbPtr $db,
#   int32 $cycles_count is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_cycles_count() {
		my int32 $cycle_count;
		my $rc = libmzdb_get_cycles_count($!db, $cycle_count, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $cycle_count;
	}


# sub get_data_encodings_count_from_sequence(
#   DbPtr $db,
#   int32 $count is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_data_encodings_count_from_sequence() {
		my int32 $de_count;
		my $rc = libmzdb_get_data_encodings_count_from_sequence($!db, $de_count, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $de_count;
	}

# sub get_spectra_count_from_sequence(
#   DbPtr $db,
#   int32 $spectra_count is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_spectra_count_from_sequence() {
		my int32 $spectra_count;
		my $rc = libmzdb_get_spectra_count_from_sequence($!db, $spectra_count, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $spectra_count;
	}

# sub get_spectra_count(
#   DbPtr $db,
#   int32 $ms_level,
#   int32 $spectra_count is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_spectra_count(int32 $ms_level) {
		my int32 $spectra_count;
		my $rc = libmzdb_get_spectra_count($!db, $ms_level, $spectra_count, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $spectra_count;
	}

# sub get_run_slices_count_from_sequence(
#   DbPtr $db,
#   int32 $run_slices_count is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_run_slices_count_from_sequence() {
		my int32 $run_slices_count;
		my $rc = libmzdb_get_run_slices_count_from_sequence($!db, $run_slices_count, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $run_slices_count;
	}

# sub get_table_records_count(
#   DbPtr $db,
#   Str $table_name,
#   int32 $table_records_count is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_table_records_count(Str $table_name) {
		my int32 $table_records_count;
		my $rc = libmzdb_get_table_records_count($!db, $table_name, $table_records_count, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $table_records_count;
	}

# sub get_bounding_box_data(
#   DbPtr $db,
#   int32 $bb_id,
#   Pointer $blob_ptr is rw,
#   int32 $blob_length is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
;

	method get_bounding_box_data(int32 $bb_id, int32 $blob_length is rw) {
		my Pointer[Str] $blob_ptr = Pointer[Str].new();
		my $rc = libmzdb_get_bounding_box_data($!db, $bb_id, $blob_ptr, $blob_length, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $blob_ptr;
	}


# sub get_chromatogram_data_points(
#   DbPtr $db,
#   int32 $chromato_id,
#   Pointer $data_ptr is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_chromatogram_data_points(int32 $chromato_id) {
		my Pointer $data_ptr = Pointer.new();
		my $rc = libmzdb_get_chromatogram_data_points($!db, $chromato_id, $data_ptr, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $data_ptr;
	}

# sub get_bounding_box_first_spectrum_id(
#   DbPtr $db,
#   int32 $first_id,
#   long $bb_first_spectrum_id is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns long is export is native(LIB) { * };
	method get_bounding_box_first_spectrum_id(int32 $first_id) {
		my long $bb_first_spectrum_id;
		my $rc = libmzdb_get_bounding_box_first_spectrum_id($!db, $first_id, $bb_first_spectrum_id, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $bb_first_spectrum_id;
	}


# sub get_bounding_box_min_mz(
#   DbPtr $db,
#   int32 $bb_rtree_id,
#   num32 $bb_min_mz is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_bounding_box_min_mz(int32 $bb_rtree_id) {
		my long $bb_min_mz;
		my $rc = libmzdb_get_bounding_box_min_mz($!db, $bb_rtree_id, $bb_min_mz, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $bb_min_mz;
	}

# sub get_bounding_box_min_time(
#   DbPtr $db,
#   int32 $bb_rtree_id,
#   num32 $bb_min_time is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_bounding_box_min_time(int32 $bb_rtree_id) {
		my long $bb_min_time;
		my $rc = libmzdb_get_bounding_box_min_time($!db, $bb_rtree_id, $bb_min_time, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $bb_min_time;
	}

# sub get_run_slice_id(
#   DbPtr $db,
#   int32 $bb_id,
#   int32 $run_slice_id is rw,
#   Pointer[Str] $!err_msg_ptr
# ) returns int32 is export is native(LIB) { * };
	method get_run_slice_id(int32 $bb_id) {
		my long $run_slice_id;
		my $rc = libmzdb_get_run_slice_id($!db, $bb_id, $run_slice_id, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $run_slice_id;
	}


# sub get_ms_level_from_run_slice_id_manually(
#   DbPtr $db,
#   int32 $run_slice_id,
#   int32 $ms_level is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_ms_level_from_run_slice_id_manually(long $run_slice_id) {
		my int32 $ms_level;
		my $rc = libmzdb_get_ms_level_from_run_slice_id_manually($!db, $run_slice_id, $ms_level, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $ms_level;
	}

# sub get_bounding_box_ms_level(
#   DbPtr $db,
#   int32 $bb_id,
#   int32 $bb_ms_level is rw,
#   Pointer[Str] $!err_msg_ptr
#   ) returns int32 is export is native(LIB) { * };
	method get_bounding_box_ms_level(int32 $bb_id) {
		my int32 $bb_ms_level;
		my $rc = libmzdb_get_bounding_box_ms_level($!db, $bb_id, $bb_ms_level, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $bb_ms_level;
	}

# sub get_data_encoding_id(
#   DbPtr $db,
#   int32 $bounding_box_id,
#   int32 $data_encoding_id is rw,
#   Pointer[Str] $!err_msg_ptr
# ) returns int32 is export is native(LIB) { * };
	method get_data_encoding_id(int32 $bb_id) {
		my int32 $data_encoding_id;
		my $rc = libmzdb_get_bounding_box_ms_level($!db, $bb_id, $data_encoding_id, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		return $data_encoding_id;
	}

# sub get_spectrum_headers(DbPtr $db, CArray[Pointer[SpectrumHeader]] $spectrum_headers, int32 $spectrum_header_count is rw, Pointer[Str] $err_msg)
	method get_spectrum_headers() {
		my $spectrum_headers = CArray[Pointer[SpectrumHeader]].new; #CArray[Pointer[SpectrumHeader]]
		my int32 $spectrum_header_count;
		my $rc = libmzdb_get_spectrum_headers($!db, $spectrum_headers, $spectrum_header_count, $!err_msg_ptr);
		self!_check_rc_with_msg($rc, $!err_msg_ptr);

		my SpectrumHeader $sh = SpectrumHeader.new;
		$sh = $spectrum_headers[0].deref;
		say $sh.id;

		#say $spectrum_headers[0].$id;

		return $spectrum_headers; #count in not return
	}

# sub get_spectrum(DbPtr $db, int64 $spectrum_id, MzDBEntityCachePtr $entity_cache, Pointer[SpectrumPtr] $result);
	method get_spectrum(int64 $spectrum_id) {
		my Pointer[SpectrumPtr] $result = Pointer[SpectrumPtr].new();
		my $rc = libmzdb_get_spectrum($!db, int64($spectrum_id), $!entity_cache_ptr, $result);
		self!_check_rc_with_msg($rc, 'unknow error');

		return $result;
	}


# 	sub get_spectrum(
#   DbPtr $db, 
#   int64 $spectrum_id, 
#   MzDBEntityCachePtr $entity_cache, 
#   Pointer[SpectrumPtr] $result is rw
# ) returns int32 is export is native(LIB) { * };

}
