|newRepository|
Smalltalk vm maxExternalSemaphoresSilently: 1000.
newRepository := IceRepositoryCreator new
				repository: nil;
				location: '.' asFileReference ;
				createRepository .
newRepository register.

CombinationsFinder appFolder: './build' asFileLocatorOrReference ensureCreateDirectory.
CombinationsFinder exportApp.
