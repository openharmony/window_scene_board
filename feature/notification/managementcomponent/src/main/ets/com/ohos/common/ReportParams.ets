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
import { bundleManager } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from './BasicCommon';

const TAG = 'ReportParams';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

// 设备状态枚举
export enum DisPlayMode {
  BAR_DEVICE,
  FLOD_DEVICE_EXPAND,
  FLOD_DEVICE_UNEXPAND
}

export enum ReplaceReason {
  NOTIFICATION,
  APPLICATIONINSIDE,
  SIDEEDGEBAR,
  DOCK_CLICK,
  DOCK_DRAG,
}

export class ReportParams {
  private static versionCode: number;
  public static PACKAGE_NAME: string = 'com.ohos.sceneboard';
  public static PROCESS_NAME: string = 'sceneBoard';

  public static async getVersionCode(): Promise<string> {
    if (!ReportParams.versionCode) {
      let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;
      try {
        const bundleInfo = await bundleManager.getBundleInfoForSelf(bundleFlags);
        // 获取应用的版本名（versionCode）
        ReportParams.versionCode = bundleInfo?.versionCode;
      } catch (err) {
        log.error('getVersionCode failed:', err);
      }
    }
    return `${ReportParams.versionCode || ''}`;
  }
}

export class DefaultParams {
  public PACKAGE_NAME: string = ReportParams.PACKAGE_NAME;
  public PROCESS_NAME: string = ReportParams.PROCESS_NAME;
}

export class SystemMenuClickParams extends DefaultParams {
  public NAME?: number;
  public EVENT_TYPE?: string;
}

export class NotificationParams extends DefaultParams {
  public STATUS?: number;
}

export class WakeScreenParams extends DefaultParams {
  public SWITCH_STATUS?: number;
}

export class ManageAllParams extends DefaultParams {
  public STATE?: number;
  public SHOT_TYPE?: number;
  public COMMAND?: number;
}

export class InManageAllParams extends DefaultParams {
  public BUNDLE_NAME?: string;
  public SWITCH_STATUS?: number;
}

export class ApplicationParams extends DefaultParams {
  public BUNDLE_NAME?: string;
  public STATE?: number;
}

export class DelayReportParams {
  public name?: string;
  public timer?: number;
  public msg?: Object;
}

// 通知中心和控制中心
export class NTFControlParams {
  public PNAMEID?: string = ReportParams.PACKAGE_NAME;
  public PVERSIONID?: string = ReportParams.PROCESS_NAME;

  /**
   * 通知控制字段标识
   * 通过在某一位上设置1标识位标识特定业务类型，如25位置1表示用增消息
   */
  public NOTIFICATION_CONTROL_FLAGS?: number;
}

export class NtfSettingModuleClickEventParams {
  public PNAMEID?: string = ReportParams.PACKAGE_NAME;
  public PVERSIONID?: string = ReportParams.PROCESS_NAME;

  /**
   * 通知和状态栏管理入口类型：1-实况窗 2-状态栏 3-更多通知设置
   */
  public MODULE?: number;
}

export class ClickLiveViewSwitchParams {
  public PNAMEID?: string = ReportParams.PACKAGE_NAME;
  public PVERSIONID?: string = ReportParams.PROCESS_NAME;

  /** 实况窗应用包名 */
  public PACKAGE?: string;
  /** 实况窗开关状态 */
  public STATUS?: string;
  /** 操作入口 */
  public SOURCE?: string;
}
