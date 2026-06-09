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
import { HiSysReportEvent, ReportDomain, ReportParams } from '@ohos/frameworkwrapper';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import osAccount from '@ohos.account.osAccount';
import { DomainName, TraceUtil } from '@ohos/basicutils';

const TAG: string = 'Common-PerformanceMonitorUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class Constants {
  static FINGERPRINT_UNLOCK_ANI: string = 'FINGERPRINT_UNLOCK_ANI';
  static FACIAL_UNLOCK_ANI: string = 'FACIAL_UNLOCK_ANI';
  static PASSWORD_UNLOCK_ANI: string = 'PASSWORD_UNLOCK_ANI';
  static FACIAL_FLING_UNLOCK_ANI: string = 'FACIAL_FLING_UNLOCK_ANI';
  static INTO_HOME_ANI: string = 'INTO_HOME_ANI';
  static SCREEN_OFF_FINGERPRINT_UNLOCK_ANI: string = 'SCREEN_OFF_FINGERPRINT_UNLOCK_ANI';
  static SCREENLOCK_SCREEN_OFF_ANIM: string = 'SCREENLOCK_SCREEN_OFF_ANIM';
  public static SCREENLOCK_INTO_EDITOR_ANIM: string = 'SCREENLOCK_INTO_EDITOR_ANIM';
  public static SCREENLOCK_EXIT_EDITOR_ANIM: string = 'SCREENLOCK_EXIT_EDITOR_ANIM';
  static SCREENLOCK_SCREEN_INTO_PIN: string = 'SCREENLOCK_SCREEN_INTO_PIN';
  // 锁屏编辑事件名
  static EDIT_CLOCK_LAYOUT_TOGGLE: string = 'EDIT_CLOCK_LAYOUT_TOGGLE';
  static SCREEN_LOCK_EDIT_DRAG_CLOCK: string = 'SCREEN_LOCK_EDIT_DRAG_CLOCK';
  static SCREEN_LOCK_EDIT_APPLY: string = 'SCREEN_LOCK_EDIT_APPLY';
  static SCREEN_LOCK_EDIT_CANCEL: string = 'SCREEN_LOCK_EDIT_CANCEL';
  static SCREEN_LOCK_EDIT_CARD_ADD: string = 'SCREEN_LOCK_EDIT_CARD_ADD';
  static SCREEN_LOCK_EDIT_CARD_REMOVE: string = 'SCREEN_LOCK_EDIT_CARD_REMOVE';
  static SCREEN_LOCK_EDIT_CLEAR_LOOK: string = 'SCREEN_LOCK_EDIT_CLEAR_LOOK';
  static SCREEN_LOCK_TWO_FINGER_PINCH: string = 'SCREEN_LOCK_TWO_FINGER_PINCH';
  static SCREEN_LOCK_EDIT_SIGN_INPUT_OK: string = 'SCREEN_LOCK_EDIT_SIGN_INPUT_OK';
  static SCREEN_LOCK_EDIT_MORE_CARD: string = 'SCREEN_LOCK_EDIT_MORE_CARD';
  static SCREEN_LOCK_EDIT_MORE_CARD_ADD: string = 'SCREEN_LOCK_EDIT_MORE_CARD_ADD';
  static SCREEN_LOCK_EDIT_TIME_CLICK: string = 'SCREEN_LOCK_EDIT_TIME_CLICK';
  static SCREEN_LOCK_EDIT_SERVICE_WIDGETS: string = 'SCREEN_LOCK_EDIT_SERVICE_WIDGETS';
  public static SCREEN_LOCK_EDIT_SIGN_EMPTY: string = 'SCREEN_LOCK_EDIT_SIGN_EMPTY';
  public static SCREEN_LOCK_STATE_WEEKLY_UPLOAD: string = 'SCREEN_LOCK_STATE_WEEKLY_UPLOAD';
  public static SCREEN_LOCK_EDIT_SIGN_INPUT: string = 'SCREEN_LOCK_EDIT_SIGN_INPUT';
  public static SCREEN_LOCK_EMPTY_STRING: string = '';
  public static SCREEN_LOCK_INTO_EMERGENCY_MODE: string = 'SCREEN_LOCK_INTO_EMERGENCY_MODE';
  public static SCREEN_LOCK_INTO_SLIDE: string = 'SCREEN_LOCK_INTO_SLIDE';
  public static SCREEN_LOCK_JUMP_APP: string = 'SCREEN_LOCK_JUMP_APP';
  public static SCREEN_LOCK_SCRIPT_THEME: string = 'SCREEN_LOCK_SCRIPT_THEME';
  //艺术签名事件名
  public static AIGC_IDENTIFY_FONT_BLOCK: string = 'AIGC_IDENTIFY_FONT_BLOCK';
  public static APPLY_AIGC_NEW_FONT: string = 'APPLY_AIGC_NEW_FONT';
  public static AIGC_NEW_FONT_CANCEL: string = 'AIGC_NEW_FONT_CANCEL';
  public static CLICK_AIGC_FONT_BLOCK: string = 'CLICK_AIGC_FONT_BLOCK';
  public static CLICK_POSTER_AIGC_BUTTON: string = 'CLICK_POSTER_AIGC_BUTTON';
  public static CLICK_POSTER_TEXT_APPLY: string = 'CLICK_POSTER_TEXT_APPLY';
  public static CLICK_POSTER_THEME_APPLY: string = 'CLICK_POSTER_THEME_APPLY';
  public static CLICK_TRY_COMPOUND: string = 'CLICK_TRY_COMPOUND';
  public static EDIT_POSTER_LAYOUT_TOGGLE: string = 'EDIT_POSTER_LAYOUT_TOGGLE';
  public static EDIT_POSTER_FONT_TOGGLE: string = 'EDIT_POSTER_FONT_TOGGLE';
  public static EDIT_POSTER_COLOR_TOGGLE: string = 'EDIT_POSTER_COLOR_TOGGLE';
  public static EDIT_POSTER_STYLE_TOGGLE: string = 'EDIT_POSTER_STYLE_TOGGLE';
  public static EDIT_CLOCK_POSTER_TAB_TOGGLE: string = 'EDIT_CLOCK_POSTER_TAB_TOGGLE';
  public static GENERATE_AIGC_NEW_FONT: string = 'GENERATE_AIGC_NEW_FONT';
  public static POSTER_LAYOUT_DRAG: string = 'POSTER_LAYOUT_DRAG';
  public static POSTER_PRIVACE_STATEMENT_CONFIRM: string = 'POSTER_PRIVACE_STATEMENT_CONFIRM';
  public static DELETE_AIGC_FONT: string = 'DELETE_AIGC_FONT';
  public static CLICK_ART_TIP_HIDDEN: string = 'CLICK_ART_TIP_HIDDEN';

  // 皮套操作事件名
  /**
   * 锁屏皮套合上
   * 事件id: 990220170
   */
  public static SCREEN_LOCK_COVER_ADD: string = 'SCREEN_LOCK_COVER_ADD';
  /**
   * 锁屏皮套移除
   * 事件id: 990220171
   */
  public static SCREEN_LOCK_COVER_REMOVE: string = 'SCREEN_LOCK_COVER_REMOVE';
  /**
   * 亮屏查看锁屏皮套时间
   * 事件id: 990220146
   */
  public static SCREEN_LOCK_COVER_TIME: string = 'SCREEN_LOCK_COVER_TIME';
  /**
   * 电源事件变化
   */
  public static SCREEN_LOCK_POWER_STATE_CHANGE: string = 'SCREEN_LOCK_POWER_STATE_CHANGE';
  /**
   * 壁纸变化
   */
  public static SCREEN_LOCK_WALLPAPER_CHANGE: string = 'SCREEN_LOCK_WALLPAPER_CHANGE';
  /**
   * 不播一镜到底原因
   */
  public static SCREEN_LOCK_NO_MIRROR_REASON: string = 'SCREEN_LOCK_NO_MIRROR_REASON';
}

const hiSysEventTypes: Map< osAccount.AuthType, string> = new Map([
  [osAccount.AuthType.FINGERPRINT, Constants.FINGERPRINT_UNLOCK_ANI],
  [osAccount.AuthType.FACE, Constants.FACIAL_UNLOCK_ANI],
  [osAccount.AuthType.PIN, Constants.PASSWORD_UNLOCK_ANI],
]);

export interface BaseParams {
  NAME: string;
  CODE: number;
}

interface TimeoutParam {
  NAME: string;
  TIME_OUT: number;
}

interface TimeoutScene {
  PSD_AUTH: TimeoutParam,
  OSACCOUNT_CANCEL: TimeoutParam,
  UNLOCK_FROM_BOUNCER_ANI: TimeoutParam,
  UNLOCK_FROM_MAIN_ANI: TimeoutParam,
  UNLOCK_ONE_SHOT_ANI: TimeoutParam,
}

export interface TimePosition {
  positionX: number;
  positionY: number;
}

/**
 * screen lock hiDfxEvent上报基类
 */
export class HiKGReportBase {
  /*
   * 故障点位
   */
  private static readonly FAULT: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain.SCENE_BOARD_APP);

  /*
   * 行为点位
   */
  private static readonly UE: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain.SCREENLOCK_UE);

  /*
   * 定位日志
   */
  private static logReport(type: string, name: string, params?: Object): void {
    log.showWarn(`HiKGReport: type: ${type} --- name: ${name} --- params: ${JSON.stringify(params)}`);
  }

  /*
   * 故障打点
   */
  public static reportFault(name: string, params?: Object): void {
    Promise.resolve().then(() => {
      HiKGReportBase.FAULT.reportFault(name, params);
      HiKGReportBase.logReport('FAULT', name, params);
    });
  }

  /*
   * 行为打点
   */
  public static reportUe(name: string, params?: Object): void {
    Promise.resolve().then(() => {
      HiKGReportBase.UE.reportBehavior(name, params);
      HiKGReportBase.logReport('UE', name, params);
    });
  }
}

export class HiKGReportTimeout {
  private readonly timeoutIds: Map<string, number> = new Map();
  private static instance: HiKGReportTimeout;

  public static getInstance(): HiKGReportTimeout {
    if (!HiKGReportTimeout.instance) {
      HiKGReportTimeout.instance = new HiKGReportTimeout();
    }
    return HiKGReportTimeout.instance;
  }

  /**
   * 监听开始
   * 超时默认值为1s
   */
  public logTimeout(scene: string, delay: number = 1000): void {
    if (this.timeoutIds.has(scene)) {
      log.showWarn(`HiKGReportTimeout logTimeout: ${scene} has been regist`);
      return;
    }
    let timeoutId: number = setTimeout(() => {
      log.showError(`Keyguard Timeout Error: ${scene} and ${delay}`);
      HiKGReportBase.reportFault(DfxFaultEventTag.KG_TIMEOUT, Object({ NAME: scene }));
      this.timeoutIds.delete(scene);
    }, delay);
    this.timeoutIds.set(scene, timeoutId);
  }

  /**
   * 监听结束
   */
  public rollbackTimeout(scene: string): void {
    if (this.timeoutIds.has(scene)) {
      clearTimeout(this.timeoutIds.get(scene));
      this.timeoutIds.delete(scene);
    }
  }
}

/**
 * screen lock hiDfxEvent 故障点位
 */
export enum DfxFaultEventTag {
  PASSWORD_UNLOCK_FAILED = 'PASSWORD_UNLOCK_FAILED',
  FINGERPRINT_UNLOCK_FAILED = 'FINGERPRINT_UNLOCK_FAILED',
  FACE_UNLOCK_FAILED = 'FACE_UNLOCK_FAILED',
  ACCOUNT_INTERFACE_ABNORMAL = 'ACCOUNT_INTERFACE_ABNORMAL',
  SCREEN_LOCK_MGR_ERROR = 'SCREEN_LOCK_MGR_ERROR',
  KG_TIMEOUT = 'KG_TIMEOUT',
  FINISH_CALLBACK_TIMEOUT = 'FINISH_CALLBACK_TIMEOUT',
}

export const TIMEOUT_PARAMS: TimeoutScene = {
  PSD_AUTH: { NAME: 'PSD_AUTH', TIME_OUT: 500 },
  OSACCOUNT_CANCEL: { NAME: 'OSACCOUNT_CANCEL', TIME_OUT: 100 },
  UNLOCK_FROM_BOUNCER_ANI: { NAME: 'UNLOCK_FROM_BOUNCER_ANI', TIME_OUT: 1100 },
  UNLOCK_FROM_MAIN_ANI: { NAME: 'UNLOCK_FROM_MAIN_ANI', TIME_OUT: 1100 },
  UNLOCK_ONE_SHOT_ANI: { NAME: 'UNLOCK_ONE_SHOT_ANI', TIME_OUT: 1100 },
};

export default class PerformanceMonitorUtil {
  public static COLOR: string = 'color';
  public static FONT: string = 'font';
  public static LAYOUT: string = 'layout';
  public static SIGN: string = 'sign';
  public static SIGN_INPUT: string = 'SignInput';
  public static CLOCK: string = 'clock';
  public static EDIT_CLEAR_TYPE_CARD: string = 'card';
  public static EDIT_CLEAR_TYPE_CARD_NUM: string = '2';
  public static SHOW_CLICK_TYPE_CLOCK_NUM: string = '1';
  public static EDIT_SIGN_INPUT_CANCEL: string = 'cancel';
  public static EDIT_SIGN_INPUT_OK: string = 'ok';
  public static EDIT_INDEX_STATUS: string = '-100';

  private static readonly SCREENLOCK_UE: HiSysReportEvent =
    HiSysReportEvent.getHiSysReportEvent(ReportDomain.SCREENLOCK_UE);

  /**
   * 打点
   *
   * @param name 事件名称
   * @param params 事件参数
   */
  static reportBehaviorEvent(name: string, params: LockscreenEditStatusParams | LockscreenEditPosterParams): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    PerformanceMonitorUtil.SCREENLOCK_UE.reportBehavior(name, params);
  }

  static reportStatisticEvent(name: string, params: LockscreenEditStatusParams): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    PerformanceMonitorUtil.SCREENLOCK_UE.reportStatistic(name, params);
  }
  /**
   * 解锁动效丢帧打点Start
   *
   * @param authType 认证类型
   */
  public static setFrameRateMoStart(authType?: osAccount.AuthType, isFaceUnlockSwitchOpen: boolean = false): void {
    // 指纹, 人脸直接解锁, 密码解锁
    if (authType && hiSysEventTypes.has(authType)) {
      performanceMonitor.begin(hiSysEventTypes.get(authType), authType === osAccount.AuthType.FINGERPRINT ?
      performanceMonitor.ActionType.LAST_DOWN : performanceMonitor.ActionType.LAST_UP);
      return;
    }
    // 人脸上划解锁
    if (isFaceUnlockSwitchOpen) {
      performanceMonitor.begin(Constants.FACIAL_FLING_UNLOCK_ANI, performanceMonitor.ActionType.FIRST_MOVE);
      return;
    }
    // 无密码上划解锁
    performanceMonitor.begin(Constants.INTO_HOME_ANI, performanceMonitor.ActionType.FIRST_MOVE, 'NoPwd');
  }

  /**
   * 解锁动效丢帧打点End
   *
   * @param authType 认证类型
   */
  public static setFrameRateMoEnd(authType?: osAccount.AuthType, isFaceUnlockSwitchOpen: boolean = false): void {
    // 指纹, 人脸直接解锁, 密码解锁
    if (authType && hiSysEventTypes.has(authType)) {
      performanceMonitor.end(hiSysEventTypes.get(authType));
      return;
    }
    // 人脸上划解锁
    if (isFaceUnlockSwitchOpen) {
      performanceMonitor.end(Constants.FACIAL_FLING_UNLOCK_ANI);
      return;
    }
  }

  /**
   * 上滑进入密码输入页面打点start
   *
   */
  public static setScreenIntoPINStart(): void {
    performanceMonitor.begin(Constants.SCREENLOCK_SCREEN_INTO_PIN, performanceMonitor.ActionType.FIRST_MOVE);
  }

  /**
   * 上滑进入密码输入页面打点end
   *
   */
  public static setScreenIntoPINEnd(): void {
    performanceMonitor.end(Constants.SCREENLOCK_SCREEN_INTO_PIN);
  }

  /**
   * 灭屏动效卡顿打点start
   *
   */
  public static setScreenSleepMoStart(): void {
    performanceMonitor.begin(Constants.SCREENLOCK_SCREEN_OFF_ANIM, performanceMonitor.ActionType.LAST_DOWN);
  }

  /**
   * 灭屏动效卡顿打点end
   *
   */
  public static setScreenSleepMoEnd(): void {
    performanceMonitor.end(Constants.SCREENLOCK_SCREEN_OFF_ANIM);
  }

  /**
   * 灭屏指纹解锁打点Start
   *
   */
  public static setScreenOffFPStart(): void {
    performanceMonitor.begin(Constants.SCREEN_OFF_FINGERPRINT_UNLOCK_ANI, performanceMonitor.ActionType.LAST_DOWN);
  }

  /**
   * 灭屏指纹解锁打点end
   *
   */
  public static setScreenOffFPEnd(): void {
    performanceMonitor.end(Constants.SCREEN_OFF_FINGERPRINT_UNLOCK_ANI);
  }

  /**
   * 锁屏捏合进入锁屏编辑动效卡顿打点start
   *
   */
  public static setPinchGestureMoStart(): void {
    performanceMonitor.begin(Constants.SCREENLOCK_INTO_EDITOR_ANIM, performanceMonitor.ActionType.FIRST_MOVE);
    TraceUtil.startTrace(DomainName.KG, Constants.SCREENLOCK_INTO_EDITOR_ANIM, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
  }

  /**
   * 锁屏捏合进入锁屏编辑动效卡顿打点end
   *
   */
  public static setPinchGestureMoEnd(): void {
    performanceMonitor.end(Constants.SCREENLOCK_INTO_EDITOR_ANIM);
    TraceUtil.endTrace(DomainName.KG, Constants.SCREENLOCK_INTO_EDITOR_ANIM, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
  }

  /**
   * 退出锁屏编辑动效卡顿打点start
   *
   */
  public static setOutScreenLockEditorMoStart(): void {
    performanceMonitor.begin(Constants.SCREENLOCK_EXIT_EDITOR_ANIM, performanceMonitor.ActionType.FIRST_MOVE);
    TraceUtil.startTrace(DomainName.KG, Constants.SCREENLOCK_EXIT_EDITOR_ANIM, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
  }

  /**
   * 退出锁屏编辑动效卡顿打点end
   *
   */
  public static setOutScreenLockEditorMoEnd(): void {
    performanceMonitor.end(Constants.SCREENLOCK_EXIT_EDITOR_ANIM);
    TraceUtil.endTrace(DomainName.KG, Constants.SCREENLOCK_EXIT_EDITOR_ANIM, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
  }

  /**
   * emergency common dotting
   * @param tagName
   * @param func
   * @param sceneName
   */
  public static reportScreenLockCommonEvent(eventName: string, tagName?: string, func?: string): void {
    let params: ScreenLockReportCommonParams = new ScreenLockReportCommonParams();
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    params.TAG_NAME = tagName ?? Constants.SCREEN_LOCK_EMPTY_STRING;
    params.FUNC = func ?? Constants.SCREEN_LOCK_EMPTY_STRING;
    PerformanceMonitorUtil.SCREENLOCK_UE.reportBehavior(eventName, params);
  }

  /**
   * JumpApp dotting
   * @param cardName
   * @param appName
   */
  public static reportScreenLockJumpAppParams(cardName: string, appName: string): void {
    let params: ScreenLockJumpAppParams = new ScreenLockJumpAppParams();
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    params.CARDNAME = cardName;
    params.APPNAME = appName;
    PerformanceMonitorUtil.SCREENLOCK_UE.reportBehavior(Constants.SCREEN_LOCK_JUMP_APP, params);
  }

  /**
   * 上报锁屏_锁屏编辑器_应用
   *
   * @param params 上报锁屏_锁屏编辑器_应用数据
   */
  public static reportLockscreenEditApply(editApplyParams: LockscreenEditApplyParams,
    timePosition: TimePosition): void {
    let params: LockscreenEditStatusParams = {
      TIME_LAYOUT: editApplyParams.timeLayout ?? '',
      TIME_FONT: editApplyParams.timeFont ?? '',
      TIME_COLOR: editApplyParams.timeColor ?? '',
      SHOW_DATE: editApplyParams.showDate ?? '',
      SHOW_LUNAR_CALENDAR: editApplyParams.showLunarCalendar ?? '',
      SHOW_SIGNATURE: editApplyParams.showSignature ?? '',
      FORMNUM: editApplyParams.formNum ?? '',
      DIMENSIONNUM: editApplyParams.dimensionNum ?? '',
      THEMEID: editApplyParams.themeId ?? '',
      THEMENAME: editApplyParams.themeName ?? '',
      TIME_POSITION: '(' + timePosition.positionX + ',' +  timePosition.positionY + ')'
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.SCREEN_LOCK_EDIT_APPLY, params);
  }

  /**
   * 上报锁屏_锁屏编辑器_取消
   *
   * @param params 上报锁屏_锁屏编辑器_取消数据
   */
  public static reportLockscreenEditCancel(): void {
    let params: LockscreenEditStatusParams = {};
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.SCREEN_LOCK_EDIT_CANCEL, params);
  }

  /**
   * 上报锁屏_锁屏编辑器_卡片编辑_服务卡片_点击卡片添加至锁屏
   *
   * @param params 上报锁屏_锁屏编辑器_卡片编辑_服务卡片_点击卡片添加至锁屏数据
   */
  public static reportLockscreenEditCardAdd(formId: string, packageName: string, cardDimension: string, moduleName: string,
    formName: string): void {
    let params: LockscreenEditStatusParams = {
      FORMID: formId,
      PACKAGENAME: packageName,
      CARDDIMENSION: cardDimension,
      MODULENAME: moduleName,
      FORMNAME: formName,
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.SCREEN_LOCK_EDIT_CARD_ADD, params);
  }

  /**
   * 上报锁屏_锁屏编辑器_卡片编辑_服务卡片_点击移除卡片
   *
   * @param params 上报锁屏_锁屏编辑器_卡片编辑_服务卡片_点击移除卡片数据
   */
  public static reportLockscreenEditCardRemove(formId: string, packageName: string, cardDimension: string,
    moduleName: string,
    formName: string): void {
    let params: LockscreenEditStatusParams = {
      FORMID: formId,
      PACKAGENAME: packageName,
      CARDDIMENSION: cardDimension,
      MODULENAME: moduleName,
      FORMNAME: formName,
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.SCREEN_LOCK_EDIT_CARD_REMOVE, params);
  }

  /**
   * 上报锁屏_锁屏编辑器_卡片编辑_服务卡片_拖拽卡片
   *
   * @param params 上报锁屏_锁屏编辑器_卡片编辑_服务卡片_拖拽卡片
   */
  public static reportLockscreenEditCardDrag(cardItem: CardItemUEInfo, eventType: string): void {
    let params: LockscreenEditStatusParams = {
      FORMID: cardItem.formId,
      PACKAGENAME: cardItem.packageName,
      CARDDIMENSION: cardItem.cardDimension,
      MODULENAME: cardItem.moduleName,
      FORMNAME: cardItem.formName,
      POSITIONX: cardItem.positionX ?? undefined,
      POSITIONY: cardItem.positionY ?? undefined,
      NEWX: cardItem.newX ?? undefined,
      NEWY: cardItem.newY ?? undefined
    };
    PerformanceMonitorUtil.reportBehaviorEvent(eventType, params);
  }

  /**
   * 上报锁屏_锁屏编辑器_清屏查看效果
   *
   * @param params 上报锁屏_锁屏编辑器_清屏查看效果数据
   */
  public static reportLockscreenEditClearLook(editorName: string, quitMethod: string): void {
    let params: LockscreenEditStatusParams = {
      EDITOR_NAME: editorName,
      QUIT_METHOD: quitMethod,
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.SCREEN_LOCK_EDIT_CLEAR_LOOK, params);
  }

  /**
   * 上报点击应用进入更多卡片界面
   *
   * @param formId 主题ID packageName 应用包名 cardDimension 卡片规格 moduleName 模块名 formName 卡片名
   */
  public static reportLockscreenEditMoreCardAdd(formId: string, packageName: string, cardDimension: string,
    moduleName: string,
    formName: string): void {
    let params: LockscreenEditStatusParams = {
      FORMID: formId,
      PACKAGE_NAME: packageName,
      CARDDIMENSION: cardDimension,
      MODULENAME: moduleName,
      FORMNAME: formName
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.SCREEN_LOCK_EDIT_MORE_CARD_ADD, params);
  }

  /**
   * 上报点击卡片添加至锁屏
   *
   * @param params 上报点击卡片添加至锁屏数据
   */
  public static reportLockscreenEditMoreCard(packageName?: string): void {
    let params: LockscreenEditStatusParams = {
      PACKAGE_NAME: packageName
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.SCREEN_LOCK_EDIT_MORE_CARD, params);
  }

  /**
   * 上报点击卡片位弹出服务卡片
   *
   * @param params 上报点击卡片位弹出服务卡片数据
   */
  public static reportLockscreenEditServiceWidgets(): void {
    let params: LockscreenEditStatusParams = {};
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.SCREEN_LOCK_EDIT_SERVICE_WIDGETS, params);
  }

  /**
   * 上报锁屏_锁屏编辑器_双指捏合锁屏界面
   *
   * @param params 上报锁屏_锁屏编辑器_双指捏合锁屏界面数据
   */
  public static reportLockscreenEditorEnterMethod(method: number): void {
    let params: LockscreenEditStatusParams = {
      EDITOR_ENTRY_METHOD: method
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.SCREEN_LOCK_TWO_FINGER_PINCH, params);
  }

  /**
   * 输入锁屏签名_点击取消/确认
   *
   * @param params 上报点击开始输入锁屏签名_取消/确认数据
   */
  public static reportLockscreenEditSignInputOk(openName: string, signatureLength: string): void {
    let params: LockscreenEditStatusParams = {
      OPER_NAME: openName,
      SIGNATURE_LENGTH: signatureLength
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.SCREEN_LOCK_EDIT_SIGN_INPUT_OK, params);
  }

  /**
   * 锁屏编辑器_双指捏合锁屏界面_点击时间组件弹出编辑器
   */
  public static reportLockscreenEditTimeClick(type: number): void {
    let params: LockscreenEditStatusParams = {
      TYPE: type
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.SCREEN_LOCK_EDIT_TIME_CLICK, params);
  }

  /**
   * 锁屏编辑_点击时间组件-布局-切换数字时钟/个性海报tab
   */
  public static reportEditClockPosterTabToggle(type: number): void {
    let params: LockscreenEditStatusParams = {
      TYPE: type
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.EDIT_CLOCK_POSTER_TAB_TOGGLE, params);
  }

  /**
   * 上报锁屏_锁屏编辑器_锁屏布局状态点（每周日锁屏曝光时上报）
   *
   * @param params 上报锁屏_锁屏编辑器_锁屏布局状态点（每周日锁屏曝光时上报）数据
   */
  public static reportLockscreenEditStateNowWeek(weekParams: LockscreenEditWeekParams, type?: number,
    posterFontParams?: PosterFontParams, isDof?: boolean, isSupportPoster?: boolean): void {
    let params: LockscreenEditStatusParams = {
      TIME_LAYOUT: weekParams.layout,
      TIME_FONT: weekParams.clockFontFamily,
      TIME_COLOR: weekParams.clockStrokeColor,
      SHOW_DATE: weekParams.showDate,
      SHOW_LUNAR_CALENDAR: weekParams.showLunarCalendar,
      SHOW_SIGNATURE: weekParams.showSignature,
      SIGNATURE_LENGTH: weekParams.signatureLength,
      SIGNATURE_HAS_EMOJI: weekParams.signatureHasEmoji,
      FORMNUM: weekParams.editFormNum,
      DIMENSIONNUM: weekParams.editDimensionNum,
      THEMEID: weekParams.editThemeId,
      THEMENAME: weekParams.editThemeName,
      TYPE: type ?? 1,
      TEXTLENGTH: posterFontParams?.TEXTLENGTH ?? -1,
      ISCOMPOUND: posterFontParams?.ISCOMPOUND ?? false,
      COMPOUNDID: posterFontParams?.COMPOUNDID ?? '-1',
      CHINESECHARACTERNUM: posterFontParams?.CHINESECHARACTERNUM ?? -1,
      ENGLISHCHARACTERNUM: posterFontParams?.ENGLISHCHARACTERNUM ?? -1,
      ISDOF: isDof ?? false,
      ISSUPPORTPOSTER: isSupportPoster ?? false,
    };
    PerformanceMonitorUtil.reportStatisticEvent(Constants.SCREEN_LOCK_STATE_WEEKLY_UPLOAD, params);
  }

  /**
   * 锁屏编辑器_切换项目_布局/字体/颜色/签名
   *
   * @param 点击布局/字体/颜色/签名
   */
  public static reportClockStyleStatus(itemName: string): void {
    let params: LockscreenEditStatusParams = {
      ITEM_NAME: itemName,
      ITEM_INDEX: PerformanceMonitorUtil.EDIT_INDEX_STATUS,
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.EDIT_CLOCK_LAYOUT_TOGGLE, params);
  }

  /**
   * 锁屏编辑器_点击布局/字体/颜色/签名中的内容
   *
   * @param 点击布局/字体/颜色/签名
   * @param 点击布局/字体/颜色中item
   */
  public static reportLockscreenEditStatus(itemName: string, layoutName?: string): void {
    let params: LockscreenEditStatusParams = {
      ITEM_NAME: itemName,
      ITEM_INDEX: layoutName,
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.EDIT_CLOCK_LAYOUT_TOGGLE, params);
  }

  /**
   * 锁屏编辑_长按删除AIGC生成字体
   *
   * @param 删除字体ID
   */
  public static reportDeleteAIGCFont(fontId: string): void {
    let params: LockscreenEditPosterParams = {
      FONTID: fontId
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.DELETE_AIGC_FONT, params);
  }

  /**
   * 锁屏编辑器_锁屏签名显示编辑框
   */
  public static reportSignInputAppear(itemName: string): void {
    let params: LockscreenEditStatusParams = {
      ITEM_NAME: itemName
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.EDIT_CLOCK_LAYOUT_TOGGLE, params);
  }

  /**
   * 上报锁屏_锁屏编辑器_时间组件编辑_点击时间字体按钮_点击开始输入锁屏签名
   *
   *
   */
  public static reportLockscreenEditSignInput(): void {
    let params: LockscreenEditStatusParams = {};
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.SCREEN_LOCK_EDIT_SIGN_INPUT, params);
  }

  /**
   * 锁屏编辑器_拖拽时钟组件
   */
  public static reportDragClock(): void {
    let params: LockscreenEditStatusParams = {};
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.SCREEN_LOCK_EDIT_DRAG_CLOCK, params);
  }

  /**
   * 打点
   *
   * @param name 事件名称
   * @param params 事件参数
   */
  static reportCoverBehaviorEvent(name: string, params: LockscreenCoverApplyParams): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    PerformanceMonitorUtil.SCREENLOCK_UE.reportBehavior(name, params);
  }

  /**
   * 上报锁屏进入皮套
   *
   * @param params 上报锁屏_皮套_进入皮套
   */
  public static reportLockscreenCoverAdd(): void {
    let params: LockscreenCoverApplyParams = {
      COVER_TIME : 0,
    };
    PerformanceMonitorUtil.reportCoverBehaviorEvent(Constants.SCREEN_LOCK_COVER_ADD, params);
  }

  /**
   * 上报锁屏移除皮套
   *
   * @param params 上报锁屏_皮套_移除皮套
   */
  public static reportLockscreenCoverRemove(time: number): void {
    let params: LockscreenCoverApplyParams = {
      COVER_TIME : time,
    };
    PerformanceMonitorUtil.reportCoverBehaviorEvent(Constants.SCREEN_LOCK_COVER_REMOVE, params);
  }

  /**
   * 上报亮屏查看皮套时间事件
   *
   * @param params 上报锁屏_皮套_查看皮套时间
   */
  public static reportLockscreenCoverTime(): void {
    let params: LockscreenCoverApplyParams = {
      COVER_TIME : 0,
    };
    PerformanceMonitorUtil.reportCoverBehaviorEvent(Constants.SCREEN_LOCK_COVER_TIME, params);
  }

  /**
   * DMS发送的电源事件变化
   * @param params 上报由DMS发生的电源事件变化数据
   */
  public static reportPowerStateEvent(params: PowerStateChangeParams): void {
    params.pNameId = ReportParams.PACKAGE_NAME;
    params.pVersionId = ReportParams.PROCESS_NAME;
    PerformanceMonitorUtil.SCREENLOCK_UE.reportBehavior(Constants.SCREEN_LOCK_POWER_STATE_CHANGE, params);
  }

  /**
   * 壁纸状态变化
   * @param params 上报切换场景壁纸变化事件
   */
  public static reportWallpaperChangeEvent(params: WallpaperChangeParams): void {
    params.pNameId = ReportParams.PACKAGE_NAME;
    params.pVersionId = ReportParams.PROCESS_NAME;
    PerformanceMonitorUtil.SCREENLOCK_UE.reportBehavior(Constants.SCREEN_LOCK_WALLPAPER_CHANGE, params);
  }

  /**
   * 不播放一镜到底原因
   * @param params 上报不播放一镜到底的具体原因
   */
  public static reportNoMirrorReasonEvent(params: NoMirrorReasonParams): void {
    params.pNameId = ReportParams.PACKAGE_NAME;
    params.pVersionId = ReportParams.PROCESS_NAME;
    PerformanceMonitorUtil.SCREENLOCK_UE.reportBehavior(Constants.SCREEN_LOCK_NO_MIRROR_REASON, params);
  }

  /**
   * 锁屏编辑_点击时间组件-字体-海报样式字体相机按钮_AIGC识别字体块
   */
  public static reportAIGCIdentifyFontBlock(fontBlockNum: number, identifyDuration: number, isSuccess: boolean,
    errorcode?: string): void {
    let params: LockscreenEditPosterParams = {
      FONTBLOCKNUM: fontBlockNum,
      IDENTIFYDURATION: identifyDuration,
      ISSUCCESS: isSuccess,
      ERRORCODE: errorcode ?? ''
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.AIGC_IDENTIFY_FONT_BLOCK, params);
  }

  /**
   * 锁屏编辑_点击时间组件-字体-海报样式字体相机按钮_AIGC识别字体块-点击AIGC生成字体块-生成AIGC新字体-应用新生成字体
   */
  public static reportApplyAIGCNewFont(fontId: string): void {
    let params: LockscreenEditPosterParams = {
      FONTID: fontId
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.APPLY_AIGC_NEW_FONT, params);
  }

  /**
   * 锁屏编辑_点击时间组件-字体-海报样式字体相机按钮_AIGC识别字体块-点击AIGC生成字体块-生成AIGC新字体-不应用新生成字体
   */
  public static reportApplyAIGCNewFontCancel(): void {
    let params: LockscreenEditPosterParams = {};
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.AIGC_NEW_FONT_CANCEL, params);
  }

  /**
   * 锁屏编辑_点击时间组件-字体-海报样式字体相机按钮_AIGC识别字体块-点击AIGC生成字体块
   */
  public static reportClickAIGCFontBlock(): void {
    let params: LockscreenEditPosterParams = {};
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.CLICK_AIGC_FONT_BLOCK, params);
  }

  /**
   * 锁屏编辑_点击时间组件-字体-点击海报样式字体相机按钮
   */
  public static reportClickPosterAIGCButton(): void {
    let params: LockscreenEditPosterParams = {};
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.CLICK_POSTER_AIGC_BUTTON, params);
  }

  /**
   * 锁屏编辑_锁屏编辑_点击时间组件-布局-个性海报-输入文本-确认或选择合体字应用海报字体
   */
  public static reportClickPosterTextApply(posterFontParams: PosterFontParams): void {
    let params: LockscreenEditPosterParams = {
      TEXTLENGTH: posterFontParams.TEXTLENGTH,
      ISCOMPOUND: posterFontParams.ISCOMPOUND,
      COMPOUNDID: posterFontParams.ISCOMPOUND? posterFontParams.COMPOUNDID : '-1',
      CHINESECHARACTERNUM: posterFontParams.CHINESECHARACTERNUM,
      ENGLISHCHARACTERNUM: posterFontParams.ENGLISHCHARACTERNUM
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.CLICK_POSTER_TEXT_APPLY, params);
  }

  /**
   * 锁屏编辑_点击应用个性海报时钟
   */
  public static reportClickPosterThemeApply(posterFontParams: PosterFontParams, posterLayout: string, isDof: boolean,
    color: string): void {
    let params: LockscreenEditPosterParams = {
      TEXTLENGTH: posterFontParams.TEXTLENGTH,
      ISCOMPOUND: posterFontParams.ISCOMPOUND,
      COMPOUNDID: posterFontParams.ISCOMPOUND? posterFontParams.COMPOUNDID : '-1',
      CHINESECHARACTERNUM: posterFontParams.CHINESECHARACTERNUM,
      ENGLISHCHARACTERNUM: posterFontParams.ENGLISHCHARACTERNUM,
      POSTERLAYOUT: posterLayout,
      ISDOF: isDof,
      COLOR: color
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.CLICK_POSTER_THEME_APPLY, params);
  }

  /**
   * 锁屏编辑_点击时间组件-布局-个性海报-输入文本-点击试试合体字
   */
  public static reportClickTryCompound(): void {
    let params: LockscreenEditPosterParams = {};
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.CLICK_TRY_COMPOUND, params);
  }

  /**
   * 锁屏编辑_个性海报样式切换布局/字体/颜色tab
   */
  public static reportEditPosterLayoutToggle(itemName: string, fontNum?: number): void {
    let params: LockscreenEditPosterParams = {
      ITEMNAME: itemName,
      FONTNUM: fontNum ?? -1
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.EDIT_POSTER_LAYOUT_TOGGLE, params);
  }

  /**
   * 锁屏编辑_个性海报tab首次点击使用-记录tip提示消失
   */
  public static reportArtTipHidden(): void {
    let params: LockscreenEditPosterParams = {
      MOUDLETYPE: 'screenLockEdit'
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.CLICK_ART_TIP_HIDDEN, params);
  }

  /**
   * 锁屏编辑_点击时间组件-字体-切换海报样式字体
   */
  public static reportEditPosterFontToggle(fontId: string, isOnlineFont: boolean): void {
    let params: LockscreenEditPosterParams = {
      FONTID: fontId,
      ISONLINEFONT: isOnlineFont
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.EDIT_POSTER_FONT_TOGGLE, params);
  }

  /**
   * 锁屏编辑_点击时间组件-颜色-切换海报样式字体颜色
   */
  public static reportEditPosterColorToggle(color: string): void {
    let params: LockscreenEditPosterParams = {
      COLOR: color
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.EDIT_POSTER_COLOR_TOGGLE, params);
  }

  /**
   * 锁屏编辑_点击时间组件-布局-个性海报-样式切换
   */
  public static reportEditPosterStyleToggle(posterLayout: string, fontId: string, duration: number, color: string,
    isNeedRipple: boolean): void {
    let params: LockscreenEditPosterParams = {
      POSTERLAYOUT: posterLayout,
      FONTID: fontId,
      DURATION: duration,
      COLOR: color,
      ISNEEDRIPPLE: isNeedRipple
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.EDIT_POSTER_STYLE_TOGGLE, params);
  }

  /**
   * 锁屏编辑_点击时间组件-字体-海报样式字体相机按钮_AIGC识别字体块-点击AIGC生成字体块-生成AIGC新字体
   */
  public static reportGenerateAIGCNewFont(fontId: string, isSuccess: boolean, generatedDuration: number,
    traceId: string, handleTime: number, errorCode?: string): void {
    let params: LockscreenEditPosterParams = {
      FONTID: fontId,
      ISSUCCESS: isSuccess,
      ERRORCODE: errorCode ?? '',
      GENERATEDURATION: generatedDuration,
      TRACEID: traceId,
      HANDLETIME: handleTime
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.GENERATE_AIGC_NEW_FONT, params);
  }

  /**
   * 锁屏编辑_个性海报时钟布局拖拽
   */
  public static reportPosterLayoutDrag(posterFontParams: PosterFontParams, posterLayout: string,
    isEnableDrag: boolean): void {
    let params: LockscreenEditPosterParams = {
      TEXTLENGTH: posterFontParams.TEXTLENGTH,
      ISCOMPOUND: posterFontParams.ISCOMPOUND,
      COMPOUNDID: posterFontParams.ISCOMPOUND? posterFontParams.COMPOUNDID : '-1',
      CHINESECHARACTERNUM: posterFontParams.CHINESECHARACTERNUM,
      ENGLISHCHARACTERNUM: posterFontParams.ENGLISHCHARACTERNUM,
      POSTERLAYOUT: posterLayout,
      ISENABLEDRAG: isEnableDrag
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.POSTER_LAYOUT_DRAG, params);
  }

  /**
   * 锁屏编辑_点击时间组件-字体-点击海报样式字体相机按钮-字体创作隐私声明确认结果
   */
  public static reportPosterPrivaceStatementConfirm(isConfirm: boolean): void {
    let params: LockscreenEditPosterParams = {
      ISCONFIRM: isConfirm
    };
    PerformanceMonitorUtil.reportBehaviorEvent(Constants.POSTER_PRIVACE_STATEMENT_CONFIRM, params);
  }
}

export class LockscreenEditStatusParams {
  public PNAMEID?: string;
  public PVERSIONID?: string;
  public ITEM_NAME?: string;
  public ITEM_INDEX?: string;
  public TIME_LAYOUT?: string;
  public TIME_FONT?: string;
  public TIME_COLOR?: string;
  public TIME_POSITION?: string;
  public SHOW_DATE?: string;
  public SHOW_LUNAR_CALENDAR?: string;
  public SHOW_SIGNATURE?: string;
  public FORMNUM?: string;
  public DIMENSIONNUM?: string;
  public THEMEID?: string;
  public THEMENAME?: string;
  public FORMID?: string;
  public PACKAGENAME?: string;
  public CARDDIMENSION?: string;
  public MODULENAME?: string;
  public FORMNAME?: string;
  public EDITOR_NAME?: string;
  public QUIT_METHOD?: string;
  public OPER_NAME?: string;
  public SIGNATURE_LENGTH?: string;
  public SIGNATURE_HAS_EMOJI?: string;
  public PACKAGE_NAME?: string;
  public POSITIONX?: number;
  public POSITIONY?: number;
  public NEWX?: number;
  public NEWY?: number;
  public TYPE?: number;
  public TEXTLENGTH?: number;
  public ISCOMPOUND?: boolean;
  public COMPOUNDID?: string;
  public CHINESECHARACTERNUM?: number;
  public ENGLISHCHARACTERNUM?: number;
  public ISDOF?: boolean;
  public EDITOR_ENTRY_METHOD?: number;
  public ISSUPPORTPOSTER?: boolean;
}

export class LockscreenEditPosterParams {
  public PNAMEID?: string;
  public PVERSIONID?: string;
  public ISPOSTERSTYLE?: boolean;
  public POSTERLAYOUT?: string;
  public TEXTLENGTH?: number;
  public CHINESECHARACTERNUM?: number;
  public ENGLISHCHARACTERNUM?: number;
  public ISCOMPOUND?: boolean;
  public COMPOUNDID?: string;
  public FONTID?: string;
  public ISDOF?: boolean;
  public COLOR?: string;
  public ISENABLEDRAG?: boolean;
  public DURATION?: number;
  public IDENTIFYDURATION?: number;
  public GENERATEDURATION?: number;
  public ISCONFIRM?: boolean;
  public ISSUCCESS?: boolean;
  public ERRORCODE?: string;
  public FONTBLOCKNUM?: number;
  public FONTNUM?: number;
  public ITEMNAME?: string;
  public ISONLINEFONT?: boolean;
  public ISNEEDRIPPLE?: boolean;
  public MOUDLETYPE?: string;
  public TRACEID?: string;
  public HANDLETIME?: number;
}

export class PosterFontParams {
  public TEXTLENGTH?: number;
  public ISCOMPOUND?: boolean;
  public COMPOUNDID?: string;
  public CHINESECHARACTERNUM?: number;
  public ENGLISHCHARACTERNUM?: number;
}

/**
 * Screen Lock 时钟编辑页面进入方式
 */
export enum ClockEditorEntryMethod {
  LONG_PRESS,
  FINGER_PINCH,
}

export class LockscreenEditWeekParams {
  public layout: string = '';
  public clockFontFamily: string = '';
  public clockStrokeColor: string = '';
  public showDate: string = '';
  public showLunarCalendar: string = '';
  public showSignature: string = '';
  public signatureLength?: string = '';
  public signatureHasEmoji?: string = '';
  public editFormNum: string = '';
  public editDimensionNum: string = '';
  public editThemeId: string = '';
  public editThemeName: string = '';
}

export class LockscreenEditApplyParams {
  public timeLayout: string = '';
  public timeFont: string = '';
  public timeColor: string = '';
  public showDate: string = '';
  public showLunarCalendar: string = '';
  public showSignature: string = '';
  public formNum: string = '';
  public dimensionNum: string = '';
  public themeId: string = '';
  public themeName: string = '';
}

export class LockscreenCoverApplyParams {
  public PNAMEID?: string;
  public PVERSIONID?: string;
  public COVER_TIME: number = 0; // 皮套时长，单位ms
}

//锁屏卡片上报
export class CardItemUEInfo {
  public formId: string | undefined;
  public packageName: string | undefined;
  public cardDimension: string | undefined;
  public moduleName: string | undefined;
  public formName: string | undefined;
  public positionX?: number | undefined = undefined;
  public positionY?: number | undefined = undefined;
  public newX?: number | undefined = undefined;
  public newY?: number | undefined = undefined;
}

class ScreenLockReportCommonParams {
  public PNAMEID: string = Constants.SCREEN_LOCK_EMPTY_STRING;
  public PVERSIONID: string = Constants.SCREEN_LOCK_EMPTY_STRING;
  public TAG_NAME: string = Constants.SCREEN_LOCK_EMPTY_STRING;
  public FUNC: string = Constants.SCREEN_LOCK_EMPTY_STRING;
}

/**
 * 用户跳转到卡片应用内部的行为打点事件的Bean类
 */
class ScreenLockJumpAppParams {
  public PNAMEID: string = Constants.SCREEN_LOCK_EMPTY_STRING;
  public PVERSIONID: string = Constants.SCREEN_LOCK_EMPTY_STRING;
  public CARDNAME: string = Constants.SCREEN_LOCK_EMPTY_STRING;
  public APPNAME: string = Constants.SCREEN_LOCK_EMPTY_STRING;
}

/**
 * 电源事件，由DMS发生
 */
export class PowerStateChangeParams {
  // 包名
  public pNameId?: string;
  // 版本号
  public pVersionId?: string;
  // 电源状态
  public powerStatus: string = '';
  // 状态改变原因
  public changeReason: number = 0;
}

/**
 * 壁纸改变事件
 */
export class WallpaperChangeParams {
  // 包名
  public pNameId?: string;
  // 版本号
  public pVersionId?: string;
  // 壁纸当前状态
  public curState: number = 0;
  // 壁纸目标状态
  public tarState: number = 0;
  // 是否需要播放动效
  public isPlayingAnim: boolean = false;
}
//不播一镜到底事件
export class NoMirrorReasonParams {
  // 包名
  public pNameId?: string;
  // 版本号
  public pVersionId?: string;
  // 不播一镜到底原因
  public noMirrorReason: string = '';
}