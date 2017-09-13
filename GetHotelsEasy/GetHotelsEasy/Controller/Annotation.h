//
//  Annotation.h
//  GetHotelsEasy
//
//  Created by admin on 2017/9/13.
//  Copyright © 2017年 self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface Annotation : NSObject<MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@end
