/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

export class AigcConstant {
  // Flag path to identify theme A is currently active
  public static readonly THEME_A_FLAG: string = '/data/themes/a/app/flag';

  // Flag path to identify theme B is currently active
  public static readonly THEME_B_FLAG: string = '/data/themes/b/app/flag';

  // Actual resource path for theme A
  public static readonly THEME_A_PATH: string = '/data/themes/a/system';

  // Actual resource path for theme B
  public static readonly THEME_B_PATH: string = '/data/themes/b/system';

  public static readonly PRESET_DIR: string = '/data/themes/s/preset';

  public static readonly WORK_DIR: string = '/data/themes/s/preset/xuniverse';

  public static readonly DOWNLOAD_DIR: string = '/data/themes/s/preset/xuniverse/download';

  public static readonly CAROUSEL_DIR: string = '/data/themes/s/preset/xuniverse/carousel';

  public static readonly CAROUSEL_UNFOLDED_DIR: string = '/data/themes/s/preset/xuniverse/carousel_unfolded';

  public static readonly TEMP_DIR: string = '/data/themes/s/preset/xuniverse/temp';

  public static readonly THEME_CUSTOM_DIR: string = AigcConstant.CAROUSEL_DIR + '/tmpTheme';

  public static readonly ACTIVATE_THEME_CUSTOM: string = 'activateThemeCustom';

  public static readonly INTERFACE_TOKEN = 'ohos.pandora.aigcService';

  public static readonly GET_CURRENT_THEME: string = `getCurrentTheme`;

  public static readonly EDIT_THEME: string = `editTheme`;

  public static readonly GET_SUB_SCREEN_THEMES: string = `getSubScreenThemes`;

  public static readonly GENERATE_FILE_COUNT: number = 4;

  public static readonly MAX_FILE_COUNT: number = 8;

  public static readonly MAX_STYLE_COUNT: number = 100;

  public static readonly PANDORA_BEGIN_ID: number = 522;

  public static readonly AOD_DIM_FACTOR: number = 90;

  public static readonly MAX_VIDEO_COUNT: number = 8;

  public static readonly GENERATE_VIDEO_COUNT: number = 2;

  /**
   * AIGC生成视频结束消息
   */
  public static readonly AIGC_VIDEO_GENERATE_FINISHED: string = 'AIGCVideoFinished';

  // 水印相关
  public static WATER_MARK_X_V1: number = 30;

  public static WATER_MARK_Y_V1: number = 10;

  public static WATER_MARK_X_V2: number = 50;

  public static WATER_MARK_Y_V2: number = 3;

  public static WATER_MARK_X_V1_FOLD: number = 37.5;

  public static WATER_MARK_X_V1_UNFOLD: number = 62.5;

  public static WATER_MARK_Y_V1_FOLD: number = 10;

  public static WATER_MARK_Y_V1_OUTSCREEN: number = 40;

  public static WATER_MARK_FONT: string = 'normal 30px HarmonyHeiTi';

  public static WATER_MARK_FILL_STYLE: string = '#99ffffff';

  public static readonly WATERMARK_DIR: string = '/data/themes/s/preset/xuniverse/watermark.json';

  public static CONTENT_PRODUCER: string = '001191320114777023172010000';

  public static PRODUCE_ID_HEAD: string = 'cv_photo_';

  public static DEVICE_TYPE_LARGE_FOLD: string = 'TwofoldPhoneTheme';

  public static DEVICE_TYPE_STRAIGHT: string = 'PhoneTheme';

  public static STYLE_MAP: Map<string, string[]> = new Map([
    ['Female', ['Aesthetic', 'ChineseAn','Fantasy','Fashion','Nation','Traditional','Travel']],
    ['Male', ['ChineseAn', 'Feel', 'Nation', 'Science', 'Sport', 'Suit', 'Travel']],
    ['Girl', ['ChineseAn', 'Elegant', 'Energy', 'Fantasy', 'Travel']],
    ['Boy', ['ChineseAn', 'Cool', 'Fantasy', 'Science', 'Travel']]
  ]);
}

export class ImagePath {
  public src: string = '';
}

export class GalleryCardLockConfig {
  public type: string = '';
  public image: ImagePath = new ImagePath();
  public clockVisible: boolean = true;
}

export class HomeManifest {
  public type: string = '';
  public image?: ImagePath;
  public wallpaperTouchable: boolean = false;
  public applyFrom: string = '';
}

export class ThemeImageActiveParam {
  public PNAMEID: string = '';
  public PVERSIONID: string = '';
  public COSTTIME: number = 0;
  public STATUS: boolean = false;
}

export class PandoraVideoConfig {
  public enableUpdate: boolean = false;
  public style: string = '';
  public type: string = '';
  public templateIdList?: string = '';
}

export class TaskConfig {
  public beginTime: number = -1;
  // public status: AIGCEditorStatus = AIGCEditorStatus.INIT;
  public status: ESObject = 1;
  public errorCode: number = 0;
}

// 调用语音助手接口的参数
export class VideoParameter {
  public scenario: string = '';
  public style: string = '';
  public type: string = '';
  public watermark: boolean = false;
  public templateIdList?: string[] = [];
  public demander?: string = '';
  public generateNum?: number = AigcConstant.GENERATE_VIDEO_COUNT;
}

export class GCMetaData {
  public AIGC: Record<string, string> = {};
}

export class VideoPersonalizeParam {
  public videoCount: number = 0;
}