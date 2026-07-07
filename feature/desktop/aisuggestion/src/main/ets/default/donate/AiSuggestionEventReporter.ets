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

import commonEvent from '@ohos.commonEvent';
import hiSysEvent from '@ohos.hiSysEvent';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DeviceHelper,
  getCommonEventManager,
  HiSysEventUtil,
  ReportParams,
} from '@ohos/frameworkwrapper';
import {
  BundleConstants,
  CommonConstants,
  Extend1Data,
  FormLayoutCacheManager,
  GridLayoutItemInfo,
  WeeklyReporter
} from '@ohos/launchercommon';
import { FormViewModel } from '@ohos/form/src/main/ets/default/viewmodel/FormViewModel';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import type {
  FormClickReportParams,
  FormDeleteReportParams,
  FormMenuReportParams,
  IconClickReportParams,
  IconMenuReportParams,
  RefreshReportParams,
  WeeklyStatusReportParams,
} from '../bean/AiSuggestionReportParams';
import { ReportItem } from '../bean/AiSuggestionReportParams';
import { EventReportConstants } from '../constants/EventReportConstants';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';
import { PreferenceUtil } from '../utils/PreferenceUtil';
import { SCBConstants, FormType } from '@ohos/commonconstants';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';

const TAG = 'AiSuggestionEventReporter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

// 不同点位类型值不同，用于映射
const menuTypeMap = new Map<number, number>([
  [EventReportConstants.SUGGEST_MENU_TYPE_NO_CLICK, EventReportConstants.SERVICE_MENU_TYPE_NO_CLICK],
  [EventReportConstants.SUGGEST_MENU_TYPE_MORE_CARD, EventReportConstants.SERVICE_MENU_TYPE_MORE_CARD],
  [EventReportConstants.SUGGEST_MENU_TYPE_UNINTEREST, EventReportConstants.SERVICE_MENU_TYPE_UNINTEREST],
  [EventReportConstants.SUGGEST_MENU_TYPE_PIN, EventReportConstants.SERVICE_MENU_TYPE_PIN],
  [EventReportConstants.SUGGEST_MENU_TYPE_UNPIN, EventReportConstants.SERVICE_MENU_TYPE_UNPIN],
  [EventReportConstants.SUGGEST_MENU_TYPE_REMOVE, EventReportConstants.SERVICE_MENU_TYPE_REMOVE],
  [EventReportConstants.SUGGEST_MENU_TYPE_UNINTEREST_SCENE, EventReportConstants.SERVICE_MENU_TYPE_UNINTEREST_SCENE],
]);

//语音助手建议不会出现在新形态小外屏，使用默认屏幕
const DEFAULT_SCREEN_TYPE = 1;

/**
 * 语音助手建议卡片服务点击、卡片刷新等事件上报
 *
 * @since 2023-12-23
 */
export class AiSuggestionEventReporter {
  // 记录请求时间
  public requestTime: number = 0;
  // 记录请求响应时间
  public receiveTime: number = 0;
  private static instance: AiSuggestionEventReporter;
  private menuType: number = EventReportConstants.SUGGEST_MENU_TYPE_DEFAULT;
  private deviceType: number = this.getDeviceType();
  private codeValue: string = '';
  private weeklyTask = (): Promise<void> => this.reportWeeklyRefreshTimeOfSuggestion();

  private constructor() {
    this.registerTimeAdjust();
    this.startReportTask();
  }

  /**
   * 获取AiSuggestionEventReporter单例
   *
   * @return 单例
   */
  static getInstance(): AiSuggestionEventReporter {
    if (AiSuggestionEventReporter.instance == null) {
      AiSuggestionEventReporter.instance = new AiSuggestionEventReporter();
    }
    return AiSuggestionEventReporter.instance;
  }

  // 注册时间被调节后的事件监听，用于更新剩余计时
  private registerTimeAdjust(): void {
    log.showInfo('registerTimeAdjust');
    let manager = getCommonEventManager(
      TAG,
      {
        events: [
          commonEvent.Support.COMMON_EVENT_TIME_CHANGED, // 时间被设置
          commonEvent.Support.COMMON_EVENT_TIMEZONE_CHANGED, // 时区变化
        ]
      },
      () => this.onTimeAdjust(),
      (isSubscribe) => isSubscribe
    );
    manager.subscriberCommonEvent();
  }

  // 注册时间被调节后的事件监听，用于更新剩余计时
  private onTimeAdjust(): void {
    log.showInfo('onTimeAdjust');
    this.startReportTask();
    this.clearTimeRecord();
  }

  // 注册时间被调节后的事件监听，用于更新剩余计时
  private clearTimeRecord(): void {
    this.requestTime = 0;
    this.receiveTime = 0;
  }

  /**
   * 获取设备类型
   *
   * @returns 类型
   */
  private getDeviceType(): number {
    if (DeviceHelper.isPad()) {
      return EventReportConstants.DEVICE_PAD;
    } else {
      return EventReportConstants.DEVICE_PHONE;
    }
  }

  /**
   * 设置菜单选项
   *
   * @param item 菜单选项
   * @returns void
   */
  setMenuType(type: number): void {
    this.menuType = type;
  }

  /**
   * 获取菜单选项
   *
   * @returns 菜单选项
   */
  getMenuType(): number {
    return this.menuType;
  }

  /**
   * 获取横竖屏状态
   *
   * @returns 0-竖屏 1-横屏
   */
  private getRotationMode(): number {
    let isVertical: boolean = AppStorage.get<boolean>('isPortrait') as boolean;
    if (isVertical) {
      return EventReportConstants.ROTATIONMODE_PORTRAIT;
    } else {
      return EventReportConstants.ROTATIONMODE_LANDSCAPE;
    }
  }

  /**
   * 获取语音助手建议版本
   *
   * @returns 版本
   */
  async getVersionCode(): Promise<string> {
    if (this.codeValue === '') {
      await AbilityFormUtil.getVersionName(BundleConstants.AI_SUGGESTION_BUNDLE).then(value => {
        this.codeValue = value;
      });
    }
    return this.codeValue;
  }

  /**
   * 开启上报任务
   *
   * @returns void
   */
  startReportTask(): void {
    WeeklyReporter.getInstance().unRegisterTask(this.weeklyTask);
    WeeklyReporter.getInstance().registerTask(this.weeklyTask);
  }

  /**
   * 服务卡片_语音助手建议_语音助手卡片刷新
   *
   * @param item 刷新的卡片
   * @param disPlayCardInfo 卡片的内容
   * @returns void
   */
  async reportRequestRefreshSuggestionForm(formItem: GridLayoutItemInfo,
    disPlayCardInfo: LauncherDisplayCardInfo | undefined): Promise<void> {
    if (!disPlayCardInfo) {
      return;
    }
    let mFormStyleConfig = FormViewModel.getInstance().getFormStyleConfig();
    let dpSize = mFormStyleConfig.mFormWidth.get(formItem.cardDimension?.toString() ?? '') + '*' +
    mFormStyleConfig.mFormHeight.get(formItem.cardDimension?.toString() ?? '');
    let iconNum = disPlayCardInfo.recItems?.filter(item => item.itemType === CommonConstants.TYPE_APP).length;
    let formNum = disPlayCardInfo.recItems?.filter(item => item.itemType === CommonConstants.TYPE_CARD).length;
    const versionCode: string = await this.getVersionCode();
    let params: RefreshReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CELLSIZE: `${formItem.area?.[0]}*${formItem.area?.[1]}`,
      DPSIZE: dpSize,
      DEVICETYPE: this.deviceType,
      ROTATIONMODE: this.getRotationMode(),
      REQUESTTIME: this.getRequestTime().toString(),
      REFRESHTIME: this.getRefreshTime().toString(),
      ICONNUM: iconNum,
      FORMNUM: formNum,
      FAINFO: this.getReportFaInfo(formItem, disPlayCardInfo),
      FORMID: formItem.cardId ?? '',
      MODULENAME: formItem.moduleName,
      FORMNAME: formItem.cardName,
      VERSIONCODE: versionCode,
      SOURCETYPE: Extend1Data.getCardSourceType(formItem.extend1),
      SCREEN_TYPE: HiSysEventUtil.screenType,
    };

    log.showInfo('reportRequestRefreshSuggestionForm REQUESTTIME:%{public}s, REFRESHTIME:%{public}s, FORMID:%{public}s'
      , params.REQUESTTIME, params.REFRESHTIME, params.FORMID);
    HiSysEventUtil.report(EventReportConstants.FORM_REPORT_DOMAIN, EventReportConstants.AISUGGESTION_CARD_UPDATE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  private getReportFaInfo(formItem: GridLayoutItemInfo, disPlayCardInfo: LauncherDisplayCardInfo): string {
    let itemList: ReportItem[] = [];
    disPlayCardInfo.recItems.forEach(recItem => {
      let reportItem = new ReportItem();
      reportItem.cardId = formItem.cardId ?? '';
      reportItem.serviceId = recItem.serviceId;
      reportItem.itemType = recItem.itemType;
      reportItem.pinStatus = recItem.pinStatus;
      reportItem.uid = recItem.uid;
      reportItem.rowStart = recItem.rowStart;
      reportItem.columnStart = recItem.columnStart;
      reportItem.rowSpan = recItem.rowSpan;
      reportItem.columnSpan = recItem.columnSpan;
      itemList.push(reportItem);
    });
    return JSON.stringify(itemList).replace(/"/g, "'");
  }

  private getRequestTime(): number {
    if (this.receiveTime === 0 || this.requestTime === 0) {
      return 0;
    }
    let requestTime = this.receiveTime - this.requestTime;
    return requestTime > 0 ? requestTime : 0;
  }

  private getRefreshTime(): number {
    if (this.receiveTime === 0 || this.requestTime === 0) {
      return 0;
    }
    let refreshTime = new Date().getTime() - this.requestTime;
    return refreshTime > 0 ? refreshTime : 0;
  }

  private reportAiSuggestionItem(params: WeeklyStatusReportParams[]): void {
    HiSysEventUtil.batchReport(EventReportConstants.FORM_REPORT_DOMAIN,
      EventReportConstants.AISUGGESTION_CARD_WEEKLY_REPORT,
      hiSysEvent.EventType.STATISTIC, params);

    //上报之后，清除sp
    PreferenceUtil.getAiSuggestionPreference().delete(AiSuggestionConstants.AI_SUGGESTION_REFRESH_TIMES);
  }

  /**
   * 服务卡片_语音助手建议_语音助手卡片状态周报（周日0点上报）
   *
   * @returns void
   */
  async reportWeeklyRefreshTimeOfSuggestion(): Promise<void> {
    const refreshTimes = await PreferenceUtil.getAiSuggestionPreference()
      .get(AiSuggestionConstants.AI_SUGGESTION_REFRESH_TIMES, 0) as number;
    const itemList: GridLayoutItemInfo[] = AbilityFormUtil.getAllAiSuggestionItems();
    const currentTime: string = new Date().getTime()?.toString();
    const versionCode: string = await this.getVersionCode();

    if (itemList.length === 0) {
      let params: WeeklyStatusReportParams = {
        REFRESHTIMES: refreshTimes,
        CELLSIZE: '-1',
        SCREENID: -1,
        CELLX: -1,
        CELLY: -1,
        FORMID: '-1',
        FANUM: 0,
        SERIALNUM: currentTime,
        PNAMEID: ReportParams.PACKAGE_NAME,
        PVERSIONID: ReportParams.PROCESS_NAME,
      };
      this.reportAiSuggestionItem([params]);
      return;
    }
    let params: WeeklyStatusReportParams[] = [];
    for (let item of itemList) {
      if (!item.area || item.area.length < AiSuggestionConstants.ARRAY_LENGTH_TWO) {
        return;
      }
      let param: WeeklyStatusReportParams =
        {
          PNAMEID: ReportParams.PACKAGE_NAME,
          PVERSIONID: ReportParams.PROCESS_NAME,
          REFRESHTIMES: refreshTimes,
          DEVICETYPE: this.deviceType,
          CELLSIZE: `${item.area[0]}*${item.area[1]}`,
          SCREENID: item.page ?? -1,
          CELLX: item.column ?? 0,
          CELLY: item.row ?? 0,
          FORMID: item.cardId ?? '',
          FANUM: itemList.length,
          MODULENAME: item.moduleName,
          FORMNAME: item.cardName,
          VERSIONCODE: versionCode,
          SERIALNUM: currentTime,
          SOURCETYPE: Extend1Data.getCardSourceType(item.extend1),
        };
      params.push(param);
    }
    this.reportAiSuggestionItem(params);
  }

  /**
   * 记录卡片请求刷新的时间
   */
  recordRequestTime(): void {
    this.requestTime = new Date().getTime();
  }

  /**
   * 记录响应请求的时间
   */
  recordReceiveTime(): void {
    this.receiveTime = new Date().getTime();
  }

  /**
   * 语音助手建议_点击语音助手建议卡片内应用图标
   */
  async reportSuggestionFormIconClick(formItem: GridLayoutItemInfo, appItem: LauncherRecItem): Promise<void> {
    const versionCode: string = await this.getVersionCode();
    let params: IconClickReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DEVICETYPE: this.deviceType,
      PACKAGENAME: appItem.bundleName,
      CELLSIZE: `${formItem.area?.[0]}*${formItem.area?.[1]}`,
      CURRENTPAGE: formItem.page ?? -1,
      TOTALPAGE: FormLayoutCacheManager.getInstance().selectPageCount(),
      CELLX: formItem.column ?? 0,
      CELLY: formItem.row ?? 0,
      ISCLONEAPP: false,
      POSITIONX: appItem.columnStart,
      POSITIONY: appItem.rowStart,
      ROTATIONMODE: this.getRotationMode(),
      FORMID: formItem.cardId ?? '',
      VERSIONCODE: versionCode,
      FORMNAME: formItem.cardName,
      MODULENAME: formItem.moduleName,
      SOURCETYPE: Extend1Data.getCardSourceType(formItem.extend1),
      SCREEN_TYPE: HiSysEventUtil.screenType,
    };
    log.showInfo('reportSuggestionFormIconClick PACKAGENAME:%{public}s, FORMID:%{public}s', params.PACKAGENAME,
      params.FORMID);
    HiSysEventUtil.report(EventReportConstants.FORM_REPORT_DOMAIN, EventReportConstants.AISUGGESTION_INNER_ICON_CLICK,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 语音助手建议_长按语音助手建议卡片内应用图标
   */
  async reportSuggestionFormIconLongPress(formItem: GridLayoutItemInfo,
    appItem: LauncherRecItem | undefined): Promise<void> {
    if (!formItem || !appItem) {
      log.showWarn('reportSuggestionFormIconLongPress formItem or appItem isEmpty');
      return;
    }
    if (appItem.itemType !== CommonConstants.TYPE_APP) {
      return;
    }
    if (this.menuType === EventReportConstants.SUGGEST_MENU_TYPE_DEFAULT) {
      this.menuType = EventReportConstants.SUGGEST_MENU_TYPE_NO_CLICK;
    }
    const versionCode: string = await this.getVersionCode();
    let params: IconMenuReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DEVICETYPE: this.deviceType,
      PACKAGENAME: appItem.bundleName,
      CELLSIZE: `${formItem.area?.[0]}*${formItem.area?.[1]}`,
      CURRENTPAGE: formItem.page ?? -1,
      TOTALPAGE: FormLayoutCacheManager.getInstance().selectPageCount(),
      CELLX: formItem.column ?? 0,
      CELLY: formItem.row ?? 0,
      ISCLONEAPP: false,
      POSITIONX: appItem.columnStart,
      POSITIONY: appItem.rowStart,
      ROTATIONMODE: this.getRotationMode(),
      FORMID: formItem.cardId ?? '',
      MENUTYPE: this.menuType,
      VERSIONCODE: versionCode,
      FORMNAME: formItem.cardName,
      MODULENAME: formItem.moduleName,
      SOURCETYPE: Extend1Data.getCardSourceType(formItem.extend1),
      SCREEN_TYPE: HiSysEventUtil.screenType,
    };

    log.showInfo('reportSuggestionFormIconLongPress PACKAGENAME:%{public}s, MENUTYPE:%{public}d, FORMID:%{public}s',
      params.PACKAGENAME, params.MENUTYPE, params.FORMID);
    HiSysEventUtil.report(EventReportConstants.FORM_REPORT_DOMAIN, EventReportConstants.AISUGGESTION_ICON_LONG_PRESS,
      hiSysEvent.EventType.BEHAVIOR, params);
    this.setMenuType(EventReportConstants.SUGGEST_MENU_TYPE_DEFAULT);
  }

  /**
   * 服务卡片_语音助手建议_删除卡片
   */
  async reportSuggestionFormDelete(cardId: string, isCanceled: boolean): Promise<void> {
    const itemList: GridLayoutItemInfo[] = AbilityFormUtil.getAllAiSuggestionItems();
    let formItem: GridLayoutItemInfo = itemList.find(item => item.cardId === cardId) ?? new GridLayoutItemInfo();
    const versionCode: string = await this.getVersionCode();
    if (formItem !== null && formItem !== undefined) {
      let params: FormDeleteReportParams = {
        PNAMEID: ReportParams.PACKAGE_NAME,
        PVERSIONID: ReportParams.PROCESS_NAME,
        ABILITYFORM: formItem.bundleName,
        SIZE: `${formItem.area?.[0]}*${formItem.area?.[1]}`,
        POSITION: `[${formItem.page},${formItem.column},${formItem.row}]`,
        RESULTTYPE: isCanceled ? EventReportConstants.RESULTTYPE_CANCEL : EventReportConstants.RESULTTYPE_DELETE,
        FORMID: formItem.cardId ?? '',
        VERSIONCODE: versionCode,
        FORMNAME: formItem.cardName,
        MODULENAME: formItem.moduleName,
        SOURCETYPE: Extend1Data.getCardSourceType(formItem.extend1),
        SCREEN_TYPE: DEFAULT_SCREEN_TYPE,
        FORMTYPE: FormType.COMMON_FORM_TYPE,
      };

      log.showInfo('reportSuggestionFormDelete ABILITYFORM:%{public}s, FORMID:%{public}s',
        params.ABILITYFORM, params.FORMID);
      HiSysEventUtil.report(EventReportConstants.FORM_REPORT_DOMAIN, EventReportConstants.REMOVE_CARD_UE,
        hiSysEvent.EventType.BEHAVIOR, params);
    } else {
      log.showError('reportSuggestionFormDelete find card error');
    }
  }

  /**
   * 服务卡片_语音助手建议_点击卡片
   */
  async reportSuggestionFormClick(formItem: GridLayoutItemInfo, appItem?: LauncherRecItem): Promise<void> {
    let mFormStyleConfig = FormViewModel.getInstance().getFormStyleConfig();
    let dpSize = mFormStyleConfig.mFormWidth.get(formItem.cardDimension?.toString() ?? '') + '*' +
    mFormStyleConfig.mFormHeight.get(formItem.cardDimension?.toString() ?? '');
    const versionCode: string = await this.getVersionCode();
    let params: FormClickReportParams = {
      PACKAGENAME: appItem ? appItem.bundleName : formItem.bundleName,
      CELLSIZE: `${formItem.area?.[0]}*${formItem.area?.[1]}`,
      DPSIZE: dpSize,
      CURRENTPAGE: formItem.page ?? -1,
      TOTALPAGE: FormLayoutCacheManager.getInstance().selectPageCount(),
      CELLX: formItem.column ?? 0,
      CELLY: formItem.row ?? 0,
      INFOTYPE: appItem ? EventReportConstants.INFOTYPE_SUB : EventReportConstants.INFOTYPE_MASTER,
      FORMID: formItem.cardId ?? '',
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DEVICETYPE: this.deviceType,
      ROTATIONMODE: this.getRotationMode(),
      VERSIONCODE: versionCode,
      FORMNAME: formItem.cardName,
      MODULENAME: formItem.moduleName,
      SOURCETYPE: Extend1Data.getCardSourceType(formItem.extend1),
      SCREEN_TYPE: DEFAULT_SCREEN_TYPE,
    };

    log.showInfo('reportSuggestionFormClick PACKAGENAME:%{public}s, FORMID:%{public}s',
      params.PACKAGENAME, params.FORMID);
    HiSysEventUtil.report(EventReportConstants.FORM_REPORT_DOMAIN, EventReportConstants.CLICK_CARD_UE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 服务卡片_语音助手建议_长按语音助手建议卡片弹出菜单
   */
  async reportSuggestionFormMenu(formItem: GridLayoutItemInfo, appItem: LauncherRecItem | undefined): Promise<void> {
    if (!formItem || appItem?.itemType === CommonConstants.TYPE_APP) {
      return;
    }
    if (this.menuType === EventReportConstants.SUGGEST_MENU_TYPE_DEFAULT) {
      this.menuType = EventReportConstants.SUGGEST_MENU_TYPE_NO_CLICK;
    }
    let mFormStyleConfig = FormViewModel.getInstance().getFormStyleConfig();
    let dpSize = mFormStyleConfig.mFormWidth.get(formItem.cardDimension?.toString() ?? '') + '*' +
    mFormStyleConfig.mFormHeight.get(formItem.cardDimension?.toString() ?? '');
    const versionCode: string = await this.getVersionCode();
    let params: FormMenuReportParams = {
      PACKAGENAME: appItem ? appItem.bundleName : formItem.bundleName,
      CELLSIZE: `${formItem.area?.[0]}*${formItem.area?.[1]}`,
      DPSIZE: dpSize,
      INFOTYPE: !appItem ? EventReportConstants.INFOTYPE_MASTER : EventReportConstants.INFOTYPE_SUB,
      FORMID: formItem.cardId ?? '',
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DEVICETYPE: this.deviceType,
      ROTATIONMODE: this.getRotationMode(),
      VERSIONCODE: versionCode,
      FORMNAME: formItem.cardName,
      MODULENAME: formItem.moduleName,
      MENUTYPE: menuTypeMap.get(this.menuType) ?? 0,
      SOURCETYPE: Extend1Data.getCardSourceType(formItem.extend1),
      SCREEN_TYPE: DEFAULT_SCREEN_TYPE,
      FORMTYPE: FormType.COMMON_FORM_TYPE,
    };

    log.showInfo('reportSuggestionFormMenu PACKAGENAME:%{public}s, MENUTYPE:%{public}d, FORMID:%{public}s',
      params.PACKAGENAME, params.MENUTYPE, params.FORMID);
    HiSysEventUtil.report(EventReportConstants.FORM_REPORT_DOMAIN, EventReportConstants.GO_INTO_CARD_SHORTCUT_MENU_UE,
      hiSysEvent.EventType.BEHAVIOR, params);
    this.setMenuType(EventReportConstants.SUGGEST_MENU_TYPE_DEFAULT);
  }
}