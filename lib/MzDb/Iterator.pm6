use NativeCall;

unit module MzDb::Iterator;

use MzDb::NativeTypes;

class SpectrumIterator does Iterator {

	sub libmzdb_spectrum_iterator_create(DbPtr $db, SQLite3Stmt $stmt, MzDBEntityCachePtr $entity_cache) returns SpectrumIteratorPtr is export is native(LIB) { * };

	sub libmzdb_spectrum_iterator_next(SpectrumIteratorPtr $it, SpectrumPtr $result) returns int32 is export is native(LIB) { * };

	sub libmzdb_spectrum_iterator_has_next(SpectrumIteratorPtr $it) returns int32 is export is native(LIB) { * };

	sub libmzdb_spectrum_iterator_dispose(SpectrumIteratorPtr $it) returns void is export is native(LIB) { * };

	has SpectrumIteratorPtr $!it = NULL;

	has DbPtr $.db;
	has MzDBEntityCachePtr $.entity_cache;
	has SQLite3Stmt $.stmt;

	#create the object
	method new ($db, $entity_cache, $stmt) {
    	self.bless(:$db,:$entity_cache, :$stmt);
    	$!it = libmzdb_spectrum_iterator_create($db, $stmt, $entity_cache);
    	if ($!it == NULL) { 
    		say "ERROR : spectrum creation failed ";
    		die -1;
    	}
 	}

    # Free data when the object is garbage collected. 
    submethod DESTROY {
        libmzdb_spectrum_iterator_dispose(explicitly-manage($!it));
    }

    method pull-one ( --> Mu ) {
	    if (libmzdb_spectrum_iterator_has_next($!it) != 0) {
	    	my Pointer[SpectrumPtr] $spectrum_ptr_ref;
	    	libmzdb_spectrum_iterator_next($!it, $spectrum_ptr_ref);
	    	return $spectrum_ptr_ref.deref;
	    } else {
	    		return IterationEnd;
	    }
    }

}