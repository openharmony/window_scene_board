/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import image from '@ohos.multimedia.image';
import AVSessionManager from '@ohos.multimedia.avsession';
import audio from '@ohos.multimedia.audio';
import { TargetPanel } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';

export default class Constants {

  //ExpandControlCenterComponent
  public static PANEL_EXPAND_WIDTH: number = 304; //播控一级页面宽度304，横竖屏统一
  public static PANEL_EXPAND_HEIGHT: number = 488;
  public static PANEL_EXPAND_HEIGHT_SMALL: number = 224; //播控一级页面小卡的高度（显示设备列表）
  public static HIS_CARD_HEIGHT: number = 162; //播控一级页面历史歌单卡高度

  public static PANEL_EXPAND_SWITCH_SIZE = '21vp';
  public static PANEL_EXPAND_SMALL_SWITCH_SIZE = '18vp';
  public static MEDIA_IMAGE_RADIUS_SIZE_BIG = '16vp';
  public static MEDIA_IMAGE_RADIUS_SIZE_SMALL = '14vp';
  public static ICON_RADIUS_SIZE_BIG = '8.48vp';
  public static ICON_RADIUS_SIZE_SMALL = '4.67vp';

  public static PIC_CONTAINER_WIDTH = 48;
  //歌曲图片大小
  public static EXPAND_PICTURE_SIZE = 256; //宽度 = 播控页面宽度-边距*2
  public static EXPAND_PICTURE_SIZE_SMALL = 56;
  //歌曲图片比例
  public static MIN_PORTRAIT_RATIO = 13 / 18;
  public static MAX_PORTRAIT_RATIO = 16 / 9;
  //icon大小
  public static EXPAND_ICON_SIZE = 34;
  public static EXPAND_ICON_SIZE_SMALL = 19;

  public static EXPAND_DEVICE_LIST_MAX_HEIGHT = 340; //设备列表竖屏最大高度
  //----------

  // 播控二级页面竖屏宽度，一级界面304，二级界面312
  public static PANEL_PORTRAIT_WIDTH: number = 312;
  // 播控二级页面竖屏高度，Constants.PANEL_PORTRAIT_WIDTH - 48 + Constants.PORTRAIT_OTHERS_HEIGHT
  public static PANEL_PORTRAIT_HEIGHT: number = 502;
  // 播控二级页面竖屏小卡的高度（显示设备列表）
  public static PANEL_PORTRAIT_HEIGHT_SMALL: number = 241;
  //播控二级页面横屏宽度总宽度
  public static PANEL_LANDSCAPE_WIDTH: number = 624;
  // 播控二级页横屏一镜到底X轴偏移量
  public static PANEL_LANDSCAPE_GEOM_OFFSET_X: number = 10;
  public static PANEL_PAD_GEOM_OFFSET_X: number = 6;
  // 播控二级页面横屏高度 = 竖屏小卡高度
  public static PANEL_LANDSCAPE_HEIGHT: number = 241;
  // 播控二级界面可以动高度
  public static PANEL_PORTRAIT_MOVE_HEIGHT: number = 450;
  // 状态栏高度
  public static PHONE_STATUS_BAR_HEIGHT: number = 40;
  // 折叠屏播控二级页面右侧边距，一级页面右侧边距36，二级界面右侧边距32
  public static FOLD_PADDING_RIGHT: number = 32;
  // PC状态栏高度
  public static PC_STATUS_BAR_HEIGHT: number = 43;

  public static CARD_EDGE_HALF_PADDING = 12;
  // 历史歌单高度
  public static HISTORY_CARD_HEIGHT = 141;

  // 通话卡片高度
  public static CALL_CARD_HEIGHT: number = 152;
  public static CALL_CARD_EXPAND_HEIGHT: number = 120;
  public static POINT_ANIMATION_INTERVAL: number = 1300;
  public static CALL_CARD_HEIGHT_ANIM_RATIO: number = 0.8;

  public static CARD_MARGIN_LEFT = '24vp';
  public static CARD_MARGIN_RIGHT = '24vp';
  public static COMMON_MARGIN_TOP = '12vp';
  public static COMMON_MARGIN_LEFT = '12vp';
  public static COMMON_MARGIN_BOTTOM = '12vp';
  public static COMMON_MARGIN_RIGHT = '12vp';
  public static COMMON_MARGIN_SMALL = '4vp'
  public static COMMON_PICTURE_SIZE = 24;
  public static COMMON_SWITCH_SIZE = 28;
  public static COMMON_POINT_SIZE = 4;
  public static COMMON_POINT_GROUP_WIDTH = 18;
  public static COMMON_POINT_GROUP_MARGIN = 6;
  public static COMMON_ROW_PADDING = 24;
  public static COMMON_CAST_SMALL_SIZE = '20vp';
  public static COMMON_PICTURE_SIZE_LARGE_SMALLER = '47.5vp';
  public static COMMON_PICTURE_SIZE_LARGE_BIG = '264vp';
  public static COMMON_PICTURE_SIZE_LARGE_BIG_LAND = '191vp'
  public static COMMON_PICTURE_SIZE_LARGE = 48;
  public static COMMON_PICTURE_SIZE_LARGE_LAND = '501vp';
  public static COMMON_PICTURE_SIZE_LARGE_B_BOX = '264.5vp';
  public static COMMON_PICTURE_SIZE_LARGE_B_BOX_LAND = '191.5vp';
  public static COMMON_PICTURE_SIZE_LARGE_FLEX = '314vp';
  public static COMMON_PICTURE_SIZE_SMALL = 16;
  public static COMMON_PICTURE_SIZE_BIG = '32vp';
  public static COMMON_PICTURE_SIZE_BIG_PLUS = '40vp';
  public static COMMON_PICTURE_SIZE_NO_MUSIC = '18vp';
  public static COMMON_TEXT_SIZE_MIDDLE = '16fp';
  public static COMMON_TEXT_SIZE_SMALL = '14fp';
  public static FIRST_PANEL_BACKGROUND_COLOR = $r('app.color.media_card_background');
  public static SECOND_PANEL_BACKGROUND_COLOR = $r('app.color.media_card_background');
  public static COMMON_DIVIDER_HEIGHT = '1vp';
  public static MUSIC_ICON_RADIUS_SIZE = '8vp';
  public static MUSIC_ICON_RADIUS_SIZE_BIG = '16vp';
  public static MUSIC_ICON_RADIUS_SIZE_BIG_LAND = '32.2vp';
  public static APP_ICON_RADIUS_SIZE = '8vp';
  public static APP_ICON_RADIUS_SIZE_BIG = '8vp';
  public static SECOND_PANEL_BORDER_RADIUS = '16vp';
  public static FIRST_PANEL_BORDER_RADIUS = '16vp';
  public static PLAY_BUTTON_SIZE = '32vp'

  public static FIRST_COLUMN_TEXT_SIZE = '16fp';
  public static FIRST_COLUMN_HEIGHT = '31vp';
  public static FIRST_COLUMN_WIDTH = '100%';
  public static FIRST_COLUMN_MARGIN_TOP = '30vp';
  public static MEDIA_IMAGE_HEIGHT = '60vp';
  public static MEDIA_IMAGE_WIDTH = '60vp';
  public static MEDIA_IMAGE_BACKGROUND_COLOR = '#d9f10d28';
  public static TRANSLUCENT_COLOR = '#00ffffff';
  public static APP_IMAGE_HEIGHT = '16vp';
  public static APP_IMAGE_WIDTH = '16vp';
  public static APP_IMAGE_BACKGROUND_COLOR = '#adbebcbc';
  public static MEDIA_AND_APP_IMAGE_HEIGHT = '60vp';
  public static MEDIA_AND_APP_IMAGE_WIDTH = '60vp';
  public static MUSIC_TITLE_TEXT_SIZE = '20fp';
  public static MUSIC_TITLE_MAX_WIDTH = '160vp';
  public static MUSIC_TITLE_MAX_HEIGHT = '20vp';
  public static MUSIC_ARTIST_TEXT_SIZE = '14fp';
  public static MUSIC_ARTIST_MAX_WIDTH = '160vp';
  public static MUSIC_ARTIST_MAX_HEIGHT = '20vp';
  public static MUSIC_ARTIST_TEXT_COLOR = '#000000FF';
  public static MUSIC_TITLE_AND_TITLE_MAX_WIDTH = '160vp';
  public static MUSIC_TITLE_AND_TITLE_MAX_HEIGHT = '40vp';
  public static MUSIC_TITLE_AND_TITLE_MARGIN_LEFT = '20vp';
  public static SECOND_COLUMN_MARGIN_TOP = '30vp';
  public static SECOND_COLUMN_MARGIN_BOTTOM = '20vp';
  public static SECOND_COLUMN_WIDTH = '100%';
  public static SECOND_COLUMN_HEIGHT = '40vp';
  public static INNER_PANEL_MARGIN_LEFT_AND_RIGHT = '18vp';
  public static PANEL_WIDTH = '100%';
  public static FIRST_PANEL_HEIGHT = '200vp';
  public static OUTER_PANEL_MARGIN_LEFT_AND_RIGHT = '12vp';
  public static SECOND_PANEL_MARGIN_TOP = '12vp';
  //mediaCard NEW UX Adapter
  public static MEDIA_CARD_BORDER_RADIUS = '32vp';
  public static MEDIA_CARD_BORDER_RADIUS_PC_MODE = $r('sys.float.ohos_id_corner_radius_default_l');
  public static MEDIA_CARD_LANDSCAPE_BORDER_RADIUS = '24vp';

  public static MEDIA_CARD_BACKGROUND_RATE = 0.1;
  public static MEDIA_CARD_BACKGROUND_RATE_DARK = 0.4;
  public static MEDIA_CARD_BACKGROUND_LIGHT_UP = 0.15;
  public static MEDIA_CARD_BACKGROUND_LIGHT_UP_DARK = -0.021;

  // PANEL
  public static FIRST_PANEL_CLIP: boolean = true;
  public static DEVICE_ICON_HEIGHT = '24vp';
  public static DEVICE_ICON_WIDTH = '24vp';
  public static DEVICE_NAME_TEXT_SIZE = '16fp';
  public static DEVICE_NAME_HEIGHT = '22vp';
  public static DEVICE_NAME_MARGIN_LEFT = '16vp';
  public static TWO_COLUMN_DEVICE_NAME_TEXT_SIZE = '16fp';
  public static TWO_COLUMN_DEVICE_NAME_HEIGHT = '22vp';
  public static TWO_COLUMN_DEVICE_NAME_MARGIN_LEFT = '16vp';
  public static TWO_COLUMN_HINT_TEXT_SIZE = '10fp';
  public static TWO_COLUMN_HINT_TEXT_HEIGHT = '10fp';
  public static TWO_COLUMN_HINT_TEXT_MARGIN_LEFT = '16fp';
  public static DEVICE_TEXT_HEIGHT = '36vp';
  public static DEVICE_SELECTED_ICON_WIDTH_AND_HEIGHT = '24vp';
  public static DEVICE_SELECTED_ICON_MAX_WIDTH_AND_HEIGHT = '20vp';
  public static DEVICE_SELECTED_ICON_BACKGROUND_COLOR = '';
  public static IMAGE_ANIMATOR_REVERSE: boolean = false;
  public static IMAGE_ANIMATOR_FIXED_SIZE: boolean = false;
  public static IMAGE_ANIMATOR_PRE_DECODE: number = 2;
  public static IMAGE_ANIMATOR_ITERATIONS: number = -1;
  public static IMAGE_ANIMATOR_WIDTH_AND_HEIGHT = '20vp';
  public static DEVICE_SELECTED_ICON_MAX_WIDTH = '22vp';
  public static EACH_DEVICE_ITEM_HEIGHT = '56vp';
  public static ITEMS_PANEL_MARGIN_LEFT_AND_RIGHT = '24vp';
  public static ITEMS_PANEL_MARGIN_TOP = '4vp';
  public static DEVICE_LIST_MAX_HEIGHT = 372; // 设备列表竖屏最大高度
  public static DEVICE_LIST_SCROLL_RADIUS = 40;
  public static DEVICE_LIST_BOTH_PADDING = 8; // 设备列表上下padding之和
  public static DEVICE_ITEM_HEIGHT = 56; // 单个设备行高
  public static DEVICE_UN_AUTH_TITLE_HEIGHT = 56; // 更多设备标题高度

  public static SECOND_PANEL_CLIP: boolean = true;
  public static DIALOG_MARGIN_LEFT_AND_RIGHT = '12vp';
  public static LOCAL_NETWORK_ID: string = 'LocalDevice';
  public static MAX_WIDTH_AND_HEIGHT = '100%';
  public static HALF_WIDTH_AND_HEIGHT = '50%';
  public static LIST_DIALOG_HEIGHT = '502vp'; //20231021
  public static TABLET_DEVICES_LIST_WIDTH = '362vp';
  public static DEVICE_ICON_OPACITY: number = 0.6;

  public static WINDOW_NAME: string = 'WindowForMediaControl';

  public static OPERATE_MIN_INTERVAL: number = 500;

  public static TABLET_WINDOW_ANIMATE_RATE: number = 1.03;
  public static TABLET_WINDOW_LEFT: number = 1336;
  public static TABLET_WINDOW_RIGHT: number = 6;
  public static TABLET_WINDOW_TOP: number = 40;
  public static TABLET_WINDOW_DEF_WIDTH: number = 540;
  public static TABLET_WINDOW_DEF_HEIGHT: number = 1600;
  public static TABLET_UX_WIDTH: number = 360;
  public static TABLET_UX_TOTLE_WIDTH: number = 1700;
  public static TABLET_UX_TOTLE_HEIGHT: number = 1060;
  public static TABLET_WINDOW_SHADOW_RADIUS: number = 10;
  public static TABLET_WINDOW_SHADOW_COLOR = '#20000000';
  public static TABLET_WINDOW_SHADOW_OFFSET_X: number = 0;
  public static TABLET_WINDOW_SHADOW_OFFSET_Y: number = 0;
  public static TABLET_WINDOW_SHADOW_PADDING: number = 44;
  public static TABLET_WINDOW_SHADOW_PADDING_TOP: number = 8;
  public static TABLET_WINDOW_SHADOW_PADDING_BOTTOM: number = 40;
  public static TABLET_WINDOW_SHADOW_PADDING_LEFT: number = 40;
  public static TABLET_WINDOW_SHADOW_PADDING_RIGHT: number = 6;
  public static TABLET_WINDOW_BACKGROUND_COLOR = '#99FAFAFA';
  public static TABLET_WINDOW_DEFAULT_RADIUS: number = 24;
  public static TABLET_MEDIA_BLOCK_WIDTH: string = '270vp';
  public static TABLET_ARTIST_TITLE_BLOCK_WIDTH: string = '210vp';
  public static PHONE_MEDIA_BLOCK_WIDTH: string = '248vp';
  public static PHONE_ARTIST_TITLE_BLOCK_WIDTH: string = '188vp';
  public static SESSION_LIST_SIZE_LIMIT_NUM: number = 4;

  // playback card
  public static TITLE_BAR_HEIGHT : number = 56;
  public static PLAYBACK_CARD_TOP_MIN_MARGIN = 8;
  public static PLAYBACK_DEVICE_LIST_MARGIN_TOP = 16;
  public static VOLUME_SLIDER_MAX: number = 150;
  public static CAST_VOLUME_MAX: number = 100;
  public static CAST_DEVICE_VOLUME_MAX_DEFAULT: number = 15;
  public static CALL_VOLUME_SLIDER_MAX: number = 150; // for call
  public static deviceListmarginBottom: number = 9;//距离屏幕下边距
  public static arrowheadHeight: number = 28;//箭头容器高度

  // pc device card
  public static PC_DEVICE_ITEM_HEIGHT: number = 40;
  public static PC_DEVICE_ITEM_MARGIN: number = 24;
  public static PC_DEVICE_ITEM_GUTTER: number = 2;
  public static PC_DEVICE_LIST_TOP_BOTTOM_MARGIN: number = 4;
  public static PC_DEVICE_CARD_LEFT_RIGHT_MARGIN: number = 16;
  public static PC_DEVICE_CARD_CONTENT_PADDING: number = 20;
  public static PC_MINIMUM_GUTTER_TO_DOCK: number = 8;
  public static PC_DOCK_HEIGHT: number = 88;

  // av cast panel
  public static PANEL_GRID_ROW_COLUMNS : GridRowColumnOption = { sm: 4, md: 8, lg: 12 };
  public static PANEL_GRID_COL_SPAN : GridColColumnOption = { sm: 4, md: 6, lg: 6 };
  public static PANEL_GRID_COL_OFFSET : GridColColumnOption = { md: 1, lg: 3 };
  public static PANEL_TITLE_FONT_SIZE = '20fp';
  public static PANEL_TITLE_LINE_HEIGHT = '27fp';
  public static PANEL_LIST_TOW_LINE_HEIGHT = '128vp';
  public static PANEL_LIST_MID_LINE_HEIGHT = '228vp';
  public static PANEL_LIST_ITEM_CONTENT_HEIGHT = 56;
  public static APPPANEL_LIST_ITEM_CONTENT_HEIGHT = '64vp';
  public static PANEL_LIST_ITEM_PRESS_RADIUS = '14vp';
  public static PANEL_LIST_MARGIN_TOP = '22vp';
  public static PANEL_LIST_HEIGHT = 136;
  public static PANEL_BOTTOM_PADDING = '24vp';
  public static PANEL_MINI_HEIGHT_FOR_CLOSE = 150;
  public static PANEL_FULL_HEIGHT_OFFSET = 8;
  public static LIST_DIVIDER_MARGIN_LEFT = '52vp';
  public static LIST_DIVIDER_MARGIN_RIGHT_OK = 12;
  public static LIST_DIVIDER_MARGIN_RIGHT_CHECKBOX = 24;
  public static LIST_DIVIDER_MARGIN_SMALL_SCREEN = 12;
  public static LANDSCAPE_WIDTH_AND_HEIGHT = '480vp';
  // tablet panel
  public static DEVICE_LIST_AREA_HEIGHT = 556;
  public static TABLET_DEVICE_DIALOG_WIDTH = 360;
  public static TABLET_DEVICE_DIALOG_MAX_HEIGHT = 720;
  public static TABLET_DEVICE_DIALOG_MIN_HEIGHT = 180;
  public static TABLET_DEVICE_DIALOG_HEIGHT = 80;
  public static DIALOG_SHADOW_COLOR = '#22000000';
  public static DIALOG_SHADOW_RADIUS_SIZE = 32;
  // time
  public static DEVICE_SELECT_TRIGGER_TIME = 700; // do not trigger device select again
  public static DEVICE_CONNECT_TIMEOUT = 6000; // do not trigger device select again while connecting
  public static MAX_CONNECT_TIMEOUT = 70 * 1000; // 70 seconds
  // list
  public static APP_LIST_SUPPORT_CAST = [
    'com.ohos.music',
  ];
  // progress bar
  public static PROGRESS_BAR_TEXT_SIZE = '12vp';
  public static PROGRESS_BAR_TEXT_COLOR = '#99000000';
  public static PROGRESS_BAR_TEXT_WIDTH = '35vp';

  // audio vivid flag
  public static AUDIO_VIVID_FLAG_WIDTH = 79;
  public static GOLD_FLAG_HEIGHT = 16;
  public static GOLD_FLAG_MARGIN = 8;

  //Slider Width
  public static LANDSCAPE_LEFT_RIGHT_PADDING = 218;
  public static LANDSCAPE_CARD_MARGIN = 24;
  public static CARD_EDGE_PADDING = 24;
  public static CARD_ICON_PADDING = 20;
  public static SLIDER_INNER_PADDING = 6; // InSet类型的Slider，左右边距默认=阴影厚度=6vp
  public static LANDSCAPE_CARD_EDGE_PADDING = 20;
  public static PROGRESS_TEXT_HOUR_WIDTH = 46;
  public static LANDSCAPE_SLIDER_OUTSIDE_WIDTH = 467;
  public static SLIDER_HEIGHT = 40;
  public static SLIDER_MARGIN = 8;
  public static SLIDER_POINT_HEIGHT = 4;
  public static SLIDER_SMALL_HEIGHT = 32;
  public static PLAYBACK_BTNS_HEIGHT = 48;
  public static PORTRAIT_LEFT_RIGHT_PADDING = 96;
  public static LANDSCAPE_SHOWDEV_HEIGHT = 235;
  public static LANDSCAPE_NO_SHOWDEV_HEIGHT = 251;
  public static PORTRAIT_SHOWDEV_HEIGHT = 241;
  public static PORTRAIT_OTHERS_HEIGHT = 238;
  public static SLICER_SHAPE_COMMANDS: string = 'M60 60 M30 30 L15 56 L45 56 Z';

  public static PICKER_CLICK_INTERVAL: number = 100; // 防抖时间
  public static ONE_SECOND_IN_MS: number = 1000;


  public static FUN_NUM_PHONE = 'SF-10169850_f101'; // 玩机技巧fumNum
  public static FUN_NUM_PC = 'SF-10169850_f071';
  public static FUN_TYPE = '70'; // 玩机技巧type
  public static FUN_TYPE_SCENEBOARD = '87'; // 玩机技巧type，sceneboard跳转

  // 折叠屏所需数据
  // 展开态--竖屏
  public static EXPAND_VERTICAL_POSITION = 381;
  public static EXPAND_VERTICAL_POSITION_PADDING = 48;
  public static EXPAND_VERTICAL_RIGHTWHITE = 30;
  public static EXPAND_VERTICAL_TOPWHITE_ISSHOWDEV = 152
  public static EXPAND_VERTICAL_TOPWHITE_NOSHOWDEV = 62

  //   展开态--横屏
  public static EXPAND_HORIZONTAL_POSITION = 447
  public static EXPAND_HORIZONTAL_RIGHTWHITE = 48
  public static EXPAND_HORIZONTAL_TOPWHITE_ISSHOWDEV = 109
  public static EXPAND_HORIZONTAL_TOPWHITE_NOSHOWDEV = 19
  public static EXPAND_HORIZONTAL_PADDINGLEFTRIGHT = 78
  public static EXPAND_HORIZONTAL_IMAGESIZE = 191

  //  折叠态--竖屏
  public static FOLD_VERTICAL_HEIGHT = 240
  public static FOLD_VERTICAL_WHITEHEIGHT_ISSHOWDEV = 108
  public static FOLD_VERTICAL_WHITEHEIGHT_NOSHOWDEV = 43

  // 折叠态--横屏
  public static FOLD_HORIZONTAL_HEIGHT_ISSHOW = 241
  public static FOLD_HORIZONTAL_HEIGHT_NOSHOW = 251
  public static LANDSCAPE_LEFT_RIGHT_WIDTH_PADDING = 156;

  // 折叠屏字体最大倍数
  public static EXPAND_TEXT_MAX_FONT_SCALE = 1.45;

  // 平板、折叠屏、三折叠展开态弹窗高度
  public static FOLD_DEVICE_EXPAND_PANEL_HEIGHT = 600;

  // 直板机弹窗高度
  public static PHONE_PANEL_HEIGHT = 620;

  public static HISTORCAL_DAYUER_TEXT_SCREENOFFSETX = 10;

  public static TRANSLATEVALUEY_OBJECTIVES = -501;
  public static TRANSLATEVALUEY_NEXKEY_ELSE = -562;

  public static CAST_DEVICE = 4;
  public static CAST_AND_DLNA_DEVICE = 10;

  // 音量按键间隔
  public static SOUND_LONG_PRESS_SPLIT = 100;

  // dm回调间隔
  public static DM_CALLBACK_SPLIT = 600;

  // small external screen
  public static SMALL_SCREEN_CARD_CAST_ICON = '18vp';
  public static MAX_DURATION = 24 * 60 * 60 * 1000;
  public static SMALL_SCREEN_CARD_LEFTRIGHTPADDING = 16;
  public static SMALL_SCREEN_MEDIA_CARD_LEFTRIGHTPADDING = 25;
  public static SMALL_SCREEN_CARD_APP_ICON = 28;
  public static SMALL_SCREEN_CARD_SWITCH_SIZE = 24;
  public static SMALL_SCREEN_CONTROL_CENTER_IMAGE_SIZE = 40;
  public static SMALL_SCREEN_CONTROL_CENTER_APP_ICON_SIZE = 12;
  public static SMALL_SCREEN_CARD_HEIGHT = 108;
  public static SMALL_SCREEN_CARD_PADDING = 24;
  public static SMALL_SCREEN_DEVICE_LIST_MAX_HEIGHT = 216;
  public static SMALL_SCREEN_DEVICE_LIST_LEFTRIGHTPADDING = 12;
  public static SMALL_SCREEN_DEVICE_ITEM_HEIGHT = 56;

  // 设备连接触发播控通知的类型
  public static NOTIFY_TRIGGER_DEVICE_TYPE = [
    audio.DeviceType.WIRED_HEADSET,
    audio.DeviceType.WIRED_HEADPHONES,
    audio.DeviceType.BLUETOOTH_A2DP,
    audio.DeviceType.USB_HEADSET,
  ];

  // 投播banner
  public static CAST_BANNER_HEIGHT = 64;
  public static CAST_BANNER_PADDING = 12;
  public static CAST_BANNER_MARGIN_TOP = 12;
  public static CAST_BANNER_IMG_SIZE = 40;
  public static CAST_BANNER_IMG_BORDER_RADIUS = 10;
  public static CAST_BANNER_ICON_SIZE = 24;
  public static CAST_BANNER_ICON_WIDTH = 12;
  public static CAST_BANNER_TITLE_MARGIN = 16;
  public static CAST_BANNER_LANDSCAPE_OFFSET_SPLIT = -8;
  public static CAST_BANNER_LANDSCAPE_OFFSET = 20;

  // 适老化字体最大倍数 1 1.15 1.3 1.45 1.75 2 3.2
  public static TEXT_MAX_FONT_SCALE = 2;
  public static TITLE_MAX_FONT_SCALE = 1.45;
  public static PROGRESS_MAX_FONT_SCALE = 1.45;
  public static SMALL_FOLD_DEVICE_TEXT_MAX_FONT_SCALE = 1.3;
  public static SMALL_FOLD_DEVICE_TITLE_MAX_FONT_SCALE = 1.3;
  public static SMALL_FOLD_DEVICE_PROGRESS_MAX_FONT_SCALE = 1.15;

  public static DEFAULT_LANGUAGE: string = 'zh-Hans';
  public static MINUTE_CN: string = '分';
  public static SECOND_CN: string = '秒';

  public static BUTTON_GROUP_LOOP: string = 'buttonGroupLoopButton';
  public static BUTTON_GROUP_FAVOR: string = 'buttonGroupFavorButton';

  // 通知按钮大小
  public static CONTROL_BUTTON_PLAY_SIZE: number = 30;
  public static CONTROL_BUTTON_FOLD_PLAY_SIZE: number = 24;
  public static CONTROL_BUTTON_ICON_SIZE: number = 24;
  public static CONTROL_BUTTON_FOLD_ICON_SIZE: number = 20;
  public static CONTROL_BUTTON_ICON_SM_SIZE: number = 22;
  public static CONTROL_BUTTON_FOLD_ICON_SM_SIZE: number = 20;
  public static CONTROL_BUTTON_SIZE: number = 48;
  public static CONTROL_BUTTON_FOLD_SIZE: number = 32;
  public static CONTROL_BUTTON_SM_SIZE: number = 40;
  public static CONTROL_BUTTON_FOLD_SM_SIZE: number = 32;
  public static NOTIFY_IMAGE_SIZE = 64;
  public static NOTIFY_LOGO_SIZE = 16;

  // 历史卡片动画参数
  public static HISTORY_CARD_TRANSLATE = -115; // 历史歌单卡片出现/消失时的位移
  public static DEVICE_CARD_TRANSLATE = -100; // 设备列表卡片出现/消失时的位移
  public static ONE_HISTORY_ITEM_MARGIN_TOP = -90; // 一个历史歌单时折叠起来顶部距离
  public static OTHERS_HISTORY_ITEM_MARGIN_TOP = -140; // 两个及以上历史歌单时折叠起来顶部距离
  public static EXPAND_HISTORY_CARD = 32; // 历史卡片收起时的高度
  public static SWIPE_DISTANCE = 80; // 手势滑动距离
  public static HISTORY_CARD_ARROW_DOWN_MARGIN = -32; // 历史卡片折叠，箭头向下时的上间距
  public static HISTORY_CARD_ARROW_UP_MARGIN = -8; // 历史卡片展开，箭头向上时的上间距
  public static CARD_PADDING = 16; // 最外层卡片向外拓展的间距
  public static ARROW_WIDTH = 64; // 历史歌单下方箭头宽度
  public static ARROW_HEIGHT = 24; // 历史歌单下方箭头高度

  // 设备授权状态码
  public static DEVICE_AUTH_CODE: number = 10;
  public static DEVICE_STATE_AUTH : number = 10003;
  public static DEVICE_STATE_SHOW_PIN: number = 10000;
  public static DEVICE_STATE_CONNECT: number = 10012;

  // DC子线程相关常量
  public static CARD_MEDIA_CONTROLLER: string = 'cardMediaController';
  public static ASYNC_CARD_MEDIA_CONTROLLER: string = 'asyncCardMediaController';
  public static MEDIA_INFO_PROVIDER: string = 'mediaInfoProvider';
  public static ASYNC_MEDIA_INFO_PROVIDER: string = 'asyncMediaInfoProvider';
  public static CAST_DEVICE_CONTROL: string = 'castDeviceControl';
  public static ASYNC_CAST_DEVICE_CONTROL: string = 'asyncCastDeviceControl';

  // 助听器设备类型
  public static DEVICE_TYPE_HEARING_AID: audio.DeviceType = 30;

  public static LOADING_PLAY_DELAY: number = 8000;

  // 通话应用-电话
  public static PHONE_CALL_SCENE: PhoneSceneInfo = {
    bundleName: 'com.ohos.callui',
    abilityName: 'com.ohos.callui.MainAbility',
  };
  // 通话应用-畅联
  public static MEET_SERVICE_SCENE: PhoneSceneInfo = {
    bundleName: 'com.ohos.meetimeservice',
    abilityName: 'CallUIKitAbility',
  };

  public static BUNDLE_MAIN_CATEGORY_APP: number = 13;
  public static BUNDLE_SUB_CATEGORY_BUSINESS: number = 10000001;
  public static BUNDLE_SUB_CATEGORY_SOCIAL: number = 10000016;
  public static WELINK_BUNDLE_NAME: string = 'com.openharmony.it.welink';

  // 横屏大卡片的宽度
  public static LANDSCAPE_LARGE_MEDIA_CARD_WIDTH = 545;
  // 横屏整个卡片的高度
  public static LANDSCAPE_LARGE_MEDIA_CARD_HEIGHT = 284;
  // 横屏最近播放卡片宽度
  public static LANDSCAPE_CONTROLLER_WIDTH = 284;
  // 横屏最近播放卡片高度
  public static LANDSCAPE_CONTROLLER_HEIGHT = 260;
  // 竖屏媒体卡片宽度
  public static PORTRAIT_MEDIA_CARD_WIDTH = 312;
  // 竖屏媒体卡片高度
  public static PORTRAIT_MEDIA_CARD_HEIGHT = 518;
  // 竖屏最近播放卡片高度
  public static PORTRAIT_RECENTLY_CARD_HEIGHT = 264;
  // 竖屏正在播放中卡片高度
  public static PORTRAIT_RECENTLY_PLAYING_CARD_HEIGHT = 326;
  // 横屏大图宽高
  public static LANDSCAPE_LARGE_IMAGE_WIDTH_HEIGHT = 236;
  // 横屏音乐图标偏移量
  public static LANDSCAPE_APP_ICON_OFFSET = 204;
  // 列表中的图片宽高
  public static SMALL_IMAGE_WIDTH_HEIGHT = 40;
  // 最近播放列表中文字的最大宽度
  public static RECENTLY_PLAY_TEXT_MAX_LENGTH = 190;
  // 投音按钮栏高度
  public static TITLE_LAYOUT_HEIGHT = 56;
  // 歌曲信息顶部间距
  public static TEXT_INFO_MARGIN_TOP = 8;
  // 小折叠歌曲信息顶部间距
  public static SMALL_FOLD_DEVICE_TEXT_INFO_MARGIN_TOP = 3;
  // 大折叠最近播放列表高度
  public static FOLD_DEVICE_RECENTLY_PLAYING_HEIGHT = 266;
  // 大折叠Tabs高度
  public static FOLD_DEVICE_TABS_HEIGHT = 326;
}

export interface PhoneSceneInfo {
  bundleName: string;
  abilityName: string;
}

/**
 * 组件key，用于自动化测试
 */
export class ComponentKeys {
  public static MEDIA_CARD: string = 'media_card';
}

/**
 * 按钮操作的类型
 */
export enum ActionType {
  PREVIOUS = 'previous',
  NEXT = 'next',
  PLAY_AND_PAUSE = 'play_and_pause',
  FAST_FORWARD = 'fast_forward',
  REWIND = 'rewind',
}

/**
 * 播控卡片展示信息
 */
export interface ShowingMesTS {
  loopMode?: string | number | undefined;
  musicTitle?: string | boolean | undefined;
  musicAuthor?: string | boolean | undefined;
  musicPic?: boolean | string | image.PixelMap | undefined;
  mediaPlayerIcon?: boolean | string | image.PixelMap | undefined;
  playState?: boolean | undefined;
  hasMedia?: boolean | undefined;
  validCommands?: Array<string> | undefined;
  skipIntervals?: number | undefined;
  mediaType?: AVSessionManager.AVSessionType | undefined;
  appName?: string | boolean;
  duration?: number | undefined;
  position?: AVSessionManager.PlaybackPosition | undefined;
  speed?: number | undefined;
  lyric?: string | undefined;
  musicAssetId?: string | number | undefined;
  isFavor?: boolean | undefined;
  displayTags?: number | undefined;
}

/**
 * 需要展示的bundle信息
 */
export interface ShowingBundleTS {
  pixelData?: image.PixelMap | undefined;
  appName?: string | undefined;
}

/**
 * 设备信息
 */
export interface LocalDeviceInfo {
  deviceId: number | string;
  deviceType: number;
  deviceIcon?: Resource;
  deviceName?: string;
  deviceSource?: DeviceSource;
  deviceState?: DeviceState;
  isLocal?: boolean;
  supportedProtocols?: number;
  authenticationStatus?: number;
  deviceAddress?: string;
  isLegacy?: boolean;
  mediumTypes?: number;
  networkId?: string;
  fromCall?: boolean;
}

/**
 * 设备来源
 */
export enum DeviceSource {
  LOCAL, // audio manager devices
  CAST, // cast+ discovery devices
}

/**
 * 设备状态
 */
export enum DeviceState {
  IDLE, // ready for select
  CONNECTING, // is in connecting
  WORKING, // is working as output device
}

/**
 * 歌单队列
 */
export interface AVQueueInfo {
  bundleName?: string;
  avQueueName?: string;
  avQueueId?: string;
  avQueueImage?: image.PixelMap | string;
  lastPlayedTime?: number;
  appIconImage?: string | image.PixelMap;
  sessionId?: string;
}

// 定义统计项的类型
export interface BundleStat {
  bundleName: string;
  count: number;
}

/**
 * 歌单DFX
 */
export interface AVQueueInfoDfx {
  PACKAGE_NAME?: string;
  AVQUEUE_NAME?: string;
  AVQUEUE_ID?: string;
  TIME_COST?:number;
}

/**
 * 位置信息（时间戳）
 */
export interface NewTime {
  elapsedTime: number
  updateTime: number
}

/**
 * 图片回调
 */
export interface ImageCallback {
  width: number,
  height: number
}

/**
 * 拖动组件样式
 */
export interface SliderStyleEx {
  sliderWidth: number,
  volumeWidth: number
}

/**
 * 专辑图片样式
 */
export interface ImageStyle {
  imagesSmallWidth: number,
  imagesSmallHeight: number,
  smallImagesX: number,
  smallImagesY: number,
  imagesWidth: number,
  imagesHeight: number,
  imagesX: number,
  imagesY: number,
  goldFlagX: number,
  goldFlagY: number,
}

/**
 * 组件卡片样式
 */
export interface StyleObj {
  height: number,
  width: number,
  padding?: Padding
}

/**
 * 组件样式
 */
export interface StyleObject {
  left: number,
  right: number,
  top?: number,
  bottom?: number
}

/**
 * 操作按钮组件样式
 */
export interface PlayStyleObj {
  padding: Padding
  offsetLeft: Position,
  offsetRight: Position
}

/**
 * 歌词
 */
export interface LyricDataArray {
  index: number,
  time:number,
  originalTime:string,
  lyric:string
}

/**
 * 投播图标
 */
export interface IconStyleTS {
  width?: string | number | Resource;
  height?: string | number | Resource;
}

/**
 * 输出设备
 */
export interface CurOutputDevTS {
  deviceType: audio.DeviceType;
  deviceId: number;
  deviceAddress?: string;
  networkId?: string;
}

/**
 * 通话卡片
 */
export interface StyleObjForCall {
  callHeight: string;
  stackHeight: string;
}

/**
 * 折叠屏卡片
 */
export interface foldHeightCard {
  width: number,
  height: number,
  textAlign ?: TextAlign,
  align ?: Alignment,
  marginTop ?: number,
  horizontalWidth ?: string | number,
  justifyContent ? :FlexAlign
}

/**
 * 大图位置
 */
export interface bigImagePosition {
  imagesWidth: number
  imagesHeight: number
  imagesX: number
  imagesY: number
}

/**
 * 折叠屏高度
 */
export interface FoldHeight {
  width?: number | string,
  height?: number | string,
  position ?: Position,
  padding ?: Length | Padding,
  deviceWidth ?: number | string,
  direction ?: FlexDirection,
  leftMargin ?: Length | Padding,
  showPadding ?: Length | Padding,
  whiteWidth ?: number | string,
  whiteHeight ?: number | string,
  whiteWidthRight ?: number | string,
  whiteHeightRight ?: number | string,
  foldStatusBottomWhite ?: number | string,
  foldRightCollapseColumn ?: number | string,
  historicalCardWidth ?: number | string,
  foldTotalHeight ? : number | string,
  maxHeight ?: number | string,
  listDirection ? : Axis,
  historicalWidth ? : number | string,
  historicalHeight ? : number | string,
  historicalFontSize ? : string | number | Resource,
  historicalMaxLines ? : number,
  historicalMargin ? : Padding | Length,
  portraitFoldPosition? : Position,
  historicalStackAlignContent? : Alignment,
  historicalStackMargin? : Length | Padding,
  historicalScrollBarVisibility?: Visibility,
  historicalColumnHeight?: Length,
  historicalColumnPadding?: Length | Padding,
  historicalSpace?: string | number,
}

export enum AudioVolumeType {
  VOICE_CALL = 0,
  RINGTONE = 2,
  MEDIA = 3,
}


export enum HostType {
  UNKNOWN_HOST = -1,
  AUDIO_SYSTEM = 0,
  VOLUME_PANEL = 1,
  SOUND_PANEL = 2
}

/**
 * 音量信息
 */
export interface VolumeInfo {
  volumeType: AudioVolumeType;
  volume: number;
  isMute: boolean;
  updateUi: boolean;
  hostType?: HostType;
  isActive?: boolean;
  maxVolume?: number;
  minVolume?: number;
  lastVolume?: number;
}

/**
 * 设备symbol库图标名称
 */
export enum AVCastPickerDeviceIconName {
  WIRED_SYMBOL = 'sys.symbol.earphone_16640_fill',
  EARPIECE_SYMBOL = 'sys.symbol.ear',
  SPEAKER_SYMBOL = 'sys.symbol.speaker_wave_2_fill',
  SPEAKER_CALL_SYMBOL = 'sys.symbol.speaker_wave_3',
  BLUETOOTH_SYMBOL = 'sys.symbol.bluetooth',
  PHONE_SYMBOL = 'sys.symbol.phone_fill_1',
  PAD_SYMBOL = 'sys.symbol.pad_fill',
  MATEBOOK_SYMBOL = 'sys.symbol.matebook_fill',
  SOUND_BOX_SYMBOL = 'sys.symbol.soundx_fill',
  CAST_MORE_SYMBOL = 'sys.symbol.smart_speaker_fill',
  CAST_STREAM_SYMBOL = 'sys.symbol.shareplay',
  CAST_SCREEN_SYMBOL = 'sys.symbol.wireless_projection',
  SELECTED_ICON_SYMBOL = 'sys.symbol.checkmark',
  SOUND_MINUS_SYMBOL = 'sys.symbol.speaker_wave_1_fill',
  SOUND_PLUS_SYMBOL = 'sys.symbol.speaker_wave_3_fill',
  CAR_SYMBOL = 'sys.symbol.car_fill',
  NEARLINK_SYMBOL = 'sys.symbol.nearlink',
  HEARING_AID_SYMBOL = 'sys.symbol.audiphonen',
}

/**
 * 按钮symbol库图标名称
 */
export enum ButtonIconName {
  FAVOR_SYMBOL = 'sys.symbol.heart',
  FAVOR_FILL_SYMBOL = 'sys.symbol.heart_fill',
  PREVIOUS_SYMBOL = 'sys.symbol.backward_end_fill',
  NEXT_SYMBOL = 'sys.symbol.forward_end_fill',
  PLAY_SYMBOL = 'sys.symbol.play_fill',
  PAUSE_SYMBOL = 'sys.symbol.pause_fill',
  FAST_FORWARD_10 = 'sys.symbol.goforward_10',
  FAST_FORWARD_15 = 'sys.symbol.goforward_15',
  FAST_FORWARD_30 = 'sys.symbol.goforward_30',
  FAST_REWIND_10 = 'sys.symbol.gobackward_10',
  FAST_REWIND_15 = 'sys.symbol.gobackward_15',
  FAST_REWIND_30 = 'sys.symbol.gobackward_30',
  RANDOM_PLAY_SYMBOL = 'sys.symbol.shuffle',
  ORDER_PLAY_SYMBOL = 'sys.symbol.order_play',
  SINGLE_CYCLE_SYMBOL = 'sys.symbol.repeat_1',
  LIST_CYCLE_SYMBOL = 'sys.symbol.repeat',
  VOLUME_REDUCE_SYMBOL = 'sys.symbol.speaker_wave_1_fill',
  VOLUME_ADD_SYMBOL = 'sys.symbol.speaker_wave_3_fill',
  COLLECT_MORE_SYMBOL = 'sys.symbol.dot_grid_1x2',
  CANCEL_SYMBOL = 'sys.symbol.xmark',
  CALL_SYMBOL = 'sys.symbol.phone_fill',
  CALL_REDUCE_SYMBOL = 'sys.symbol.phone_badge_waveform_1',
  CALL_ADD_SYMBOL = 'sys.symbol.phone_badge_waveform_3',
}

/**
 * 一镜到底参数
 */
export interface GeometryOptions {
  hierarchyStrategy: TransitionHierarchyStrategy
}

/**
 * dm监听数据
 */
export interface dmReplyData {
  param: string;
}

/**
 * dm监听数据参数
 */
export interface dmReplyDataParam {
  uiStateMsg?: number;
}

export interface CastingSessionInfo {
  sessionId: string;
  deviceName?: string;
  deviceType?: number;
  deviceId?: string | number;
}


/**
 * 同步设备信息
 */
export interface SyncDeviceInfo {
  deviceType?: audio.DeviceType;
  deviceId?: number;
  deviceAddress?: string;
  networkId?: string;
  remoteDevice?: number;
}

/**
 * worker消息参数
 */
export interface WorkerMsgParameter {
  type?: string,
  assetId?: string | number;
  isFavor?: boolean;
  loopMode?: number;
  skipIntervals?: number;
  time?: number;
  sceneType?: string;
  movePosition?: number;
  isSwitch?: boolean;
  curDeviceType?: audio.DeviceType;
  curDeviceId?: number,
  curDeviceAddress?: string;
  curDeviceNetworkId?: string;
  iconInfo?: audio.DeviceType;
  isLocal?: boolean;
  storageKey?: string;
  storageValue?: boolean | string;
  formId?: string;
  skipInit?: boolean;
  forceUpdate?: boolean;
  isColdStart?: boolean;
  sessionId?: string;
  bundleName?: string;
  targetPanel?: TargetPanel;
  startTime?: number;
  notifyId?: string;
  from?: string;
  isNotificationFromDeviceChange?: boolean;
  isMediaNtfShowing?: boolean;
  forceRemove?: boolean;
  name?: string;
  value?: number | string | boolean | Object;
  avQueueId?: string;
  isForceTopSession?: boolean;
}

/**
 * worker二级页消息参数
 */
export interface WorkerMsgSubParameter {
  type?: string,
  sessionId?: string;
  movePosition?: number;
  isFavorite?: boolean;
  isFromSessionCreate?: boolean;
  shouldCallPlay?: boolean;
  isColdStart?: boolean;
  time?: number;
  loopMode?: number;
  volume?: number;
  mode?: number;
  actionType?: InputVolumeAction;
  volumeType?: SetVolumeType;
  avQueueId?: string;
  oldAvQueueId?: string;
  timeCost?: number;
  bundleName?: string;
  hasCast?: boolean;
  startTime?: number;
  isShowSwitch?: number;
  showState?: number;
  operatingMode?: number;
  isHistoryAVQueue?: boolean;
  showRecommend?: boolean;
  isForceTopSession?: boolean;
}

/**
 * 二级页信息
 */
export interface SyncSubDataInfo {
  sessionId?: string;
  needRemove?: boolean;
  metadata?: AVSessionManager.AVMetadata;
  playState?: AVSessionManager.AVPlaybackState;
  validCommands?: Array<AVSessionManager.AVControlCommandType>;
  appName?: string;
  albumInfoList?: Array<AVQueueInfo>;
  position?: Object;
  appIcon?: image.PixelMap;
  imageRatio?: number;
  mediaInfoListData?: Array<MediaInfoData>;
  isExistAvQueueInfo?: boolean;
}

/**
 * sessionList信息
 */
export interface SyncSessionListInfo {
  sessionList?: string[];
}

/**
 * 是否为投播session
 */
export interface SyncIsSinkSessionInfo {
  isSinkSession?: boolean;
}

/**
 * globalStorage信息
 */
export interface SyncGlobalStorageInfo {
  name?: string;
  value?: number | string | boolean | Object;
}

/**
 * 推荐服务信息
 */
export interface SyncRecommendCollectInfo {
  isActivated?: boolean;
  context?: Object;
  hasMedia?: boolean;
  musicAssetId?: string;
}

/**
 * CommunicationUtil本地消息
 */
export interface SyncLocalNotifyInfo {
  name?: string;
  value?: number | string | Object;
}

/**
 * worker投播参数
 */
export interface WorkerMsgCastParameter {
  type?: string;
  sessionId?: string;
  bundleName?: string;
  selectDevId?: number | string;
  isCall?: boolean;
}

/**
 * session信息
 */
export interface SyncSessionDataInfo {
  sessionId?: string;
  descriptor?: AVSessionManager.AVSessionDescriptor | string;
}

/**
 * AppStorage信息
 */
export interface SyncAppStorageInfo {
  name?: string;
  value?: number | string | boolean | Object | Resource;
}

/**
 * 歌单右上角按钮是否显示
 */
export interface RecommendMoreInfo {
  isRecommendMoreIconEnable: boolean;
  isShowRecommendData: boolean;
}

/**
 * 设备列表
 */
export interface SyncDeviceListDataInfo {
  deviceList?: LocalDeviceInfo[];
  callDeviceList?: LocalDeviceInfo[];
}

/**
 * 历史歌单状态
 */
export enum AVQueueShowState {
  FOLD,
  EXPAND,
}

/**
 * 操作方式
 */
export enum AVQueueOperatingMode {
  SWIPE,
  CLICK,
}

export interface QuitSubWindowInfo {
  hideWindow?: boolean;
}

/**
 * 通话卡片
 */
export interface CallSessionInfo {
  sessionId: string;
  appIcon?: image.PixelMap;
  appName?: string;
}

/**
 * 应用分类
 */
export interface BundleCategoryInfo {
  primaryCategoryId: number;
  secondaryCategoryId: number;
}

/**
 * 设备列表显示类型
 */
export enum ShowDevType {
  CALL,
  MEDIA,
}

/**
 * 音量控制类型
 */
export enum SetVolumeType {
  CALL,
  AUDIO,
  CAST,
}

/**
 * 音量操作类型
 */
export enum InputVolumeAction {
  PLUS,
  MINUS,
}

/**
 * 手势操作类型
 */
export enum InputGestureType {
  TOUCH,
  LONG_PRESS,
}

export enum DeviceType {
  CONNECTED = 6,
  DISCONNECTED = 5,
  MIRROR_TO_CAST = 11,
  MIRROR_CAST_TO_MIRROR = 12,
}

/**
 * 最近播放列表信息
 */
export interface MediaInfoData {
  sessionId?: string;
  isPlaying?: boolean;
  title?: string;
  author?: string;
  album?: string | image.PixelMap;
  appIcon?: string | image.PixelMap;
  queueAlbum?: string | image.PixelMap;
  queueName?: string;
  appName?: string;
  hasMedia?: boolean;
  isAVQueue?: boolean;
  avQueueId?: string;
  bundleName?: string;
}

export interface CarInfo {
  deviceId: number,
  deviceType: number,
  deviceName: string,
  brMac: string,
}

export enum  AudioControlCode {
  SET_AUDIO_ON_PAD,
  SET_AUDIO_ON_CAR
}