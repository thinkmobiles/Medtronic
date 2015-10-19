//
//  ErrorsTable.m
//  home
//
//  Created by Hanna Dutkiewicz on 12-04-24.
//  Copyright (c) 2012 Looksoft Sp. z o. o. All rights reserved.
//

#import "ErrorsTable.h"

@implementation ErrorsTable


+ (ErrorsTable *) sharedSingleton{
    static ErrorsTable * singleton;
	
	@synchronized(self){
		if (!singleton) {
			singleton = [[ErrorsTable alloc] init];
            
		}
		return singleton;
	}
}


- (id) init{
    self = [super init];
    errorCodes = [[NSMutableDictionary alloc] init];
    
    [errorCodes setObject:@"Błąd połączenia z serwerem. Spróbuj ponownie później." forKey:@"00"];
    
    [errorCodes setObject:@"Błędny e-mail." forKey:@"01"];
    
    [errorCodes setObject:@"Nie udało się przesłać danych do serwera. Spróbuj ponownie później." forKey:@"02"];
    
    [errorCodes setObject:@"Błąd połączenia z serwerem. Spróbuj ponownie później." forKey:@"03"];
    
    [errorCodes setObject:@"Użytkownik o podanym adresie e-mail nie istnieje w bazie. Sprawdź wpisane dane." forKey:@"04"];
    
    [errorCodes setObject:@"Podano błędne hasło." forKey:@"05"];
    
    return self;
}


- (NSString *) getStringForError: (NSString *) code{
    return [errorCodes objectForKey: code];
}

@end
