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

import { CommonEventData } from 'commonEvent/commonEventData';
import commonEvent from '@ohos.commonEventManager';
import { CommonUtils } from '@ohos/basicutils';

enum FileManagerWindowAction {
  ENTER_RECYCLE_BIN = 0,
  LEAVE_RECYCLE_BIN = 1
}

interface LegacyInfo {
  // 对应包名 必传
  pkgName: string,

  // 桌面上显示的应用包名（不会跟随小语种变化）
  pkgLableName: string,

  // 应用签名信息（从迁移服务的app_list.json文件中获取，或克隆通过接口传递）  必传
  pkgSignature: string,

  // App安装路径 （从迁移服务的app_list.json文件中获取，克隆场景不需要传入）
  pkgSourceDir?: string,

  // 应用对应版本名（从迁移服务的app_list.json文件中获取，或克隆通过接口传递）
  versionName?: string,

  // 应用对应版本code（从迁移服务的app_list.json文件中获取，或克隆通过接口传递）
  versionCode?: string,

  // cpu类型（从迁移服务的app_list.json文件中获取），克隆当前无此信息
  primaryCpuAbi?: string,

  // cpu类型（从迁移服务的app_list.json文件中获取），克隆当前无此信息
  secondaryCpuAbi?: string,

  // 是否备份
  backup: number,

  // 应用安装来源
  installSource?: string,

  // 应用置灰状态
  maskState?: number,

  // 快捷方式id
  shortcutId?: string,
}

interface ParametersDataType {
  'ag.params.HARMONY_PKGS_ADDED'?: string[],
  'ag.params.HARMONY_PKGS_REMOVED'?: string[],
  'ag.params.PUBLIC_TEST_APP_PKGS_ADDED'?: string[],
  appId?: string,
  result?: boolean,
  slotId?: number,
  isSleep?: boolean,
  rgmStatus?: string,
  action?: string,
  windowId?: number,
  windowAction?: FileManagerWindowAction,
  windowMode?: string,
  uid?: number,
  userId?: number,
  isModuleUpdate?: boolean,
  bundleType?: number,
  atomicServiceModuleUpgrade?: number,
  isEnableDynamicIcon?: boolean,
  appIndex?: number,
  actionFiles?: string[],
  failFiles?: string[],
  pasteFileUri?: string[],
  isExtensionSuffix?: boolean,
  compressEvent?: string,
  taskId?: string,
  bundleName?: string,
  taskContext?: string,
  appName?: string,
  versionCode?: number,
  versionName?: string,
  iconUrl?: string,
  status?: number,
  totalSize?: number,
  downloadedSize?: number,
  updateStatus?: number,
  legacyInfos?: LegacyInfo[],
  oldBundleNames?: string[],
  startTime?: number,
  errorCode?: number,
  errorDesc?: string,
  moduleName?: string,
  distributeType?: string,
  isSaveIcon?: boolean,
  isSupportShare?: boolean
}
/**
 * 外部广播转内部Event事件
 * 封装转换SDK数据
 *
 * @since 2022-10-07
 */
export class CommonEvent {
  static eventTypeName = 'CommonEvent';
  /**
   * 广播事件名
   */
  readonly event: string;

  /**
   * 广播发送方包名
   */
  readonly bundleName?: string;

  /**
   * 结果码
   */
  readonly code?: number;

  /**
   * 简要数据
   */
  readonly data?: string;
  /**
   * 复杂数据
   */
  readonly parameters?: ParametersDataType;

  /**
   * 构造
   *
   * @param eventData 原始数据
   */
  constructor(eventData: CommonEventData) {
    this.event = eventData?.event;
    this.bundleName = eventData?.bundleName;
    this.code = eventData?.code;
    this.data = eventData?.data;
    this.parameters = eventData?.parameters;
  }
}

/**
 * 包管理广播事件
 */
export class PackageCommonEvent extends CommonEvent {
  static eventTypeName = 'PackageCommonEvent';
  /**
   * 新包安装事件
   */
  static readonly EVENT_PACKAGE_ADD = commonEvent.Support.COMMON_EVENT_PACKAGE_ADDED;

  /**
   * 包卸载事件，数据未删除
   */
  static readonly EVENT_PACKAGE_REMOVED = commonEvent.Support.COMMON_EVENT_PACKAGE_REMOVED;

  /**
   * 包卸载事件，数据同步删除
   */
  static readonly EVENT_PACKAGE_FULL_REMOVED = commonEvent.Support.COMMON_EVENT_PACKAGE_FULLY_REMOVED;

  /**
   * 包更新事件
   */
  static readonly EVENT_PACKAGE_REPLACED = commonEvent.Support.COMMON_EVENT_PACKAGE_REPLACED;

  /**
   * 包组件变化事件
   */
  static readonly EVENT_PACKAGE_CHANGED = commonEvent.Support.COMMON_EVENT_PACKAGE_CHANGED;

  /**
   * 动态图标使能/去使能事件
   */

  static readonly EVENT_DYNAMIC_ICON_CHANGED = commonEvent.Support.COMMON_EVENT_DYNAMIC_ICON_CHANGED;

  /**
   * 应用uid
   */
  readonly uid?: number;

  /**
   * 用户id
   */
  readonly userId?: number;

  /**
   * isModuleUpdate or not
   */
  readonly isModuleUpdate?: boolean;

  /**
   * bundleType 1：元服务
   */
  readonly bundleType?: number;

  /**
   * atomicServiceModuleUpgrade 元服务升级模式
   */
  readonly atomicServiceModuleUpgrade?: number;

  /**
   * isEnableDynamicIcon 动态图标使能/去使能
   */
  readonly isEnableDynamicIcon?: boolean;

  /**
   * 应用分身索引
   */
  readonly appIndex?: number;

  /**
   * 构造
   *
   * @param eventData 原始数据
   */
  constructor(eventData: CommonEventData) {
    super(eventData);
    if (!CommonUtils.isInvalid(this.parameters)) {
      this.uid = this.parameters?.uid;
      this.userId = this.parameters?.userId;
      this.isModuleUpdate = this.parameters?.isModuleUpdate;
      this.bundleType = this.parameters?.bundleType;
      this.atomicServiceModuleUpgrade = this.parameters?.atomicServiceModuleUpgrade;
      this.isEnableDynamicIcon = this.parameters?.isEnableDynamicIcon;
      this.appIndex = this.parameters?.appIndex;
    }
  }
}


/**
 * 分屏广播事件
 */
export class SplitScreenEvent extends CommonEvent {
  static eventTypeName = 'SplitScreenEvent';
  /**
   * 窗口模式，显示分屏条
   */
  static readonly SPLIT_WINDOW_MODE_SHOW = 'common.event.SPLIT_SCREEN.data.show.divider';

  /**
   * 窗口模式，销毁分屏条
   */
  static readonly SPLIT_WINDOW_MODE_DESTROY = 'common.event.SPLIT_SCREEN.data.destroy.divider';

  /**
   * 窗口模式
   */
  windowMode?: string;

  /**
   * 构造
   *
   * @param eventData 原始数据
   */
  constructor(eventData: CommonEventData) {
    super(eventData);
    if (!CommonUtils.isInvalid(this.parameters)) {
      this.windowMode = this.parameters?.windowMode;
    }
  }
}


/**
 * 播控广播事件
 */
export class MediaControlEvent extends CommonEvent {
  static eventTypeName = 'MediaControlEvent';
  /**
   * 播控二级界面跳转音源APP
   */
  static readonly MEDIA_CONTROL_JUMP = 'jump';

  /**
   * 播控二级界面返回控制中心
   */
  static readonly MEDIA_CONTROL_QUIT = 'quit';
}

/**
 * 时间变化事件
 */
export class TimeChangeEvent extends CommonEvent {
  static eventTypeName = 'TimeChangeEvent';
  /**
   * 设置时间事件
   */
  static readonly EVENT_TIME_CHANGE = commonEvent.Support.COMMON_EVENT_TIME_CHANGED;

  /**
   * 设置时区事件
   */
  static readonly EVENT_ZONE_CHANGE = commonEvent.Support.COMMON_EVENT_TIMEZONE_CHANGED;

  /**
   * 时间1分钟变化
   */
  static readonly EVENT_TIME_TICK = commonEvent.Support.COMMON_EVENT_TIME_TICK;
}


/**
 * 亮灭屏事件
 */
export class ScreenOnOffEvent extends CommonEvent {
  static eventTypeName = 'ScreenOnOffEvent';
  /**
   * 是否亮屏
   *
   * @return true 亮屏
   */
  isScreenOn(): boolean {
    return this.event === commonEvent.Support.COMMON_EVENT_SCREEN_ON;
  }

  /**
   * 是否灭屏
   *
   * @return true 灭屏
   */
  isScreenOff(): boolean {
    return this.event === commonEvent.Support.COMMON_EVENT_SCREEN_OFF;
  }
}


/**
 * SIM卡PIN码校验事件
 */
export class SimPinVerifyEvent extends CommonEvent {
  static eventTypeName = 'SimPinVerifyEvent';
}

/**
 * 关闭二级弹窗事件
 */
export class HideWindowPanelEvent extends CommonEvent {
  static eventTypeName = 'HideWindowPanelEvent';
}

export class FileChangeEvent extends CommonEvent {
  static eventTypeName = 'FileChangeEvent';
}

/**
 * 应用市场下载状态变更事件
 */
export class DownloadStatusChangeEvent extends CommonEvent {
  static eventTypeName = 'DownloadStatusChangeEvent';
  static readonly DOWNLOAD_STATUS_CHANGE = 'com.ohos.appgallery.commonevent.EVENT_DOWNLOAD_STATUS_CHANGE';
}

/**
 * 应用市场下载进度变更事件
 */
export class DownloadingProgressChangeEvent extends CommonEvent {
  static eventTypeName = 'DownloadingProgressChangeEvent';
  static readonly DOWNLOAD_PROGRESS_CHANGE = 'com.ohos.appgallery.commonevent.EVENT_DOWNLOAD_PROGRESS_CHANGE';
}

/**
 * 应用市场安装状态变更事件
 */
export class InstallStatusChangeEvent extends CommonEvent {
  static eventTypeName = 'InstallStatusChangeEvent';
  static readonly INSTALL_STATUS_CHANGE = 'com.ohos.appgallery.commonevent.EVENT_INSTALL_STATUS_CHANGE';
}

/**
 * 关机事件
 */
export class ShutDownEvent extends CommonEvent {
  static eventTypeName = 'ShutDownEvent';
  static readonly SHUT_DOWN_EVENT = commonEvent.Support.COMMON_EVENT_SHUTDOWN;
}

/**
 * rgm状态变更事件
 */
export class RgmStatusChangeEvent extends CommonEvent {
  static eventTypeName = 'RgmStatusChangeEvent';
  static readonly RGM_STATUS_CHANGED = 'usual.event.RGM_STATUS_CHANGED';
}

/**
 * 周报调度事件
 */
export class WeekSchedulerReporterEvent extends CommonEvent {
  static eventTypeName = 'WeekSchedulerReporterEvent';
}


/**
 * 包组件清除数据事件
 */
export class PackageDataClearedEvent extends CommonEvent {
  static eventTypeName = 'PackageDataClearedEvent';
  static readonly EVENT_PACKAGE_DATA_CLEARED = commonEvent.Support.COMMON_EVENT_PACKAGE_DATA_CLEARED;
}

/**
 * 睡眠模式变化事件
 */
export class SleepingModeChangeEvent extends CommonEvent {
  static eventTypeName = 'COMMON_EVENT_USER_SLEEP_STATE_CHANGED';
}

/**
 * 系统账号认证解锁事件
 */
export class UserUnlockedEvent extends CommonEvent {
  static eventTypeName = 'UserUnlockedEvent';
}

/**
 * 处置状态事件
 */
export class DisposedRuleAddEvent extends CommonEvent {
  static eventTypeName = 'DisposedRuleAddEvent';
  static readonly DISPOSED_RULE_ADD_EVENT = 'usual.event.DISPOSED_RULE_ADDED';
}

/**
 * 处置状态事件
 */
export class DisposedRuleDeleteEvent extends CommonEvent {
  static eventTypeName = 'DisposedRuleDeleteEvent';
  static readonly DISPOSED_RULE_DELETE_EVENT = 'usual.event.DISPOSED_RULE_DELETED';
}

/**
 * 处置状态事件
 */
export class UpdateMigrateStatusChangeEvent extends CommonEvent {
  static eventTypeName = 'UpdateMigrateStatusChangeEvent';
  static readonly UPDATE_MIGRATE_STATUS_CHANGE_EVENT = 'usual.event.UPDATE_MIGRATE_STATUS_CHANGE';
}

/**
 * OpenHarmony化状态变化事件
 */
export class BundleMappingChangeEvent extends CommonEvent {
  static eventTypeName = 'BundleMappingChangeEvent';
  static readonly BUNDLE_MAPPING_CHANGE = 'com.ohos.appgallery.commonevent.EVENT_LEGACY_BUNDLE_MAPPING_CHANGE';
}

