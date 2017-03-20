//
//  LyricViewController.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/4/4.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#import "LyricViewController.h"
#import "LyricTableViewCell.h"

@interface LyricViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _needsLocation;
}
@property (weak, nonatomic) IBOutlet UITableView *lyricTableView;
@property(nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,assign) NSInteger currentLocation;

@end

@implementation LyricViewController

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)resetLoaction
{
    _currentLocation = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lyricTableView.delegate = self;
    self.lyricTableView.dataSource = self;
    self.lyricTableView.backgroundColor = [UIColor clearColor];
    [self.lyricTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LyricTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    self.lyricTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Method

-(void)parserLyric
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    if (self.dataSource.count != 0) {
        [self.dataSource removeAllObjects];
        [self resetLoaction];
    }
    
    if (self.lyric.length != 0 && self.lyric != nil) {
        NSArray * snips = [self.lyric componentsSeparatedByString:@"\n"];

        [snips enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray * arr = [obj componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"【】[]"]];
            if (arr.count > 2) {
                NSDictionary * oneLyric = @{@"time":arr[1],@"word":arr[2]};
                [self.dataSource addObject:oneLyric];
            }
           
        }];
        
       [self.lyricTableView reloadData];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyricTableViewCell * myCell = (LyricTableViewCell *)cell;
    if (indexPath.item == _currentLocation) {
        myCell.lyricLabel.font = [UIFont systemFontOfSize:16];
    }else{
        myCell.lyricLabel.font = [UIFont systemFontOfSize:13];
    }
}

-(void)locationLyric:(CMTime)location
{
    if (_currentLocation -1 <0 && _currentLocation +1 >= self.dataSource.count) {
        return;
    }
    
    CGFloat timeNum = [self secondsOfTime];
    
    CGFloat songTime = CMTimeGetSeconds(location);
    
    if (songTime - timeNum > 30) {
        CGFloat lastDiff = 999;
        while (1) {
            if (_currentLocation +1 >= self.dataSource.count) {
                break;
            }
            _currentLocation ++;
            if (fabs([self secondsOfTime] - songTime) > lastDiff) {
                _currentLocation --;break;
            }
            lastDiff = fabs([self secondsOfTime] - songTime);
        }
    }else if(songTime - timeNum < -30){
        CGFloat lastDiff = 999;
        while (1) {
            if (_currentLocation -1 <0) {
                break;
            }
            _currentLocation --;
            if (fabs([self secondsOfTime] - songTime) > lastDiff) {
                _currentLocation ++;break;
            }
            lastDiff = fabs([self secondsOfTime] - songTime);
        }
    }
    
    if (fabs(songTime - timeNum) > 10) {
        if (songTime > timeNum) {
            _currentLocation += 1;
        }else{
            _currentLocation -= 1;
        }
        _needsLocation = YES;
        if (_currentLocation < 0 || _currentLocation >= self.dataSource.count) {
            return;
        }
    }
    
    if (_needsLocation) {
       [self.lyricTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentLocation inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        _needsLocation = NO;
    }
    
}

-(CGFloat)secondsOfTime
{
    if (_currentLocation < 0) {
        _currentLocation = 0;
    }
    if (_currentLocation >= self.dataSource.count) {
        _currentLocation = self.dataSource.count -1;
    }
    
    NSDictionary * dict = self.dataSource[_currentLocation];
    NSString * time = dict[@"time"];
    NSArray * timeComponentArr = [time componentsSeparatedByString:@":"];
    
    __block CGFloat timeNum = 0;
    
    [timeComponentArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            timeNum += [obj floatValue] * 60;
        }
        if (idx == 1) {
            timeNum += [obj floatValue];
        }
    }];
    
    return timeNum;
}

#pragma mark TableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource.count == 0 || self.dataSource == nil) {
        return 1;
    }
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyricTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
//    cell.backgroundColor = [UIColor clearColor];
//    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    cell.textLabel.frame = cell.contentView.bounds;
    
    if (self.dataSource.count != 0) {
        NSDictionary * oneLyric =  self.dataSource[indexPath.item];
        cell.lyricLabel.text = oneLyric[@"word"];
    }else{
        if (indexPath.item == 0) {
            cell.lyricLabel.text = @"没有歌词";
        }else{
            cell.lyricLabel.text = @"";
        }
    }
    
    return cell;
}

-(void)setLyric:(NSString *)lyric
{
    if (_lyric != lyric) {
        _lyric = lyric;
        [self parserLyric];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
