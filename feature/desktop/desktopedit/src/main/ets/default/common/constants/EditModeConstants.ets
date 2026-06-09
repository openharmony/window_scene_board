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

import type UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { WallpaperConstants } from '@ohos/commonconstants';

/**
 * 图标编辑页图标信息
 */
export class AppInfo {
  public bundleName: string;
  public appName: string;

  constructor(bundleName: string, appName: string) {
    this.bundleName = bundleName;
    this.appName = appName;
  }
}

/**
 * 编辑模式常量类
 */
export class EditModeConstants {
  /**
   * 主题包Icon路径名称
   */
  public static readonly PATH_ICON: string = 'icon';

  /**
   * 文件分隔符
   */
  public static readonly FILE_SEPARATOR: string = '/';

  /**
   * back手势事件常量
   */
  public static readonly BACK_EVENT: string = 'backEvent';

  /**
   * 展示ICON_EDIT_PAGE元素
   */
  public static readonly SHOW_EVENT: string = 'showEvent';

  /**
   * background图标路径
   */
  public static readonly FAKE_ICON_BACK_PATH: string = '/entry/background';

  /**
   * foreground图标路径
   */
  public static readonly FAKE_ICON_FORE_PATH: string = '/entry/foreground';

  /**
   * 获取屏幕锁定状态的表格名称
   */
  public static readonly SCREEN_LOCK_BIND_SHEET = 'sceneboard.screenLockBindSheet';

  /**
   * 获取屏幕高度的表格名称
   */
  public static readonly SCREEN_LOCK_BIND_SHEET_HEIGHT = 'sceneboard.screenLockBindSheetHeight';

  /**
   * 显示底部导航栏事件
   */
  public static readonly AI_BAR_SHOW_EVENT = 'AIBarShow';

  public static readonly ACTIVATED_PATH_A: string = '/data/themes/a/';
  public static readonly ACTIVATED_PATH_B: string = '/data/themes/b/';
  public static readonly ACTIVATED_FLAG: string = 'app/flag';
  public static readonly ACTIVATED_CONFIG: string = 'app/icons/manifest.json';

  public static readonly FORMAT_PNG: string = '.png';
  public static readonly FORMAT_WEBP: string = '.webp';
  public static readonly PATH_ICONS: string = 'icons';

  public static readonly PHONE_ICONS = [
    ['settings', 'gallery', 'clock', 'messaging'],
    ['allapps', 'calculator', 'contacts', 'camera'],
    ['weather', 'himovie', 'music', 'notepad'],
  ];
  public static readonly PHONE_ICONS_SIMPLE = [
    ['camera', 'gallery', 'thememanager'],
    ['filemanager', 'gamecenter', 'notepad'],
  ];
  public static readonly FOLDER_EXPAND_ICONS = [
    ['settings', 'clock', 'calculator', 'contacts', 'gallery', 'mms', 'camera', 'weather'],
    ['meetime', 'calendar', 'appmarket', 'notepad', 'music', 'hwireader', 'thememanager', 'health']
  ];
  /**
   * 超大屏全展态竖屏展示的图标
   */
  public static readonly TRIFOLDER_MODEL_G_PORTRAIT_ICONS = [
    ['settings', 'clock', 'calculator', 'contacts', 'gallery', 'mms', 'camera', 'weather'],
    ['meetime', 'calendar', 'appmarket', 'notepad', 'music', 'hwireader', 'thememanager', 'health'],
    ['gamecenter', 'himovie', 'ailife', 'wallet', 'vmall', 'clouddrive', 'filemanager', 'finddevice']
  ];
  /**
   * 超大屏全展态三屏横屏展示的图标
   */
  public static readonly TRIFOLDER_MODEL_G_TRI_SCREEN_ICONS = [
    ['settings', 'clock', 'calculator', 'contacts', 'gallery', 'mms', 'camera', 'weather', 'meetime', 'calendar', 'appmarket', 'notepad'],
    ['music', 'hwireader', 'thememanager', 'health', 'gamecenter', 'himovie', 'ailife', 'wallet', 'vmall', 'clouddrive', 'filemanager', 'finddevice']
  ];
  public static readonly PAD_LANDSCAPE_ICONS = [
    ['settings', 'clock', 'calculator', 'tips', 'gallery', 'browser', 'camera', 'weather', 'meetime', 'calendar'],
    ['appmarket', 'notepad', 'email', 'music', 'hwireader', 'thememanager', 'health', 'gamecenter', 'himovie',
      'ailife']
  ];
  public static readonly PAD_ICONS = [
    ['settings', 'clock', 'calculator', 'tips', 'gallery', 'browser'],
    ['camera', 'weather', 'meetime', 'calendar', 'appmarket', 'notepad'],
    ['email', 'recorder', 'music', 'hwireader', 'thememanager', 'health'],
    ['gamecenter', 'himovie', 'ailife', 'vmall', 'filemanager', 'finddevice']
  ];

  public static readonly APP_INFOS: Record<string, AppInfo> = {
    'settings': new AppInfo('ohos_settings', 'app.string.settings'),
    'gallery': new AppInfo('ohos_gallery', 'app.string.gallery'),
    'clock': new AppInfo('ohos_clock', 'app.string.clock'),
    'messaging': new AppInfo('ohos_messages', 'app.string.messaging'),
    'allapps': new AppInfo('ohos_allapps', 'app.string.appmarket'),
    'calculator': new AppInfo('ohos_calculator', 'app.string.calculator'),
    'contacts': new AppInfo('ohos_contacts', 'app.string.contacts'),
    'camera': new AppInfo('ohos_camera', 'app.string.camera'),
    'weather': new AppInfo('ohos_airquality', 'app.string.weather'),
    'himovie': new AppInfo('ohos_video', 'app.string.himovie'),
    'music': new AppInfo('ohos_music', 'app.string.sound_music'),
    'notepad': new AppInfo('ohos_notes', 'app.string.notepad'),
    'filemanager': new AppInfo('ohos_document', 'app.string.filemanager'),
    'recorder': new AppInfo('ohos_video', 'app.string.recorder'),
    'vmall': new AppInfo('ohos_shopping', 'app.string.vmall'),
  };

  /**
   * 编辑模式右侧addPage按钮尺寸
   */
  public static readonly PAGE_EDIT_BUTTON_SIZE: number = 40;

  /**
   * 编辑模式右侧addPage按钮内图标尺寸
   */
  public static readonly PAGE_EDIT_BUTTON_ICON_SIZE: number = 24;

  /**
   * 编辑模式右侧addPage按钮呼吸动效scale
   */
  public static readonly PAGE_EDIT_BUTTON_BREARHE_SCALE: number = 0.75;

  /**
   * 编辑模式删除页面按钮底边距
   */
  public static readonly PAGE_EDIT_DELETE_ICON_MARGIN_BOTTOM: number = 24;

  /**
   * 编辑模式右侧addPage按钮非深色背景颜色
   */
  public static readonly PAGE_EDIT_BUTTON_BG_COLOR: string = '#33000000';

  /**
   * 编辑模式右侧addPage按钮深色背景透明度
   */
  public static readonly PAGE_EDIT_BUTTON_DEEP_BG_OPACITY: number = 0.2;

  /**
   * 编辑模式右侧addPage按钮内图标色
   */
  public static readonly PAGE_EDIT_BUTTON_COLOR: string = '#ffffff';

  /**
   * 图标编辑设置项字体最大放大倍数
   */
  public static readonly MAX_FONT_SIZE_SCALE = 1.45;

  /**
   * 图标编辑页设置项镜像语言字体最大放大倍数
   */
  public static readonly MAX_FONT_SIZE_SCALE_RT = 1.3;
}

/**
 * 图标配置文件信息
 */
export interface ManifestData {
  id: string;
  preview: string;
}

/**
 * 图标编辑页面参数信息
 */
export class WantParams {
  public isDarkMode: boolean;
  public wallpaperType: number;
  public fontSizeScale: number;
  public vp2pxScale: number;
  public isAccessibilityMode: boolean;
  public nav: string;
  public nameFontColor: string;
  public statusBarHeight: number;
  public iconSize: number;
  public gridWidth: number;
  public gridHeight: number;
  public rows: number;
  public columns: number;
  public screenHeight: number;
  public screenWidth: number;
  public isDarkWallpaper: boolean;
  public isShowName: boolean;
  public iconChangeSize: number;
  public session?: UIExtensionContentSession;
  public 'ability.want.params.uiExtensionType'?: string;
  public isNeedAppNameShadow: boolean;
  public isFoldExpandedInLandscape: boolean;
  public singlePageFoldScreenWidth: number;

  constructor() {
    this.isDarkMode = false;
    this.wallpaperType = WallpaperConstants.WALLPAPER_TYPE_FIVE;
    this.fontSizeScale = 1;
    this.vp2pxScale = 1;
    this.isAccessibilityMode = false;
    this.nav = '';
    this.nameFontColor = '';
    this.statusBarHeight = 0;
    this.iconSize = 0;
    this.gridWidth = 0;
    this.screenHeight = 0;
    this.screenWidth = 0;
    this.gridHeight = 0;
    this.iconChangeSize = 0;
    this.rows = 1;
    this.columns = 1;
    this.isDarkWallpaper = false;
    this.isShowName = false;
    this.isNeedAppNameShadow = true;
    this.isFoldExpandedInLandscape = false;
    this.singlePageFoldScreenWidth = 0;
  }
}