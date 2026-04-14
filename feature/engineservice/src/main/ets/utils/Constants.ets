/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import lazy { AnimatorOptions } from '@ohos.animator';

/**
 * 锁屏状态编码
 */
const SCREEN_OFF_PAGE: number = 0x1000; // 熄屏页
const MAIN_PAGE: number = 0x2000; // 主页
const BOUNCER_PAGE: number = 0x4000; // 密码页
const UNLOCK_PAGE: number = 0x8000; // 非锁屏页

const NORMAL_SHOW: number = 0x100; // 常态显示态
const EDIT: number = 0x200; // 编辑态
const FAKE_AOD: number = 0x400; // 假AOD态
const INACTIVE: number = 0x800; // 去激活态

const EDIT_EXTENSION: number = 0x20; // 编辑外部接入态

/**
 * 节点类型
 *
 * @since 2023-11-13
 */
export enum DataType {
  LOCKSCREEN = 0,
  VAR = 1,
  GROUP = 2,
  IMAGE = 3,
  TEXT = 4,
  FAEE_SCENE = 5,
  TRIGGER = 6,
  COMMAND = 7,
  VAR_COMMAND = 8,
  EX_COMMANDS = 9,
  SOURCE = 10,
  SOURCE_ANI = 11,
  ALPHA_ANI = 12,
  ALPHA = 13,
  BUTTON = 14,
  ANI_FRAME = 15,
  VAR_ANI = 16,
  IMAGE_ARRAY = 17,
  START_POINT = 18,
  END_POINT = 19,
  UNLOCKER = 20,
  EX_COMMAND = 21,
  TRIGGERS = 22,
  POSITION_ANI = 23,
  POSITION = 24,
  ROTATION_ANI = 25,
  ROTATION = 26,
  VIDEO = 27,
  SIZE_ANI = 28,
  SIZE = 29,
  VIRTUAL_SCREEN = 30,
  VARIABLE_BINDERS = 31,
  SENSOR_BINDER = 32,
  BINDER_VAR = 33,
  TIME = 34,
  INT_COMMAND = 35,
  SLIDER = 36,
  UNLOCKER_POINT = 37,
  STATE = 38,
  PATH = 39,
  NORMAL_STATE = 40,
  PRESSED_STATE = 41,
  REACHED_STATE = 42,
  RECTANGLE = 43,
  CIRCLE = 44,
  ELLIPSE = 45,
  ARC = 46,
  LINE = 47,
  FILL_GRADIENT = 48,
  STROKE_GRADIENT = 49,
  LINEAR = 50,
  RADIAL = 51,
  SWEEP = 52,
  GRADIENT_POINT = 53,
  ROTATION_X = 54,
  ROTATION_Y = 55,
  DATETIME = 56,
  SOUND_COMMAND = 57,
  IMAGE_NUMBER = 58,
  CALENDAR = 59,
  VAR_ARRAY = 60,
  VARS = 61,
  ITEMS = 62,
  ITEM = 63,
  ARRAY = 64,
  COUNT_DOWN_TIME = 65,
  MARQUEE = 66,
  PATH_UTIL = 67,
  IMAGE_SERIES = 68,
  WEATHER = 69,
  STRINGS = 70,
  STRING = 71,
  TIME_ANI = 72,
  SOURCE_IMAGE = 73,
  PARTICLE_VIEW = 74,
  RANGE = 75,
  VID_COMMAND = 76,
  PARTICLE_COMMAND = 77,
  CYCLE_COMMAND = 78,
  VARIABLE_POINT = 79,
  VARIABLE_FRAME_RATE = 80,
  DROP_PHYSICAL = 81,
  DROP_PHYSICAL_VIEW = 82,
  DROP_PHYSICAL_VIEW_ITEM_GROUP = 83,
  DROP_PHYSICAL_VIEW_ITEM = 84,
  DROP_PHYSICAL_VIEW_ITEM_VELOCITY = 85,
  DROP_PHYSICAL_VIEW_ITEM_ANGLE = 86,
  DROP_PHYSICAL_VIEW_ITEM_POSITION = 87,
  DROP_PHYSICAL_VIEW_ITEM_ANGLEVELOCITY = 88,
  DROP_PHYSICAL_VIEW_ITEM_WEIGHT = 89,
  DROP_PHYSICAL_VIEW_ITEM_ALPHAAREA = 90,
  DROP_PHYSICAL_VIEW_ITEM_SIZEAREA = 91,
  BRUSH_PAINT = 92,
  COLL_BODY = 93,
  TEXTURE = 94,
  FAEE_VIDEO = 95,
  PROGRESS = 96,
  PROGRESS_COMMAND = 97,
  FAEE_FRAME_VIDEO = 98,
  MASK = 99,
  MEDIA_CONTROLLER = 100,
  HEALTHY = 101,
  LRC_VIEW = 102,
  MEDIA_ICON = 103,
  REFRESH_HEALTHY_COMMAND = 104,
  REFRESH_WEATHER_COMMAND = 105,
  MEDIA_COMMAND = 106,
  GROUP_COMMAND = 107,
  MSDP_DATA = 108,
  MSDP_TRIGGER_STORY = 109,
  MESH_IMAGE = 110,
  TRANSLATION = 111,
  SINMOTION = 112,
  SWIPER = 113,
  VIDEO_FRAME = 114,
  FOLD_CHANGE_DATA = 115,
  AGP = 116,
  WEATHER_TYPE = 117,
  WEATHER_DATA = 118,
  FOLD_CHANGE_TRIGGER_STORY = 119,
  INTERACTIVE_AGP = 120,
  WEATHER_RESOURCE = 121,
  SIM_SCENE = 122,
  SMART_STICKER = 123,
  CUTE_PET = 124,
  SIM_UNIT = 125,
  SIM_TEXTURE = 126,
  SIM_SHADER = 127,
  SIM_NODE = 128,
  SIM_ANIMATION = 129,
  COMMON_STICKER = 130,
  SCENE_2D = 131,
  FLIP_LIGHT = 132,
  FLIP_KALEIDOSCOPE = 133,
  FLIP_TRANSFORM = 134,
  DIGITAL_CLOCK = 135,
  CIRCLE_GRADIENT = 136,
  BLUETOOTH_BATTERY = 137,
  SIM_PHYSICS = 138,
  STEREO_VIEW = 139,
  STEREO_GROUP = 140,
  STYLE_COMMAND = 141,
  SKELETAL = 142,
  SKELETAL_COMMAND = 143,
  CAROUSEL = 144,
  INFLATE = 145,
  INFLATE_UNIT = 146,
  INFLATE_TEXTURE = 147,
  INFLATE_SHADER = 148,
  INFLATE_NODE = 149,
  INFLATE_ANIMATION = 150,
  INFLATE_CAM = 151,
  INFLATE_EXPLOSION = 152,
  INFLATE_RENDER = 153,
  INFLATE_SIMULATION = 154,
  INFLATE_OPERATION = 155,
  INFLATE_BACK_SHADOW_IMAGE = 156,
  INFLATE_PBR = 157,
  INFLATE_SHADOW_IMAGE_DATA = 158,
  INFLATE_VIEW_PROJECTION = 159,
  INFLATE_SHADOW_DATA = 160,
  CHARGING_SKIN = 161, // 充电动效节点
  SCENERY = 162,
  CONTEXT_AWARENESS = 163,
  SHADER_EFFECT = 164,
  MULTILAYER = 165,
  LAYER = 166,
  AOD_CLOCK = 167,
  LOCK_CLOCK = 168,
  GROUP_CLOCK = 169,
  GROUP_BATTERY = 170,
  COLLISION_WORLD = 171,
  TEXTURE_2D = 172,
  SCREEN_OFF_TIME_COMMAND=173,
  SCENE_3D = 174,
  SCENE_MODEL_3D = 175,
  CAMERA_3D = 176,
  COLLABORATION = 177,
  DATA_SHARE = 178,
  LAYER_PHOTO_WALL = 179,
  GRID_PHOTO_WALL = 180,
  EDIT_PARENT = 181,
  LIGHT_3D = 182,
  MATERIAL_3D = 183,
  NODE_3D = 184,
  SHADER = 185,
  FLUIDS_COMPONENT = 186,
  CIRCLE_SHAPE = 187,
  POLYGON_SHAPE = 188,
  RIGID_BODY_3D = 189,
  ADVANCED_2D_TRANSITION = 190,
  COMMON_TRIGGER_COMMAND = 191,
  MSDP_USER_STATUS_CONFIG_COMMAND = 192,
  ANIMATION_3D = 193,
  INFINITY = 194,
}

/**
 * 交互类型
 *
 * @since 2024-3-6
 */
export enum InteractiveType {
  TOUCH_DOWN = 0,
  TOUCH_UP = 1,
  CLICK = 2,
  DOUBLE_CLICK = 3,
  LONG_PRESS = 4,
  MOVE = 5,
  MOVE_LEFT_START = 6,
  MOVE_LEFT_END = 7,
  MOVE_RIGHT_START = 8,
  MOVE_RIGHT_END = 9,
  CANCEL = 10,
}

/**
 * 解锁类型
 */
export enum UnlockAuthType {
  PIN = 1, //Pin解锁
  FACE = 2, // 人脸解锁
  FINGERPRINT = 4 // 指纹解锁
}

/**
 * 解锁结果
 */
export enum UnlockAuthRes {
  FAIL = 0,
  SUCCESS = 1,
}

/**
 * 锁屏主页状态机-状态类型
 */
export enum MpStateType {
  /**
   * 初始态
   */
  INIT_STATE = 0,

  /**
   * 熄屏态
   */
  SCREEN_OFF_STATE = SCREEN_OFF_PAGE,

  /**
   * 常态锁屏态
   */
  NORMAL_LOCK_STATE = MAIN_PAGE | NORMAL_SHOW | 0x1,

  /**
   * 去激活态
   */
  INACTIVE_STATE = MAIN_PAGE | INACTIVE,

  /**
   * 常态解锁态
   */
  NORMAL_UNLOCK_STATE = MAIN_PAGE | NORMAL_SHOW | 0x2,

  /**
   * 常态AOD态
   */
  NORMAL_FAKE_AOD_STATE = MAIN_PAGE | FAKE_AOD,

  /**
   * 编辑态常态
   */
  EDIT_NORMAL_STATE = MAIN_PAGE | EDIT,

  /**
   * 主页编辑态
   */
  EDIT_MAIN_PAGE_STATE_FULL = MAIN_PAGE | EDIT | 0x1,

  /**
   * 时钟编辑态
   */
  EDIT_CLOCK_STATE = MAIN_PAGE | EDIT | 0x2,

  /**
   * 卡片编辑态
   */
  EDIT_CARD_STATE = MAIN_PAGE | EDIT | 0x3,

  /**
   * 卡片编辑详情态
   */
  EDIT_CARD_DETAIL_STATE = MAIN_PAGE | EDIT | 0x4,

  /**
   * 壁纸编辑态
   */
  EDIT_WALLPAPER_STATE = MAIN_PAGE | EDIT | EDIT_EXTENSION | 0x5,

  /**
   * 熄屏风格编辑态
   */
  EDIT_AOD_STYLE_STATE = MAIN_PAGE | EDIT | EDIT_EXTENSION | 0x6,

  /**
   * 主题编辑态
   */
  EDIT_THEME_STATE = MAIN_PAGE | EDIT | EDIT_EXTENSION | 0x7,

  /**
   * 主题自定义编辑态
   */
  EDIT_CUSTOM_THEME_STATE = MAIN_PAGE | EDIT | EDIT_EXTENSION | 0x8,

  /**
   * 密码页态
   */
  BOUNCER_STATE = BOUNCER_PAGE,

  /**
   * 非锁屏态
   */
  UNLOCK_STATE = UNLOCK_PAGE,
}

export enum LoopModeType {
  LOOP_MODE_SEQUENCE = 0,
  LOOP_MODE_SINGLE = 1,
  LOOP_MODE_LIST = 2,
  LOOP_MODE_SHUFFLE = 3,
  LOOP_MODE_CUSTOM = 4,
}

export enum MediaLoadStatus {
  PLAY_LOADING = '1',
  PLAY_LOADED = '2',
}

/**
 * 音乐播放状态
 */
export enum PlaybackState {
  PLAYBACK_STATE_INITIAL = 0,
  PLAYBACK_STATE_PREPARE = 1,
  PLAYBACK_STATE_PLAY = 2,
  PLAYBACK_STATE_PAUSE = 3,
  PLAYBACK_STATE_FAST_FORWARD = 4,
  PLAYBACK_STATE_REWIND = 5,
  PLAYBACK_STATE_STOP = 6,
  PLAYBACK_STATE_COMPLETED = 7,
  PLAYBACK_STATE_RELEASED = 8,
  PLAYBACK_STATE_ERROR = 9,
  PLAYBACK_STATE_IDLE = 10,
  PLAYBACK_STATE_BUFFERING = 11,
}

/**
 * 与ThemeDataService数据传输类型
 */
export enum DataSourceType {
  MICROPHONE = 0,
  HEALTH = 1,
  WEATHER = 2,
  BLUETOOTH = 3,
  CALENDAR = 4,
}

/**
 * 壁纸类型
 * image：静态壁纸
 * script：动态壁纸
 * longTake：对应一镜到底的配置模式
 */
export enum ScriptType {
  IMAGE = 'image',
  SCRIPT = 'script',
  LONG_TAKE = 'longTake',
}

/**
 * video视频状态
 */
export enum VideoState {
  IDLE = 0,
  INITIALIZED = 1,
  PREPARED = 2,
  PLAYING = 3,
  PAUSED = 4,
  COMPLETED = 5,
  STOPPED = 6,
  RELEASED = 7,
  ERROR = 8,
}

/**
 * AvPlayer状态
 */
export enum AvPlayerState {
  INITIALIZED = 'initialized',
  IDLE = 'idle',
  PREPARED = 'prepared',
  PLAYING = 'playing',
  PAUSED = 'paused',
  COMPLETED = 'completed',
  STOPPED = 'stopped',
  RELEASED = 'released',
  ERROR = 'error',
}

/**
 * 动画状态
 */
export enum AnimationState {
  RUNNING = 0,
  STOP = 1,
}

/**
 * Constants常量类
 *
 * @since 2023-11-13
 */
export class Constants {
  /**
   * Json文件中Image标识符
   */
  public static readonly ATTRIBUTES_MAP: Map<string, number> = new Map([
    ['Lockscreen', DataType.LOCKSCREEN],
    ['Var', DataType.VAR],
    ['VarArray', DataType.VAR_ARRAY],
    ['Vars', DataType.VARS],
    ['Items', DataType.ITEMS],
    ['Item', DataType.ITEM],
    ['Group', DataType.GROUP],
    ['Image', DataType.IMAGE],
    ['Text', DataType.TEXT],
    ['Trigger', DataType.TRIGGER],
    ['Triggers', DataType.TRIGGERS],
    ['Command', DataType.COMMAND],
    ['VariableCommand', DataType.VAR_COMMAND],
    ['ExternalCommands', DataType.EX_COMMANDS],
    ['Source', DataType.SOURCE],
    ['SourcesAnimation', DataType.SOURCE_ANI],
    ['AlphaAnimation', DataType.ALPHA_ANI],
    ['Alpha', DataType.ALPHA],
    ['Button', DataType.BUTTON],
    ['AniFrame', DataType.ANI_FRAME],
    ['VariableAnimation', DataType.VAR_ANI],
    ['StartPoint', DataType.START_POINT],
    ['EndPoint', DataType.END_POINT],
    ['Unlocker', DataType.UNLOCKER],
    ['ExternCommand', DataType.EX_COMMAND],
    ['PositionAnimation', DataType.POSITION_ANI],
    ['Position', DataType.POSITION],
    ['RotationAnimation', DataType.ROTATION_ANI],
    ['Rotation', DataType.ROTATION],
    ['RotationX', DataType.ROTATION_X],
    ['RotationY', DataType.ROTATION_Y],
    ['SizeAnimation', DataType.SIZE_ANI],
    ['Size', DataType.SIZE],
    ['VirtualScreen', DataType.VIRTUAL_SCREEN],
    ['VariableBinders', DataType.VARIABLE_BINDERS],
    ['SensorBinder', DataType.SENSOR_BINDER],
    ['Variable', DataType.BINDER_VAR],
    ['Time', DataType.TIME],
    ['IntentCommand', DataType.INT_COMMAND],
    ['Slider', DataType.SLIDER],
    ['State', DataType.STATE],
    ['Path', DataType.PATH],
    ['NormalState', DataType.NORMAL_STATE],
    ['PressedState', DataType.PRESSED_STATE],
    ['ReachedState', DataType.REACHED_STATE],
    ['Rectangle', DataType.RECTANGLE],
    ['Circle', DataType.CIRCLE],
    ['Ellipse', DataType.ELLIPSE],
    ['Arc', DataType.ARC],
    ['Line', DataType.LINE],
    ['FillGradient', DataType.FILL_GRADIENT],
    ['StrokeGradient', DataType.STROKE_GRADIENT],
    ['Linear', DataType.LINEAR],
    ['Radial', DataType.RADIAL],
    ['Sweep', DataType.SWEEP],
    ['GradientPoint', DataType.GRADIENT_POINT],
    ['Array', DataType.ARRAY],
    ['DateTime', DataType.DATETIME],
    ['SoundCommand', DataType.SOUND_COMMAND],
    ['CountDownTime', DataType.COUNT_DOWN_TIME],
    ['ImageNumber', DataType.IMAGE_NUMBER],
    ['Calendar', DataType.CALENDAR],
    ['Marquee', DataType.MARQUEE],
    ['PathUtil', DataType.PATH_UTIL],
    ['Video', DataType.VIDEO],
    ['ImageSeries', DataType.IMAGE_SERIES],
    ['Weather', DataType.WEATHER],
    ['strings', DataType.STRINGS],
    ['string', DataType.STRING],
    ['SourceImage', DataType.SOURCE_IMAGE],
    ['ParticleView', DataType.PARTICLE_VIEW],
    ['Range', DataType.RANGE],
    ['VideoCommand', DataType.VID_COMMAND],
    ['ParticleCommand', DataType.PARTICLE_COMMAND],
    ['CycleCommand', DataType.CYCLE_COMMAND],
    ['VariableFramerate', DataType.VARIABLE_FRAME_RATE],
    ['VariablePoint', DataType.VARIABLE_POINT],
    ['DropPhysicalView', DataType.DROP_PHYSICAL],
    ['ItemGroup', DataType.DROP_PHYSICAL_VIEW_ITEM_GROUP],
    ['Item', DataType.DROP_PHYSICAL_VIEW_ITEM],
    ['Velocity', DataType.DROP_PHYSICAL_VIEW_ITEM_VELOCITY],
    ['Angle', DataType.DROP_PHYSICAL_VIEW_ITEM_ANGLE],
    ['AngleVelocity', DataType.DROP_PHYSICAL_VIEW_ITEM_ANGLEVELOCITY],
    ['weight', DataType.DROP_PHYSICAL_VIEW_ITEM_WEIGHT],
    ['Paint', DataType.BRUSH_PAINT],
    ['CollBody', DataType.COLL_BODY],
    ['Texture', DataType.TEXTURE],
    ['Progress', DataType.PROGRESS],
    ['ProgressCommand', DataType.PROGRESS_COMMAND],
    ['Mask', DataType.MASK],
    ['Healthy', DataType.HEALTHY],
    ['MediaControl', DataType.MEDIA_CONTROLLER],
    ['MediaIcon', DataType.MEDIA_ICON],
    ['MediaCommand', DataType.MEDIA_COMMAND],
    ['BluetoothBattery', DataType.BLUETOOTH_BATTERY],
    ['ContextAwareness', DataType.CONTEXT_AWARENESS],
    ['lrcView', DataType.LRC_VIEW],
    ['MediaProgressbar', DataType.PROGRESS],
    ['RefreshHealthyCommand', DataType.REFRESH_HEALTHY_COMMAND],
    ['RefreshWeatherCommand', DataType.REFRESH_WEATHER_COMMAND],
    ['GroupCommands', DataType.GROUP_COMMAND],
    ['MsdpUserStatusDataCommand', DataType.MSDP_DATA],
    ['MsdpUserStatusTriggerStoryCommand', DataType.MSDP_TRIGGER_STORY],
    ['MeshImage', DataType.MESH_IMAGE],
    ['Translation', DataType.TRANSLATION],
    ['SinMotion', DataType.SINMOTION],
    ['Swiper', DataType.SWIPER],
    ['VideoFrame', DataType.VIDEO_FRAME],
    ['FoldChangeStatusDataCommand', DataType.FOLD_CHANGE_DATA],
    ['FlipLight', DataType.FLIP_LIGHT],
    ['FlipKaleidoscope', DataType.FLIP_KALEIDOSCOPE],
    ['FlipTransform', DataType.FLIP_TRANSFORM],
    ['DigitalClock', DataType.DIGITAL_CLOCK],
    ['CircleGradient', DataType.CIRCLE_GRADIENT],
    ['ShaderEffect', DataType.SHADER_EFFECT],
    ['Infinity', DataType.INFINITY],
    ['AGP', DataType.AGP],
    ['WeatherType', DataType.WEATHER_TYPE],
    ['WeatherData', DataType.WEATHER_DATA],
    ['WeatherResource', DataType.WEATHER_RESOURCE],
    ['FoldChangeStatusTriggerStoryCommand', DataType.FOLD_CHANGE_TRIGGER_STORY],
    ['InteractiveAGP', DataType.INTERACTIVE_AGP],
    ['SimScene', DataType.SIM_SCENE],
    ['CutePet', DataType.CUTE_PET],
    ['SimUnit', DataType.SIM_UNIT],
    ['SimTexture', DataType.SIM_TEXTURE],
    ['SimShader', DataType.SIM_SHADER],
    ['SimNode', DataType.SIM_NODE],
    ['SimAnimation', DataType.SIM_ANIMATION],
    ['SimPhysics', DataType.SIM_PHYSICS],
    ['CommonSticker', DataType.COMMON_STICKER],
    ['SmartSticker', DataType.SMART_STICKER],
    ['StereoView', DataType.STEREO_VIEW],
    ['StereoGroup', DataType.STEREO_GROUP],
    ['StyleCommand', DataType.STYLE_COMMAND],
    ['Inflate', DataType.INFLATE],
    ['InflateUnit', DataType.INFLATE_UNIT],
    ['InflateTexture', DataType.INFLATE_TEXTURE],
    ['InflateShader', DataType.INFLATE_SHADER],
    ['InflateNode', DataType.INFLATE_NODE],
    ['InflateAnimation', DataType.INFLATE_ANIMATION],
    ['InflateCam', DataType.INFLATE_CAM],
    ['ExplosionNode', DataType.INFLATE_EXPLOSION],
    ['InflateRender', DataType.INFLATE_RENDER],
    ['InflateSimulation', DataType.INFLATE_SIMULATION],
    ['InflateOperation', DataType.INFLATE_OPERATION],
    ['ShadowImageNode', DataType.INFLATE_BACK_SHADOW_IMAGE],
    ['InflatePbr', DataType.INFLATE_PBR],
    ['ShadowImageData', DataType.INFLATE_SHADOW_IMAGE_DATA],
    ['InflateViewProjection', DataType.INFLATE_VIEW_PROJECTION],
    ['InflateShadowData', DataType.INFLATE_SHADOW_DATA],
    ['ChargingSkin', DataType.CHARGING_SKIN],
    ['TvScenery', DataType.SCENERY],
    ['TvCarouselImage', DataType.CAROUSEL],
    ['MultiLayer', DataType.MULTILAYER],
    ['Layer', DataType.LAYER],
    ['AodClock', DataType.AOD_CLOCK],
    ['LockClock', DataType.LOCK_CLOCK],
    ['GroupClock', DataType.GROUP_CLOCK],
    ['GroupBattery', DataType.GROUP_BATTERY],
    ['ScreenOffTimeCommand', DataType.SCREEN_OFF_TIME_COMMAND],
    ['SceneModel3D', DataType.SCENE_MODEL_3D],
    ['Camera3D', DataType.CAMERA_3D],
    ['Light3D', DataType.LIGHT_3D],
    ['Material3D', DataType.MATERIAL_3D],
    ['Node3D', DataType.NODE_3D],
    ['RigidBody3D', DataType.RIGID_BODY_3D],
    ['Shader', DataType.SHADER],
    ['CollaborationCommands', DataType.COLLABORATION],
    ['DataShare', DataType.COLLABORATION],
    ['CircleShape', DataType.CIRCLE_SHAPE],
    ['PolygonShape', DataType.POLYGON_SHAPE],
    ['Advanced2DTransition', DataType.ADVANCED_2D_TRANSITION],
    ['CommonTriggerStoryCommand', DataType.COMMON_TRIGGER_COMMAND],
    ['MsdpUserStatusConfigCommand', DataType.MSDP_USER_STATUS_CONFIG_COMMAND],
  ]);

  /**
   * 字体粗细对应映射关系，底层OH领域接口进行兼容性变更，使用FontWeight映射实际设置值不生效，当前替换成每个映射对应的实际数值
   */
  public static readonly FONT_WEIGHT_MAP: Map<string, number> = new Map([
    ['Lighter', 100],
    ['Normal', 400],
    ['Regular', 400],
    ['Medium', 500],
    ['Bold', 700],
    ['Bolder', 900],
  ]);

  /**
   * 相机应用bundleName
   */
  public static readonly CAMERA_BUNDLE_NAME: string = 'com.ohos.camera';

  /**
   * 相机应用主界面abilityName
   */
  public static readonly CAMERA_ABILITY_NAME: string = 'com.ohos.camera.MainAbility';

  /**
   * 默认混合模式
   */
  public static readonly DEFAULT_HYBRID_MODE: string = '6';

  /**
   * 默认音效类型
   */
  public static readonly STREAM_USAGE_MUSIC_TYPE: number = 0;

  /**
   * 开启ThemeDataService监听code码
   */
  public static readonly LISTEN_ON_CODE: number = 1;

  /**
   * 获取ThemeDataService数据code码
   */
  public static readonly REQUEST_DATA_CODE: number = 2;

  /**
   * 关闭ThemeDataService监听code码
   */
  public static readonly LISTEN_OFF_CODE: number = 3;

  /**
   * 获取ThemeDataService天气数据code码
   */
  public static readonly REQUEST_WEATHER_CODE: number = 4;

  /**
   * 获取ThemeDataService日历数据code码
   */
  public static readonly REQUEST_CALENDAR_CODE: number = 5;

  /**
   * 设置语音互动技能列表code码
   */
  public static readonly VOICE_SKILLS = 15;

  /**
   * 删除语音互动技能列表code码
   */
  public static readonly DELETE_VOICE_SKILLS = 16;

  /**
   * 设置语音互动动态指令列表code码
   */
  public static readonly VOICE_CHIPS = 17;

  /**
   * 语音通话音量进度条
   */
  public static readonly VOICE_CALL_PROGRESS: number = 0;

  /**
   * 亮度进度条
   */
  public static readonly BRIGHTNESS_PROGRESS: number = 1;

  /**
   * 铃声音量进度条
   */
  public static readonly RINGTONE_PROGRESS: number = 2;

  /**
   * 媒体音量进度条
   */
  public static readonly MEDIA_PROGRESS: number = 3;

  /**
   * 闹铃音量进度条
   */
  public static readonly ALARM_PROGRESS: number = 4;

  /**
   * 音乐播放进度条
   */
  public static readonly MUSIC_PROGRESS: number = 5;

  /**
   * 切换收藏模式
   */
  public static readonly TOGGLE_FAVORITE: string = 'toggleFavorite';

  /**
   * 切换播放模式
   */
  public static readonly SET_LOOP_MODE: string = 'setLoopMode';

  /**
   * 设置音量
   */
  public static readonly SET_VOLUME: string = 'setVolume';

  /**
   * 设置音乐进度
   */
  public static readonly SET_MEDIA_POSITION: string = 'seek';

  /**
   * 音量变化的步进默认值
   */
  public static readonly VOLUME_CHANGE_STEP_DEFAULT: number = 10;

  /**
   * 歌词的行间距默认值
   */
  public static readonly DIVIDER_HEIGHT_DEFAULT: number = 20;

  /**
   * true对应的数字
   */
  public static readonly TRUE_NUM: string = '1';

  /**
   * false对应的数字
   */
  public static readonly FALSE_NUM: string = '0';

  /**
   * 1000毫秒
   */
  public static readonly SECOND_IN_MILLS: number = 1000;

  /**
   * 基准刷新率
   */
  public static readonly BASELINE_REFRESH_RATE: number = 120;

  /**
   * 未读或错过的数量
   */
  public static readonly UNREAD_MISSED_NUMBER: number = 100;

  /**
   * 未读或错过的数量超过99时，显示99+
   */
  public static readonly OVER_DISPLAY_NUMBER: string = '99+';

  /**
   * Json文件中Lockscreen标识符
   */
  public static readonly LOCKSCREEN: string = 'Lockscreen';

  /**
   * 布尔默认值
   */
  public static readonly DEFAULT_BOOLEAN_TRUE: number = 1;

  /**
   * 虚拟屏幕宽度与真实屏幕宽度默认比例
   */
  public static readonly DEFAULT_RATE: number = 1;

  /**
   * 布尔默认值
   */
  public static readonly DEFAULT_BOOLEAN_FALSE: number = 0;

  /**
   * 触摸时间默认值
   */
  public static readonly LONG_TOUCH_TIME_DEFAULT: number = 1000;

  /**
   * number类型默认值
   */
  public static readonly NUM_ZERO: number = 0;

  /**
   * 默认长度
   */
  public static readonly DEFAULT_WIDTH: number = 4;

  /**
   * 字符串true
   */
  public static readonly TRUE: string = 'true';

  /**
   * 字符串false
   */
  public static readonly FALSE: string = 'false';

  /**
   * Json文件中Var标识符
   */
  public static readonly VAR: string = 'Var';

  /**
   * Json文件中Group标识符
   */
  public static readonly GROUP: string = 'Group';

  /**
   * Json文件中nodeName标识符
   */
  public static readonly NODE_NAME: string = 'nodeName';

  /**
   * Json文件中childNodes标识符
   */
  public static readonly CHILD_NODE: string = 'childNodes';

  /**
   * Json文件中attributes标识符
   */
  public static readonly ATTRIBUTE: string = 'attributes';

  /**
   * 一镜到底引擎
   */
  public static readonly LONG_TAKE: number = 1;

  /**
   * FAEE引擎
   */
  public static readonly FAEE_ENGINE: number = 2;

  /**
   * 动态壁纸主题引擎
   */
  public static readonly openharmony_THEME_ENGINE: number = 3;

  /**
   * Json文件中子类为空
   */
  public static readonly NO_CHILD: number = 2;

  /**
   * Json文件中子类key的起始值
   */
  public static readonly START_CHILD_ID: number = 0;

  /**
   * Json文件中子类key的最大值
   */
  public static readonly MAX_CHILD_ID: number = 1000;

  /**
   * 一镜到底AOD到桌面
   */
  public static readonly AOD_TO_LAUNCHER: number = 0;

  /**
   * 一镜到底桌面到AOD
   */
  public static readonly LAUNCHER_TO_AOD: number = 1;

  /**
   * 一镜到底锁屏到桌面
   */
  public static readonly LOCKSCREEN_TO_LAUNCHER: number = 2;

  /**
   * 一镜到底锁屏到AOD
   */
  public static readonly LOCKSCREEN_TO_AOD: number = 3;

  /**
   * 一镜到底AOD到锁屏
   */
  public static readonly AOD_TO_LOCKSCREEN: number = 4;

  /**
   * 主题引擎包名
   */
  public static readonly BUNDLE_NAME: string = 'com.ohos.themeengine';

  /**
   * 主题引擎实例模式
   */
  public static readonly ENGINE_MODE: string = 'engineMode';

  /**
   * 主题引擎,next引擎
   */
  public static readonly NEXT_THEME_ENGINE: string = 'nextThemeEngine';

  /**
   * 主题引擎,编辑显示引擎
   */
  public static readonly EDIT_ENGINE: string = 'editEngine';

  /**
   * 主题引擎,编辑器资源引擎
   */
  public static readonly RESOURCE_ENGINE: string = 'resourceEngine';

  /**
   * 时钟颜色常量
   */
  public static readonly ENGINE_CLOCK_COLOR: string = 'engineClockColor';

  /**
   * 动画类型状态
   */
  public static readonly ANIMATION_STATE_TRACEID_MAP: Map<number, string> = new Map([
    [Constants.AOD_TO_LAUNCHER, 'AOD_TO_LAUNCHER'],
    [Constants.LAUNCHER_TO_AOD, 'LAUNCHER_TO_AOD'],
    [Constants.LOCKSCREEN_TO_LAUNCHER, 'LOCKSCREEN_TO_LAUNCHER'],
    [Constants.LOCKSCREEN_TO_AOD, 'LOCKSCREEN_TO_AOD'],
    [Constants.AOD_TO_LOCKSCREEN, 'AOD_TO_LOCKSCREEN'],
  ]);

  /**
   * 系统状态-AOD
   */
  public static readonly AOD_STATUS: number = 5;

  /**
   * 系统状态-锁屏
   */
  public static readonly LOCKSCREEN_STATUS: number = 6;

  /**
   * 系统状态-桌面
   */
  public static readonly LAUNCHER_STATUS: number = 7;

  /**
   * 一镜到底桌面到锁屏
   */
  public static readonly LAUNCHER_TO_LOCKSCREEN: number = 8;

  /**
   * 无动画状态
   */
  public static readonly NO_ANIMATION = 9;

  /**
   * AOD导出序列帧
   */
  public static readonly AOD_TO_AOD = 10;

  /**
   * 预亮屏消息
   */
  public static readonly PRE_BEGIN_ON: number = 11;

  /**
   * * 开盖触发一镜到底AOD到锁屏
   */
  public static readonly AOD_TO_LOCKSCREEN_LID_OPEN = 12;

  /**
   * 一镜到底桌面双击
   */
  public static readonly LAUNCHER_STATUS_DOUBLE_CLICK = 13;

  /**
   * 壁纸做主屏
   */
  public static readonly SOURCE_MODE_MAIN = 14;

  /**
   * 壁纸做扩展屏
   */
  public static readonly SOURCE_MODE_EXTEND = 15;

  /**
   * 路径不足3位补0
   */
  public static readonly PADDING_LENGTH: number = 3;

  /**
   * 动画参数iterations的默认值
   */
  public static readonly DEFAULT_ITERATIONS: number = 1;

  /**
   * 动画参数begin的默认值
   */
  public static readonly DEFAULT_ANIMATION_BEGIN: number = 1;

  /**
   * 动画参数end的默认值
   */
  public static readonly DEFAULT_ANIMATION_END: number = 2;

  /**
   * 遍历图片下标的增量
   */
  public static readonly TRAVERSAL_INCREMENT: number = 1;

  /**
   * 遍历图片初始值
   */
  public static readonly INITIAL_VALUE: number = -1;

  /**
   * 文件分隔符
   */
  public static readonly FILE_SEPARATOR: string = '/';

  /**
   * 文件分隔符
   */
  public static readonly IMAGE_SUFFIX: string = '.png';

  /**
   * astc格式图片后缀
   */
  public static readonly ASTC_SUFFIX: string = '.astc';

  /**
   * 主题包后缀
   */
  public static readonly HWT_SUFFIX: string = '.hwt';

  /**
   * 沙箱文件路径前缀
   */
  public static readonly SANDBOX_PRE: string = 'file://';

  /**
   * 资源目录名称
   */
  public static readonly RESOURCES: string = 'resources';

  /**
   * 生成资源目录
   */
  public static readonly GENERATE_RESOURCES: string = 'generate_resources';

  /**
   * 沙箱文件路径
   */
  public static readonly SANDBOX_PATH: string = '/preview/ImageAnimator/image_00';

  /**
   * 标记文件。存在该文件，表示当前a为使用中的主题，a、b目录同一时刻只能有一个存在flag文件。
   */
  public static readonly FLAG_PATH_A: string = '/data/themes/a/app/flag';

  /**
   * 沙箱文件路径a
   */
  public static readonly SANDBOX_PATH_A: string = '/data/themes/a/system';

  /**
   * 沙箱文件share路径
   */
  public static readonly SANDBOX_PATH_SHARE: string = '/data/themes/s/';

  /**
   * 沙箱文件share中lock路径
   */
  public static readonly THEME_LOCK_PATH: string = '/data/themes/s/lock/';

  /**
   * 沙箱文件share中home路径
   */
  public static readonly THEME_HOME_PATH: string = '/data/themes/s/home/';

  /**
   * 标记文件。存在该文件，表示当前b为使用中的主题，a、b目录同一时刻只能有一个存在flag文件。
   */
  public static readonly FLAG_PATH_B: string = '/data/themes/b/app/flag';

  /**
   * 沙箱文件路径b
   */
  public static readonly SANDBOX_PATH_B: string = '/data/themes/b/system';

  /**
   * AB目录匹配正则
   */
  public static readonly THEME_ROOT_REGEX: string = '\/data\/themes\/[a,b]\/system';

  /**
   * 全局变量 沙箱路径
   */
  public static readonly SANDBOX = 'sandbox';

  /**
   * 全局变量 edit 临时路径
   */
  public static readonly EDIT_ROOT_PATH: string = 'editRootPath';

  /**
   * 全局变量 是否是会在编辑时生成资源的主题
   */
  public static readonly IS_GENERATE_RESOURCE_WHEN_EDITING: string = 'isGenerateResourceWhenEditing';

  /**
   * 全局变量 会在编辑时生成资源的主题参数
   */
  public static readonly IS_GENERATE_RESOURCE_WHEN_EDITING_TRUE: string = '1';

  /**
   * 全局变量 是否应用生成的自定义资源
   */
  public static readonly APPLY_GENERATE_RESOURCES: string = 'applyGenerateResources';

  /**
   * 全局变量 AIGC生成图片类型
   */
  public static readonly AIGC_IMAGE_TYPE: string = 'aigcImageType';

  /**
   * 全局变量 AIGC生成图片类型 - 法线3D图
   */
  public static readonly AIGC_IMAGE_TYPE_NORMAL3D: string = 'normal3d';

  /**
   * 小折叠外屏资源路径
   */
  public static readonly THEME_COMMON_SUBS_DIR: string = 'sub_screen';

  /**
   * 全局变量 aodPosX
   */
  public static readonly AODPOSX = 'aodPosX';

  /**
   * 全局变量 aodPosY
   */
  public static readonly AODPOSY = 'aodPosY';

  /**
   * 全局变量 aodWidth
   */
  public static readonly AODWIDTH = 'aodWidth';

  /**
   * 全局变量 aodHeight
   */
  public static readonly AODHEIGHT = 'aodHeight';

  /**
   * 图片多语言默认路径
   */
  public static readonly LANGUAGE_DEFAULT_PATH: string = '/base/en-Latn-US.json';

  /**
   * 资源路径（需要RootPath作为前缀拼接使用）
   */
  public static readonly SANDBOX_RESOURCES_PATH: string = '/base/resources/';

  /**
   * zip包后缀
   */
  public static readonly ZIP_SUFFIX: string = '.zip';

  /**
   * 音乐包名
   */
  public static readonly openharmony_MUSIC_PKG_NAME: string = 'com.ohos.music';

  /**
   * 历史会话session上限
   */
  public static SESSION_SIZE_LIMIT: number = 2;

  /**
   * number默认值
   */
  public static readonly UNDEFINED: number = -1;

  /**
   * alpha参数的最大值
   */
  public static readonly MAX_ALPHA: number = 255;

  /**
   * 透明度动画类型
   */
  public static readonly ALPHA_ANIMATION: number = 1;

  /**
   * 位移动画类型
   */
  public static readonly POSITION_ANIMATION: number = 2;

  /**
   * 旋转动画类型
   */
  public static readonly ROTATION_ANIMATION: number = 3;

  /**
   * 缩放动画类型
   */
  public static readonly SIZE_ANIMATION: number = 4;

  /**
   * 额外宽高初始值
   */
  public static readonly DEFAULT_EXTRAL_WH: number = -1;

  /**
   * 一镜到底帧动画类型
   */
  public static readonly FRAME_ANIMATION: number = 5;

  /**
   * 帧动画类型
   */
  public static readonly SOURCES_ANIMATION: number = 6;

  /**
   * fontSize默认值
   */
  public static readonly DEFAULT_FONT_SIZE: number = 40;

  /**
   * 判断浮点数是否相等的Epsilon常量
   */
  public static readonly EPSILON: number = 0.00000001;

  /**
   * 命令执行条件默认值，默认允许执行
   */
  public static readonly DEFAULT_COMMAND_CONDITION: number = 1;

  /**
   * 命令延时默认值，默认不延时
   */
  public static readonly DEFAULT_DELAY: number = 0;

  /**
   * 屏幕旋转的key
   */
  public static readonly IS_ROTATED: string = 'isRotated';

  /**
   * 视频主题最大动画时长，用于半折状态到AOD
   */
  public static readonly MAX_ANIM_TIME_VIDEO_FRAME: number = 900;

  /**
   * 超大屏视频主题视频尺寸，单位px
   */
  public static readonly TRI_FOLD_VIDEO_FRAME_SIZE: number = 3184;

  /**
   * 超大屏M态宽，单位px
   */
  public static readonly TRI_FOLD_UNFOLD_WIDTH: number = 2048;

  /**
   * 超大屏M态高，单位px
   */
  public static readonly TRI_FOLD_UNFOLD_HEIGHT: number = 2232;

  /**
   * 超大屏F态宽，单位px
   */
  public static readonly TRI_FOLD_BASE_WIDTH: number = 1008;

  /**
   * 超大屏M态X轴偏移，单位px
   */
  public static readonly TRI_FOLD_UNFOLD_OFFSET_X: number = -1136;

  /**
   * 超大屏G态锁屏X轴偏移，单位px
   */
  public static readonly UNFOLD2_LOCK_OFFSET_X: number = 1084;

  /**
   * 超大屏F态锁屏X轴偏移，单位px
   */
  public static readonly TRI_BASE_LOCK_OFFSET_X: number = 52;

  /**
   * 黑色
   */
  public static readonly COLOR_BLACK: number = 0x00000000;

  /**
   * 白色
   */
  public static readonly COLOR_WHITE: number = 0xFFFFFFFF;

  /**
   * 锁屏静态壁纸新的资源读取方式标志位
   */
  public static readonly IS_LOCK_NEW_RESOURCE_READING: string = 'isLockNewResourceReading';

  /**
   * 桌面静态壁纸新的资源读取方式标志位
   */
  public static readonly IS_HOME_NEW_RESOURCE_READING: string = 'isHomeNewResourceReading';

  /**
   * visibility默认值
   */
  public static readonly DEFAULT_VISIBILITY: number = 1;

  /**
   * 默认锁屏虚拟宽带720px
   */
  public static readonly DEFAULT_SCREEN_WIDTH: number = 720;

  /**
   * 1000ms
   */
  public static readonly ONE_SECOND: number = 1000;

  /**
   * 支持最小帧率5fps
   */
  public static readonly SUPPORT_MIN_FRAME_RATE: number = 5;

  /**
   * 支持最大帧率120fps
   */
  public static readonly SUPPORT_MAX_FRAME_RATE: number = 120;

  /**
   * 默认锁屏帧率60fps
   */
  public static readonly DEFAULT_FRAME_RATE: number = 60;

  /**
   * 括号长度, 如: {}, [], ()
   */
  public static readonly BRACKETS_LENGTH: number = 2;

  /**
   * 文本滚动播放延迟时间
   */
  public static readonly DEFAULT_DELAY_TIME: number = 3000;

  /**
   * 打断类型暂停
   */
  public static readonly INTERRUPT_TYPE_PAUSE: string = '0';

  /**
   * 打断类型重启
   */
  public static readonly INTERRUPT_TYPE_RESUME: string = '1';

  /**
   * 动画类型map
   */
  public static readonly ANIMATION_TYPE_MAP = new Map<string, number>([
    ['alphaAnimation', Constants.ALPHA_ANIMATION],
    ['positionAnimation', Constants.POSITION_ANIMATION],
    ['rotationAnimation', Constants.ROTATION_ANIMATION],
    ['sizeAnimation', Constants.SIZE_ANIMATION],
    ['frameAnimation', Constants.FRAME_ANIMATION],
    ['SourcesAnimation', Constants.SOURCES_ANIMATION],
  ]);

  /**
   * 电池默认状态
   */
  public static readonly BATTERY_NORMAL_STATE: number = 0;

  /**
   * 电池满电状态
   */
  public static readonly BATTERY_FULL_STATE: number = 3;

  /**
   * 电池充电中状态
   */
  public static readonly BATTERY_CHARGING_STATE: number = 1;

  /**
   * 电池低电量状态
   */
  public static readonly BATTERY_LOW_STATE: number = 2;

  /**
   * 数组删除个数
   */
  public static readonly ARRAY_DELETE_NUMBER: number = 1;

  /**
   * 字符串分隔符
   */
  public static readonly STRING_SEPARATOR: string = '_';

  /**
   * 黑屏维测日志前缀 black screen of death
   */
  public static readonly PREFIX_BSOD: string = 'BSoD_';

  /**
   * 系统返回深色模式
   */
  public static readonly SYSTEM_DARK_MODE: number = 0;

  /**
   * 系统返回浅色模式
   */
  public static readonly SYSTEM_LIGHT_MODE: number = 1;

  /**
   * 系统返回不支持任何模式
   */
  public static readonly SYSTEM_NOT_SUPPORT: number = -1;

  /**
   * 全局变量深色模式
   */
  public static readonly GLOBAL_DARK_MODE: string = '2';

  /**
   * 全局变量浅色模式
   */
  public static readonly GLOBAL_LIGHT_MODE: string = '1';

  /**
   * 全局变量不支持任何模式
   */
  public static readonly GLOBAL_NOT_SUPPORT: string = '0';

  /**
   * 震动状态名称
   */
  public static readonly VIBRATE_STATE: string = 'contextVibrate';

  // 黄历
  public static readonly ALMANAC: string = 'Almanac';

  // 星座
  public static readonly CONSTELLATIONS: string = 'Constellations';

  // 历史上今天大事件
  public static readonly BIG_EVENT: string = 'BigEvent';

  // 动画选项，无限次播放
  public static readonly UNLIMITED_LINEAR_ANIMATOR_OPTIONS: AnimatorOptions = {
    duration: 20000, // 动画时间 20000
    easing: 'linear',
    delay: 0,
    fill: 'forwards',
    direction: 'normal',
    iterations: -1, // 无限次播放
    begin: 0.0,
    end: 1.0,
  };

  /**
   * 平角180度
   */
  public static readonly FLAT_ANGLE: number = 180;

  /**
   * 摇一摇键名
   */
  public static readonly SHAKE_NAME: string = 'shake';

  /**
   * scaleType 缩放类型fill
   */
  public static readonly FILL: string = 'fill';

  /**
   * scaleType 缩放类型center_crop
   */
  public static readonly CENTER_CROP: string = 'center_crop';

  /**
   * scaleType 缩放类型HOLD_center_crop
   */
  public static readonly HOLD_CENTER_CROP: string = 'hold_center_crop';

  /**
   * 刚体默认系数
   */
  public static readonly COLLBODY_DEFAULT_COEFFICIENT: number = 0.5;

  /**
   * 刚体默认形状-圆形
   */
  public static readonly COLLBODY_DEFAULT_SHAPE: number = 1;

  /**
   * 进度条顶部默认颜色
   */
  public static readonly DEFAULT_TOP_COLOR: string = '#fff';

  /**
   * 进度条底部默认颜色
   */
  public static readonly DEFAULT_BOTTOM_COLOR: string = '#808080';

  /**
   * 触发监听 HealthyProvider 的emitter事件id
   */
  public static readonly HEALTHY_PROVIDER_EMITTER_ID: number = 1;

  /**
   * 默认不透明
   */
  public static readonly DEFAULT_ALPHA: number = 1;

  /**
   * 默认字体不响应设置中修改字体大小
   */
  public static readonly DEFAULT_FONT_SCALE: number = 1;

  /**
   * 资源重加载策略标识
   */
  public static readonly RESOURCE_RELOAD = 0;

  /**
   * 窗口重加载策略标识
   */
  public static readonly WINDOW_RELOAD = 1;

  /**
   * 布局重加载策略标识
   */
  public static readonly LAYOUT_RELOAD = 2;

  /**
   * 需要减半的数据使用
   */
  public static readonly HALF_DATA = 2;

  /**
   * 深色模式变量名
   */
  public static readonly DARK_MODE: string = 'darkMode';

  /**
   * 电量变量名
   */
  public static readonly BATTERY_LEVEL: string = 'battery_level';

  /**
   * 电池状态变量名
   */
  public static readonly BATTERY_STATE: string = 'battery_state';

  /**
   * 打点上报操作类型
   */
  public static readonly PERF_MONITOR_ACTION_TYPE: number = 1;

  /**
   * 全局变量 AOD定制化类型变量名
   */
  public static readonly AOD_CUSTOMTYPE: string = 'customType';

  /**
   * 是否在进入AOD时实时生成AOD截图，默认false
   */
  public static readonly AOD_SCREEN_SHOT: string = 'aodScreenShot';

  /**
   * 是否在根节点截图，默认false
   */
  public static readonly CONTEXT_PAGE_SNAP_SHOT: string = 'contextPageSnapShot';

  /**
   * 全局变量 AOD类型变量名
   */
  public static readonly AOD_TYPE: string = 'type';

  /**
   * 全局变量 全屏AOD名称
   */
  public static readonly FULL_AOD: string = 'fullScreen';

  /**
   * 全局变量 半屏aod与orientation有关样式名称
   */
  public static readonly HALF_AOD: string = 'halfAodWithOrientation';

  /**
   * 全局变量 AOD定制化类型，screenShot
   */
  public static readonly AOD_CUSTOMTYPE_SCREENSHOT: string = 'screenShot';

  /**
   * 全局变量 主题share路径
   */
  public static readonly THEME_SHARE_PATH: string = '/data/themes/s/';

  /**
   * 全局变量 当前设备限定符
   */
  public static readonly RESOURCE_QUALIFIER: string = 'resourceQualifier';

  /**
   * 全局变量 png 类型文件扩展名
   */
  public static readonly EXTENSION_NAME_PNG: string = 'png';

  /**
   * 全局变量 webp 类型文件扩展名
   */
  public static readonly EXTENSION_NAME_WEBP: string = 'webp';

  /**
   * 系统全局变量名数组
   */
  public static readonly SYSTEM_GLOBAL_PARAMETER: Set<string> = new Set([
    'systemVersion',
    'storageFree',
    'storageFreeNum',
    'storageTotal',
    'storageTotalNum',
    'automaticRotary',
    'brightness',
    'vibration',
    'flashlight']);

  /**
   * 电池全局变量名数组
   */
  public static readonly BATTERY_GLOBAL_PARAMETER: Set<string> = new Set([
    'battery_level',
    'battery_state']);

  public static readonly FOCUS_MODE: string = 'focus_mode';

  /**
   * 时间变量名数组
   */
  public static readonly TIME_GLOBAL_PARAMETER: Set<string> = new Set([
    'year',
    'month',
    'day_of_week',
    'date',
    'hour',
    'lunarYear',
    'lunarMonth',
    'lunarDay',
    'ishour12',
    'hour24',
    'hour12',
    'utcHour',
    'minute',
    'utcMinute',
    'system.time.min1',
    'system.time.min2',
    'system.time.hour1',
    'system.time.hour2',
    'system.time.ampm',
    'second']);

  /**
   * 充电全局变量名数组
   */
  public static readonly CHARGE_GLOBAL_PARAMETER: Set<string> = new Set([
    'charge_anim',
    'charge_type',
    'charge_type_value',
    'charge_mode',
    'charge_mode_value',
    'charge_max_power',
    'charge_power_value',
    'charge_level',
    'wireless_center_X',
    'wireless_center_Y',
    'super_charge',
    'charge_info',
    'turbo_status',
    'turbo_anim']);

  /**
   * 充电动效引擎 对应的key
   */
  public static readonly CHARGING_ENGINE_KEY: string = 'com.ohos.charging';

  /**
   * rpc发送桌面壁纸的code
   */
  public static readonly STATIC_WALLPAPER_HOME_CODE: number = 2;

  /**
   * rpc发送锁屏壁纸的code
   */
  public static readonly STATIC_WALLPAPER_LOCK_CODE: number = 3;

  /**
   * 引擎上下文无效状态
   */
  public static readonly CONTEXT_STATE_INVALID: number = -1;

  /**
   * 引擎上下文有效状态
   */
  public static readonly CONTEXT_STATE_VALID: number = 0;

  /**
   * 十进制
   */
  public static readonly RADIX_10: number = 10;

  /**
   * 十六进制
   */
  public static readonly RADIX_16: number = 16;

  /**
   * 引擎上下文无效时的key
   */
  public static readonly CONTEXT_KEY_INVALID: string = 'invalid';

  public static readonly QUALIFIER_BASE: string = 'base';

  public static readonly QUALIFIER_LOCK: string = 'lock';

  public static readonly QUALIFIER_UNFOLDED: string = 'Unfolded';

  public static readonly QUALIFIER_FULL_UNFOLDED: string = 'Unfolded2';

  public static readonly QUALIFIER_LAND: string = 'Land';

  public static readonly QUALIFIER_UNFOLDED_LAND: string = `${Constants.QUALIFIER_UNFOLDED}${Constants.QUALIFIER_LAND}`;

  public static readonly QUALIFIER_FULL_UNFOLDED_LAND: string = `${Constants.QUALIFIER_FULL_UNFOLDED}${Constants.QUALIFIER_LAND}`;

  // Aod2Home
  public static readonly AOD_TO_HOME: string = 'Aod2Home';

  // Aod2Lock
  public static readonly AOD_TO_LOCK: string = 'Aod2Lock';

  // Lock2Aod
  public static readonly LOCK_TO_AOD: string = 'Lock2Aod';

  // Home2Aod
  public static readonly HOME_TO_AOD: string = 'Home2Aod';

  // Lock2Home
  public static readonly LOCK_TO_HOME: string = 'Lock2Home';

  // Home
  public static readonly HOME: string = 'Home';

  // Lock
  public static readonly LOCK: string = 'Lock';

  // Aod
  public static readonly AOD: string = 'Aod';

  // Aod2Aod
  public static readonly AOD_TO_AOD_STATUS: string = 'Aod2Aod';

  // Home2Home
  public static readonly HOME_TO_HOME_STATUS: string = 'Home2Home';

  // Lock2Lock
  public static readonly LOCK_TO_LOCK_STATUS: string = 'Lock2Lock';

  // Home2Lock
  public static readonly HOME_TO_LOCK_STATUS: string = 'Home2Lock';

  // LidOpen
  public static readonly LID_OPEN: string = 'LidOpen';

  // DoubleClick
  public static readonly DOUBLE_CLICK: string = 'DoubleClick';

  // SourceModeMain
  public static readonly SOURCE_MODE_CHANGE_MAIN: string = 'SourceModeMain';

  // SourceModeExtend
  public static readonly SOURCE_MODE_CHANGE_EXTEND: string = 'SourceModeExtend';

  // BatteryChange
  public static readonly BATTERY_CHANGE: string = 'BatteryChange';

  // 贴纸触发刷新属性
  public static readonly STICKER_REFRESH_ATTRIBUTE: string = 'sticker';

  // unlockAuthResult
  public static readonly UNLOCK_AUTH_RESULT_PROP: string = 'unlockAuthResult';

  // unlockAuthType
  public static readonly UNLOCK_AUTH_TYPE_PROP: string = 'unlockAuthType';

  // DYNAMIC_CONTEXT_PAGE
  public static readonly DYNAMIC_CONTEXT_PAGE: string = 'DYNAMIC_CONTEXT_PAGE';

  // 展开态标志
  public static readonly EXPAND_STATUS: string = '1';

  // 默认静态壁纸模糊半径
  public static readonly DEFAULT_STATIC_WALLPAPER_BLUR_RADIUS: number = 150;

  // 静态壁纸模糊半径最小值
  public static readonly MIN_STATIC_WALLPAPER_BLUR_RADIUS: number = 1;

  // 静态壁纸模糊半径最大值
  public static readonly MAX_STATIC_WALLPAPER_BLUR_RADIUS: number = 250;

  //星盾动效时长
  public static readonly SAFEMODE_ANIMATION_DURATION: number = 1900;

  // 默认动效速度
  public static readonly DEFAULT_ANIMATION_SPEED: number = 1;

  // 能播放的动画状态的列表
  public static readonly ANIMATION_TYPE_LIST: number[] = [
    this.AOD_STATUS,
    this.AOD_TO_LOCKSCREEN,
    this.AOD_TO_LAUNCHER,
    this.LOCKSCREEN_STATUS,
    this.LOCKSCREEN_TO_AOD,
    this.LOCKSCREEN_TO_LAUNCHER,
    this.LAUNCHER_STATUS,
    this.LAUNCHER_TO_AOD,
    this.LAUNCHER_TO_LOCKSCREEN,
    this.AOD_TO_LOCKSCREEN_LID_OPEN,
    this.LAUNCHER_STATUS_DOUBLE_CLICK,
  ];

  public static animationCanPlay(type: number): boolean {
    return Constants.ANIMATION_TYPE_LIST.includes(type);
  }
}

export enum AnimationCommandPC {
  DESKTOP_TO_LOCKSCREEN_PC = 1000,
  LOCKSCREEN_TO_DESKTOP_PC = 1001,
  DOUBLE_CLICK_DESKTOP_PC = 1002,
  SCREEN_ON_PC = 1003,
  SCREEN_OFF_PC = 1004,
  LID_OPEN_PC = 1005,
}

export enum AnimationCommandPad {
  LOCKSCREEN_TO_DESKTOP_PAD = 2000,
  DOUBLE_CLICK_PAD = 2001,
  SCREEN_ON_PAD = 2002,
  SCREEN_OFF_PAD = 2003,
  ANIMATION_STOP_PAD = 2004,
}

/**
 * wallpaperConfig.json版本号标识
 */
export enum VersionCode {
  VERSION_CODE_UNKNOWN = 0,
  VERSION_CODE_FIVE_ZERO = 500000000,
  VERSION_CODE_FIVE_ONE = 500100000,
}

/**
 * 几何图形类型
 */
export const geometryType: number[] = [
  DataType.RECTANGLE,
  DataType.CIRCLE,
  DataType.ELLIPSE,
  DataType.ARC,
  DataType.LINE,
];

/**
 * 3d旋转支持的视图类型
 */
export const stereoSupportType: number[] = [
  DataType.IMAGE,
  DataType.TEXT,
];

/**
 * tv上的类型
 */
export const tvType: number[] = [
  DataType.SCENERY,
  DataType.CAROUSEL,
  DataType.LAYER_PHOTO_WALL,
  DataType.GRID_PHOTO_WALL,
];

/**
 * 基础视图类型，主要支持通用属性的视图
 */
export const baseNodeType: number[] = [
  DataType.IMAGE,
  DataType.TEXT,
  DataType.GROUP,
  DataType.SOURCE_IMAGE,
  DataType.DATETIME,
  DataType.TIME,
  DataType.IMAGE_NUMBER,
  DataType.IMAGE_SERIES,
  DataType.PROGRESS,
  DataType.MARQUEE,
  DataType.VIDEO,
  DataType.VIDEO_FRAME,
  DataType.FLIP_LIGHT,
  DataType.FLIP_KALEIDOSCOPE,
  DataType.FLIP_TRANSFORM,
  DataType.DIGITAL_CLOCK,
  DataType.CIRCLE_GRADIENT,
  DataType.SHADER_EFFECT,
  DataType.INFINITY,
  DataType.MESH_IMAGE,
  DataType.MULTILAYER,
  DataType.LAYER,
  DataType.ARRAY,
  DataType.SLIDER,
  DataType.AGP,
  DataType.INTERACTIVE_AGP,
  DataType.SIM_SCENE,
  DataType.UNLOCKER,
  DataType.MEDIA_ICON,
  DataType.SMART_STICKER,
  DataType.COMMON_STICKER,
  DataType.STEREO_VIEW,
  DataType.INFLATE,
  DataType.AOD_CLOCK,
  DataType.LOCK_CLOCK,
  DataType.GROUP_CLOCK,
  DataType.GROUP_BATTERY,
  ...geometryType,
  ...tvType,
];

/**
 * 折叠状态枚举
 */
export enum FoldStatus {
  /**
   * 折叠态
   */
  FOLD = 0,

  /**
   * 展开态
   */
  UNFOLD = 1,
}

export enum BodyType {
  STATIC = 0,
  DYNAMIC = 1
}

/**
 * 3D旋转视图滚动状态
 */
export enum StereoViewScrollState {
  SCROLLING = 0, // 正在滑动
  STOP = 1 // 停止
}

/**
 * 折叠屏折展和横竖屏需要做动画的状态枚举
 */
export enum DeviceChangeStatus {
  /**
   * 横竖屏旋转
   */
  ROTATE = 0,
  /**
   * M态竖屏展开到横屏倒转G态，充电口在下方
   */
  PORTRAIT_M2G_LAND_INVERTED = 1,
  /**
   * M态横屏展开到G态，充电口在上方
   */
  PORTRAIT_INVERTED_M2G_LAND = 2,
  /**
   * 横屏倒转M态展开到竖屏倒转G态，充电口在上方
   */
  LAND_INVERTED_M2G_PORTRAIT_INVERTED = 3,
  /**
   * M态横屏展开到竖屏G态，充电口在下方
   */
  LAND_M2G_PORTRAIT = 4,
  /**
   * G态竖屏折叠到M态横屏，充电口在左侧
   */
  PORTRAIT_G2M_LAND = 5,
  /**
   * G态竖屏倒转折叠到M态横屏倒转，充电口在右侧
   */
  PORTRAIT_INVERTED_G2M_LAND_INVERTED = 6,
  /**
   * G态横屏折叠到M态,充电口在上方
   */
  LAND_G2M_PORTRAIT_INVERTED = 7,
  /**
   * G态横屏倒转折叠到M态,充电口在下方
   */
  LAND_INVERTED_G2M_PORTRAIT = 8,
  /**
   * F态竖屏展开到G态,充电口在下方
   */
  PORTRAIT_F2G_LAND_INVERTED = 9,
  /**
   * G态横屏折叠到F态,充电口在下方
   */
  LAND_INVERTED_G2F_PORTRAIT = 10,
  /**
   * 无效
   */
  INVALID = 11,
}

/**
 * 引擎animatronix组件配置信息
 */
export enum AnimatronixInfo {
  BUNDLE_NAME = 'com.ohos.animatronix',
  MODULE_NAME = 'animatronix'
}

export enum DesktopModeEnum {
  BASE_MODE = 0, // 正常模式
  EMERGENCY_MODE = 1, // 应急模式
  THERMAL_SAFE_MODE = 2, // 热安全模式
  THER_EMC_OVERLAY_MODE = -1
}