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

import {
  CardSourceType,
  CommonConstants,
  Extend1Data,
  FormHiSysEventReporter,
  WeeklyReporter,
  FormCommonUtil,
} from '@ohos/launchercommon';
import { AppModel, FormModel } from '@ohos/launchercommon';
import { LogHelper, LogDomain, CheckEmptyUtils } from '@ohos/basicutils';
import { HiSysReportEvent, HiSysEventUtil, ReportDomain, DeviceHelper } from '@ohos/frameworkwrapper';
import { Alarm, ObjectCopyUtil } from '@ohos/componenthelper';
import type { CardItemInfo, AppItemInfo } from '@ohos/launchercommon';
import { FormWeeklyParams, FormExposureParams, FormParams } from './FormReportParams';
import { FormViewModel } from '../viewmodel/FormViewModel';
import systemDateTime from '@ohos.systemDateTime';
import { FormReportConstants } from '../common/constants/FormReportConstants';
import FormConstants from '../common/constants/FormConstants';
import { CardAddType } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';

export class ReportParams {
  public static readonly PACKAGE_NAME: string = 'com.ohos.sceneboard';
  public static readonly PROCESS_NAME: string = 'sceneBoard';
}

export enum ItemType {
  RECOMMEND_CARD, // 卡片中心推荐卡片
  CARD_LIST, // 卡片中心本地应用卡片列表
}

export enum RemoveCardResultType {
  REMOVE,
  CANCEL,
}

export enum ScreenSelectType {
  CURRENT = 1, // 当前屏
  NEXT, // 下一屏
  CREATE, // 新增屏
}

const TAG: string = 'FormHiSysEventUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const reporter: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain.FORM_UE);
const outerReporter: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain.OUTER_HOME_UE);

const CARD_ADD_ARR: number[][] = [
  [FormConstants.FORM_MANAGER_SHOW_FROM_FORM_SERVICE_FORM_APP, CardAddType.RESOURCE_LIB_FORM_APP_INTO_FORM_MANAGER],
  [FormConstants.FORM_MANAGER_SHOW_FROM_FORM_SERVICE_GRID_FORM, CardAddType.RESOURCE_LIB_GRID_FORM_INTO_FORM_MANAGER],
  [FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_FORM_RIGHT_MENU, CardAddType.SHORTCUT_MENU_INTO_FORM_MANAGER],
  [FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_APP_RIGHT_MENU, CardAddType.SHORTCUT_MENU_INTO_FORM_MANAGER],
  [FormConstants.FORM_MANAGER_SHOW_FROM_SEARCH, CardAddType.RESOURCE_LIB_FORM_SEARCH],
  [FormConstants.FORM_MANAGER_ATOMIC_SERVICE, CardAddType.ATOMIC_SERVICE],
  [FormConstants.FORM_MANAGER_APP, CardAddType.APP],
];
const SHOW_FROM_INDEX: number = 0;
const ADD_TYPE_INDEX: number = 1;

/**
 * Form UE Util.
 */
export class FormHiSysEventUtil {
  private static instance: FormHiSysEventUtil;

  // User behavior events use this domain
  public static readonly FORM_UE_DOMAIN: string = 'FORM_UE';
  // 长按应用后-服务卡片打点
  public static readonly APP_MENU_INTO_FORM_MANAGER = 'APP_MENU_INTO_FORM_MANAGER';
  // 管理卡片界面滑动选择卡片打点
  public static readonly SLIDE_TO_SELECT_CARD = 'SLIDE_TO_SELECT_CARD';
  // 桌面编辑,点击+按键进入卡片资源库
  public static readonly INTO_FORM_RESOURCE_LIBRARY = 'INTO_FORM_RESOURCE_LIBRARY';
  // 点击卡片资源库优推卡片、本地应用卡片进入更多服务卡片界面
  public static readonly RESOURCE_LIB_INTO_FORM_MANAGER = 'RESOURCE_LIB_INTO_FORM_MANAGER';

  public static readonly FORM_WEEKLY_REPORT: string = 'FORM_WEEKLY_REPORT';

  // 新形态小外屏桌面_外屏桌面卡片详情状态点周报
  public static readonly OUTER_HOME_FORM_WEEKLY_REPORT: string = 'OUTER_HOME_FORM_WEEKLY_REPORT';

  public static readonly FORM_EXPOSURE_DATA: string = 'FORM_EXPOSURE_DATA';
  // 点击卡片中心应用列表，进入卡片管理页打点
  public static readonly FORM_CENTER_CLICK_APP_LIST: string = 'FORM_CENTER_CLICK_APP_LIST';
  // 主题卡片，点击查看更多百变卡片，跳转主题应用打点
  public static readonly THEME_FORM_CLICK_MORE: string = 'THEME_FORM_CLICK_MORE';

  // 进入服务卡片方式打点
  public static readonly INTO_FORM_TYPE = 'INTO_FORM_TYPE';

  private weeklyTask = (): Promise<void> => this.reportWeeklyInfo();

  private mFormModel: FormModel = FormModel.getInstance();
  private exposureFormInfo: FormExposureParams[] = [];
  private exposureStartTime: Map<string, number> = new Map();
  private reportAlarm: Alarm = new Alarm();

  static getInstance(): FormHiSysEventUtil {
    if (FormHiSysEventUtil.instance == null) {
      FormHiSysEventUtil.instance = new FormHiSysEventUtil();
    }
    return FormHiSysEventUtil.instance;
  }
  /**
   * 长按应用后-服务卡片打点
   */
  public static reportIntoFormManagerFromAppShortcutMenu(packageName?: string): void {
    let params: FormParams = new FormParams();
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    params.PACKAGENAME = packageName ?? '';
    params.DEVICETYPE = FormHiSysEventReporter.getDeviceType();
    params.ROTATIONMODE = HiSysEventUtil.getRotationMode();
    reporter.reportBehavior(FormHiSysEventUtil.APP_MENU_INTO_FORM_MANAGER, params);
  }

  /**
   * 进入服务卡片方式打点
   */
  public static reportIntoFormType(intoCardType: string): void {
    let params: FormParams = new FormParams();
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    params.INTOCARDTYPE = intoCardType;
    reporter.reportBehavior(FormHiSysEventUtil.INTO_FORM_TYPE, params);
  }

  /**
   * 管理卡片界面滑动选择卡片打点
   */
  public static reportSlideToSelectCard(componentName: string, size: number[], formId?: string,
    formName?: string, moduleName?: string): void {
    let params: FormParams = new FormParams();
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    params.COMPONENTNAME = componentName;
    params.SIZE = `${size[0]} * ${size[1]}`;
    params.FORMID = formId ?? '';
    params.FORMNAME = formName ?? '';
    params.MODULENAME = moduleName ?? '';
    params.VERSIONCODE = HiSysEventUtil.getVersionName(componentName);
    reporter.reportBehavior(FormHiSysEventUtil.SLIDE_TO_SELECT_CARD, params);
  }

  /**
   * 桌面编辑,点击+按键进入卡片资源库打点
   */
  public static reportIntoFormResourceLibrary(): void {
    let params: FormParams = new FormParams();
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    reporter.reportBehavior(FormHiSysEventUtil.INTO_FORM_RESOURCE_LIBRARY, params);
  }

  /**
   * 点击卡片资源库优推卡片、本地应用卡片进入更多服务卡片界面
   */
  public static reportIntoFormManagerFromResourceLibrary(pkg: string, formId: string,
    moduleName: string, formName: string, cellSize?: number[], itemType?: number): void {
    let params: FormParams = new FormParams();
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    params.PKG = pkg;
    params.DEVICE_TYPE = FormHiSysEventReporter.getDeviceType();
    params.ROTATION_MODE = HiSysEventUtil.getRotationMode();
    params.FORM_ID = formId;
    params.MODULE_NAME = moduleName;
    params.FORM_NAME = formName;
    params.CELL_SIZE = `${cellSize?.[0]} * ${cellSize?.[1]}`;
    params.ITEM_TYPE = itemType ?? -1;
    params.VERSIONCODE = HiSysEventUtil.getVersionName(pkg);
    reporter.reportBehavior(FormHiSysEventUtil.RESOURCE_LIB_INTO_FORM_MANAGER, params);
  }

  /**
   * 卡片中心-点击应用列表打点
   */
  public static reportFormCenterClickAppList(packageName?: string): void {
    let params: FormParams = new FormParams();
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    params.PACKAGENAME = packageName ?? '';
    params.DEVICETYPE = FormHiSysEventReporter.getDeviceType();
    params.ROTATIONMODE = HiSysEventUtil.getRotationMode();
    reporter.reportBehavior(FormHiSysEventUtil.FORM_CENTER_CLICK_APP_LIST, params);
  }

  public static getClickAddCardType(formManagerShowFrom: number): number {
    for (let addType of CARD_ADD_ARR) {
      if (addType[SHOW_FROM_INDEX] === formManagerShowFrom) {
        return addType[ADD_TYPE_INDEX];
      }
    }
    return CardAddType.OTHERS;
  }

  public static getDragAddCardType(dragItemType: number, formManagerShowFrom: number): number {
    log.showInfo(`getDragAddCardType dragItemType=${dragItemType}, formManagerShowFrom=${formManagerShowFrom}`);
    if (dragItemType === CommonConstants.DRAG_FROM_FORM_SERVICE) {
      return CardAddType.RESOURCE_LIB_GRID_FORM;
    }
    if (dragItemType === CommonConstants.DRAG_FROM_FORM_INTELLIGENT) {
      return CardAddType.AA_CARD;
    }
    if (dragItemType !== CommonConstants.DRAG_FROM_MANAGE && dragItemType !== CommonConstants.DRAG_FROM_APP) {
      log.showWarn(`unknown dragItemType ${dragItemType}`);
      return CardAddType.OTHERS;
    }

    for (let addType of CARD_ADD_ARR) {
      if (addType[SHOW_FROM_INDEX] === formManagerShowFrom) {
        return addType[ADD_TYPE_INDEX];
      }
    }
    log.showWarn(`unknown formManagerShowFrom ${formManagerShowFrom}`);
    return CardAddType.OTHERS;
  }

  private getAppInfo(info: FormWeeklyParams): void {
    let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
    if (!appList) {
      log.showWarn('no app info');
      return;
    }
    let appSupportForm: number = 0;
    info.APPNUM = appList.length;
    log.showInfo(`APPNUM: ${info.APPNUM}`);
    appList.forEach((appInfo: AppItemInfo, index: number) => {
      log.showInfo(`app ${appInfo.appName}`);
      const formInfoList: CardItemInfo[] | undefined = this.mFormModel.getAppItemFormInfo(appInfo.bundleName as string);
      if (!CheckEmptyUtils.isEmptyArr(formInfoList)) {
        appSupportForm++;
      }
    });
    info.SUPAPP = appSupportForm;
    log.showInfo(`APPNUM: ${info.APPNUM}, SUPAPP: ${info.SUPAPP}`);
  }

  private getFormSize(formInfo: CardItemInfo): string {
    let width: number =
      Number(FormViewModel.getInstance().getFormStyleConfig().mFormWidth.get(formInfo.cardDimension.toString()));
    let height: number =
      Number(FormViewModel.getInstance().getFormStyleConfig().mFormHeight.get(formInfo.cardDimension.toString()));
    return `${width}*${height}`;
  }

  private getFormCellSize(formInfo: CardItemInfo): string {
    return `${formInfo.area?.[1]}*${formInfo.area?.[0]}`;
  }

  /**
   * 开始计时
   *
   * @returns void
   */
  public startReportAlarm(): void {
    WeeklyReporter.getInstance().unRegisterTask(this.weeklyTask);
    WeeklyReporter.getInstance().registerTask(this.weeklyTask);

  }

  private batchReportFormInfo(params: Object[], isOuter?: boolean): void {
    if (isOuter === undefined) {
      isOuter = false;
    }

    if (isOuter) {
      outerReporter.batchReportStatistic(FormHiSysEventUtil.OUTER_HOME_FORM_WEEKLY_REPORT, params);
    } else {
      reporter.batchReportStatistic(FormHiSysEventUtil.FORM_WEEKLY_REPORT, params);
    }
  }

  private async reportFormInfo(isOuter?: boolean): Promise<void> {
    let formInfoList: CardItemInfo[] = await this.mFormModel.getAllFormsInfoExceptStackFromRdb(isOuter);
    if (!formInfoList) {
      log.showWarn('no form info');
      return;
    }
    let info: FormWeeklyParams = new FormWeeklyParams();
    this.getAppInfo(info);
    info.FANUM = formInfoList.length;
    log.showInfo(`formlist: ${info.FANUM}`);
    let time: number = systemDateTime.getTime(false);
    info.SERIALNUM = time.toString();
    info.PRESETSNUM = 0;
    info.UPGRADENUM = 0;
    if (formInfoList.length === 0) {
      info.PNAMEID = ReportParams.PACKAGE_NAME;
      info.PVERSIONID = ReportParams.PROCESS_NAME;
      info.PACKAGENAME = '-1';
      info.MODULENAME = '-1';
      info.CELLSIZE = '-1';
      info.DPSIZE = '-1';
      info.FORMID = '-1';
      info.FORMNAME = '-1';
      info.SCREENID = '-1';
      info.CELLX = -1;
      info.CELLY = -1;
      info.SOURCETYPE = '-1';
      info.FORMTYPE = -1;
      this.batchReportFormInfo([info], isOuter);
      return;
    }
    formInfoList.forEach(item => {
      const sourceType: string = Extend1Data.getCardSourceType(item.extend1);
      if (sourceType === CardSourceType.UPGRADE_MIGRATE) {
        info.UPGRADENUM++;
      } else if (sourceType === CardSourceType.SYS_PRESETS) {
        info.PRESETSNUM++;
      } else {}
    });
    let data: FormWeeklyParams[] = [];
    for (const formInfo of formInfoList) {
      let copyItem: FormWeeklyParams = ObjectCopyUtil.deepClone(info);
      this.collectStatisticsData(copyItem, formInfo, data);
    }
    this.batchReportFormInfo(data, isOuter);
	}

  private reportWeeklyFormInfo(): void {
    let isOuter: boolean = false;
    this.reportFormInfo(isOuter);
  }

  private reportWeeklyOuterFormInfo(): void {
    let isOuter: boolean = true;
    this.reportFormInfo(isOuter);
  }

  // weekly report fa info
  public async reportWeeklyInfo(): Promise<void> {
    log.showInfo('reportWeeklyInfo start');
    this.reportWeeklyFormInfo();
  }

  private collectStatisticsData(info: FormWeeklyParams, formInfo: CardItemInfo, data: FormWeeklyParams[]): void {
    info.PNAMEID = ReportParams.PACKAGE_NAME;
    info.PVERSIONID = ReportParams.PROCESS_NAME;
    info.PACKAGENAME = formInfo.bundleName;
    info.MODULENAME = formInfo.moduleName;
    info.CELLSIZE = this.getFormCellSize(formInfo);
    info.DPSIZE = this.getFormSize(formInfo);
    info.FORMID = formInfo.cardId;
    info.FORMNAME = formInfo.cardName;
    info.SCREENID = formInfo.page?.toString() ?? '';
    info.CELLX = formInfo.column ?? -1;
    info.CELLY = formInfo.row ?? -1;
    info.SOURCETYPE = Extend1Data.getCardSourceType(formInfo.extend1);
    info.FORMTYPE = FormCommonUtil.getFormType(formInfo.gameCardInfo);
    data.push(info);
  }

  private getExposureStartTime(timeString: string, time: number, isEnd: boolean, isStart: boolean): string {
    if (isStart) {
      timeString += `${time}+`;
    } else {
      timeString += `${time}`;
      if (isEnd) {
        timeString += ']';
      } else {
        timeString += ',';
      }
    }
    return timeString;
  }

  public async exposureChange(formInfo: CardItemInfo, exposure: boolean, isUnInstall: boolean): Promise<void> {
    if (CheckEmptyUtils.isEmpty(formInfo) || CheckEmptyUtils.isEmpty(formInfo.cardId)) {
      log.showWarn('form card id can not be zero or undefined');
      return;
    }
    let time: number = systemDateTime.getTime(false);
    let exposureInfo: FormExposureParams | undefined =
      this.exposureFormInfo.find(item => item.FORMID === formInfo.cardId);
    if (!exposureInfo) {
      exposureInfo = new FormExposureParams();
      exposureInfo.PNAMEID = ReportParams.PACKAGE_NAME;
      exposureInfo.PVERSIONID = ReportParams.PROCESS_NAME;
      exposureInfo.BUNDLENAME = formInfo.bundleName;
      exposureInfo.ABILITYNAME = formInfo.abilityName;
      exposureInfo.MODULENAME = formInfo.moduleName;
      exposureInfo.FORMNAME = formInfo.cardName;
      exposureInfo.FORMID = formInfo.cardId;
      exposureInfo.FORMTYPE = FormCommonUtil.getFormType(formInfo.gameCardInfo);
      exposureInfo.PAGE = formInfo.page?.toString() ?? '';
      exposureInfo.SIZE = this.getFormCellSize(formInfo);
      exposureInfo.CELLX = formInfo.column ?? -1;
      exposureInfo.CELLY = formInfo.row ?? -1;
      exposureInfo.TOTALCOUNT = 0;
      exposureInfo.TOTALTIME = 0;
      exposureInfo.TIME = '[';
      this.exposureFormInfo.push(exposureInfo);
      this.exposureStartTime.set(formInfo.cardId, 0);
    } else {
      exposureInfo.PAGE = formInfo.page?.toString() ?? '';
      exposureInfo.CELLX = formInfo.column ?? -1;
      exposureInfo.CELLY = formInfo.row ?? -1;
    }
    let startTime: number = this.exposureStartTime.get(formInfo.cardId) ?? 0;
    if (!exposure && startTime !== 0) {
      if (++exposureInfo.TOTALCOUNT === FormReportConstants.EXPOSURE_MAX_TIME || isUnInstall) {
        exposureInfo.TIME = this.getExposureStartTime(exposureInfo.TIME, time, true, exposure);
        exposureInfo.TOTALTIME += time - startTime;
        log.showInfo(`TIME: ${exposureInfo.TIME}`);
        reporter.reportStatistic(FormHiSysEventUtil.FORM_EXPOSURE_DATA, exposureInfo);
        this.exposureFormInfo.splice(this.exposureFormInfo.indexOf(exposureInfo), 1);
        return;
      }
      exposureInfo.TIME = this.getExposureStartTime(exposureInfo.TIME, time, false, exposure);
      exposureInfo.TOTALTIME += time - startTime;
      this.exposureStartTime.set(formInfo.cardId, 0);
      log.showInfo(`TOTALTIME: ${exposureInfo.TOTALTIME}, TOTALCOUNT: ${exposureInfo.TOTALCOUNT}`);
    } else if (exposure && startTime === 0) {
      exposureInfo.TIME = this.getExposureStartTime(exposureInfo.TIME, time, false, exposure);
      this.exposureStartTime.set(formInfo.cardId, time);
    }
  }
}