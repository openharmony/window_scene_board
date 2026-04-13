/**
 * Copyright (c) 2025-2025 Huawei Device Co., Ltd.
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

import { Callback } from '@kit.BasicServicesKit';
import { formHost } from '@kit.FormKit';
import { ArrayList } from '@kit.ArkTS';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import { SCBSceneSessionManager, ScenePanelState } from '@ohos/windowscene';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { OverflowConstants, VisualEffectConstants } from '@ohos/commonconstants';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { PageInfoManager } from '../../cache/layout/PageInfoManager';

const TAG: string = 'FormHostService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const RECOVER_DELAY: number = 2 * 1000;
const MAX_VISIBLE_SETABLE: number = 32;
const LOW_VISUAL_EFFECT: string = 'low';

export class FormHostService {
  private static instance: FormHostService;
  private invisibleFormList: Set<string> = new Set();
  private currentRecycledMap: Map<string, number> = new Map();
  private formVisibleListenerMap: Map<string, ArrayList<VisibleChangeListener>> = new Map();
  private formRecycleListenerMap: Map<string, ArrayList<RecycleChangeListener>> = new Map();

  public static getInstance(): FormHostService {
    if (FormHostService.instance == null) {
      FormHostService.instance = new FormHostService();
    }
    return FormHostService.instance;
  }

  /**
   * register form visible change listener
   *
   * @param cardId card id
   * @param listener form visible change listener
   */
  public registerFormVisibleListener(cardId: string, listener: VisibleChangeListener): void {
    log.showInfo(`registerFormVisibleListener: ${cardId}`);
    let listeners: ArrayList<VisibleChangeListener> =
      this.formVisibleListenerMap.get(cardId) ?? new ArrayList<VisibleChangeListener>();
    listeners.add(listener);
    this.formVisibleListenerMap.set(cardId, listeners);
  }

  /**
   * unregister form visible change listener
   *
   * @param cardId card id
   * @param listener form visible change listener
   */
  public unRegisterFormVisibleListener(cardId: string, listener: VisibleChangeListener): void {
    log.showInfo(`unregisterFormVisibleListener: ${cardId}`);
    let listeners: ArrayList<VisibleChangeListener> | undefined = this.formVisibleListenerMap.get(cardId);
    listeners?.remove(listener);
    if (listeners?.isEmpty()) {
      this.formVisibleListenerMap.delete(cardId);
    }
  }

  /**
   * 通知卡片的回收
   *
   * @param formList 需要通知的卡片列表
   */
  public formHostNotifyToRecycle(formList: string[]): void {
    if (CheckEmptyUtils.isEmptyArr(formList)) {
      return;
    }
    let formIds: string[] = [];
    formIds = formList.filter((item: string)=> {
      const isRecycled: boolean = !this.queryRecycledItem(item);
      return isRecycled;
    });
    if (formIds.length === 0) {
      log.showInfo('no need to notify recycle');
      return;
    }
    log.showInfo(`need to recycled list: ${formIds.toString()}`);
    this.sliceAndNotify(formIds, list => this.handleRecycle(list));
  }

  /**
   * 通知卡片的恢复
   *
   * @param formList 需要通知的卡片列表
   */
  public formHostNotifyToRecover(formList: string[]): void {
    if (CheckEmptyUtils.isEmptyArr(formList)) {
      return;
    }
    let formIds: string[] = [];
    formIds = formList.filter((item: string) => this.queryRecycledItem(item));
    if (formIds.length === 0) {
      log.showInfo('no need to notify recover');
      return;
    }

    log.showInfo(`current recycled list: ${Array.from(this.currentRecycledMap.keys()).join(',')}`);

    // 回收时间不足2s的，延迟2s恢复，其他的即时恢复
    let recoverList: string[][] = this.getRecoverList(formIds);
    log.showInfo(`current need recover list: ${recoverList[0].toString()}`);
    this.sliceAndNotify(recoverList[0], list => this.handleRecover(list));

    if (!CheckEmptyUtils.isEmptyArr(recoverList[1])) {
      const timerId: number = setTimeout((delayRecoverList: string[]) => {
        log.showInfo(`time up to recover delay2s forms: ${delayRecoverList.toString()}`);
        clearTimeout(timerId);
        this.sliceAndNotify(delayRecoverList, list => this.handleRecover(list));
      }, RECOVER_DELAY, recoverList[1]);
    }
  }

  /**
   * 通知卡片可见
   *
   * @param formList 需要通知的卡片列表
   */
  public formHostNotifyVisible(formList: string[], isNeedFilter: boolean = false, formBriefList: string[]): void {
    if (CheckEmptyUtils.isEmptyArr(formList)) {
      log.showWarn('formVisibleList empty');
      return;
    }
    let formIds: string[] = [];
    if (isNeedFilter) {
      formIds = formList.filter((item: string) => this.queryInvisibleListItem(item));
    } else {
      formIds = formList;
    }
    if (formIds.length === 0) {
      log.showInfo('no need to notify visibility');
      return;
    }

    this.sliceAndNotify(formIds, (list): void => this.handleVisible(list, formBriefList));
  }

  /**
   * 通知卡片不可见
   *
   * @param formList 需要通知的卡片列表
   */
  public formHostNotifyInvisible(formList: string[], isNeedFilter: boolean = true): void {
    if (CheckEmptyUtils.isEmptyArr(formList)) {
      return;
    }
    let formIds: string[] = [];
    if (isNeedFilter) {
      formIds = formList.filter((item: string) => !this.queryInvisibleListItem(item));
    } else {
      formIds = formList;
    }
    if (formIds.length === 0) {
      log.showInfo('no need to notify inVisibility');
      return;
    }

    this.sliceAndNotify(formIds, (list): void => this.handleInvisible(list));
  }

  public formHostNotifyCardVisibility(formId: string, pageIndex: number, isOuter?: boolean): void {
    if (CheckEmptyUtils.checkStrIsEmpty(formId)) {
      log.showError('invalid formId, no need to handleVisible');
      return;
    }

    let isScreenLock: boolean = SCBSceneSessionManager.getInstance().isScreenLocked();
    let isFullScreen: boolean = AppStorage.get('onDeskTopState') === ScenePanelState.FULLSCENE;
    let isCurPage: boolean =
      PageInfoManager.getInstance().isCurrentPageShow(desktopUtil.getPageIndexValue(isOuter), pageIndex);
    log.showInfo(`form: ${formId}, screen lock: ${isScreenLock}, full screen: ${isFullScreen}, cur page: ${isCurPage}`);

    let isVisible: boolean = !isScreenLock && !isFullScreen && isCurPage;
    if (isVisible) {
      this.handleVisible([formId]);
    } else {
      this.handleInvisible([formId]);
    }
  }

  /**
   * 通知卡片可见
   *
   * @param formList 需要通知的卡片列表
   */
  private handleVisible(formList: string[], formBriefList?: string[]): void {
    if (CheckEmptyUtils.isEmptyArr(formList)) {
      log.showInfo('current formList is empty no need to set visible');
      return;
    }
    try {
      formHost.notifyVisibleForms(formList).then(() => {
        if (!CheckEmptyUtils.isEmptyArr(formBriefList)) {
          let formInfoList: string[] = formBriefList.filter((item) => formList.includes(item.split('_')[0]));
          log.showWarn(`formHost notifyVisibleForms success, cardInfo: ${formInfoList.toString()}`);
        } else {
          log.showWarn(`formHost notifyVisibleForms success, cardId is ${formList.toString()}`);
        }
        this.updateInvisibleFormList(formList);
        this.formHostNotifyToRecover(formList);
      }).catch((error: Error) => {
        log.error(`formList: ${formList.toString()}, formHost notifyVisibleForms, error: ${error}`);
      });
      formList.forEach(formId => {
        this.formVisibleListenerMap.get(formId)?.forEach(listener => listener.onVisibleChange(true));
      });
    } catch (error) {
      log.error(`formList: ${formList.toString()}, notifyVisibleForms fail, catch err: ${error}`);
    }
  }

  /**
   * 通知卡片不可见
   *
   * @param formList 需要通知的卡片列表
   */
  private handleInvisible(formList: string[]): void {
    if (CheckEmptyUtils.isEmptyArr(formList)) {
      log.showInfo('current formList is empty no need to set invisible');
      return;
    }
    try {
      formHost.notifyInvisibleForms(formList).then(() => {
        log.showWarn(`formHost notifyInvisibleForms success, cardId is ${formList.toString()}`);
        formList.forEach(formId => {
          this.insertItemToInvisibleList(formId);
        });
      }).catch((error: Error) => {
        log.error(`formList: ${formList.toString()}, formHost notifyInvisibleForms, error: ${error}`);
      });
      formList.forEach(formId => {
        this.formVisibleListenerMap.get(formId)?.forEach(listener => listener.onVisibleChange(false));
      });
    } catch (error) {
      log.error(`formList: ${formList.toString()}, notifyInvisibleForms fail, catch err: ${error}`);
    }
  }

  /**
   * 通知卡片回收
   *
   * @param formList 需要通知的卡片列表
   */
  public handleRecycle(formList: string[]): void {
    if (CheckEmptyUtils.isEmptyArr(formList)) {
      log.showInfo('current formList is empty no need to recycle');
      return;
    }
    try {
      formHost.recycleForms(formList).then(() => {
        log.showWarn(`formHost notifyRecycleForms success, cardId is ${formList.toString()}`);
        this.insertListToCurrentRecycleList(formList);
      }).catch((error: Error) => {
        log.error(`formList: ${formList.toString()}, formHost notifyRecycleForms, error: ${error}`);
      });
      formList.forEach(formId => {
        this.formRecycleListenerMap.get(formId)?.forEach(listener => listener.onRecycleChange(true));
      });
    } catch (error) {
      log.error(`formList: ${formList.toString()}, notifyRecycleForms fail, catch error: ${error}`);
    }
  }

  /**
   * 通知卡片恢复
   *
   * @param formList 需要通知的卡片列表
   */
  private handleRecover(recoverList: string[]): void {
    if (CheckEmptyUtils.isEmptyArr(recoverList)) {
      log.showInfo('current formList is empty no need to recover');
      return;
    }

    recoverList.forEach(formId => this.updateCurrentRecycleList(formId));
    try {
      formHost.recoverForms(recoverList).then(() => {
        log.showWarn(`formHost notifyRecoverForms success, cardId is ${recoverList.toString()}`);
      }).catch((error) => {
        log.error(`recoverList: ${recoverList.toString()}, formHost notifyRecoverForms, error: ${error}`);
      });
      recoverList.forEach(formId => {
        this.formRecycleListenerMap.get(formId)?.forEach(listener => listener.onRecycleChange(false));
      });
    } catch (error) {
      log.error(`recoverList: ${recoverList.toString()}, notifyRecoverForms fail, catch error: ${error}`);
    }
  }

  /**
   * 因框架一次最多处理MAX_VISIBLE_SETABLE张卡片，需要对需通知的卡片进行切片
   *
   * @param formList 需要通知的卡片列表
   * @param notifyCallback 通知的回调
   */
  private sliceAndNotify(formList: string[], notifyCallback: Callback<string[]>): void {
    while (formList.length > 0) {
      notifyCallback(formList.splice(0, Math.min(formList.length, MAX_VISIBLE_SETABLE)));
    }
  }

  private insertItemToInvisibleList(formId: string): void {
    this.invisibleFormList.add(formId);
  }

  private deleteInvisibleListItem(formId: string): void {
    this.invisibleFormList.delete(formId);
  }

  public queryInvisibleListItem(formId: string): boolean {
    return this.invisibleFormList.has(formId);
  }

  private queryRecycledItem(formId: string): boolean {
    return this.currentRecycledMap.has(formId);
  }

  private updateCurrentRecycleList(formId: string): boolean {
    if (!this.currentRecycledMap.has(formId)) {
      return false;
    }
    this.currentRecycledMap.delete(formId);
    return true;
  }

  private insertListToCurrentRecycleList(formList: string[]): void {
    let dateNow: number = Date.now();
    formList.forEach(formId => this.currentRecycledMap.set(formId, dateNow));
  }

  private updateInvisibleFormList(formList: string[]): void {
    formList.forEach(formId => {
      this.deleteInvisibleListItem(formId);
    });
  }

  private getRecoverList(formList: string[]): string[][] {
    let currentRecoverList: string[] = [];
    let delayRecoverList: string[] = [];
    let timeNow: number = Date.now();
    formList.forEach(formId => {
      if (!this.queryRecycledItem(formId)) {
        return;
      }
      let timeDiff: number = timeNow - (this.currentRecycledMap.get(formId) as number);
      if (timeDiff < RECOVER_DELAY) {
        delayRecoverList.push(formId);
      } else {
        currentRecoverList.push(formId);
      }
    });
    return [currentRecoverList, delayRecoverList];
  }
}

export interface VisibleChangeListener {
  onVisibleChange(visible: boolean): void;
}

export interface RecycleChangeListener {
  onRecycleChange(state: boolean): void;
}

/**
 * 互动卡片包括趣味交互卡片、场景动效卡片
 * 0：不支持互动卡片
 * 1：仅支持趣味交互卡片（游戏卡片）
 * 2：仅支持场景动效卡片
 * 3：支持场景动效卡片和趣味交互卡片
 */
export enum LiveFormSupportType {
  LIVE_FORM_NONE = '0',
  FUN_INTERACTION = '1',
  SCENE_ANIMATION = '2',
  LIVE_FORM_BOTH = '3',
}

export class LiveFormSupportMgr {
  private static instance: LiveFormSupportMgr;
  private gameCardEnable: string = 'false';
  private liveFormSupportType: string = LiveFormSupportType.LIVE_FORM_NONE;
  private gameCardMaxPauseTime: string = OverflowConstants.GAME_CARD_MAX_PAUSE_TIME;
  private liveFormMaxAnimationDuration: string = OverflowConstants.LIVE_FORM_MAX_ANIMATION_DURATION;
  private liveFormScaleRatio: string = OverflowConstants.LIVE_FORM_SCALE_RATIO;
  private liveFormMaxActivationNumber: string = OverflowConstants.LIVE_FORM_MAX_ACTIVATION_NUMBER_DEFAULT;
  private liveFormVisualEffectLevel: string | undefined = undefined;
  private liveFormLongOverflowRequestDuration: string = OverflowConstants.LIVE_FORM_LONG_OVERFLOW_DURATION;
  private liveFormSupportLauncherSet: Set<string> = new Set<string>();

  public addSupportLauncher(formId: string): void {
    this.liveFormSupportLauncherSet.add(formId);
  }

  public removeSupportLauncher(formId: string): void {
    this.liveFormSupportLauncherSet.delete(formId);
  }

  public hasSupportLauncher(formId: string): boolean {
    return this.liveFormSupportLauncherSet.has(formId);
  }

  public static getInstance(): LiveFormSupportMgr {
    if (!LiveFormSupportMgr.instance) {
      LiveFormSupportMgr.instance = new LiveFormSupportMgr();
    }
    return LiveFormSupportMgr.instance;
  }

  constructor() {
    this.initLiveFormParameters();
  }

  public initLiveFormParameters(): void {
    try {
      this.gameCardEnable = systemParameterEnhance.getSync('persist.sceneboard.desktop.game_card', 'false');
      this.liveFormSupportType = systemParameterEnhance.getSync('persist.sys.fms.support.liveForm', '0');
      this.gameCardMaxPauseTime = systemParameterEnhance.getSync('persist.sceneboard.desktop.game_card_max_pause_time',
        OverflowConstants.GAME_CARD_MAX_PAUSE_TIME);
      this.liveFormMaxAnimationDuration =
        systemParameterEnhance.getSync('persist.sceneboard.desktop.live_form_max_animation_duration',
          OverflowConstants.LIVE_FORM_MAX_ANIMATION_DURATION);
      this.liveFormScaleRatio = systemParameterEnhance.getSync('persist.sceneboard.desktop.live_form_scale_ratio',
        OverflowConstants.LIVE_FORM_SCALE_RATIO);
      this.liveFormMaxActivationNumber =
        systemParameterEnhance.getSync('persist.sceneboard.desktop.live_form_max_activation_number',
          OverflowConstants.LIVE_FORM_MAX_ACTIVATION_NUMBER_DEFAULT);
      this.liveFormLongOverflowRequestDuration =
        systemParameterEnhance.getSync('const.sceneboard.desktop.live_form_long_overflow_request_duration',
          OverflowConstants.LIVE_FORM_LONG_OVERFLOW_DURATION);

      log.showInfo('gameCardEnable: %{public}s, liveFormSupportType: %{public}s, ' +
        'MaxPauseTime: %{public}s, MaxAnimationDuration: %{public}s, ' +
        'ScaleRatio: %{public}s, MaxActivationNumber: %{public}s, liveFormLongOverflowRequestDuration: %{public}s',
        this.gameCardEnable, this.liveFormSupportType, this.gameCardMaxPauseTime, this.liveFormMaxAnimationDuration,
        this.liveFormScaleRatio, this.liveFormMaxActivationNumber, this.liveFormLongOverflowRequestDuration);
    } catch (err) {
      log.showError(`initLiveFormParameters error, code:${err?.code}, message:${err?.message}`);
    }

    this.liveFormVisualEffectLevel = SCBVisualEffectMgr.getFeatureParam(VisualEffectConstants.CARD_VISUAL_EFFECT_LEVEL);
  }

  public isSupportLiveForm(): boolean {
    return this.liveFormSupportType !== LiveFormSupportType.LIVE_FORM_NONE;
  }

  public isSupportSceneAnimation(): boolean {
    return this.liveFormSupportType === LiveFormSupportType.SCENE_ANIMATION ||
      this.liveFormSupportType === LiveFormSupportType.LIVE_FORM_BOTH;
  }

  public isSupportFunInteraction(): boolean {
    return this.liveFormSupportType === LiveFormSupportType.FUN_INTERACTION ||
      this.liveFormSupportType === LiveFormSupportType.LIVE_FORM_BOTH;
  }

  // 小蒙卡片属于互动卡片，由于已存在单独开关，故需要单独判断以兼容
  public isSupportGameCard(): boolean {
    return this.gameCardEnable === 'true';
  }

  public getGameCardMaxPauseTime(): number {
    return Number(this.gameCardMaxPauseTime);
  }

  public getLiveFormMaxAnimationDuration(): number {
    return Number(this.liveFormMaxAnimationDuration);
  }

  public getLiveFormScaleRatio(): string {
    return this.liveFormScaleRatio;
  }

  public getLiveFormMaxActivationNumber(): number {
    return Number(this.liveFormMaxActivationNumber);
  }

  public isLowVisualEffect(): boolean {
    return this.liveFormVisualEffectLevel === LOW_VISUAL_EFFECT;
  }

  public getLongOverflowRequestDuration(): number {
    return Number(this.liveFormLongOverflowRequestDuration);
  }
}