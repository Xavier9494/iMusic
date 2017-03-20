//
//  CommonHeader.h
//  iMusic
//
//  Created by Xavier's iCloud ID on 16/3/25.
//  Copyright © 2016年 Xavier. All rights reserved.
//

#ifndef CommonHeader_h
#define CommonHeader_h

#define WeakSelf(weakSelf)  __weak __typeof(&*self) weakSelf = self;

#define URL_BASE @"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&%@"
#define PARAM_LIST @"method=baidu.ting.billboard.billList&type=%lu&size=%lu&offset=%lu"
#define PARAM_SEARCH @"method=baidu.ting.search.catalogSug&query=%@"
#define PARAM_PLAY @"method=baidu.ting.song.play&songid=%lu"
#define PARAM_LRC @"method=baidu.ting.song.lry&songid=%lu"
#define PARAM_COMMEND @"method=baidu.ting.song.getRecommandSongList&song_id=%lu&num=%lu"
#define PARAM_DOWN @"method=baidu.ting.song.downWeb&songid=%lu&bit=%lu&_t=1393123213"
#define PARAM_SINGERINFO @"method=baidu.ting.artist.getInfo&tinguid=%lu"
#define PARAM_SINGERMUSIC @"method=baidu.ting.artist.getSongList&tinguid=%lu&limits=%lu&use_cluster=1&order=2"

#define URL(PARAM) [NSString stringWithFormat:URL_BASE,PARAM]

#endif /* CommonHeader_h */