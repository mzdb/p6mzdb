use v6;
use NativeCall;

constant LIB = "../native/libmzdb";

unit module MzDb::NativeTypes;

constant NULL is export = Pointer;

constant StrPtr is export = Pointer[Str];


class DbPtr is export is repr('CPointer')  { };

class SpectrumIteratorPtr is export is repr('CPointer')  { };


class SQLite3Stmt is export is repr('CPointer')  { };


class MzDbParamTreePtr is export is repr('CPointer')  { };

class CvParamPtr is export is repr('CPointer')  { };

class UserParamPtr is export is repr('CPointer')  { };

class UserTextPtr is export is repr('CPointer') { };

class ParamTreePtr is export is repr('CPointer') { };


class SpectrumHeader is export is repr('CStruct') {
    has int32 $id;
    has int32 $initial_id;
    has Str $title;
    has int32 $cycle;
    has num32 $time; #float binding
    has int32 $ms_level;
    has Str $activation_type;
    has num32 $tic;
    has num64 $base_peak_mz;
    has num32 $base_peak_intensity;
    has num64 $precursor_mz;
    has int32 $precursor_charge;
    has int32 $peaks_count;
    has Str $param_tree_str;
    has Str $scan_list_str; 
    has Str $precursor_list_str; 
    has Str $product_list_str; 
    has int32 $shared_param_tree_id;
    has int32 $instrument_configuration_id;
    has int32 $source_file_id;
    has int32 $run_id;
    has int32 $data_processing_id;
    has int32 $data_encoding_id;
    has int32 $bb_first_spectrum_id;
    has int32 $is_high_resolution;
};

class SpectrumPtr is export is repr('CPointer')  { };

class MzDBEntityCachePtr is export is repr('CPointer') { };



class DataEncodingsCache is export is repr('CStruct') {
    HAS CArray[Pointer] $.data_encodings; # length = number of data_encodings
    has int32 $.de_size;
    HAS CArray[Pointer] $.data_encoding_id_mapping; #[ id => idx] ; length of MAX(id) + 1
    has int32 $.mapping_size;
    HAS CArray[Pointer] $.spectrum_id_to_data_encoding_id; #[ spectrum_id => data_encoding_id] ; length of MAX(spectrum_id) + 1
    has int32 $.spectrum_count;
};

class MzDBEntityCache is export is repr('CStruct') {    
  HAS DataEncodingsCache $.data_encodings_cache;  # embedded
  HAS CArray[SpectrumHeader] $.spectrum_headers;  # embedded 
  has int32 $.spectrum_header_count;
};

enum SQLITE_RC is export (
    SQLITE_OK        =>    0 , #  Successful result
    SQLITE_ERROR     =>    1 , #  SQL error or missing database
    SQLITE_INTERNAL  =>    2 , #  Internal logic error in SQLite
    SQLITE_PERM      =>    3 , #  Access permission denied
    SQLITE_ABORT     =>    4 , #  Callback routine requested an abort
    SQLITE_BUSY      =>    5 , #  The database file is locked
    SQLITE_LOCKED    =>    6 , #  A table in the database is locked
    SQLITE_NOMEM     =>    7 , #  A malloc() failed
    SQLITE_READONLY  =>    8 , #  Attempt to write a readonly database
    SQLITE_INTERRUPT =>    9 , #  Operation terminated by sqlite3_interrupt()
    SQLITE_IOERR     =>   10 , #  Some kind of disk I/O error occurred
    SQLITE_CORRUPT   =>   11 , #  The database disk image is malformed
    SQLITE_NOTFOUND  =>   12 , #  Unknown opcode in sqlite3_file_control()
    SQLITE_FULL      =>   13 , #  Insertion failed because database is full
    SQLITE_CANTOPEN  =>   14 , #  Unable to open the database file
    SQLITE_PROTOCOL  =>   15 , #  Database lock protocol error
    SQLITE_EMPTY     =>   16 , #  Database is empty
    SQLITE_SCHEMA    =>   17 , #  The database schema changed
    SQLITE_TOOBIG    =>   18 , #  String or BLOB exceeds size limit
    SQLITE_CONSTRAINT=>   19 , #  Abort due to constraint violation
    SQLITE_MISMATCH  =>   20 , #  Data type mismatch
    SQLITE_MISUSE    =>   21 , #  Library used incorrectly
    SQLITE_NOLFS     =>   22 , #  Uses OS features not supported on host
    SQLITE_AUTH      =>   23 , #  Authorization denied
    SQLITE_FORMAT    =>   24 , #  Auxiliary database format error
    SQLITE_RANGE     =>   25 , #  2nd parameter to sqlite3_bind out of range
    SQLITE_NOTADB    =>   26 , #  File opened that is not a database file
    SQLITE_ROW       =>   100, #  sqlite3_step() has another row ready
    SQLITE_DONE      =>   101, #  sqlite3_step() has finished executing
);




















# class CvParamPtr is repr('CPointer') { *
#     # Str cv_ref;
#     # Str accession;
#     # Str name;
#     # Str value;
#     # Str unit_cv_ref;
#     # Str unit_accession;
#     # Str unit_name;
# };

# class UserParamPtr is repr('CPointer') { *
# 	# Str cv_ref;
#  #    Str accession;
#  #    Str name;
#  #    Str value;
#  #    Str type;
# };

# class UserTextPtr is repr('CPointer') { *
# 	# Str cv_ref;
# 	# Str accession;
# 	# Str name;
# 	# Str text;
# 	# Str type;
# };

# class ParamTreePtr is repr('CPointer') { *
# 	# HAS CvParamPtr $.cv_params;
# 	# HAS UserParamPtr $.user_params;
# 	# HAS UserTextPtr $.user_text;
# };

# class SpectrumHeaderPtr is repr('CPointer') { #c ptr ? *
# 	# int32 id;
# 	# int32 initial_id;
#  #    Str title;
#  #    int32 cycle;
#  #    num32 time;
#  #    int32 ms_level;
#  #    Str activation_type;
#  #    num32 tic;
#  #    double base_peak_mz;
#  #    num32 base_peak_intensity;
#  #    num64 precursor_mz;
#  #    int32 precursor_charge;
#  #    int32 peaks_count;

#  #    HAS ParamTreePtr $.param_tree;

#  #    Str scan_list_str; 
#  #    Str precursor_list_str; 
#  #    Str product_list_str; 
#  #    int32 shared_param_tree_id;
#  #    int32 instrument_configuration_id;
#  #    int32 source_file_id;
#  #    int32 run_id;
#  #    int32 data_processing_id;
#  #    int32 data_encoding_id;
#  #    int32 bb_first_spectrum_id;
#  #    int32 is_high_resolution;
# };
