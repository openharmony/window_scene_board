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
import { InnerEventUtil } from '../utils/InnerEventUtil';
import { SingletonHelper } from '@ohos/basicutils';
import { TimeChangeEvent } from '@ohos/frameworkwrapper';
import { systemDateTime } from '@kit.BasicServicesKit';
import { MaintenanceRecord } from '@ohos/systemuiutils/src/main/ets/maintenance/MaintenanceRecord';
import { LiveViewDataStatus } from '../liveview/common/LiveConstants';
import { ClickRegion, ExternalDeleteReason, ParseNotificationErrorCode, RemindType } from './StatisticsConstants';
import { notificationManager } from '@kit.NotificationKit';
import { NotificationCreatorType } from '../model/NotificationContent';
import {
  MaintenanceExtendType,
  MaintenanceRecordType,
  MaintenanceReportChannel } from '@ohos/systemuiutils/src/main/ets/maintenance/MaintenanceModel';
import { CompatibleLiveView, CompatibleNotification, MaintenanceCompatibleUtils } from './MaintenanceCompatibleUtils';
import { LiveNotification } from '../live/model/LiveNotification';
import { NotificationBase } from '../model/NotificationBase';
import { TaskQueue } from '../utils/TaskQueue';
import { LiveViewData } from '../liveview/data/LiveViewData';
import { BaseInfo } from './ClickNotificationMaintenance';
import { DigestUtil } from '../utils/DigestUtil';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'StatisticsMaintenance');

interface StatisticsMaintenanceExt {
  ntfNum: Record<string, string>;
  liveViewNum: Record<string, string>;
  queueNum: number;
  dropNum: number[];
  userId: number;
  volume: number;
  showPanelTime: number[];
  version: number;
  taskException: string;
  swingStatus: string;
}

enum NtfDataIndex {
  // 普通通知
  NORMAL,
  // 异常普通通知
  ERR,
}

enum NtfDelDataIndex {
  USER_DEL_NORMAL,
  ERR,
  // 应用主动删除
  APP_DEL_NORMAL,
}

interface NtfNum {
  ntfCreateNum: number[];
  ntfUpdateNum: number[];
  ntfDeleteNum: number[];
  ntfClickNum: number[];
  remindFlag: number[];
  alertOnce: number[];
  ringMode: number[];
  keyGuard: number[];
  ringTime: number[];
  receiveNum: number;
  isShow: number[];
  soundDuration: number[];
  deliverPlayTime: number[];
  deliverStopTime: number[];
  deliverSendPlayTime: number[];
  deliverSendStopTime: number[];
  customSound: number[];
  ringSetting: number[];
  isProtected: number[];
}

enum NTFNumArrLength {
  NTF_CREATE_NUM_ARR_LENGTH = 2,
  NTF_UPDATE_NUM_ARR_LENGTH = 2,
  NTF_DELETE_NUM_ARR_LENGTH = 3,
  NTF_CLICK_NUM_ARR_LENGTH = 2,
}

enum LiveViewType {
  // 系统实况
  SYSTEM_LIVE_VIEW = 0,
  //  三方实况
  OTHER_LIVE_VIEW = 1,
}

enum LiveViewDataIndex {
  // 本地实况成功
  LOCAL_LIVE_SUC,
  // 本地实况异常(图片读取异常)
  LOCAL_LIVE_PHOTO_ERR,
  // 本地实况异常(图片读取异常)
  LOCAL_LIVE_OTHER_ERR,
  // 云端实况成功
  CLOUD_LIVE_SUC,
  // 云端实况异常(图片读取异常)
  CLOUD_LIVE_PHOTO_ERR,
  // 云端实况异常(其他异常)
  CLOUD_LIVE_OTHER_ERR,
}

enum LiveViewDeleteDataIndex {
  // 实况用户删除成功
  LIVE_DELETE_SUC,
  // 实况用户删除异常
  LIVE_DELETE_ERR,
  // 胶囊隐藏数量
  LIVE_CAPSULE_HIDE,
  // 实况ANS调用删除(应用卸载)
  LIVE_ANS_DELETE_UNINSTALL,
  // 实况ANS调用删除(4小时不更新)
  LIVE_ANS_DELETE_NOT_UPDATE,
  // 实况ANS调用删除(展示超过8小时)
  LIVE_ANS_DELETE_OVER,
  // 实况ANS调用删除(开发者设置删除时间，到期删除)
  LIVE_ANS_DELETE_EXPIRES,
  // 实况ANS调用删除(左滑关闭实况窗，相当于是关闭开关触发的删除)
  LIVE_ANS_DELETE_SLOT,
  // 实况ANS调用删除(应用结束后再删除)
  LIVE_ANS_DELETE_ARCHIVE,
  // 实况ANS调用删除(应用直接删除)
  LIVE_ANS_DELETE_APP_CANCEL,
}

enum LiveViewClickDataIndex {
  // 卡片点击成功（非辅助区）
  LIVE_CLICK_SUC_NON_AUXILIARY,
  // 卡片点击失败（非辅助区)
  LIVE_CLICK_ERR_NON_AUXILIARY,
  // 卡片点击成功（辅助区）
  LIVE_CLICK_SUC_AUXILIARY,
  // 卡片点击失败（辅助区)
  LIVE_CLICK_ERR_AUXILIARY,
  // 胶囊点击
  LIVE_CLICK_CAPSULE,
}

interface LiveViewNum {
  liveViewCreateNum: number[];
  liveViewUpdateNum: number[];
  liveViewEndNum: number[];
  liveViewDeleteNum: number[];
  liveViewClickNum: number[];
  isOtherLiveView: number;
  ringMode: number[];
  keyGuard: number[];
  ringTime: number[];
  keepTime: number[];
  eventCreateNum: number[];
  eventUpdateNum: number[];
  eventEndNum: number[];
  phoneButtonCreateNum: number[];
  phoneButtonUpdateNum: number[];
  phoneButtonClickSucNum: string[];
  phoneButtonClickErrNum: string[];
  receiveNum: number;
  liveViewExtendNum: LiveViewExtendNum[];
}

interface LiveViewExtendNum {
  type?: string;
  digest?: string;
  actionType?: LiveViewExtendActionType;
  clickSucNum?: number;
  clickErrNum?: number;
}

enum LiveViewExtendActionType {
  CREATE,
  UPDATE,
  CLICK,
}

enum LiveViewNumArrLength {
  LIVE_VIEW_CREATE_NUM_ARR_LENGTH = 6,
  LIVE_VIEW_UPDATE_NUM_ARR_LENGTH = 6,
  LIVE_VIEW_END_NUM_ARR_LENGTH = 6,
  LIVE_VIEW_DELETE_NUM_ARR_LENGTH = 10,
  LIVE_VIEW_CLICK_NUM_ARR_LENGTH = 5,
}

/**
 * 通知统计运维打点
 */
export class StatisticsMaintenance extends MaintenanceRecord<StatisticsMaintenanceExt> {
  public static get = SingletonHelper.createFactory(() => new StatisticsMaintenance());
  public protectedAppSet: Set<string> = new Set();
  /**
   * 上报间隔，10min，单位: second
   */
  private static readonly REPORT_INTERVAL = 600;

  /**
   * 一次最多上报10个包名信息
   */
  private static readonly REPORT_PKG_LIMIT = 10;

  /**
   * 最新100条通知压缩信息（remindFlag、userId、isAlertOnce）
   */
  private static readonly MAX_RECORD_ITEM_COMPRESS = 100;

  /**
   * 最新20条非压缩记录
   */
  private static readonly MAX_RECORD_ITEM = 20;

  private static readonly OTHERS = 'others';

  private static readonly SPLIT = '#';

  private static readonly NO_NUM = '-1';

  private static readonly PHOTO_ERROR_CODES: Set<number> = new Set([
    ParseNotificationErrorCode.NO_APP_ICON,
    ParseNotificationErrorCode.NO_SA_ICON,
    ParseNotificationErrorCode.SYSTEM_LIVE_VIEW_BUTTON_ERROR,
    ParseNotificationErrorCode.OTHER_LIVE_VIEW_CAPSULE_ICON_ERROR,
    ParseNotificationErrorCode.OTHER_LIVE_VIEW_EXTEND_ICON_ERROR,
    ParseNotificationErrorCode.OTHER_LIVE_VIEW_PROGRESS_INDICATOR_ICON_ERROR,
    ParseNotificationErrorCode.OTHER_LIVE_VIEW_PROGRESS_NODE_ICON_ERROR,
    ParseNotificationErrorCode.OTHER_LIVE_VIEW_PICKUP_DESC_ICON_ERROR,
    ParseNotificationErrorCode.OTHER_LIVE_VIEW_FLIGHT_SPACE_ICON_ERROR,
    ParseNotificationErrorCode.OTHER_LIVE_VIEW_SCORE_HOST_ICON_ERROR,
    ParseNotificationErrorCode.OTHER_LIVE_VIEW_SCORE_GUEST_ICON_ERROR,
    ParseNotificationErrorCode.NAVIGATION_LIVE_VIEW_CURRENT_ICON_ERROR,
    ParseNotificationErrorCode.NAVIGATION_LIVE_VIEW_DIRECTION_ICONS_ERROR,
  ]);

  private static readonly NEED_STATISTICS_CLICK_REGION: Set<number> = new Set([
  // 通知中心非辅助区
    ClickRegion.NTF_MAIN,
    // 通知中心通知按钮
    ClickRegion.CONTENT_BUTTON,
    // 系统实况按钮(辅助区)
    ClickRegion.LIVE_BUTTON,
    // 三方实况辅助区
    ClickRegion.SUB_AREA,
    // 实况列表非辅助区
    ClickRegion.EXTEND_AREA,
    // 实况列表非辅助区按钮
    ClickRegion.EXPAND_BUTTON,
    // 实况胶囊
    ClickRegion.CAPSULE,
    // 横幅非辅助区
    ClickRegion.BANNER_MAIN,
    // 横幅通知按钮
    ClickRegion.BANNER_BUTTON,
    // 胶囊拉起应用
    ClickRegion.CAPSULE_TRIGGER,
    // 胶囊按钮
    ClickRegion.CAPSULE_BUTTON,
  ]);

  private static readonly AUXILIARY_REGION_CODES: Set<number> = new Set([
  // 系统实况辅助区
    ClickRegion.LIVE_BUTTON,
    // 三方实况辅助区
    ClickRegion.SUB_AREA,
  ]);

  private static readonly CAPSULE_CLICK: Set<number> = new Set([
    ClickRegion.CAPSULE,
    ClickRegion.CAPSULE_TRIGGER,
    ClickRegion.CAPSULE_BUTTON,
  ]);

  private static readonly DELETE_REASON_TYPES_MAP: Map<number, number> = new Map([
    [ExternalDeleteReason.LIVE_CAPSULE_HIDE, LiveViewDeleteDataIndex.LIVE_CAPSULE_HIDE],
    [ExternalDeleteReason.PACKAGE_CHANGED_REASON_DELETE, LiveViewDeleteDataIndex.LIVE_ANS_DELETE_UNINSTALL],
    [ExternalDeleteReason.PACKAGE_REMOVE_REASON_DELETE, LiveViewDeleteDataIndex.LIVE_ANS_DELETE_UNINSTALL],
    [ExternalDeleteReason.TRIGGER_FOUR_HOUR_REASON_DELETE, LiveViewDeleteDataIndex.LIVE_ANS_DELETE_NOT_UPDATE],
    [ExternalDeleteReason.TRIGGER_EIGHT_HOUR_REASON_DELETE, LiveViewDeleteDataIndex.LIVE_ANS_DELETE_OVER],
    [ExternalDeleteReason.TRIGGER_AUTO_DELETE_REASON_DELETE, LiveViewDeleteDataIndex.LIVE_ANS_DELETE_EXPIRES],
    [ExternalDeleteReason.DISABLE_SLOT_REASON_DELETE, LiveViewDeleteDataIndex.LIVE_ANS_DELETE_SLOT],
    [ExternalDeleteReason.TRIGGER_START_ARCHIVE_REASON_DELETE, LiveViewDeleteDataIndex.LIVE_ANS_DELETE_ARCHIVE],
    [ExternalDeleteReason.APP_CANCEL_REASON_DELETE, LiveViewDeleteDataIndex.LIVE_ANS_DELETE_APP_CANCEL],
  ]);

  private static readonly APP_DEL_TYPE = new Set([ExternalDeleteReason.APP_CANCEL_REASON_DELETE,
    ExternalDeleteReason.APP_CANCEL_ALL_DELETE]);

  private lastReportTime: number;

  private ntfStatistics: Map<string, NtfNum>;

  private liveViewStatistics: Map<string, LiveViewNum>;

  private ringVolume: number = -2;

  private ringMode: number = -1;

  private version: number = -1;

  // swing智能提醒是否显示横幅内容
  private isShow: boolean = true;
  private isOwnerFace: boolean = true;
  private isMultiEyeGaze: boolean = false;
  private swingStatus: string = '';

  private ringSetting: number = -1;

  private constructor() {
    super(MaintenanceRecordType.NOTIFICATION_COMMON, [MaintenanceReportChannel.PUSH], MaintenanceExtendType.STATISTICS);
    InnerEventUtil.on(TimeChangeEvent, this.onTimeChangeEvent);
    this.lastReportTime = this.getNowSec();
    this.reset();
  }

  public setRingMode(ringMode: number): number {
    return this.ringMode = ringMode;
  }

  public getRingMode(): number {
    return this.ringMode;
  }

  public setRingVolume(volume: number): number {
    return this.ringVolume = volume;
  }

  public setSwingInfo(isShow: boolean, isOwnerFace: boolean = true, isMultiEyeGaze: boolean = false): void {
    this.isShow = isShow;
    this.isOwnerFace = isOwnerFace;
    this.isMultiEyeGaze = isMultiEyeGaze;
  }

  public getIsShow(): number {
    const swingInfo = '' + Number(this.isShow) + Number(this.isOwnerFace) + Number(this.isMultiEyeGaze);
    return parseInt(swingInfo, 2);
  }

  public setSwingStatus(status: string): void {
    this.swingStatus = status;
  }

  public setRingSetting(ringAllow: boolean, vibrateAllow: boolean, vibrateWhenRing: boolean): void {
    const ringSetting = '' + Number(ringAllow ?? 0) + Number(vibrateAllow ?? 0) + Number(vibrateWhenRing ?? 0);
    this.ringSetting = parseInt(ringSetting, 2);
  }

  public async showNtfPanel(): Promise<void> {
    try {
      if (!this.ext.showPanelTime) {
        this.ext.showPanelTime = [];
      }
      this.updateInfoList(this.ext.showPanelTime, this.getNowSec(), StatisticsMaintenance.MAX_RECORD_ITEM);
    } catch (e) {
      log.error(`record show ntf panel time failed, ${e}`);
    }
  }

  public setVersion(isEnableV2: boolean):void {
    if (isEnableV2) {
      this.version = 1;
    } else {
      this.version = 0;
    }
  }

  private reset(): void {
    if (!this.ntfStatistics) {
      this.ntfStatistics = new Map();
    } else {
      this.ntfStatistics.clear();
    }
    this.ext.ntfNum = {};

    if (!this.liveViewStatistics) {
      this.liveViewStatistics = new Map();
    } else {
      this.liveViewStatistics.clear();
    }
    this.ext.liveViewNum = {};
    this.ext.showPanelTime = [];
  }

  protected isNeedReport(): boolean {
    log.showInfo('report statistics, do not limit');
    return true;
  }

  /**
   * 本次打点是否需要排队
   * @returns 返回true则表示需要排队
   */
  protected isNeedQueue(): boolean {
    return false;
  }

  /**
   * 接收通知
   * @param isNormal
   * @param ntf
   * @param isUpdate
   * @param isKeyGuard
   * @param errorCodes
   */
  public receiveNtf(isNormal: boolean, ntf: CompatibleNotification, isUpdate: boolean, isKeyGuard: boolean,
    errorCodes?: number[]): void {
    try {
      const isLive = MaintenanceCompatibleUtils.isLiveView(ntf);
      log.showInfo(`receiveNtf, isNormal: ${isNormal}, isLive: ${isLive}, isUpdate: ${isUpdate}, ` +
        `errorCodes: ${errorCodes}, isKeyGuard ${isKeyGuard}`);
      if (isLive) {
        this.receiveLive(isNormal, ntf, isUpdate, isKeyGuard, errorCodes);
      } else {
        const index = this.getDataIndex(isNormal);
        const ntfNum = this.getPkgStatistics(ntf);
        if (isUpdate) {
          ntfNum.ntfUpdateNum[index]++;
        } else {
          ntfNum.ntfCreateNum[index]++;
        }
        this.updateInfoList(ntfNum.remindFlag, ntf.remindConfig.flags);
        this.updateInfoList(ntfNum.alertOnce, Number(ntf.isAlertOnce ?? -1));
        this.updateInfoList(ntfNum.ringMode, this.ringMode);
        this.updateInfoList(ntfNum.keyGuard, Number(isKeyGuard ?? -1));
        this.updateInfoList(ntfNum.isShow, this.getIsShow());
        this.updateInfoList(ntfNum.soundDuration, ntf.soundDuration ?? 0);
        this.updateInfoList(ntfNum.customSound, Boolean(ntf.customSound) ? 1 : 0);
        this.updateInfoList(ntfNum.ringSetting, this.ringSetting);
        this.updateInfoList(ntfNum.isProtected,
          Number(this.protectedAppSet.has(`${ntf.creatorBundleName}_${ntf.appIndex}`)));
      }
      this.ext.userId = ntf.creatorUserId;
    } catch (e) {
      log.error(`receive ntf statistics fail, ${e}`);
    }
  }
  
  public receiveLive(isNormal: boolean, ntf: CompatibleLiveView, isUpdate: boolean, isKeyGuard: boolean,
    errorCodes?: number[]): void {
    const index = this.getLiveViewDataIndex(ntf.isFromPush, isNormal, errorCodes);
    const liveViewNum = this.getLiveViewPkgStatistics(ntf);
    if (!isUpdate) {
      liveViewNum.liveViewCreateNum[index]++;
      this.updateInfoList(liveViewNum.eventCreateNum, MaintenanceCompatibleUtils.getEvent(ntf));
      if (MaintenanceCompatibleUtils.isPhoneCall(ntf)) {
        this.updateInfoList(liveViewNum.phoneButtonCreateNum, MaintenanceCompatibleUtils.getPhoneButtonSize(ntf));
      }
    } else if (this.isUpdateEnd(ntf)) {
      liveViewNum.liveViewEndNum[index]++;
      this.updateInfoList(liveViewNum.keepTime, this.getKeepTime(ntf), StatisticsMaintenance.MAX_RECORD_ITEM);
      this.updateInfoList(liveViewNum.eventEndNum, MaintenanceCompatibleUtils.getEvent(ntf));
    } else {
      liveViewNum.liveViewUpdateNum[index]++;
      this.updateInfoList(liveViewNum.eventUpdateNum, MaintenanceCompatibleUtils.getEvent(ntf));
      if (MaintenanceCompatibleUtils.isPhoneCall(ntf)) {
        this.updateInfoList(liveViewNum.phoneButtonUpdateNum, MaintenanceCompatibleUtils.getPhoneButtonSize(ntf));
      }
    }
    liveViewNum.isOtherLiveView = this.getLiveViewType(ntf);
    this.updateInfoList(liveViewNum.ringMode, this.ringMode);
    this.updateInfoList(liveViewNum.keyGuard, Number(isKeyGuard ?? -1));

    const extendData = MaintenanceCompatibleUtils.getLiveExtend(ntf);
    this.updateLiveViewExtendNum(liveViewNum.liveViewExtendNum, extendData,
      isUpdate ? LiveViewExtendActionType.UPDATE : LiveViewExtendActionType.CREATE);
  }

  private isUpdateEnd(ntf: CompatibleLiveView): boolean {
    if (ntf instanceof LiveNotification) {
      return ntf.isEnd;
    }
    return ntf.liveViewData?.status === LiveViewDataStatus.END;
  }

  private getKeepTime(ntf: CompatibleLiveView): number {
    if (ntf instanceof LiveNotification) {
      return 0;
    }
    return ntf.liveViewData?.keepTime ?? 0;
  }

  private updateInfoList<T>(list: T[], item: T,
    maxNum: number = StatisticsMaintenance.MAX_RECORD_ITEM_COMPRESS): void {
    if (list.length > maxNum) {
      list.shift();
    }
    list.push(item);
  }

  /**
   * 删除通知
   * @param isNormal
   * @param ntfList
   */
  public deleteNtf(isNormal: boolean, ntfList: Array<CompatibleNotification>, deleteType?: number): void {
    try {
      log.showInfo(`deleteNtf, isNormal: ${isNormal}, length: ${ntfList.length}, deleteType: ${deleteType}`);
      ntfList.forEach(ntf => {
        if (MaintenanceCompatibleUtils.isLiveView(ntf)) {
          const index = this.getLiveViewDeleteDataIndex(isNormal, deleteType);
          const liveViewNum = this.getLiveViewPkgStatistics(ntf);
          liveViewNum.liveViewDeleteNum[index]++;
          liveViewNum.isOtherLiveView = this.getLiveViewType(ntf);
        } else {
          const index = this.getDelDataIndex(isNormal, deleteType);
          this.getPkgStatistics(ntf).ntfDeleteNum[index]++;
        }
      });
    } catch (e) {
      log.error(`delete ntf statistics fail, ${e}`);
    }
  }

  /**
   * 点击
   * @param isNormal
   * @param ntfList
   */
  public clickNtf(isNormal: boolean, ntf: CompatibleNotification, clickRegion: number,
    data?: CompatibleNotification | LiveViewData | BaseInfo, buttonName?: string): void {
    try {
      const isLive = MaintenanceCompatibleUtils.isLiveView(ntf);
      log.showInfo(`clickNtf, isNormal: ${isNormal}, isLive: ${isLive}, clickRegion: ${clickRegion}`);
      if (!StatisticsMaintenance.NEED_STATISTICS_CLICK_REGION.has(clickRegion)) {
        return;
      }
      if (isLive) {
        this.clickLive(isNormal, ntf, clickRegion, data, buttonName);
      } else {
        const index = this.getDataIndex(isNormal);
        this.getPkgStatistics(ntf).ntfClickNum[index]++;
      }
    } catch (e) {
      log.error(`clickNtf ntf statistics fail, ${e}`);
    }
  }

  public clickLive(isNormal: boolean, ntf: CompatibleNotification, clickRegion: number,
    data?: CompatibleNotification | LiveViewData | BaseInfo, buttonName?: string): void {
    const index = this.getLiveViewClickDataIndex(isNormal, clickRegion);
    const liveViewNum = this.getLiveViewPkgStatistics(ntf);
    liveViewNum.liveViewClickNum[index]++;
    liveViewNum.isOtherLiveView = this.getLiveViewType(ntf);
    if ((data instanceof LiveViewData || data instanceof NotificationBase)) {
      if (MaintenanceCompatibleUtils.isPhoneCall(data)) {
        log.showInfo(`clickNtf is phone call`);
        if (isNormal) {
          this.updateInfoList(liveViewNum.phoneButtonClickSucNum, buttonName);
        } else {
          this.updateInfoList(liveViewNum.phoneButtonClickErrNum, buttonName);
        }
      }
      if (clickRegion === ClickRegion.SUB_AREA) {
        const extendData = MaintenanceCompatibleUtils.getLiveExtend(data);
        this.updateLiveViewExtendNum(liveViewNum.liveViewExtendNum, extendData,
          LiveViewExtendActionType.CLICK, isNormal);
      }
    }
  }

  /**
   * 通知提醒
   * @param hashCode
   * @param bundleName
   * @param isLive
   */
  public remindNtf(hashCode: string, bundleName: string, isLive: boolean, type: RemindType = RemindType.NORMAL): void {
    try {
      log.showInfo(`remindNtf, hashCode: ${hashCode}, bundleName: ${bundleName}, isLive: ${isLive}, type ${type}`);
      const ntf = isLive ? new LiveNotification() : new NotificationBase();
      ntf.hashCode = hashCode;
      ntf.creatorBundleName = bundleName;
      if (isLive) {
        const liveViewNum = this.getLiveViewPkgStatistics(ntf);
        this.updateInfoList(liveViewNum.ringTime, this.getNowSec(), StatisticsMaintenance.MAX_RECORD_ITEM);
      } else {
        const ntfNum = this.getPkgStatistics(ntf);
        this.updateInfoList(this.getRingType(ntfNum, type), this.getNowSec(), StatisticsMaintenance.MAX_RECORD_ITEM);
      }
    } catch (e) {
      log.error(`remind ntf statistics fail, ${e}`);
    }
  }

  private getRingType(ntfNum: NtfNum, type: RemindType): number[] {
    switch (type) {
      case RemindType.DELIVER_PLAY:
        return ntfNum.deliverPlayTime;
      case RemindType.DELIVER_STOP:
        return ntfNum.deliverStopTime;
      case RemindType.SEND_DELIVER_PLAY:
        return ntfNum.deliverSendPlayTime;
      case RemindType.SEND_DELIVER_STOP:
        return ntfNum.deliverSendStopTime;
      default:
        return ntfNum.ringTime;
    }
  }

  /**
   * ans回调收到通知时计数
   * @param request
   */
  public listenerReceiveNtf(request: notificationManager.NotificationRequest): void {
    if (!request) {
      return;
    }
    const isLive = request.notificationSlotType === notificationManager.SlotType.LIVE_VIEW;
    const ntf = isLive ? new LiveNotification() : new NotificationBase();
    ntf.creatorBundleName = request.creatorBundleName;
    ntf.hashCode = request.hashCode;
    if (isLive) {
      const liveViewNum = this.getLiveViewPkgStatistics(ntf);
      liveViewNum.receiveNum++;
    } else {
      const ntfNum = this.getPkgStatistics(ntf);
      ntfNum.receiveNum++;
    }
  }

  /**
   * 获取通知对应的统计信息
   * @param ntf
   * @returns
   */
  private getPkgStatistics(ntf: CompatibleNotification): NtfNum {
    // SA包名为空，则取hashcode
    let key =
      (ntf.creatorType === NotificationCreatorType.SA && !ntf.creatorBundleName) ? ntf.hashCode : ntf.creatorBundleName;
    // 如果key为空或者map中key超过10个，则直接写入others
    if (!key ||
      (!this.ntfStatistics.has(key) && this.ntfStatistics.size >= StatisticsMaintenance.REPORT_PKG_LIMIT)) {
      log.showWarn(`pkg name is ${key}, change pkg name to others`);
      key = StatisticsMaintenance.OTHERS;
    }
    if (this.ntfStatistics.has(key)) {
      return this.ntfStatistics.get(key);
    }
    const ntfNum: NtfNum = {
      ntfCreateNum: new Array(NTFNumArrLength.NTF_CREATE_NUM_ARR_LENGTH).fill(0),
      ntfUpdateNum: new Array(NTFNumArrLength.NTF_UPDATE_NUM_ARR_LENGTH).fill(0),
      ntfDeleteNum: new Array(NTFNumArrLength.NTF_DELETE_NUM_ARR_LENGTH).fill(0),
      ntfClickNum: new Array(NTFNumArrLength.NTF_CLICK_NUM_ARR_LENGTH).fill(0),
      remindFlag: [],
      alertOnce: [],
      ringMode: [],
      keyGuard: [],
      ringTime: [],
      receiveNum: 0,
      isShow: [],
      soundDuration: [],
      deliverPlayTime: [],
      deliverStopTime: [],
      deliverSendPlayTime: [],
      deliverSendStopTime: [],
      customSound: [],
      ringSetting: [],
      isProtected: [],
    };
    this.ntfStatistics.set(key, ntfNum);
    return ntfNum;
  }

  /**
   * 获取实况对应的统计信息
   * @param ntf
   * @returns
   */
  private getLiveViewPkgStatistics(ntf: CompatibleNotification): LiveViewNum {
    // SA包名为空，则取hashcode
    let key =
      (ntf.creatorType === NotificationCreatorType.SA && !ntf.creatorBundleName) ? ntf.hashCode : ntf.creatorBundleName;
    // 如果key为空或者map中key超过10个，则直接写入others
    if (!key ||
      (!this.liveViewStatistics.has(key) && this.liveViewStatistics.size >= StatisticsMaintenance.REPORT_PKG_LIMIT)) {
      log.showWarn(`[liveview] pkg name is ${key}, change pkg name to others`);
      key = StatisticsMaintenance.OTHERS;
    }
    if (this.liveViewStatistics.has(key)) {
      return this.liveViewStatistics.get(key);
    }
    const liveViewNum: LiveViewNum = {
      liveViewCreateNum: new Array(LiveViewNumArrLength.LIVE_VIEW_CREATE_NUM_ARR_LENGTH).fill(0),
      liveViewUpdateNum: new Array(LiveViewNumArrLength.LIVE_VIEW_UPDATE_NUM_ARR_LENGTH).fill(0),
      liveViewEndNum: new Array(LiveViewNumArrLength.LIVE_VIEW_END_NUM_ARR_LENGTH).fill(0),
      liveViewDeleteNum: new Array(LiveViewNumArrLength.LIVE_VIEW_DELETE_NUM_ARR_LENGTH).fill(0),
      liveViewClickNum: new Array(LiveViewNumArrLength.LIVE_VIEW_CLICK_NUM_ARR_LENGTH).fill(0),
      isOtherLiveView: -1,
      ringMode: [],
      keyGuard: [],
      ringTime: [],
      keepTime: [],
      eventCreateNum: [],
      eventUpdateNum: [],
      eventEndNum: [],
      phoneButtonCreateNum: [],
      phoneButtonUpdateNum: [],
      phoneButtonClickSucNum: [],
      phoneButtonClickErrNum: [],
      receiveNum: 0,
      liveViewExtendNum: [],
    };
    this.liveViewStatistics.set(key, liveViewNum);
    return liveViewNum;
  }

  private getLiveViewType(ntf: CompatibleNotification): LiveViewType {
    if (ntf.contentType === notificationManager.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW) {
      return LiveViewType.SYSTEM_LIVE_VIEW;
    } else if (ntf.contentType === notificationManager.ContentType.NOTIFICATION_CONTENT_LIVE_VIEW) {
      return LiveViewType.OTHER_LIVE_VIEW;
    } else {
      log.showWarn('contentType is invalid: ' + ntf.contentType);
      return -1;
    }
  }

  private updateLiveViewExtendNum(liveViewExtendNum: LiveViewExtendNum[], extendData: LiveViewExtendNum,
    actionType: LiveViewExtendActionType, isClickSuc: boolean = true): void {
    if (!extendData) {
      return;
    }
    let data = liveViewExtendNum.find(e => e.type === extendData.type &&
      e.digest === extendData.digest && e.actionType === actionType);

    if (!data) {
      data = {
        type: extendData.type,
        digest: extendData.digest,
        actionType: actionType,
      };
      if (actionType === LiveViewExtendActionType.CLICK) {
        data.clickSucNum = isClickSuc ? 1 : 0;
        data.clickErrNum = !isClickSuc ? 1 : 0;
      }
      liveViewExtendNum.push(data);
    } else if (actionType === LiveViewExtendActionType.CLICK) {
      if (isClickSuc) {
        data.clickSucNum++;
      } else {
        data.clickErrNum++;
      }
    }

    if (actionType === LiveViewExtendActionType.CLICK) {
      log.showInfo(`clickNtf extend type: ` + extendData.type);
    } else {
      log.showInfo(`receiveNtf extend type: ` + extendData.type);
    }
  }

  private async getLiveViewExtendNum(list: LiveViewExtendNum[], actionType: LiveViewExtendActionType): Promise<string[]> {
    list = list.filter(e => e.actionType === actionType).slice(-2);

    let result: string[] = [];
    for (const item of list) {
      const digest = await DigestUtil.getDigestByString(item.digest);
      let res = `${item.type}_${digest?.substring(0, 10)}`;
      if (actionType === LiveViewExtendActionType.CLICK) {
        res += `_${item.clickSucNum}_${item.clickErrNum}`;
      }
      result.push(res);
    }

    // 辅助区信息不满2位使用-1占位
    for (let i = result.length; i < 2; i++) {
      result.push(StatisticsMaintenance.NO_NUM);
    }

    return result;
  }

  /**
   * 根据通知类型获取在数组中的index
   * @param ntf
   * @param isNormal
   * @returns
   */
  private getDataIndex(isNormal: boolean): number {
    return isNormal ? NtfDataIndex.NORMAL : NtfDataIndex.ERR;
  }

  private getDelDataIndex(isNormal: boolean, deleteType?: number): number {
    if (!isNormal) {
      return NtfDelDataIndex.ERR;
    }
    return StatisticsMaintenance.APP_DEL_TYPE.has(deleteType) ?
      NtfDelDataIndex.APP_DEL_NORMAL : NtfDelDataIndex.USER_DEL_NORMAL;
  }

  private getLiveViewDataIndex(isFromPush: boolean, isNormal: boolean, errorCodes?: number[]): number {
    if (isNormal) {
      return isFromPush ? LiveViewDataIndex.CLOUD_LIVE_SUC : LiveViewDataIndex.LOCAL_LIVE_SUC;
    } else {
      if (errorCodes?.some(err => StatisticsMaintenance.PHOTO_ERROR_CODES.has(err))) {
        return isFromPush ? LiveViewDataIndex.CLOUD_LIVE_PHOTO_ERR : LiveViewDataIndex.LOCAL_LIVE_PHOTO_ERR;
      } else {
        return isFromPush ? LiveViewDataIndex.CLOUD_LIVE_OTHER_ERR : LiveViewDataIndex.LOCAL_LIVE_OTHER_ERR;
      }
    }
  }

  private getLiveViewDeleteDataIndex(isNormal: boolean, deleteType?: number): number {
    if (isNormal) {
      if (StatisticsMaintenance.DELETE_REASON_TYPES_MAP.has(deleteType)) {
        return StatisticsMaintenance.DELETE_REASON_TYPES_MAP.get(deleteType);
      }
      return LiveViewDeleteDataIndex.LIVE_DELETE_SUC;
    } else {
      return LiveViewDeleteDataIndex.LIVE_DELETE_ERR;
    }
  }

  private getLiveViewClickDataIndex(isNormal: boolean, clickRegion: number): number {
    if (isNormal) {
      if (StatisticsMaintenance.AUXILIARY_REGION_CODES.has(clickRegion)) {
        return LiveViewClickDataIndex.LIVE_CLICK_SUC_AUXILIARY;
      } else if (StatisticsMaintenance.CAPSULE_CLICK.has(clickRegion)) {
        return LiveViewClickDataIndex.LIVE_CLICK_CAPSULE;
      } else {
        return LiveViewClickDataIndex.LIVE_CLICK_SUC_NON_AUXILIARY;
      }
    } else {
      if (StatisticsMaintenance.AUXILIARY_REGION_CODES.has(clickRegion)) {
        return LiveViewClickDataIndex.LIVE_CLICK_ERR_AUXILIARY;
      } else {
        return LiveViewClickDataIndex.LIVE_CLICK_ERR_NON_AUXILIARY;
      }
    }
  }

  private async reportNtfStatistics(): Promise<void> {
    try {
      this.ext.queueNum = this.getQueueLength();
      this.ext.dropNum = this.getDropNum();
      this.ext.volume = this.ringVolume;
      this.ext.showPanelTime = this.getRelativelyTime(this.ext.showPanelTime);
      this.ext.version = this.version;
      this.ntfStatistics.forEach((value, key) => {
        this.ext.ntfNum[key] = [
          value.ntfCreateNum,
          value.ntfUpdateNum,
          value.ntfDeleteNum,
          value.ntfClickNum,
          this.compressInfo(value.remindFlag),
          this.compressInfo(value.alertOnce),
          this.compressInfo(value.ringMode),
          this.compressInfo(value.keyGuard),
          this.getRelativelyTime(value.ringTime),
          value.receiveNum,
          this.compressInfo(value.isShow),
          this.compressInfo(value.soundDuration),
          this.getRelativelyTime(value.deliverPlayTime),
          this.getRelativelyTime(value.deliverStopTime),
          this.getRelativelyTime(value.deliverSendPlayTime),
          this.getRelativelyTime(value.deliverSendStopTime),
          this.compressInfo(value.customSound),
          this.compressInfo(value.ringSetting),
          this.compressInfo(value.isProtected),
        ].join(StatisticsMaintenance.SPLIT);
      });
      this.liveViewStatistics.forEach(async (value, key) => {
        const extendCreateNum = await this.getLiveViewExtendNum(value.liveViewExtendNum,
          LiveViewExtendActionType.CREATE);
        const extendUpdateNum = await this.getLiveViewExtendNum(value.liveViewExtendNum,
          LiveViewExtendActionType.UPDATE);
        const extendClickNum = await this.getLiveViewExtendNum(value.liveViewExtendNum,
          LiveViewExtendActionType.CLICK);
        const eventCreateNum = this.countInfo(value.eventCreateNum);
        const eventUpdateNum = this.countInfo(value.eventUpdateNum);
        const eventEndNum = this.countInfo(value.eventEndNum);
        const phoneButtonCreateNum = this.compressInfo(value.phoneButtonCreateNum);
        const phoneButtonUpdateNum = this.compressInfo(value.phoneButtonUpdateNum);
        const phoneButtonClickSucNum = this.compressInfo(value.phoneButtonClickSucNum);
        const phoneButtonClickErrNum = this.compressInfo(value.phoneButtonClickErrNum);
        this.ext.liveViewNum[key] = [
          [...value.liveViewCreateNum, ...extendCreateNum, eventCreateNum, phoneButtonCreateNum],
          [...value.liveViewUpdateNum, ...extendUpdateNum, eventUpdateNum, phoneButtonUpdateNum],
          [...value.liveViewEndNum, eventEndNum],
          value.liveViewDeleteNum,
          [...value.liveViewClickNum, ...extendClickNum, phoneButtonClickSucNum, phoneButtonClickErrNum],
          value.isOtherLiveView,
          this.compressInfo(value.ringMode),
          this.compressInfo(value.keyGuard),
          this.getRelativelyTime(value.ringTime),
          value.keepTime,
          value.receiveNum,
        ].join(StatisticsMaintenance.SPLIT);
      });
      const taskException = TaskQueue.getExceptionTaskQueue();
      this.ext.taskException = taskException.length ? JSON.stringify(taskException) : undefined;
      this.ext.swingStatus = this.swingStatus;
      this.report();
      this.reset();
    } catch (e) {
      log.error(`report statistic failed: ${e}`);
    }
  }

  private compressInfo(list: number[] | string[]): string | undefined {
    if (!list.length) {
      return StatisticsMaintenance.NO_NUM;
    }
    let baseValue: number | string = list[0];
    let count: number = 0;
    let out: string | undefined = undefined;
    for (const value of list) {
      // 值相同加入统计
      if (value === baseValue) {
        count++;
        continue;
      }
      // 值不同，统计出现次数
      const lastItemNum = baseValue + '_' + count;
      out = out === undefined ? lastItemNum : out + '|' + lastItemNum;
      baseValue = value; // 赋值新基线值
      count = 1;
    }
    // 处理末尾
    if (count) {
      const lastItemNum = baseValue + '_' + count;
      out = out === undefined ? lastItemNum : out + '|' + lastItemNum;
    }
    return out;
  }

  private countInfo(list: number[]): string {
    if (!list.length) {
      return StatisticsMaintenance.NO_NUM;
    }
    let map = new Map();

    for (const value of list) {
      // 值相同加入统计
      if (map.has(value)) {
        map.set(value, map.get(value) + 1);
      } else {
        map.set(value, 1);
      }
    }

    let result = Array.from(map.entries()).map(e => e[0] + '_' + e[1]);
    return result.join('|');
  }

  /**
   * 获取相对上报时间点的相对时间
   * @param ringTime
   * @returns
   */
  private getRelativelyTime(ringTime: number[]): number[] {
    const currentTime = this.getNowSec();
    return ringTime.map((time) => currentTime - time);
  }

  /**
   * 时间变化事件
   */
  private onTimeChangeEvent = (event: TimeChangeEvent): void => {
    if (TimeChangeEvent.EVENT_TIME_TICK === event.event) {
      const currentTime = this.getNowSec();
      // 10min上报一次
      if (currentTime - this.lastReportTime >= StatisticsMaintenance.REPORT_INTERVAL) {
        this.lastReportTime = currentTime;
        this.reportNtfStatistics();
      }
    }
  };

  private getNowSec(): number {
    return Math.floor(systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false) / 1000);
  }
}