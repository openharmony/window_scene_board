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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ReportDomain, ReportParams, HiSysReportEvent, } from '@ohos/frameworkwrapper';
import { LiveOtherExtendData } from '../../liveview/data/extend/LiveOtherExtendData';
import { LiveViewData } from '../../liveview/data/LiveViewData';
import { LiveType, OtherFormExtendShowType } from '../../liveview/common/LiveConstants';
import { LiveButtonData } from '../../liveview/data/extend/LiveButtonData';

const TAG = 'ImmersiveSysEventUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 沉浸锁屏打点上报工具类
 */
export class ImmersiveSysEventUtils {
  private static readonly SCREENLOCK_UE: HiSysReportEvent =
    HiSysReportEvent.getHiSysReportEvent(ReportDomain.SCREENLOCK_UE);
  // 锁屏通知生命周期
  public static readonly IMMERSIVE_LIFECYCLE: string = 'IMMERSIVE_LIFECYCLE';
  // 点击进入应用
  public static readonly CLICK_TO_APP: string = 'CLICK_TO_APP';
  // 点击按钮
  public static readonly CLICK_BUTTON: string = 'CLICK_BUTTON';
  // 应用发来带错误参数的通知
  public static readonly INCORRECT_PARAMETER: string = 'INCORRECT_PARAMETER';
  // 锁屏收到通知
  public static readonly KG_NOTIFICATION_RECEIVED: string = 'KG_NOTIFICATION_RECEIVED';
  // 锁屏通知条目上树
  public static readonly IMMERSIVE_LIST_APPEAR: string = 'IMMERSIVE_LIST_APPEAR';

  // 打点上报
  static reportImmersiveEvent(name: string, params: ImmersiveReportParams): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ImmersiveSysEventUtils.SCREENLOCK_UE.reportBehavior(name, params);
  }

  /**
   * 沉浸锁屏 收到通知打点
   */
  public static reportImmersiveKgNotificationReceivedEvent(params: ImmersiveReportParams): void {
    ImmersiveSysEventUtils.reportImmersiveEvent(ImmersiveSysEventUtils.KG_NOTIFICATION_RECEIVED, params);
  }

  /**
   * 沉浸锁屏 通知条目上树打点
   */
  public static reportImmersiveListAppearEvent(params: ImmersiveReportParams): void {
    ImmersiveSysEventUtils.reportImmersiveEvent(ImmersiveSysEventUtils.IMMERSIVE_LIST_APPEAR, {
      USER_PACKAGE_NAME: params.USER_PACKAGE_NAME,
      NTF_HASHCODE: params.NTF_HASHCODE,
      IS_LIVE: params.IS_LIVE,
      VISUAL_PARAMS: params.VISUAL_PARAMS,
    });
  }

  /**
   * 沉浸锁屏 为实况通知时的生命周期打点
   *
   * @param liveEntry 打点数据
   * @param lifeCycle 生命周期
   */
  public static reportImmersiveCycleEvent(liveEntry?: LiveViewData, lifeCycle?: number): void {
    ImmersiveSysEventUtils.reportImmersiveEvent(ImmersiveSysEventUtils.IMMERSIVE_LIFECYCLE, {
      USER_PACKAGE_NAME: liveEntry?.creatorBundleName ?? '0',
      NOTIFICATION_ID: String(liveEntry?.id ?? 0),
      NTF_HASHCODE: liveEntry?.hashCode,
      OPERATION: lifeCycle,
      LIVE_TEMPLATE_TYPE: liveEntry?.template?.getLiveType()
    });
  }

  /**
   * 沉浸锁屏 播控生命周期更新打点
   *
   * @param liveEntry 打点数据
   * @param lifeCycle 生命周期
   */
  public static reportMediaCycleEvent(): void {
    ImmersiveSysEventUtils.reportImmersiveEvent(ImmersiveSysEventUtils.IMMERSIVE_LIFECYCLE, {
      USER_PACKAGE_NAME: '0',
      NOTIFICATION_ID: '0',
      OPERATION: 1,
      LIVE_TEMPLATE_TYPE: 0
    });
  }

  // 应用传来带错误参数的通知打点
  public static reportIncorrectParamEvent(): void {
    ImmersiveSysEventUtils.reportImmersiveEvent(ImmersiveSysEventUtils.INCORRECT_PARAMETER, {
      USER_PACKAGE_NAME: 'unknown',
      NOTIFICATION_ID: '0',
      OPERATION: 0,
      REASON: 0
    });
  }

  // 点击列表或大卡实况进入应用
  public static reportClickToAppEvent(liveView?: LiveViewData, status?: StatusParams): void {
    ImmersiveSysEventUtils.reportImmersiveEvent(ImmersiveSysEventUtils.CLICK_TO_APP, {
      USER_PACKAGE_NAME: liveView?.creatorBundleName ?? '0',
      NOTIFICATION_ID: String(liveView?.id ?? 0),
      NTF_HASHCODE: liveView?.hashCode,
      LIVE_TEMPLATE_TYPE: liveView?.template?.getLiveType(),
      CLICK_AREA_TYPE: -1,
      CURRENT_STATUS: status ?? StatusParams.LIST
    });
  }

  // 点击实况三方应用辅助区 进入应用
  public static reportExtendClickEvent(extendData?: LiveOtherExtendData, hashcode?: string): void {
    ImmersiveSysEventUtils.reportImmersiveEvent(ImmersiveSysEventUtils.CLICK_TO_APP, {
      NOTIFICATION_ID: String(extendData?.clickAction?.id ?? 0),
      NTF_HASHCODE: hashcode,
      LIVE_TEMPLATE_TYPE: extendData?.clickAction?.templateType,
      USER_PACKAGE_NAME: extendData?.clickAction?.packageName ?? '0',
      CLICK_AREA_TYPE: extendData?.type,
    });
  }

  // 沉浸锁屏 点击实况通知按钮打点
  public static reportClickButtonEvent(data?: LiveButtonData, liveViewData?: LiveViewData): void {
    ImmersiveSysEventUtils.reportImmersiveEvent(ImmersiveSysEventUtils.CLICK_BUTTON, {
      USER_PACKAGE_NAME: String(data.bundle.bundle ?? '0'),
      NOTIFICATION_ID: String(data.id),
      NTF_HASHCODE: data?.hashCode,
      BUTTON_TYPE: liveViewData.sysTypeCode
    });
  }
}

export class ImmersiveReportParams {
  public PNAMEID?: string;
  public PVERSIONID?: string;
  public LIVE_TEMPLATE_TYPE?: LiveType;
  public USER_PACKAGE_NAME?: string;
  public NOTIFICATION_ID?: string;
  public NTF_HASHCODE?: string;
  public CLICK_AREA_TYPE?: OtherFormExtendShowType;
  public CURRENT_STATUS?: number;
  public IS_SHOW_LIST?: number;
  public BUTTON_TYPE?: number;
  public OPERATION?: number;
  public REASON?: number; // 错误原因：0：参数不完整
  public CAN_ADD?: boolean;
  public IS_NTF_AUTO_SCREEN_ON?: boolean;
  public NOTIFICATION_FLAGS?: number;
  /**
   * 是否为push通知
   * 0 push通知
   * 1 非push通知
   */
  public IS_PUSH?: number;
  /**
   * 是否为ongoing通知
   * 0 ongoing通知
   * 1 非ongoing通知
   */
  public IS_ONGOING?: number;
  /**
   * 是否为实况通知
   * 0 实况通知
   * 1 非实况通知
   */
  public IS_LIVE?: number;

  /**
   * 影响通知是否可见的参数，包括透明度和可见性
   */
  public VISUAL_PARAMS?: string;
}

export enum StatusParams {
  CAPSULE = 1,
  LIST = 2,
  IMMERSIVE = 3,
}


