use NativeCall;

unit module Queries;

use MzDb::NativeTypes;

sub libmzdb_open_mzdb_file(Str $mzDbFilePath, DbPtr $db is rw)
      returns int32
      is export
      is native(LIB)
      { * };

sub libmzdb_close_mzdb_file(DbPtr $db is rw)
      returns int32
      is export
      is native(LIB)
      { * };

#int create_entity_cache(sqlite3 *db, entity_cache_t** entity_cache, char **err_msg)

# TODO: add "is rw" to other queries
sub libmzdb_create_entity_cache(DbPtr $db, Pointer[MzDBEntityCachePtr] $entity_cache is rw, Pointer[Str] $err_msg is rw) 
    returns int32 
    is export
    is native(LIB) 
    { * };   


sub libmzdb_die_on_sqlite_error(int32, Str) is native(LIB) { * };


sub libmzdb_get_model_version(
  DbPtr $db,
  Pointer[Str] $model_version_ptr is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_model_version_or_die(DbPtr $db) returns Str is export is native(LIB) { * };


sub libmzdb_get_param_tree_chromatogram(
  DbPtr $db,
  Pointer[Str] $chromato_param_tree_ptr is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_param_tree_chromatogram_or_die(DbPtr $db) returns Str is export is native(LIB) { * };


sub libmzdb_get_param_tree_spectrum(
  DbPtr $db,
  int32 $spectrum_id,
  Pointer[Str] $spectrum_param_tree_ptr is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_param_tree_spectrum_or_die(DbPtr $db, int32 $spectrum_id) returns Str is export is native(LIB) { * };


sub libmzdb_get_param_tree_mzdb(
  DbPtr $db,
  MzDbParamTreePtr $param_tree_ptr is rw, 
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_param_tree_mzdb_or_die(DbPtr $db) returns Str is export is native(LIB) { * };


sub libmzdb_get_pwiz_mzdb_version(
  DbPtr $db,
  Pointer[Str] $mzdb_version_ptr is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_pwiz_mzdb_version_or_die(DbPtr $db) returns Str is export is native(LIB) { * };


sub libmzdb_get_last_time(
  DbPtr $db,
  num64 $last_time is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_last_time_or_die(DbPtr $db) returns num64 is export is native(LIB) { * };


sub libmzdb_get_max_ms_level(
  DbPtr $db,
  int32 $max_ms_level is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_max_ms_level_or_die(DbPtr $db) returns int32 is export is native(LIB) { * };;


sub libmzdb_get_bounding_boxes_count_from_sequence(
  DbPtr $db,
  int32 $bb_count is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_bounding_boxes_count_from_sequence_or_die(DbPtr $db) returns int32 is export is native(LIB) { * };


sub libmzdb_get_mz_range(
  DbPtr $db,
  int32 $ms_level,
  CArray[int32] $min_max_mz is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_mz_range_or_die(DbPtr $db, int32 $ms_level) returns CArray[int32] is export is native(LIB) { * };


sub libmzdb_get_bounding_boxes_count(
  DbPtr $db,
  int32 $bb_run_slice_id,
  int32 $bb_count is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_bounding_boxes_count_or_die(DbPtr $db, int32 $bb_run_slice_id) returns int32 is export is native(LIB) { * };


sub libmzdb_get_cycles_count(
  DbPtr $db,
  int32 $cycles_count is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_cycles_count_or_die(DbPtr $db) returns int32 is export is native(LIB) { * };


sub libmzdb_get_data_encodings_count_from_sequence(
  DbPtr $db,
  int32 $count is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_data_encodings_count_from_sequence_or_die(DbPtr $db) returns int32 is export is native(LIB) { * };


sub libmzdb_get_spectra_count_from_sequence(
  DbPtr $db,
  int32 $spectra_count is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_spectra_count_from_sequence_or_die(DbPtr $db) returns int32 is export is native(LIB) { * };


sub libmzdb_get_spectra_count(
  DbPtr $db,
  int32 $ms_level,
  int32 $spectra_count is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_spectra_count_or_die(DbPtr $db, int32 $ms_level) returns int32 is export is native(LIB) { * };


sub libmzdb_get_run_slices_count_from_sequence(
  DbPtr $db,
  int32 $run_slices_count is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_run_slices_count_from_sequence_or_die(DbPtr $db) returns int32 is export is native(LIB) { * };

sub libmzdb_get_table_records_count(
  DbPtr $db,
  Str $table_name,
  int32 $table_records_count is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_table_records_count_or_die(DbPtr $db, Str $table_name) returns int32 is export is native(LIB) { * };

sub libmzdb_get_bounding_box_data(
  DbPtr $db,
  int32 $bb_id,
  Pointer $blob_ptr is rw,
  int32 $blob_length is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_bounding_box_data_or_die(
  DbPtr $db,
  int32 $bb_id,
  int32 $blob_length is rw
  ) returns Pointer is export is native(LIB) { * };

sub libmzdb_get_chromatogram_data_points(
  DbPtr $db,
  int32 $chromato_id,
  Pointer $data_ptr is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_chromatogram_data_points_or_die(
  DbPtr $db,
  int32 $chromato_id
# TODO: return a Pointer mapping a byte array
) returns Pointer is export is native(LIB) { * };

sub libmzdb_get_bounding_box_first_spectrum_id(
  DbPtr $db,
  int32 $first_id,
  long $bb_first_spectrum_id is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns long is export is native(LIB) { * };

sub libmzdb_get_bounding_box_first_spectrum_id_or_die(
  DbPtr $db,
  int32 $first_id
  ) returns long is export is native(LIB) { * };


sub libmzdb_get_bounding_box_min_mz(
  DbPtr $db,
  int32 $bb_rtree_id,
  num32 $bb_min_mz is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_bounding_box_min_mz_or_die(
  DbPtr $db,
  int32 $bb_rtree_id
  ) returns num32 is export is native(LIB) { * };


sub libmzdb_get_bounding_box_min_time(
  DbPtr $db,
  int32 $bb_rtree_id,
  num32 $bb_min_time is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_bounding_box_min_time_or_die(DbPtr $db, int32 $bb_rtree_id) returns num32 is export is native(LIB) { * };


sub libmzdb_get_run_slice_id(
  DbPtr $db,
  int32 $bb_id,
  int32 $run_slice_id is rw,
  Pointer[Str] $err_msg_ptr is rw
) returns int32 is export is native(LIB) { * };

sub libmzdb_get_run_slice_id_or_die(DbPtr $db, int32 $bb_id) returns int32 is export is native(LIB) { * };


sub libmzdb_get_ms_level_from_run_slice_id_manually(
  DbPtr $db,
  int32 $run_slice_id,
  int32 $ms_level is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_ms_level_from_run_slice_id_manually_or_die(DbPtr $db, int32 $run_slice_id) returns int32 is export is native(LIB) { * };


sub libmzdb_get_bounding_box_ms_level(
  DbPtr $db,
  int32 $bb_id,
  int32 $bb_ms_level is rw,
  Pointer[Str] $err_msg_ptr is rw
  ) returns int32 is export is native(LIB) { * };

sub libmzdb_get_bounding_box_ms_level_or_die(DbPtr $db, int32 $bb_id) returns int32 is export is native(LIB) { * };

sub libmzdb_get_data_encoding_id(
  DbPtr $db,
  int32 $bounding_box_id,
  int32 $data_encoding_id is rw,
  Pointer[Str] $err_msg_ptr is rw
) returns int32 is export is native(LIB) { * };

sub libmzdb_get_data_encoding_id_or_die(DbPtr $db, int32 $bounding_box_id) returns int32 is export is native(LIB) { * };


sub libmzdb_get_spectrum_headers(
  DbPtr,
  CArray[Pointer[SpectrumHeader]],
  int32 is rw,
  Pointer[Str] is rw
) returns int32 is export is native(LIB) { * };

sub libmzdb_get_spectrum(
  DbPtr $db, 
  int64 $spectrum_id, 
  Pointer[MzDBEntityCachePtr] $entity_cache, 
  Pointer[SpectrumPtr] $result is rw
) returns int32 is export is native(LIB) { * };

































