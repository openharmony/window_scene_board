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
import type { DeviceState } from '../constants/CommonConstants';

export class ReportParams {
  public static PACKAGE_NAME: string = 'com.ohos.sceneboard';
  public static PROCESS_NAME: string = 'sceneBoard';
}

export class FolderStateInfoBean {
  public serialNum: string = '';
  public folderId: string = '';
  public folderContentAndPosition: string = '';
  public launcherType: number = 0;
  public launcherIdType: string = '';
  public folderIdType: string = '';
  public screenCount: number = 0;
  public screenIndex: number = 0;
  public cellX: number = 0;
  public cellY: number = 0;
  public pageNum: number = 0;
  public iconNum: number = 0;
  public isInDock: boolean = false;
  public folderType: number = 0;
}

export interface FolderStateInfoParams {
  PNAMEID: string;
  PVERSIONID: string;
  SERIALNUM: string;
  FOLDERID: string;
  LAUNCHERTYPE: number;
  LAUNCHERGRIDTYPE: string;
  FOLDERGRIDTYPE: string;
  ISINDOCK: boolean;
  SCREENCOUNT: number;
  SCREENINDEX: number;
  CELLX: number;
  CELLY: number;
  PAGENUMBER: number;
  ICONNUMBER: number;
  FOLDERTYPE: number;
}

export interface DragIconAdjustmentSequenceParams {
  PNAMEID: string;
  PVERSIONID: string;
  FROMPOSITION: string;
  TOPOSITION: string;
  PACKAGENAME: string;
  DUALSTATUS: DeviceState;
  TYPE: number;
  MODE: number;
  SCREEN_TYPE: number;
  IS_SHORTCUT: boolean;
}

export interface DesktopRegisterDMSListenerParams {
  ORG_PKG: string;
  FUNC: string;
  BIZ_SCENE: number;
  BIZ_STAGE: number;
  STAGE_RES: number;
  BIZ_STATE: number;
}

export interface DesktopReceiveDMSNoticeParams {
  ORG_PKG: string;
  FUNC: string;
  BIZ_SCENE: number;
  BIZ_STAGE: number;
  STAGE_RES: number;
  NOTIFY_MODE: string;
}

export interface DesktopShowContinueIconEndParams {
  ORG_PKG: string;
  FUNC: string;
  BIZ_SCENE: number;
  BIZ_STAGE: number;
  STAGE_RES: number;
  BIZ_STATE: number;
};

export interface UserClickContinueIconEventParams {
  ORG_PKG: string;
  FUNC: string;
  BIZ_SCENE: number;
  BIZ_STAGE: number;
  STAGE_RES: number;
  BIZ_STATE: number;
}
export interface TriggerContinueMissionParams {
  ORG_PKG: string;
  FUNC: string;
  BIZ_SCENE: number;
  BIZ_STAGE: number;
  STAGE_RES: number;
  PEER_NET_ID: string;
}

/**
 * 位置分类 1 dock 2 桌面 3 小文件夹 4大文件夹展示在桌面 5大文件夹内隐藏
 */
export enum LocationTypes {
  DOCK = 1,
  DESKTOP = 2,
  FLODER = 3,
  BIG_FLODER = 4,
  BIG_FLODER_HIDE = 5,
}

/**
 * 桌面_每一屏的大于1*1空网格种类及对应个数(状态点,周报,周日报)
 */
export class EmptyGridInfoBean {
  public PNAMEID: string = ReportParams.PACKAGE_NAME;
  public PVERSIONID: string = ReportParams.PROCESS_NAME;
  /**
   * 屏幕页码
   */
  public SCREENID: number = 0;
  /**
   * 网格尺寸
   * @see EmptyGridSizes
   */
  public SIZE: string = '';
  /**
   * 网格起始位置X轴
   */
  public CELLX: number = 0;
  /**
   * 空网格起始位置Y轴
   */
  public CELLY: number = 0;
  /**
   * 是否是空网格，0非空网格，1空网格
   */
  public EMPTYFLAG: number = 0;
}

/**
 * 桌面图标位置状态点
 */
export class IconGridInfoBean {
  public PNAMEID: string = ReportParams.PACKAGE_NAME;
  public PVERSIONID: string = ReportParams.PROCESS_NAME;
  public PARAMS: string = '';
  public NOTHARMONYNUM: number = 0;
  public EASYNUM: number = 0;
}

/**
 * 外屏桌面图标位置状态点
 */
export class OuterIconGridInfoBean {
  /**
   * 包名称
   */
  public PNAMEID: string = ReportParams.PACKAGE_NAME;
  /**
   * 应用版本
   */
  public PVERSIONID: string = ReportParams.PROCESS_NAME;
  /**
   * 屏幕页码
   */
  public SCREENID: number = 0;
  /**
   * 应用包名
   */
  public PACKAGENAME: string = '';
  /**
   * 图标起始位置X轴
   */
  public CELLX: number = 0;
  /**
   * 图标起始位置Y轴
   */
  public CELLY: number = 0;
  /**
   * 位置分类 1 dock 2 桌面 3 小文件夹 4大文件夹展示在桌面 5大文件夹内隐藏
   * @see LocationTypes
   */
  public LOCATIONTYPE: number = 0;
  /**
   * 文件夹类型 0-普通文件夾, 1-非OpenHarmony化, -1-均不是
   */
  public FOLDERTYPE: number = 0;
  /**
   * app类型 0-正常应用，可直接打开, 2-未OpenHarmony化应用（未安装）, -1-均不是
   */
  public APPTYPE: number = 0;
  /**
   * 应用appName
   */
  public APPNAME: string = '';
  /**
   * 未OpenHarmony化文件夹中图标数量
   */
  public NOTHARMONYNUM: number = 0;
  /**
   * 出xx文件夹中应用数量
   */
  public EASYNUM: number = 0;
}

/**
 * 图标位置报点参数详情
 */
export interface IconGridInfoBeanParams {
  /**
   * 屏幕页码
   */
  SCREENID: number;
  /**
   * 应用包名
   */
  PACKAGENAME: string;
  /**
   * 图标起始位置X轴
   */
  CELLX: number;
  /**
   * 图标起始位置Y轴
   */
  CELLY: number;
  /**
   * 位置分类 1 dock 2 桌面 3 小文件夹 4大文件夹展示在桌面 5大文件夹内隐藏
   * @see LocationTypes
   */
  LOCATIONTYPE: number;
  /**
   * 文件夹类型 0-普通文件夾, 1-非OpenHarmony化, -1-均不是
   *
   */
  FOLDERTYPE: number;
  /**
   * app类型 0-正常应用，可直接打开, 2-未OpenHarmony化应用（未安装）, -1-均不是
   *
   */
  APPTYPE: number;
  /**
   * 应用appName
   *
   */
  APPNAME: string;
}

/**
 * 外屏快捷方式状态点
 */
export class OuterShortcutInfoBean {
  /**
   * 包名称
   */
  public PNAMEID: string = ReportParams.PACKAGE_NAME;
  /**
   * 应用版本
   */
  public PVERSIONID: string = ReportParams.PROCESS_NAME;
  /**
   * 应用包名
   */
  public BUNDLENAME: string = '';
  /**
   * 快捷方式名称
   */
  public SHORTCUTNAME: string = '';
  /**
   * 所在屏
   * @see LocationTypes
   */
  public PAGENUM: number = 0;
  /**
   * 所在列
   */
  public COLUMN: number = 0;
  /**
   * 所在行
   */
  public ROW: number = 0;
  /**
   * 位置分类 1 dock 2 桌面 3 小文件夹 4大文件夹展示在桌面 5大文件夹内隐藏
   * @see LocationTypes
   */
  public LOCATIONTYPE: number = 0;
  /**
   * 外屏应用快捷方式总量
   */
  public TOTALNUM: number = 0;
}

 /**
  * 快捷方式参数
  *
  */
export interface ShortcutInfoBeanParams {
  BUNDLENAME: string;
  SHORTCUTNAME: string;
  PAGENUM: number;
  COLUMN: number;
  ROW: number;
  /**
   * 位置分类 1 dock 2 桌面 3 小文件夹 4大文件夹展示在桌面 5大文件夹内隐藏
   *
   * @see LocationTypes
   */
  LOCATIONTYPE: number;
  TOTALNUM: number;
}