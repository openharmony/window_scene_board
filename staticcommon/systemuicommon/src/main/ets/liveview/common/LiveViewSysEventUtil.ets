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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { HiSysReportEvent, ReportDomain, ReportParams } from '@ohos/frameworkwrapper';
import type { LiveViewData } from '../data/LiveViewData';
import { LiveOtherExtendData } from '../data/extend/LiveOtherExtendData';
import { LiveBaseTemplate } from '../data/template/LiveBaseTemplate';
import { LiveExtendType, LiveType, OtherFormExtendShowType } from './LiveConstants';
import { NotificationType } from '../../constants/NotificationType';
import { FoldParams } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { SystemUICcmConfig } from '../../utils/SystemUICcmConfig';

const TAG = 'LiveViewSysEventUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 桌面编辑打点上报工具类
 */
export class LiveViewSysEventUtil {
  private static readonly NOTIFICATION_UE: HiSysReportEvent =
  HiSysReportEvent.getHiSysReportEvent(ReportDomain.NOTIFICATION_UE);
  // 字段间隔符号
  public static readonly ITEM_SEPARATOR: string = ',';
  // 胶囊进度条刷新
  public static readonly CAPSULE_UPDATE: string = 'CAPSULE_UPDATE';
  // 实况窗信息刷新
  public static readonly LIVE_WIN_UPDATE: string = 'LIVE_WIN_UPDATE';
  // 点击卡片操作按钮
  public static readonly CLICK_LIVE_WIN_BUTTON: string = 'CLICK_LIVE_WIN_BUTTON';
  // 点击三方卡片辅助区
  public static readonly LIVE_EXTEND_CLICK: string = 'LIVE_EXTEND_CLICK';
  // 左滑出垃圾桶删除
  public static readonly LIVE_WIN_SWIPE_LEFT_DEL: string = 'LIVE_WIN_SWIPE_LEFT_DEL';
  // 点击胶囊展开卡片
  public static readonly CAPSULE_TO_LIVE_WIN_V2: string = 'CAPSULE_TO_LIVE_WIN_V2';
  // 通知_实况窗_实况胶囊数量增加
  public static readonly LIVE_CAPSULE_NUM_INCREASE: string = 'LIVE_CAPSULE_NUM_INCREASE';
  // 通知_实况窗_实况胶囊显示
  public static readonly LIVE_CAPSULE_SHOW: string = 'LIVE_CAPSULE_SHOW';
  // 通知_实况窗_应用发出带错误参数的通知，被系统丢弃
  public static readonly NTF_INVALID_PARAM_DISCARD: string = 'NTF_INVALID_PARAM_DISCARD';
  // 点击录屏胶囊操作按钮
  public static readonly NOTIFICATION_CLICK_BUTTON: string = 'NOTIFICATION_CLICK_BUTTON';

  /**
   * 实况窗打点
   *
   * @param name
   * @param params
   */
  static async reportLiveViewEvent(name: string, params: LiveViewReportParams): Promise<void> {
    if (SystemUICcmConfig.instance.isEnabledLive2) {
      return;
    }
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = await ReportParams.getVersionCode();
    params.FOLDDEVICETYPE = FoldParams.FOLD_DEVICE_TYPE;
    const isFoldablePhoneExpandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    params.ISFOLDEXPAND = FoldParams.getDisplayType(isFoldablePhoneExpandStatus);

    LiveViewSysEventUtil.NOTIFICATION_UE.reportBehavior(name, params);
  }

  /**
   * 实况胶囊数量改变的时候打点
   *
   * @param liveViewData 打点数据列表
   */
  public static reportCapsuleNumChangeEvent(liveViewData: Array<LiveViewData>): void {
    let firstCreateTime = Math.max(...liveViewData.map(item => item.createTime));
    let pkgList = liveViewData.map(data => {
      data.creatorBundleName;
    }).join(LiveViewSysEventUtil.ITEM_SEPARATOR);
    LiveViewSysEventUtil.reportLiveViewEvent(LiveViewSysEventUtil.LIVE_CAPSULE_NUM_INCREASE, {
      COUNT: liveViewData.length,
      FIRST_CREATE_TIME: firstCreateTime,
      LIMIT: Number.MAX_VALUE,
      USER_PACKAGE_NAME_LIST: pkgList });
  }

  /**
   * 实况胶囊生命周期打点
   *
   * @param liveEntry 打点数据
   */
  public static reportLiveViewLifeCycleEvent(liveEntry?: LiveViewData, totalTime?: number, lifeCycle?: number): void {
    const scenario = liveEntry?.event as string;
    LiveViewSysEventUtil.reportLiveViewEvent(LiveViewSysEventUtil.CAPSULE_UPDATE, {
      CAPSULE_TYPE: liveEntry?.capsule?.type,
      EXISTENCE_DURATION: liveEntry?.createTime,
      NOTIFICATION_ID: String(liveEntry?.id ?? 0),
      OPERATION: lifeCycle,
      SHOW_DURATION: totalTime,
      LIVE_TEMPLATE_TYPE: liveEntry?.template?.getLiveType(),
      USER_PACKAGE_NAME: liveEntry?.creatorBundleName,
      LIVE_SCENARIO: LiveEventMap[scenario] ?? LiveEventMap.UNKNOWN,
      LIVE_VERSION: SystemUICcmConfig.instance.isEnabledLive2 ? 1 : 0,
    });
  }

  /**
   * 在胶囊展开到实况列表的时候打点
   *
   * @param liveViewData 打点数据
   */
  public static reportCapsuleToLiveListEvent(liveViewData: Array<LiveViewData>): void {
    if (liveViewData.length === 0) {
      return;
    }
    let bundleNameStr = liveViewData.map(data => {
      data.creatorBundleName;
    }).join(LiveViewSysEventUtil.ITEM_SEPARATOR);
    let idStr = liveViewData.map(data => {
      data.id;
    }).join(LiveViewSysEventUtil.ITEM_SEPARATOR);
    LiveViewSysEventUtil.reportLiveViewEvent(LiveViewSysEventUtil.CAPSULE_TO_LIVE_WIN_V2, {
      COUNT: liveViewData.length, IS_SHOW: true, USER_PACKAGE_NAME_LIST: bundleNameStr, NOTIFICATION_ID_LIST: idStr });
  }

  /**
   * 点击三方卡片辅助区的时候打点
   *
   * @param liveViewData 打点数据
   * @param notificationType 卡片所在面板类型
   */
  public static reportClickExtendEvent(extendData?: LiveOtherExtendData, notificationType?: NotificationType): void {
    LiveViewSysEventUtil.reportLiveViewEvent(LiveViewSysEventUtil.LIVE_EXTEND_CLICK, {
      USE_SCENE: notificationType,
      NOTIFICATION_ID: String(extendData?.clickAction?.id ?? 0),
      LIVE_TEMPLATE_TYPE: extendData?.clickAction?.templateType,
      USER_PACKAGE_NAME: extendData?.clickAction?.packageName,
      AREA_TYPE: extendData?.type
    });
  }
}

export class LiveViewReportParams {
  public PNAMEID?: string;
  public PVERSIONID?: string;

  public USER_PACKAGE_NAME?: string;
  public USER_PACKAGE_NAME_LIST?: string;

  public USE_SCENE?: NotificationType;
  public LIVE_TEMPLATE_TYPE?: LiveType;
  public AREA_TYPE?: OtherFormExtendShowType;
  public CAPSULE_TYPE?: number;

  public NOTIFICATION_ID?: string;
  public NOTIFICATION_ID_LIST?: string;

  public COUNT?: number;
  public EXISTENCE_DURATION?: number;
  public FIRST_CREATE_TIME?: number;
  public IS_LIVE?: boolean;
  public IS_LOCKED?: boolean;
  public IS_SHOW?: boolean;
  public LIMIT?: number;
  public OPERATION?: number;
  public REASON?: number;
  public SHOW_DURATION?: number;
  public LIVE_SCENARIO?: number;
  public SCRRECORD_CAPSULE_CLICK_BUTTON?: number;
  public CREATOR_BUNDLE_NAME?: string;

  public FOLDDEVICETYPE?: number;
  public ISFOLDEXPAND?: boolean;
  public LIVE_VERSION?: number;
}

export enum LiveEventMap {
  UNKNOWN = -1,
  TAXI = 0,
  DELIVERY = 1,
  FLIGHT = 2,
  TRAIN = 3,
  QUEUE = 4,
  PICK_UP = 5,
  SCORE = 6
};

/**
 * 胶囊展示原因
 */
export enum LiveViewCapsuleShowReason {
  /**
   * 单个胶囊
   */
  single = 1,
  /**
   * 多个胶囊优先级高
   */
  multi = 2,
  /**
   * 刷新触发显示
   */
  refresh = 3
}