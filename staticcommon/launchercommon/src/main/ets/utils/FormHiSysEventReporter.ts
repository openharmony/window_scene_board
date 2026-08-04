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
  HiSysReportEvent,
  ReportDomain,
  DeviceHelper,
  ReportParams,
  HiSysEventUtil
} from '@ohos/frameworkwrapper';

const reporter: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain.FORM_UE);

const enum DeviceType {
  PHONE,
  PAD,
  FOLD
}

export enum ShortcutMenuClickType {
  NO_CLICK = 0,
  FORM_MANAGER, // 更多服务卡片
  REMOVE,
  EDIT,
  ACTIVE_CARD_LOCK,
  CANCEL_CARD_LOCK,
}

export interface ClickCardEvent {
  bundleName: string;
  cellSize: string;
  dpSize: string;
  page: number;
  pageCount: number;
  formId: string;
  moduleName: string;
  formName: string;
  column: number;
  row: number;
  // infoType 卡片信息类型，0-普通卡片 1-语音助手母卡 2-语音助手子卡
  infoType: number;
  sourceType: string;
}

export interface ClickAddCardEvent {
  packageName: string;
  area: number[];
  dpSize: string;
  formId: string;
  moduleName: string;
  formName: string;
  page: number;
  addType: number;
  column: number;
  row: number;
  screenType: number;
  sourceType?: string;
  // 卡片类型，0-普通卡片 1-互动卡片-场景动效 2-互动卡片-趣味交互
  formType: number;
}

export interface ClickViewCardDetailEvent {
  packageName: string;
  area: number[];
  dpSize: string;
  formId: string;
  sourceType?: string;
}

export interface DragAddCardEvent {
  packageName: string;
  area: number[];
  dpSize: string;
  formId: string;
  moduleName: string;
  formName: string;
  page: number;
  addType: number;
  resultType: number;
  column: number;
  row: number;
  sourceType: string;
  // 卡片类型，0-普通卡片 1-互动卡片-场景动效 2-互动卡片-趣味交互
  formType: number;
}

export interface ClickCardShortcutMenuEvent {
  packageName: string;
  area: number[];
  dpSize: string;
  formId: string;
  moduleName: string;
  formName: string;
  menuType: number;
  // infoType 卡片信息类型，0-普通卡片 1-语音助手母卡 2-语音助手子卡
  infoType: number;
  sourceType: string;
  // 卡片类型，0-普通卡片 1-互动卡片-场景动效 2-互动卡片-趣味交互
  formType: number;
}

export interface RemoveCardEvent {
  packageName: string;
  area: number[];
  formId: string;
  moduleName: string;
  formName: string;
  position: string;
  resultType: number;
  sourceType: string;
  // 卡片类型，0-普通卡片 1-互动卡片-场景动效 2-互动卡片-趣味交互
  formType: number;
}

export interface MoveCardEvent {
  packageName: string;
  area: number[];
  moveFrom: string;
  moveTo: string;
  formId: string;
  moduleName: string;
  formName: string;
  sourceType: string;
}

export interface MoveCardToIntelligentEvent {
  packageName: string;
  area: number[];
  moveFrom: string;
  formId: string;
  moduleName: string;
  formName: string;
  sourceType: string;
}

export interface CardUpdateInMigrateEvent {
  originalType: string;
  prePackageName: string;
  preCellSize: string;
  preFormName: string;
  preFormId: string;
  preVersionCode: string;
  preCurrentPage: number;
  preCellX: number;
  preCellY: number;
  packageName: string;
  cellSize: string;
  formName: string;
  formId: string;
  currentPage?: number;
  cellX?: number;
  cellY?: number;
  originalPosition?: string;
}

export class OverflowCardBaseEvent {
  packageName: string = '';
  dpSize: string = '';
  cellSize: string = '';
  formId: string = '';
  moduleName: string = '';
  formName: string = '';
  extensionType: string = '';
  extensionName: string = '';
  subBundleName: string = '';
  timeInterval: number = 0;
}

export class BuildCardEvent {
  formId: string;
  bundleName: string;
  moduleName: string;
  formName: string;
  area: number[];
  position: string;
  sourceType: string;
  // 卡片类型，0-普通卡片 1-互动卡片-场景动效 2-互动卡片-趣味交互
  formType: number;
  // 卡片来源 0: 桌面卡片 1: 卡片中心
  location: number;
}

export class LaunchOverflowCardEvent extends OverflowCardBaseEvent {
  initDuration: number;
  loadDuration: number;
  reason: number;
}

export interface PauseOverflowCardEvent extends OverflowCardBaseEvent {}

export interface ResumeOverflowCardEvent extends OverflowCardBaseEvent {}

export interface DisconnectOverflowCardEvent extends OverflowCardBaseEvent {
  disconnectType: number;
  totalUse: number;
}

export interface PreventAddCardStackEvent {
  packageName: string;
  dpSize: string;
  cellSize: string;
  formId: string;
  moduleName: string;
  formName: string;
  preventType: number;
}

export interface DragFormToChangeSizeEvent {
  packageName: string;
  currentPage: number;
  formId: string;
  formName: string;
  dragResult: boolean;
  oldSize: string;
  newSize: string;
  oldRow: number;
  oldColumn: number;
  newRow: number;
  newColumn: number;
  isEditMode: boolean;
}

export interface AddCardToScreenByClickParams {
  PNAMEID: string;
  PVERSIONID: string;
  PACKAGENAME: string;
  CELLSIZE: string;
  DPSIZE: string;
  DEVICETYPE: number;
  ROTATIONMODE: number;
  FORMID: string;
  MODULENAME: string;
  FORMNAME: string;
  SCREENID: string;
  ADDTYPE: number;
  CELLX: number;
  CELLY: number;
  SCREENTYPE: number;
  VERSIONCODE: string;
  SOURCETYPE: string;
  SCREEN_TYPE: number;
  FORMTYPE: number;
}

export interface ViewCardDetailToThemeByClickParams {
  PNAMEID: string;
  PVERSIONID: string;
  PACKAGENAME: string;
  CELLSIZE: string;
  DPSIZE: string;
  DEVICETYPE: number;
  ROTATIONMODE: number;
  FORMID: string;
  VERSIONCODE: string;
  SCREEN_TYPE: number;
}

export interface AddCardToScreenByDragParams {
  PNAMEID: string;
  PVERSIONID: string;
  PACKAGENAME: string;
  CELLSIZE: string;
  DPSIZE: string;
  DEVICETYPE: number;
  ROTATIONMODE: number;
  FORMID: string;
  MODULENAME: string;
  FORMNAME: string;
  SCREENID: string;
  ADDTYPE: number;
  RESULTTYPE: number;
  CELLX: number;
  CELLY: number;
  VERSIONCODE: string;
  SOURCETYPE: string;
  SCREEN_TYPE: number;
  FORMTYPE: number;
}

export interface GoIntoCardShortcutMenuParams {
  PNAMEID: string;
  PVERSIONID: string;
  PACKAGENAME: string;
  CELLSIZE: string;
  DPSIZE: string;
  DEVICETYPE: number;
  ROTATIONMODE: number;
  FORMID: string;
  MODULENAME: string;
  FORMNAME: string;
  MENUTYPE: number;
  INFOTYPE: number;
  VERSIONCODE: string;
  SOURCETYPE: string;
  SCREEN_TYPE: number;
  FORMTYPE: number;
}

export interface ClickCardParams {
  PNAMEID: string;
  PVERSIONID: string;
  PACKAGENAME: string;
  CELLSIZE: string;
  DPSIZE: string;
  DEVICETYPE: number;
  ROTATIONMODE: number;
  CURRENTPAGE: number;
  TOTALPAGE: number;
  FORMID: string;
  MODULENAME: string;
  FORMNAME: string;
  CELLX: number;
  CELLY: number;
  INFOTYPE: number;
  VERSIONCODE: string;
  SOURCETYPE: string;
  SCREEN_TYPE: number;
}

export interface RemoveCardParams {
  PNAMEID: string;
  PVERSIONID: string;
  ABILITYFORM: string;
  SIZE: string;
  FORMID: string;
  MODULENAME: string;
  FORMNAME: string;
  POSITION: string;
  RESULTTYPE: number;
  VERSIONCODE: string;
  SOURCETYPE: string;
  SCREEN_TYPE: number;
  FORMTYPE: number;
}

export interface MoveCardParams {
  PNAMEID: string;
  PVERSIONID: string;
  ABILITYFORM: string;
  CELLSIZE: string;
  MOVEFROM: string;
  MOVETO: string;
  FORMID: string;
  MODULENAME: string;
  FORMNAME: string;
  VERSIONCODE?: string;
  SOURCETYPE: string;
  SCREEN_TYPE: number;
}

export interface MoveCardToIntelligentParams {
  PNAMEID: string;
  PVERSIONID: string;
  ABILITYFORM: string;
  CELLSIZE: string;
  MOVEFROM: string;
  FORMID: string;
  MODULENAME: string;
  FORMNAME: string;
  VERSIONCODE?: string;
  SOURCETYPE: string;
}

export interface CardUpdateInMigrateParams {
  PNAMEID: string;
  PVERSIONID: string;
  ORIGINALTYPE: string;
  PREPACKAGENAME: string;
  PACKAGENAME: string;
  PRECELLSIZE: string;
  CELLSIZE: string;
  PREFORMNAME: string;
  FORMNAME: string;
  PREFORMID: string;
  FORMID: string;
  PREVERSIONCODE: string;
  VERSIONCODE: string;
  PRECURRENTPAGE: number;
  CURRENTPAGE: number;
  PRECELLX: number;
  CELLX: number;
  PRECELLY: number;
  CELLY: number;
  ORIGINALPOSITION?: string;
}

export class OverflowCardBaseParams {
  PNAMEID: string = '';
  PVERSIONID: string = '';
  PACKAGENAME: string = '';
  CELLSIZE: string = '';
  DPSIZE: string = '';
  DEVICETYPE: number = 0;
  ROTATIONMODE: number = 0;
  FORMID: string = '';
  MODULENAME: string = '';
  FORMNAME: string = '';
  EXTENSIONTYPE: string = '';
  EXTENSIONNAME: string = '';
  SUBBUNDLENAME: string = '';
  VERSIONCODE: string = '';
  TIMEINTERVAL: number = 0;
}

export class BuildCardBaseParams {
  PNAMEID: string;
  PVERSIONID: string;
  FORMID: string;
  BUNDLENAME: string;
  MODULENAME: string;
  FORMNAME: string;
  SIZE: string;
  POSITION: string;
  SOURCETYPE: string;
  FORMTYPE: number;
  FORMLOCATION: number;
}

export class LaunchOverflowCardParams extends OverflowCardBaseParams {
  INITDURATION: number;
  LOADDURATION: number;
  REASON: number;
}

export interface PauseOverflowCardParams extends OverflowCardBaseParams {}

export interface ResumeOverflowCardParams extends OverflowCardBaseParams {}

export interface DisconnectOverflowCardParams extends OverflowCardBaseParams {
  DISCONNECTTYPE: number;
  TOTALUSE: number;
}

export interface PreventAddCardStackParams {
  PNAMEID: string;
  PVERSIONID: string;
  PACKAGENAME: string;
  CELLSIZE: string;
  DPSIZE: string;
  DEVICETYPE: number;
  ROTATIONMODE: number;
  FORMID: string;
  MODULENAME: string;
  FORMNAME: string;
  VERSIONCODE: string;
  PREVENTTYPE: number;
}

export interface DragFormToChangeSizeParams {
  PNAMEID: string;
  PVERSIONID: string;
  PACKAGENAME: string;
  CURRENTPAGE: number;
  FORMID: string;
  FORMNAME: string;
  DRAGRESULT: boolean;
  OLDSIZE: string;
  NEWSIZE: string;
  OLDROW: number;
  OLDCOLUMN: number;
  NEWROW: number;
  NEWCOLUMN: number;
  ISEDITMODE: boolean;
}

export enum RemoveCardResultType {
  REMOVE,
  CANCEL,
}

/**
 * Form UE Event Reporter.
 */
export class FormHiSysEventReporter {
  // 系统迁移卡片替换
  public static readonly CARD_MIGRATE_IN_UPGRADE = 'CARD_MIGRATE_IN_UPGRADE';

  // 点击新增卡片进屏幕
  public static readonly ADD_CARD_TO_DESKTOP_BY_CLICK = 'ADD_CARD_TO_DESKTOP_BY_CLICK_UE';

  // 点击查看详情到主题半模态
  public static readonly VIEW_CARD_DETAIL_TO_THEME_BY_CLICK_UE = 'VIEW_CARD_TO_THEME_BY_CLICK_UE';

  // 拖拽新增卡片进屏幕
  public static readonly ADD_CARD_TO_DESKTOP_BY_DRAG = 'ADD_CARD_TO_DESKTOP_BY_DRAG_UE';

  // 长按卡片进入快捷菜单
  public static readonly GO_INTO_CARD_SHORTCUT_MENU = 'GO_INTO_CARD_SHORTCUT_MENU_UE';

  // 点击卡片打点
  public static readonly CLICK_CARD = 'CLICK_CARD_UE';

  // 点击移除FA卡片
  public static readonly REMOVE_CARD = 'REMOVE_CARD_UE';

  // 移动卡片
  public static readonly MOVE_CARD = 'MOVE_CARD_UE';

  // 移动卡片至负一屏
  public static readonly MOVE_CARD_TO_INTELLIGENT = 'MOVE_CARD_TO_INTELLIGENT';

  // 服务卡片_互动卡片_启动
  public static readonly LAUNCH_OVERFLOW_CARD = 'CONN_EXTENSION';

  // 服务卡片_互动卡片_暂停
  public static readonly PAUSE_OVERFLOW_CARD = 'PAUSE_EXTENSION';

  // 服务卡片_互动卡片_恢复
  public static readonly RESUME_OVERFLOW_CARD = 'RESUME_EXTENSION';

  // 服务卡片_互动卡片_销毁
  public static readonly DISCONNECT_OVERFLOW_CARD = 'DISCONN_EXTENSION';

  // 服务卡片_堆叠卡片_禁止堆叠
  public static readonly PREVENT_ADD_CARD_STACK = 'PREVENT_ADD_CARD_TO_STACK';

  // 服务卡片_基础功能_拖动卡片调整大小
  public static readonly DRAG_FORM_TO_CHANGE_SIZE = 'DRAG_FORM_TO_CHANGE_SIZE';

  // 服务卡片创建成功
  public static readonly BUILD_CARD_SUCCESS = 'BUILD_CARD_SUCCESS';

  /**
   * 点击新增卡片到桌面
   */
  public static reportAddCardToScreenByClick(event: ClickAddCardEvent): void {
    let params: AddCardToScreenByClickParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: event.packageName,
      CELLSIZE: event.area[0] + '*' + event.area[1],
      DPSIZE: event.dpSize,
      DEVICETYPE: FormHiSysEventReporter.getDeviceType(),
      ROTATIONMODE: HiSysEventUtil.getRotationMode(),
      FORMID: event.formId,
      MODULENAME: event.moduleName,
      FORMNAME: event.formName,
      SCREENID: event.page.toString(),
      ADDTYPE: event.addType,
      CELLX: event.row,
      CELLY: event.column,
      SCREENTYPE: event.screenType,
      VERSIONCODE: HiSysEventUtil.getVersionName(event.packageName),
      SOURCETYPE: event.sourceType ?? '',
      SCREEN_TYPE: HiSysEventUtil.screenType,
      FORMTYPE: event.formType,
    };
    reporter.reportBehavior(FormHiSysEventReporter.ADD_CARD_TO_DESKTOP_BY_CLICK, params);
  }

  /**
   * 点击查看详情到主题
   */
  public static reportViewCardDetailToThemeByClick(event: ClickViewCardDetailEvent): void {
    let params: ViewCardDetailToThemeByClickParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: event.packageName,
      CELLSIZE: event.area[0] + '*' + event.area[1],
      DPSIZE: event.dpSize,
      DEVICETYPE: FormHiSysEventReporter.getDeviceType(),
      ROTATIONMODE: HiSysEventUtil.getRotationMode(),
      FORMID: event.formId,
      VERSIONCODE: HiSysEventUtil.getVersionName(event.packageName),
      SCREEN_TYPE: HiSysEventUtil.screenType,
    };
    reporter.reportBehavior(FormHiSysEventReporter.VIEW_CARD_DETAIL_TO_THEME_BY_CLICK_UE, params);
  }

  /**
   * 拖拽新增卡片到桌面
   */
  public static reportAddCardToScreenByDrag(event: DragAddCardEvent): void {
    let params : AddCardToScreenByDragParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: event.packageName,
      CELLSIZE: event.area[0] + '*' + event.area[1],
      DPSIZE: event.dpSize,
      DEVICETYPE: FormHiSysEventReporter.getDeviceType(),
      ROTATIONMODE: HiSysEventUtil.getRotationMode(),
      FORMID: event.formId,
      MODULENAME: event.moduleName,
      FORMNAME: event.formName,
      SCREENID: event.page.toString(),
      ADDTYPE: event.addType,
      RESULTTYPE: event.resultType,
      CELLX: event.row,
      CELLY: event.column,
      VERSIONCODE: HiSysEventUtil.getVersionName(event.packageName),
      SOURCETYPE: event.sourceType,
      SCREEN_TYPE: HiSysEventUtil.screenType,
      FORMTYPE: event.formType,
    };
    reporter.reportBehavior(FormHiSysEventReporter.ADD_CARD_TO_DESKTOP_BY_DRAG, params);
  }

  /**
   * 进入卡片快捷菜单
   */
  public static reportGoIntoCardShortcutMenu(event: ClickCardShortcutMenuEvent): void {
    let params : GoIntoCardShortcutMenuParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: event.packageName,
      CELLSIZE: event.area[0] + '*' + event.area[1],
      DPSIZE: event.dpSize,
      DEVICETYPE: FormHiSysEventReporter.getDeviceType(),
      ROTATIONMODE: HiSysEventUtil.getRotationMode(),
      FORMID: event.formId,
      MODULENAME: event.moduleName,
      FORMNAME: event.formName,
      MENUTYPE: event.menuType,
      INFOTYPE: event.infoType,
      VERSIONCODE: HiSysEventUtil.getVersionName(event.packageName),
      SOURCETYPE: event.sourceType,
      SCREEN_TYPE: HiSysEventUtil.screenType,
      FORMTYPE: event.formType,
    };
    reporter.reportBehavior(FormHiSysEventReporter.GO_INTO_CARD_SHORTCUT_MENU, params);
  }

  /**
   * 点击卡片
   */
  public static reportClickCard(event: ClickCardEvent): void {
    let params: ClickCardParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: event.bundleName,
      CELLSIZE: event.cellSize,
      DPSIZE: event.dpSize,
      DEVICETYPE: FormHiSysEventReporter.getDeviceType(),
      ROTATIONMODE: HiSysEventUtil.getRotationMode(),
      CURRENTPAGE: event.page,
      TOTALPAGE: event.pageCount,
      FORMID: event.formId,
      MODULENAME: event.moduleName,
      FORMNAME: event.formName,
      CELLX: event.column,
      CELLY: event.row,
      INFOTYPE: event.infoType,
      VERSIONCODE: HiSysEventUtil.getVersionName(event.bundleName),
      SOURCETYPE: event.sourceType,
      SCREEN_TYPE: HiSysEventUtil.screenType,
    };
    reporter.reportBehavior(FormHiSysEventReporter.CLICK_CARD, params);
  }

  /**
   * 点击移除FA卡片
   */
  public static reportRemoveCard(event: RemoveCardEvent): void {
    let params: RemoveCardParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ABILITYFORM: event.packageName,
      SIZE: event.area[0] + '*' + event.area[1],
      FORMID: event.formId,
      MODULENAME: event.moduleName,
      FORMNAME: event.formName,
      POSITION: event.position,
      RESULTTYPE: event.resultType,
      VERSIONCODE: HiSysEventUtil.getVersionName(event.packageName),
      SOURCETYPE: event.sourceType,
      SCREEN_TYPE: HiSysEventUtil.screenType,
      FORMTYPE: event.formType,
    };
    reporter.reportBehavior(FormHiSysEventReporter.REMOVE_CARD, params);
  }

  /**
   * 移动卡片
   */
  public static reportMoveCard(event: MoveCardEvent): void {
    let params : MoveCardParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ABILITYFORM: event.packageName,
      CELLSIZE: event.area[0] + '*' + event.area[1],
      MOVEFROM: event.moveFrom,
      MOVETO: event.moveTo,
      FORMID: event.formId,
      MODULENAME: event.moduleName,
      FORMNAME: event.formName,
      VERSIONCODE: HiSysEventUtil.getVersionName(event.packageName),
      SOURCETYPE: event.sourceType,
      SCREEN_TYPE: HiSysEventUtil.screenType,
    };
    reporter.reportBehavior(FormHiSysEventReporter.MOVE_CARD, params);
  }

  // 移动卡片至负一屏
  public static reportMoveCardToIntelligent(event: MoveCardToIntelligentEvent): void {
    let params : MoveCardToIntelligentParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ABILITYFORM: event.packageName,
      CELLSIZE: event.area[0] + '*' + event.area[1],
      MOVEFROM: event.moveFrom,
      FORMID: event.formId,
      MODULENAME: event.moduleName,
      FORMNAME: event.formName,
      VERSIONCODE: HiSysEventUtil.getVersionName(event.packageName),
      SOURCETYPE: event.sourceType,
    };
    reporter.reportBehavior(FormHiSysEventReporter.MOVE_CARD_TO_INTELLIGENT, params);
  }

  /**
   * 系统迁移卡片替换
   */
  public static reportCardUpdateInMigrate(event: CardUpdateInMigrateEvent): void {
    let params : CardUpdateInMigrateParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ORIGINALTYPE: event.originalType,
      PREPACKAGENAME: event.prePackageName,
      PACKAGENAME: event.packageName,
      PRECELLSIZE: event.preCellSize,
      CELLSIZE: event.cellSize,
      PREFORMNAME: event.preFormName,
      FORMNAME: event.formName,
      PREFORMID: event.preFormId,
      FORMID: event.formId,
      PREVERSIONCODE: event.preVersionCode,
      VERSIONCODE: HiSysEventUtil.getVersionName(event.packageName),
      PRECURRENTPAGE: event.preCurrentPage,
      CURRENTPAGE: event.currentPage ?? -1,
      PRECELLX: event.preCellX,
      CELLX: event.cellX ?? 0,
      PRECELLY: event.preCellY,
      CELLY: event.cellY ?? 0,
      ORIGINALPOSITION: event.originalPosition,
    };
    reporter.reportBehavior(FormHiSysEventReporter.CARD_MIGRATE_IN_UPGRADE, params);
  }

  /**
   * 服务卡片_互动卡片_启动
   */
  public static reportLaunchOverflowCard(event: LaunchOverflowCardEvent): void {
    let params: LaunchOverflowCardParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: event.packageName,
      CELLSIZE: event.cellSize,
      DPSIZE: event.dpSize,
      DEVICETYPE: FormHiSysEventReporter.getDeviceType(),
      ROTATIONMODE: HiSysEventUtil.getRotationMode(),
      FORMID: event.formId,
      MODULENAME: event.moduleName,
      FORMNAME: event.formName,
      EXTENSIONTYPE: event.extensionType,
      EXTENSIONNAME: event.extensionName,
      SUBBUNDLENAME: event.subBundleName,
      VERSIONCODE: HiSysEventUtil.getVersionName(event.packageName),
      TIMEINTERVAL: event.timeInterval,
      INITDURATION: event.initDuration,
      LOADDURATION: event.loadDuration,
      REASON: event.reason,
    };
    reporter.reportBehavior(FormHiSysEventReporter.LAUNCH_OVERFLOW_CARD, params);
  }

  /**
   * 服务卡片_互动卡片_暂停
   */
  public static reportPauseOverflowCard(event: PauseOverflowCardEvent): void {
    let params: PauseOverflowCardParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: event.packageName,
      CELLSIZE: event.cellSize,
      DPSIZE: event.dpSize,
      DEVICETYPE: FormHiSysEventReporter.getDeviceType(),
      ROTATIONMODE: HiSysEventUtil.getRotationMode(),
      FORMID: event.formId,
      MODULENAME: event.moduleName,
      FORMNAME: event.formName,
      EXTENSIONTYPE: event.extensionType,
      EXTENSIONNAME: event.extensionName,
      SUBBUNDLENAME: event.subBundleName,
      VERSIONCODE: HiSysEventUtil.getVersionName(event.packageName),
      TIMEINTERVAL: event.timeInterval,
    };
    reporter.reportBehavior(FormHiSysEventReporter.PAUSE_OVERFLOW_CARD, params);
  }

  /**
   * 服务卡片_互动卡片_恢复
   */
  public static reportResumeOverflowCard(event: ResumeOverflowCardEvent): void {
    let params: ResumeOverflowCardParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: event.packageName,
      CELLSIZE: event.cellSize,
      DPSIZE: event.dpSize,
      DEVICETYPE: FormHiSysEventReporter.getDeviceType(),
      ROTATIONMODE: HiSysEventUtil.getRotationMode(),
      FORMID: event.formId,
      MODULENAME: event.moduleName,
      FORMNAME: event.formName,
      EXTENSIONTYPE: event.extensionType,
      EXTENSIONNAME: event.extensionName,
      SUBBUNDLENAME: event.subBundleName,
      VERSIONCODE: HiSysEventUtil.getVersionName(event.packageName),
      TIMEINTERVAL: event.timeInterval,
    };
    reporter.reportBehavior(FormHiSysEventReporter.RESUME_OVERFLOW_CARD, params);
  }

  /**
   * 服务卡片_互动卡片_销毁
   */
  public static reportDisconnectOverflowCard(event: DisconnectOverflowCardEvent): void {
    let params: DisconnectOverflowCardParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: event.packageName,
      CELLSIZE: event.cellSize,
      DPSIZE: event.dpSize,
      DEVICETYPE: FormHiSysEventReporter.getDeviceType(),
      ROTATIONMODE: HiSysEventUtil.getRotationMode(),
      FORMID: event.formId,
      MODULENAME: event.moduleName,
      FORMNAME: event.formName,
      EXTENSIONTYPE: event.extensionType,
      EXTENSIONNAME: event.extensionName,
      SUBBUNDLENAME: event.subBundleName,
      VERSIONCODE: HiSysEventUtil.getVersionName(event.packageName),
      DISCONNECTTYPE: event.disconnectType,
      TIMEINTERVAL: event.timeInterval,
      TOTALUSE: event.totalUse,
    };
    reporter.reportBehavior(FormHiSysEventReporter.DISCONNECT_OVERFLOW_CARD, params);
  }

  /**
   * 服务卡片_堆叠卡片_禁止堆叠
   */
  public static reportPreventAddCardStack(event: PreventAddCardStackEvent): void {
    let params: PreventAddCardStackParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: event.packageName,
      CELLSIZE: event.cellSize,
      DPSIZE: event.dpSize,
      DEVICETYPE: FormHiSysEventReporter.getDeviceType(),
      ROTATIONMODE: HiSysEventUtil.getRotationMode(),
      FORMID: event.formId,
      MODULENAME: event.moduleName,
      FORMNAME: event.formName,
      VERSIONCODE: HiSysEventUtil.getVersionName(event.packageName),
      PREVENTTYPE: event.preventType,
    };
    reporter.reportBehavior(FormHiSysEventReporter.PREVENT_ADD_CARD_STACK, params);
  }

  public static reportDragFormToChangeSize(event: DragFormToChangeSizeEvent): void {
    let params: DragFormToChangeSizeParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: event.packageName,
      CURRENTPAGE: event.currentPage,
      FORMID: event.formId,
      FORMNAME: event.formName,
      DRAGRESULT: event.dragResult,
      OLDSIZE: event.oldSize,
      NEWSIZE: event.newSize,
      OLDROW: event.oldRow,
      OLDCOLUMN: event.oldColumn,
      NEWROW: event.newRow,
      NEWCOLUMN: event.newColumn,
      ISEDITMODE: event.isEditMode,
    };
    reporter.reportBehavior(FormHiSysEventReporter.DRAG_FORM_TO_CHANGE_SIZE, params);
  }

  /**
   * 桌面成功创建卡片
   */
  public static reportBuildCardSuccess(event: BuildCardEvent): void {
    let params: BuildCardBaseParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      FORMID: event.formId,
      BUNDLENAME: event.bundleName,
      MODULENAME: event.moduleName,
      FORMNAME: event.formName,
      SIZE: `${event.area[0]} * ${event.area[1]}`,
      POSITION: event.position,
      SOURCETYPE: event.sourceType,
      FORMTYPE: event.formType,
      FORMLOCATION: event.location,
    };
    reporter.reportBehavior(FormHiSysEventReporter.BUILD_CARD_SUCCESS, params);
  }

  public static getDeviceType(): number {
    let deviceType: number = -1;
    if (DeviceHelper.isFoldButNotSmallFoldProduct()) {
      deviceType = DeviceType.FOLD;
    } else if (DeviceHelper.isPhone()) {
      deviceType = DeviceType.PHONE;
    } else if (DeviceHelper.isPad()) {
      deviceType = DeviceType.PAD;
    } else {
      /* do nothing */
    }
    return deviceType;
  }
}