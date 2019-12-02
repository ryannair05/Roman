#import "Interfaces.h"

NSString * convertToRomanString(int num) {
  	NSArray *r_ones = [NSArray arrayWithObjects: @"", @"I", @"II", @"III", @"IV", @"V", @"VI", @"VII", @"VIII", @"IX", nil];
    NSArray *r_tens = [NSArray arrayWithObjects: @"", @"X", @"XX", @"XXX", @"XL", @"L", nil];
	// real romans should have an horizontal   __           ___           _____
	// bar over number to make x 1000: 4000 is IV, 16000 is XVI, 32767 is XXXMMDCCLXVII...

    return [NSString stringWithFormat:@"%@%@", [r_tens objectAtIndex:num / 10],[r_ones objectAtIndex:num % 10]];
}

%hook _UIStatusBarStringView
- (void)setText:(NSString *)text {
	if([text containsString:@":"]) {
		self.adjustsFontSizeToFitWidth = YES;
		NSInteger hour = [[NSCalendar currentCalendar]  component:NSCalendarUnitHour fromDate:[NSDate date]];

		text = ([NSString stringWithFormat:@"%@:%@", 
		convertToRomanString((hour > 12) ? (hour - 12) : hour),  
		convertToRomanString([[NSCalendar currentCalendar]  component:NSCalendarUnitMinute fromDate:[NSDate date]])]);
    }	

	return %orig;
}
%end
