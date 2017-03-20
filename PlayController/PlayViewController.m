//
//  PlayViewController.m
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/28.
//  Copyright © 2016年 Xavier. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "Masonry.h"
#import "CommonHeader.h"
#import "PlayListViewController.h"
#import "LyricViewController.h"
#import "PortraitViewController.h"
#import "PlayViewController.h"
#import "UIImageView+WebCache.h"
#import "ConfigureManager.h"
#import "ApiParser.h"
#import "Song.h"
#import "DownloadManager.h"
#import "SongListManager.h"

@interface PlayViewController ()<UIScrollViewDelegate>
{
    BOOL _needReloadSong;
}

@property(nonatomic,strong) AVPlayer * player;
@property(nonatomic,strong) UIActivityIndicatorView * activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *maxTime;

@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *singerName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UISlider *soundVolume;
@property (weak, nonatomic) IBOutlet UIButton *playMode;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property(nonatomic,strong) SongModel * currentModel;

@property(nonatomic,strong) UIImageView * bgView;
@property(nonatomic,weak) PortraitViewController * portraitVc;
@property(nonatomic,weak) LyricViewController * lyricVc;
@property(nonatomic,weak) PlayListViewController * listVc;
@property(nonatomic,strong) NSArray * viewControllers;
@end

static PlayViewController * sharedPlayViewController;

@implementation PlayViewController

@synthesize currentPlayList = _currentPlayList;

+(PlayViewController *)sharedPlayViewController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlayViewController = [[PlayViewController alloc]init];
    });
    return sharedPlayViewController;
}

-(UIImageView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    }
    return _bgView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self checkPlayList];
    [self loadBack];
    //[self refreshSongInfo];
}

-(void)checkPlayList
{
   if (self.currentPlayList.count == 0) { _currentPlaySong = -1; }
}

-(void)refreshSongInfo
{
    if (self.view == nil) {
        [self loadViewIfNeeded];
    }
    
    if (_currentPlaySong != -1 && _needReloadSong) {
        self.currentModel = self.currentPlayList[_currentPlaySong];
        
        if ([_currentModel isKindOfClass:[Song class]]) {
            Song * song = (Song *)_currentModel;
            self.currentModel = [[SongModel alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:song.model options:NSJSONReadingMutableContainers error:nil] error:nil];
        }
        self.songName.text = _currentModel.title;
        self.singerName.text = _currentModel.author;
        self.controlBar.songTitleLabel.text = _currentModel.title;
        self.controlBar.singerNameLabel.text = _currentModel.author;
        self.lyricVc.lyric = _currentModel.lyric;
        [self setState:PlayStatePlaying];
        _needReloadSong = NO;
    }else{
        self.songName.text = @"当前没有歌曲";
        self.singerName.text = @"没有哦 ╮(╯_╰)╭";
        self.lyricVc.lyric = nil;
        [self.portraitVc timerStop];
        [self setState:PlayStateStop];
    }
}

-(void)loadBack
{
    //self.bgView.image = [UIImage imageNamed:[ConfigureManager sharedConfigureManager].theme];
    self.bgView.backgroundColor = [UIColor blackColor];
    
    if (self.bgView.superview == nil) {
        [self.view insertSubview:self.bgView atIndex:0];
    }
}

-(void)loadPortraitImage
{
    if (_currentPlaySong != -1) {
        if (_currentModel.data_pic_big) {
            self.portraitVc.portrait.image = [UIImage imageWithData:_currentModel.data_pic_big];
        }else if(_currentModel.pic_big){
            [self.portraitVc.portrait sd_setImageWithURL:[NSURL URLWithString:_currentModel.pic_big]];
        }
    }
}

-(void)restorePlayState
{
    if (self.currentPlayList.count != 0 && self.currentPlaySong != -1) {
        return;
    }
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    self.mode = [ud integerForKey:@"playMode"];
    self.currentPlayList = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"currentPlayList"]];
    self.currentPlaySong = [ud integerForKey:@"currentPlaySong"] !=0 ?[ud integerForKey:@"currentPlaySong"]:-1;
}

-(void)storePlayState
{
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:self.mode forKey:@"playMode"];
    [ud setInteger:self.currentPlaySong forKey:@"currentPlaySong"];
    
    @try {
        NSData * listData = [NSKeyedArchiver archivedDataWithRootObject:self.currentPlayList];
        [ud setObject:listData forKey:@"currentPlayList"];
    }
    @catch (NSException *exception) {
        [ud setObject:nil forKey:@"currentPlayList"];
        NSLog(@"%@",exception);
    }
    
    [ud synchronize];
}

-(void)dealloc
{
    [self storePlayState];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.bounds = [UIScreen mainScreen].bounds;
    self.soundVolume.hidden = YES;
    [self restorePlayState];
    
    PlayListViewController * listVc = [[PlayListViewController alloc]init];
    LyricViewController * lyricVc = [[LyricViewController alloc]init];
    PortraitViewController * portraitVc = [[PortraitViewController alloc]init];
    
    [self addChildViewController:listVc];
    
    [listVc setNumberOfPlayList:^NSInteger{
        return self.currentPlayList.count;
    }];

    [listVc setModelOfIndexPath:^id(NSIndexPath *indexPath) {
        id theSong = self.currentPlayList[indexPath.item];
        if ([theSong isKindOfClass:[Song class]]) {
            Song * song = theSong;
            return [[SongModel alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:song.model options:NSJSONReadingMutableContainers error:nil] error:nil];
        }else{
            return theSong;
        }
    }];
    
    [self addChildViewController:lyricVc];
    [self addChildViewController:portraitVc];
    
    self.portraitVc = portraitVc;
    self.listVc = listVc;
    self.lyricVc = lyricVc;
    
    [self addObserver:portraitVc forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    
    self.viewControllers = @[listVc,portraitVc,lyricVc];
    
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    
    CGFloat viewWidth = self.scrollView.bounds.size.width;
    CGFloat viewHeight = self.scrollView.bounds.size.height;
    
    for (UIViewController * vc in self.viewControllers) {
        NSInteger index = [self.viewControllers indexOfObject:vc];
        UIView * view = vc.view;
        view.frame = CGRectMake(index * viewWidth, 0, viewWidth, viewHeight);
        [self.scrollView addSubview:view];
    }
    
    [self switchPage:1];
    
    self.scrollView.contentSize = CGSizeMake(self.viewControllers.count * viewWidth, viewHeight);
    self.scrollView.delegate = self;
    
    [self.progressSlider addTarget:self action:@selector(progressDidChange:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenPlayerState:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [self.controlBar.nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlBar.previewButton addTarget:self action:@selector(preview:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlBar.playOrPauseButton addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Method

-(void)listenPlayerState:(NSNotification *)notify
{
    if ([notify.name isEqualToString:AVPlayerItemDidPlayToEndTimeNotification]) {
        [self next:nil];
    }
}

-(void)progressDidChange:(UISlider *)slider
{
    CMTime time = CMTimeMake(self.player.currentItem.duration.value * slider.value, self.player.currentItem.duration.timescale);
    
    [self.player seekToTime:time];
    
    //[self.lyricVc resetLoaction];
}

-(NSInteger)scrollOffset
{
    return self.scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
}

-(void)switchPage:(NSInteger)page
{
    self.scrollView.contentOffset = CGPointMake(page * self.scrollView.frame.size.width, 0);
}

#pragma mark ScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = [self scrollOffset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(AVPlayer *)player
{
    if (_player == nil) {
        _player = [[AVPlayer alloc]init];
        
        AVAudioSession * session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        
        WeakSelf(weakSelf);
        
        [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 6) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float currentTime = weakSelf.player.currentItem.currentTime.value*1.0/
            weakSelf.player.currentItem.currentTime.timescale;
            float toltalTime = weakSelf.player.currentItem.duration.value*1.0/
            weakSelf.player.currentItem.duration.timescale;
            weakSelf.progressSlider.value = currentTime*1.0/toltalTime;
            weakSelf.currentTime.text = [weakSelf CMTimeToNSStringOfMinute:weakSelf.player.currentTime];
            weakSelf.maxTime.text = [weakSelf CMTimeToNSStringOfMinute:weakSelf.player.currentItem.duration];
            
            [weakSelf.lyricVc locationLyric:weakSelf.player.currentTime];
            
//            if (fabs(CMTimeGetSeconds(weakSelf.player.currentItem.duration) - CMTimeGetSeconds(weakSelf.player.currentTime))<0.2) {
//                [weakSelf next:nil];
//            }
            weakSelf.controlBar.progressView.progress = weakSelf.progressSlider.value;
        }];
        
    }
    return _player;
}

-(NSString *)CMTimeToNSStringOfMinute:(CMTime)time
{
    if(CMTIME_IS_VALID(time) && !CMTIME_IS_INDEFINITE(time)){
        NSInteger totalSeconds = time.value / time.timescale;
        NSInteger seconds = totalSeconds % 60;
        NSInteger minutes = 0;
        if (totalSeconds > 59) {
            minutes = totalSeconds / 60;
        }
        return [NSString stringWithFormat:@"%2.2lu:%2.2lu",minutes,seconds];
    }else{
        return @"00:00";
    }
}

-(UIActivityIndicatorView *)activityIndicator
{
    if (_activityIndicator == nil) {
        _activityIndicator = [[UIActivityIndicatorView alloc]init];
        //_activityIndicator.hidesWhenStopped = NO;
        [self.view addSubview:_activityIndicator];
        WeakSelf(weakSelf);
        [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf.view);
        }];
    }
    return _activityIndicator;
}

-(ControlBar *)controlBar
{
    if (!_controlBar) {
        _controlBar = [[[NSBundle mainBundle]loadNibNamed:@"ControlBar" owner:nil options:nil] lastObject];
    }
    return _controlBar;
}

-(instancetype)init
{
    if (self = [super init]) {
        _currentPlaySong = -1;
    }
    return self;
}

-(void)setCurrentPlaySong:(NSInteger)currentPlaySong
{
    if (!self.currentPlayList||self.currentPlayList.count == 0) {
        return;
    }
    
    if (![_currentModel isEqual: self.currentPlayList[currentPlaySong]]) {
        _currentPlaySong = currentPlaySong;
        _needReloadSong = YES;
        [self refreshSongInfo];
    }
}

-(void)setMode:(PlayMode)mode
{
    _mode = mode;
    if (_mode == PlayModeOrder) {
        [self.playMode setImage:[UIImage imageNamed:@"顺序播放"] forState:UIControlStateNormal];
    }
    if (_mode == PlayModeCycle) {
       [self.playMode setImage:[UIImage imageNamed:@"列表循环"] forState:UIControlStateNormal];
    }
    if (_mode == PlayModeRandom) {
       [self.playMode setImage:[UIImage imageNamed:@"随机播放"] forState:UIControlStateNormal];
    }
    if (_mode == PlayModeSingle) {
       [self.playMode setImage:[UIImage imageNamed:@"单曲循环"] forState:UIControlStateNormal];
    }
}

-(void)setState:(PlayState)state
{
    _state = state;
    if (_state == playStateLoad) {
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"icon_control_scan"] forState:UIControlStateNormal];
    }
    if (_state == PlayStateStop) {
        [self.player pause];
        [self.player replaceCurrentItemWithPlayerItem:nil];
        self.currentPlaySong = -1;
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_lay_icn_play"] forState:UIControlStateNormal];
    }
    if (_state == PlayStatePlaying) {
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        
        if (_currentPlaySong != -1) {
            
            if (self.player.currentItem && _needReloadSong == NO) {
                [self.player play];
                return;
            }
            
            id localSongId = nil;
            
            if (_currentModel.filePath && ![_currentModel.filePath isEqualToString:@""]) {
                
                NSLog(@"%@",[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, NO) lastObject] stringByAppendingPathComponent:_currentModel.filePath]);
                
                [self.player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:_currentModel.filePath]]]];
                [self.player play];
            }else{
                if (_currentModel.song_id) {
                    ApiParser * parser = [ApiParser sharedParser];
                    [self.activityIndicator startAnimating];
                    [parser songUrl:[_currentModel.song_id integerValue] block:^(id data) {
                        NSString * songUrl = (NSString *)data;
                        [self.player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL URLWithString:songUrl]]];
                        [self.player play];
                        [self.activityIndicator stopAnimating];
                    }];
                    if (self.lyricVc.lyric.length == 0) {
                        [[ApiParser sharedParser]lrcOfSong:[_currentModel.song_id integerValue]block:^(id data) {
                            self.lyricVc.lyric = data;
                        }];
                    }
                }else{
                    NSLog(@"歌曲模型出现错误，没有songID也没有本地文件");
                }
            }
            
            [[SongListManager sharedManager] addRecordToRecentWithTitle:self.currentModel.title author:self.currentModel.author songId:localSongId webSongId:self.currentModel.song_id.integerValue];
        }
    }
    if (_state == PlayStatePause) {
        [self.player pause];
        [self.playOrPauseButton setImage:[UIImage imageNamed:@"cm2_lay_icn_play"] forState:UIControlStateNormal];
    }
}

-(NSMutableArray *)currentPlayList
{
    if (_currentPlayList == nil) {
        _currentPlayList = [NSMutableArray array];
    }
    return _currentPlayList;
}

-(void)setCurrentPlayList:(NSMutableArray *)currentPlayList
{
    [self.currentPlayList removeAllObjects];
    [self.currentPlayList addObjectsFromArray:currentPlayList];
    [self.listVc refresh];
}

#pragma mark Action

- (IBAction)deleteMusic:(id)sender {
    SongModel * model = self.currentModel;
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    if (model.filePath && ![model.filePath isEqualToString:@""]) {
        alertVc.message = @"确认删除?";
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSFileManager * mgr = [NSFileManager defaultManager];
            NSError * err;
            [mgr removeItemAtPath:model.filePath error:&err];
            if (err) {
                NSLog(@"%@",err);
            }
        }]];
        
    }else{
        alertVc.message = @"本地歌曲文件不存在";
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    }
    [self presentViewController:alertVc animated:YES completion:nil];
}
- (IBAction)addToCollection:(id)sender {
    
}

- (IBAction)downMusic:(id)sender {
    [[DownloadManager sharedManager] downloadSongFile:self.currentModel andAddTo:nil];
    UIAlertController * alertVc =[ UIAlertController alertControllerWithTitle:@"" message:@"开始下载" preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"开始下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertVc dismissViewControllerAnimated:YES completion:nil];
    }]];
}

-(IBAction)returnPreview:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)playOrPause:(id)sender {
    if (self.state == PlayStatePause) {
        self.state = PlayStatePlaying;
    }else{
        self.state = PlayStatePause;
    }
}

- (IBAction)preview:(id)sender {
    if (self.mode != PlayModeRandom) {
        self.currentPlaySong - 1 > 0 ? ({
            self.currentPlaySong -= 1;
        }):({
            if (self.mode == PlayModeCycle) {
                self.currentPlaySong = self.currentPlayList.count;
            }else{
                UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经是当前列表的第一首歌" preferredStyle:UIAlertControllerStyleAlert];
                [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alertVc animated:YES completion:nil];
            }
        });
    }else{
        NSInteger randomValue = arc4random() % self.currentPlayList.count;
        self.currentPlaySong = randomValue;
    }
}

- (IBAction)next:(id)sender {
    if (self.mode != PlayModeRandom) {
        self.currentPlaySong + 1 < self.currentPlayList.count ? ({
            self.currentPlaySong += 1;
        }):({
            if (self.mode == PlayModeCycle) {
                self.currentPlaySong = 0;
            }else{
                UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经是当前列表的最后一首歌" preferredStyle:UIAlertControllerStyleAlert];
                [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alertVc animated:YES completion:nil];
            }
        });
    }else{
        NSInteger randomValue = arc4random() % self.currentPlayList.count;
        self.currentPlaySong = randomValue;
    }
    
}

- (IBAction)addToMyLove:(id)sender {
    id cSong = self.currentPlayList[_currentPlaySong];
    if ([cSong isKindOfClass:[Song class]]) {
        [[SongListManager sharedManager] addSongToMyLove:cSong];
        UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"已添加" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertVc animated:YES completion:^{
            [alertVc dismissViewControllerAnimated:YES completion:nil];
        }];
    }else{
        UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"添加到我的喜欢会自动下载该歌曲，是否添加？" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[DownloadManager sharedManager] downloadSongFile:self.currentModel andAddTo:@"MyLove"];
        }]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertVc animated:YES completion:^{
        }];
    }
}

- (IBAction)changePlayMode:(id)sender {
    self.mode + 1 < 4 ? ({self.mode += 1;}):({self.mode = 0;});
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
