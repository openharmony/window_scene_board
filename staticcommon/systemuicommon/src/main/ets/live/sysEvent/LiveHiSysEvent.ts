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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { FoldBaseParams, HiSysReportBase } from '../../hiSysEvent/HiSysReportBase';
import { LiveNotification } from '../model/LiveNotification';
import { notificationManager } from '@kit.NotificationKit';
import { SystemUIUseScene } from '../../constants/SystemuiConstants';
import { SystemUICcmConfig } from '../../utils/SystemUICcmConfig';
import { MaintenanceUtils } from '../../maintenance/MaintenanceUtils';

const TAG = 'LiveHiSysEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export enum LiveEvent {
  // 胶囊进度条刷新
  CAPSULE_UPDATE = 'CAPSULE_UPDATE',
  // 实况窗信息刷新
  LIVE_WIN_UPDATE = 'LIVE_WIN_UPDATE',
  // 点击卡片操作按钮
  CLICK_LIVE_WIN_BUTTON = 'CLICK_LIVE_WIN_BUTTON',
  // 点击三方卡片辅助区
  LIVE_EXTEND_CLICK = 'LIVE_EXTEND_CLICK',
  // 左滑出垃圾桶删除
  LIVE_WIN_SWIPE_LEFT_DEL = 'LIVE_WIN_SWIPE_LEFT_DEL',
  // 点击胶囊展开卡片
  CAPSULE_TO_LIVE_WIN_V2 = 'CAPSULE_TO_LIVE_WIN_V2',
  // 通知_实况窗_实况胶囊数量增加
  LIVE_CAPSULE_NUM_INCREASE = 'LIVE_CAPSULE_NUM_INCREASE',
  // 通知_实况窗_实况胶囊显示
  LIVE_CAPSULE_SHOW = 'LIVE_CAPSULE_SHOW',
  // 通知_实况窗_应用发出带错误参数的通知，被系统丢弃
  NTF_INVALID_PARAM_DISCARD = 'NTF_INVALID_PARAM_DISCARD',
  // 点击录屏胶囊操作按钮
  NOTIFICATION_CLICK_BUTTON = 'NOTIFICATION_CLICK_BUTTON',
  // 授权按钮
  LIVE_WIN_ACCEPT_BUTTON = 'LIVE_WIN_ACCEPT_BUTTON',
  // 通知进入应用
  NOTIFICATION_CLICK_APP = 'NOTIFICATION_CLICK_APP',
}

export class LiveBaseParams extends FoldBaseParams {
  USER_PACKAGE_NAME?: string;
  LIVE_SCENARIO?: number;
  LIVE_TEMPLATE_TYPE?: number;
  TEMPLATE_TYPE?: number;
  CAPSULE_TYPE?: number;
  NOTIFICATION_ID?: string;
}

export class CapsuleSwitchCardParams extends FoldBaseParams {
  COUNT?: number;
  IS_SHOW?: boolean;
  USER_PACKAGE_NAME_LIST?: string;
  NOTIFICATION_ID_LIST?: string;
}

export class LiveLifeCycleCardParams extends LiveBaseParams {
  EXISTENCE_DURATION?: number;
  OPERATION?: number;
  SHOW_DURATION?: number;
  CREATOR_BUNDLE_NAME?: string;
  LIVE_VERSION?: number;
}

export class LiveCapsuleNumChangeParams extends FoldBaseParams {
  COUNT?: number;
  FIRST_CREATE_TIME?: number;
  LIMIT?: number;
  USER_PACKAGE_NAME_LIST?: string;
}

export class LiveCapsuleShowParams extends LiveBaseParams {
  REASON?: number;
}

export class LiveClickExtendParams extends LiveBaseParams {
  USE_SCENE?: number;
  AREA_TYPE?: number;
}

export class LiveClickAppParams extends LiveBaseParams {
  CREATOR_BUNDLE_NAME?: string;
  NOTIFICATION_SLOT_TYPE?: number;
  DISPLAY_SCENE?: number;
  IS_LIVE?: number;
  IS_MIDSCENE?: number;
}

export class LiveAcceptButtonParams extends LiveBaseParams {
  CREATOR_BUNDLE_NAME?: string;
  ACCEPT?: number;
  DISPLAY_SCENE?: number;
}

export class InvalidEventParams extends LiveBaseParams {
  IS_LIVE?: boolean;
  OPERATION?: number;
  REASON?: number;
}

export class RecordCapsuleClickParams extends LiveBaseParams {
  SCRRECORD_CAPSULE_CLICK_BUTTON? : number;
  CREATOR_BUNDLE_NAME?: string;
}

export class LiveServiceButtonClickParams extends LiveBaseParams {
  CREATOR_BUNDLE_NAME?: string;
  NOTIFICATION_SLOT_TYPE?: number;
  DISPLAY_SCENE?: number;
  IS_LIVE?: number;
  BUTTON_INDEX?: number;
}

export class LiveButtonClickParams extends LiveBaseParams {
  CLICK_POSITION?: number;
  BUTTON_NAME?: string;
  CLICK_OPERATION_HAND?: number;
}

/**
 * 实况行为打点上报（new）
 */
export class LiveHiSysEvent {
  /**
   * 胶囊/卡片切换打点
   * @param liveList
   * @param isExpand
   */
  public static async reportCapsuleSwitchEvent(liveList: LiveNotification[], isExpand: boolean): Promise<void> {
    const bundleNameStr = liveList.map(data => data.creatorBundleName).join(',');
    const idStr = liveList.map(data => data.id).join(',');
    const params = await new CapsuleSwitchCardParams().init();
    params.COUNT = liveList.length;
    params.IS_SHOW = isExpand;
    params.USER_PACKAGE_NAME_LIST = bundleNameStr;
    params.NOTIFICATION_ID_LIST = idStr;
    HiSysReportBase.reportBehavior(LiveEvent.CAPSULE_TO_LIVE_WIN_V2, params);
  }

  /**
   * 实况胶囊生命周期打点
   *
   * @param live 打点数据
   */
  public static async reportLiveLifeCycleEvent(live?: LiveNotification, totalTime?: number, lifeCycle?: number): Promise<void> {
    const params = await new LiveLifeCycleCardParams().init();
    params.CAPSULE_TYPE = live?.capsule?.capsuleType;
    params.EXISTENCE_DURATION = live?.createTime;
    params.NOTIFICATION_ID = String(live?.id ?? 0);
    params.OPERATION = lifeCycle;
    params.SHOW_DURATION = totalTime;
    params.LIVE_TEMPLATE_TYPE = live?.card?.cardType;
    params.USER_PACKAGE_NAME = live?.creatorBundleName;
    params.LIVE_SCENARIO = LiveHiSysEvent.getScenario(live);
    params.LIVE_VERSION = SystemUICcmConfig.instance.isEnabledLive2 ? 1 : 0;
    params.TRACE_ID = live?.traceId;
    HiSysReportBase.reportBehavior(LiveEvent.CAPSULE_UPDATE, params);
  }

  /**
   * 实况胶囊数量改变的时候打点
   *
   * @param liveViewData 打点数据列表
   */
  public static async reportCapsuleNumChangeEvent(liveList: LiveNotification[]): Promise<void> {
    const firstCreateTime = Math.max(...liveList.map(item => item.createTime));
    const pkgList = liveList.map(data => data.creatorBundleName).join(',');
    const params = await new LiveCapsuleNumChangeParams().init();
    params.COUNT = liveList.length;
    params.FIRST_CREATE_TIME = firstCreateTime;
    params.LIMIT = Number.MAX_VALUE;
    params.USER_PACKAGE_NAME_LIST = pkgList;
    HiSysReportBase.reportBehavior(LiveEvent.LIVE_CAPSULE_NUM_INCREASE, params);
  }

  /**
   * 实况按钮点击
   *
   * @param liveEntry 打点数据
   */
  public static async reportLiveButtonClickEvent(live?: LiveNotification): Promise<void> {
    const params = await new LiveButtonClickParams().init();
    params.USER_PACKAGE_NAME = live?.creatorBundleName;
    params.NOTIFICATION_ID = String(live?.id ?? 0);
    params.TEMPLATE_TYPE = live?.card?.cardType;
    params.CAPSULE_TYPE = live?.capsule?.capsuleType;
    params.TRACE_ID = live?.traceId;
    HiSysReportBase.reportBehavior(LiveEvent.CLICK_LIVE_WIN_BUTTON, params);
  }

  /**
   * 记录胶囊出现打点
   *
   * @param firstItem 通知数据
   */
  public static async reportCapsuleShow(live: LiveNotification): Promise<void> {
    const params = await new LiveCapsuleShowParams().init();
    params.CAPSULE_TYPE = live.capsule?.capsuleType;
    params.LIVE_TEMPLATE_TYPE = live.card?.cardType;
    params.USER_PACKAGE_NAME = live.creatorBundleName;
    params.LIVE_SCENARIO = LiveHiSysEvent.getScenario(live);
    params.REASON = LiveViewCapsuleShowReason.single;
    HiSysReportBase.reportBehavior(LiveEvent.LIVE_CAPSULE_SHOW, params);
  }

  /**
   * 点击三方卡片辅助区的时候打点
   *
   * @param liveViewData 打点数据
   * @param notificationType 卡片所在面板类型
   */
  public static async reportClickExtendEvent(live?: LiveNotification, notificationType?: number): Promise<void> {
    const params = await new LiveClickExtendParams().init();
    params.USE_SCENE = notificationType;
    params.NOTIFICATION_ID = String(live?.id ?? 0);
    params.LIVE_TEMPLATE_TYPE = live?.card?.cardType;
    params.USER_PACKAGE_NAME = live?.creatorBundleName;
    params.AREA_TYPE = live?.card?.isOtherCard() ? live.card.extensionType : undefined;
    params.TRACE_ID = live?.traceId;
    HiSysReportBase.reportBehavior(LiveEvent.LIVE_EXTEND_CLICK, params);
  }

  /**
   * 实况拉起应用打点
   */
  public static async reportLiveClickAppEvent(live?: LiveNotification, displayScene?: number,
    isMidScene: boolean = false): Promise<void> {
    const params = await new LiveClickAppParams().init();
    params.CREATOR_BUNDLE_NAME = live?.creatorBundleName;
    params.NOTIFICATION_ID = String(live?.id ?? 0);
    params.NOTIFICATION_SLOT_TYPE = live?.slotType;
    params.DISPLAY_SCENE = displayScene;
    params.IS_LIVE = 0;
    params.IS_MIDSCENE = isMidScene ? 1 : 0;
    params.TRACE_ID = live?.traceId;
    HiSysReportBase.reportBehavior(LiveEvent.NOTIFICATION_CLICK_APP, params);
  }

  /**
   * 通知-实况窗-是否继续接收此应用的实况窗按钮
   * @param live 实况通知
   * @param accept 是否接收
   * @param scene 实况面板场景
   */
  public static async reportLiveAcceptButton(live?: LiveNotification, accept?: boolean,
    scene?: SystemUIUseScene): Promise<void> {
    const params = await new LiveAcceptButtonParams().init();
    params.CREATOR_BUNDLE_NAME = live?.creatorBundleName;
    params.NOTIFICATION_ID = String(live?.id ?? 0);
    params.ACCEPT = accept ? 1 : 0;
    params.DISPLAY_SCENE = scene === SystemUIUseScene.DROPDOWN ? 4 : 2;
    params.TRACE_ID = live?.traceId;
    HiSysReportBase.reportBehavior(LiveEvent.LIVE_WIN_ACCEPT_BUTTON, params);
  }

  /**
   * 通知实况卡片左滑删除
   * @param live 实况通知
   */
  public static async reportLiveLeftDelEvent(live?: LiveNotification): Promise<void> {
    LiveHiSysEvent.reportLiveBase(live, LiveEvent.LIVE_WIN_SWIPE_LEFT_DEL);
  }

  /**
   * 实况数据刷新
   */
  public static async reportLiveUpdateEvent(live?: LiveNotification): Promise<void> {
    LiveHiSysEvent.reportLiveBase(live, LiveEvent.LIVE_WIN_UPDATE);
  }

  /**
   * 通知解析无效丢弃打点
   * @param request 通知请求体
   */
  public static async reportInvalidParamEvent(request: notificationManager.NotificationRequest): Promise<void> {
    const params = await new InvalidEventParams().init();
    params.IS_LIVE = request?.notificationSlotType === notificationManager.SlotType.LIVE_VIEW;
    params.NOTIFICATION_ID = String(request?.id ?? 0);
    params.OPERATION = 0;
    params.REASON = 0;
    params.USER_PACKAGE_NAME = request?.creatorBundleName;
    params.TRACE_ID = request?.extraInfo._oh_ans_sys_traceid;
    HiSysReportBase.reportBehavior(LiveEvent.NTF_INVALID_PARAM_DISCARD, params);
  }

  /**
   * 录屏胶囊点击事件
   * @param live 实况通知
   */
  public static async reportRecordCapsuleClickEvent(live: LiveNotification): Promise<void> {
    const params = await new RecordCapsuleClickParams().init();
    params.SCRRECORD_CAPSULE_CLICK_BUTTON = 1;
    params.CREATOR_BUNDLE_NAME = live?.creatorBundleName;
    params.NOTIFICATION_ID = String(live?.id ?? 0);
    params.TRACE_ID = live?.traceId;
    HiSysReportBase.reportBehavior(LiveEvent.NOTIFICATION_CLICK_BUTTON, params);
  }

  /**
   * 三方实况关联服务按钮点击事件
   * @param live 实况通知
   */
  public static async reportServiceButtonClickEvent(live: LiveNotification,
    index?: number, displayScene?: number): Promise<void> {
    const params = await new LiveServiceButtonClickParams().init();
    params.CREATOR_BUNDLE_NAME = live?.creatorBundleName;
    params.NOTIFICATION_ID = String(live?.id ?? 0);
    params.NOTIFICATION_SLOT_TYPE = live?.slotType;
    params.DISPLAY_SCENE = displayScene;
    params.IS_LIVE = 0;
    params.BUTTON_INDEX = index;
    params.TRACE_ID = live?.traceId;
    HiSysReportBase.reportBehavior(LiveEvent.NOTIFICATION_CLICK_BUTTON, params);
  }

  private static async reportLiveBase(live?: LiveNotification, event?: LiveEvent): Promise<void> {
    const params = await new LiveBaseParams().init();
    params.USER_PACKAGE_NAME = live?.creatorBundleName;
    params.NOTIFICATION_ID = String(live?.id ?? 0);
    params.TEMPLATE_TYPE = live?.card?.cardType;
    params.CAPSULE_TYPE = live?.capsule?.capsuleType;
    params.TRACE_ID = live?.traceId;
    HiSysReportBase.reportBehavior(event, params);
  }

  private static getScenario(live?: LiveNotification): number {
    const scenario = live?.card?.isOtherCard() ? live.card.event as string : undefined;
    return MaintenanceUtils.getLiveEvent(scenario);
  }
}

/**
 * 实况胶囊生命周期状态
 */
export enum Lifecycle {
  CREATE = 0,
  UPDATE = 1,
  DELETE = 2
}

/**
 * 胶囊展示原因
 */
enum LiveViewCapsuleShowReason {
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