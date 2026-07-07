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

import { LogDomain, Logger } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, ScreenState } from '@ohos/frameworkwrapper';
import { SCBPropertyChangeReason, SCBSceneContainerState } from '../../TsIndex';
import { ArrayList } from '@kit.ArkTS';
// import lazy { insightIntent } from '@kit.IntentsKit';
import { SCBSceneInfo, SCBSceneMode } from '../session/SCBSceneInfo';
import lazy { SCBTripleFoldState, SCBTriFoldManager } from '@ohos/frameworkwrapper';
import { SCBSceneContainerSession } from '../session/SCBSceneContainerSession';
import { SCBSceneSession } from '../session/SCBSceneSession';
import { AiSplitReason } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'SCBSceneWindowAiSplitSwitchUtils';
const log: Logger = Logger.getLogHelper(LogDomain.WINDOW);

const NATURAL_SWITCH_TIME: number = 1000;
const FREQUENT_SWITCH_TIME: number = 1000;
const INTENT_SHOWING_TIME: number = 11500;
const INTENT_WAITING_TIME: number = 1000;
const AI_SPLIT_FREQUENT_SWITCH_ENABLE = false;

export enum AiSceneState {
  INITIAL_STATE = 0,
  FIRST_A = 1,
  FIRST_B = 2,
  SECOND_A = 3,
}

export enum SwitchType {
  FREQUENT_SWITCH = 0,
  NATURAL_SWITCH = 1,
  INVALID = -1,
}

enum TimerType {
  PRIMARY_TIMER = 0,
  SECONDARY_TIMER = 1,
  INVALID = -1,
}

/**
 * Listener of SCBSceneWindowAiSplitSwitchUtils
 *
 * @since 2025-06-03
 */
export interface ViewSplitListener {
  viewSplitScreen: (primaryAppSceneInfo: SCBSceneInfo, secondaryAppSceneInfo: SCBSceneInfo,
    switchType: SwitchType) => void;
  setSplitIntentByFrequentSwitch: (primaryAppSceneInfo: SCBSceneInfo, secondaryAppSceneInfo: SCBSceneInfo) => void;
  setSplitIntentByNaturalSwitch: (fromSceneInfo: SCBSceneInfo, toSceneInfo: SCBSceneInfo) => void;
  deleteSplitIntent: () => void;
}

/**
 * class to handle Ai Multi-Window: Prompt users to split when switching Apps frequently
 *
 */
export class SCBSceneWindowAiSplitSwitchUtils {
  // list to save the listeners that can be notified to split window or set intent
  public viewSplitListenerList: ArrayList<ViewSplitListener> = new ArrayList<ViewSplitListener>();

  private static instance: SCBSceneWindowAiSplitSwitchUtils;
  private primaryAppBundleName: string = '';
  private primaryAppModuleName: string = '';
  private primaryAppAbilityName: string = '';
  private secondaryAppBundleName: string = '';
  private secondaryAppModuleName: string = '';
  private secondaryAppAbilityName: string = '';
  private isSharingIntent: boolean = false;
  private primaryAppSceneInfo: SCBSceneInfo | null = null;
  private secondaryAppSceneInfo: SCBSceneInfo | null = null;
  private aiSceneState: AiSceneState = AiSceneState.INITIAL_STATE;
  private frequentControlTimer: number = -1;
  private intentTimer: number = -1;
  private isTiming: boolean = false;
  private switchType: SwitchType = SwitchType.INVALID;
  private fromSceneInfo: SCBSceneInfo | null = null;
  private toSceneInfo: SCBSceneInfo | null = null;
  private isShowingIntent: boolean = false;
  private rateLimitLock: boolean = false;
  // private viewSplitScreen: insightIntent.InsightIntent | null = null;

  /**
   * Constructor of SCBSceneWindowAiSplitSwitchUtils
   */
  constructor() {
  }

  /**
   * Get the singleton of class SCBSceneWindowAiSplitSwitchUtils
   *
   * @return SCBSceneWindowAiSplitSwitchUtils singleton
   */
  public static getInstance(): SCBSceneWindowAiSplitSwitchUtils {
    if (!SCBSceneWindowAiSplitSwitchUtils.instance) {
      SCBSceneWindowAiSplitSwitchUtils.instance = new SCBSceneWindowAiSplitSwitchUtils();
    }
    return SCBSceneWindowAiSplitSwitchUtils.instance;
  }

  /**
   * Set the value of isSharingIntent
   *
   * @return isSharingIntent is sharing intent or not
   */
  public getIsSharingIntent(): boolean {
    log.showInfo(TAG, `get IsSharingIntent ${this.isSharingIntent}`);
    return this.isSharingIntent;
  }

  /**
   * Set the value of isSharingIntent
   *
   * @param isSharingIntent is sharing intent or not
   */
  public setIsSharingIntent(isSharingIntent: boolean): void {
    log.showInfo(TAG, `set IsSharingIntent as ${isSharingIntent}`);
    this.isSharingIntent = isSharingIntent;
    if (isSharingIntent) {
      setTimeout(() => {
        log.showInfo(TAG, `timeout set isSharingIntent as false`);
        this.isSharingIntent = false;
      }, INTENT_WAITING_TIME);
    }
  }

  public getRateLimitLock(): boolean {
    log.showInfo(TAG, `get rateLimitLock ${this.rateLimitLock}`);
    return this.rateLimitLock;
  }

  public setRateLimitLock(rateLimitLock: boolean): void {
    log.showInfo(TAG, `set rateLimitLock as ${rateLimitLock}`);
    this.rateLimitLock = rateLimitLock;
    if (rateLimitLock) {
      setTimeout(() => {
        log.showInfo(TAG, `timeout set rateLimitLock as false`);
        this.rateLimitLock = false;
      }, INTENT_WAITING_TIME);
    }
  }

  /**
   * Notify the listener of class SCBSceneWindowAiSplitSwitchUtils to split screen
   *
   */
  public notifyListenerToSplitScreen(): void {
    this.isShowingIntent = false;
    this.viewSplitListenerList.forEach((listener) => {
      if (this.switchType === SwitchType.NATURAL_SWITCH) {
        if (!this.fromSceneInfo || !this.toSceneInfo) {
          log.showWarn(TAG, '[notifyListenerToSplitScreen] get app sceneInfo null');
          return;
        }
        listener.viewSplitScreen(this.fromSceneInfo, this.toSceneInfo, this.switchType);
        this.endAiSplitSwitchHandler();
      } else if (this.switchType === SwitchType.FREQUENT_SWITCH) {
        if (!this.primaryAppSceneInfo || !this.secondaryAppSceneInfo) {
          log.showWarn(TAG, '[notifyListenerToSplitScreen] get app sceneInfo null');
          return;
        }
        listener.viewSplitScreen(this.primaryAppSceneInfo, this.secondaryAppSceneInfo, this.switchType);
        this.endAiSplitSwitchHandler();
      } else {
        log.showWarn(TAG, '[notifyListenerToSplitScreen] invalid switch type');
      }
    });
  }

  /**
   * Notify the listener of class SCBSceneWindowAiSplitSwitchUtils to set split intent
   *
   * @param primaryAppSceneInfo primary App's sceneInfo
   * @param secondaryAppSceneInfo secondary App's sceneInfo
   */
  public notifyListenerToSetIntent(primaryAppSceneInfo: SCBSceneInfo, secondaryAppSceneInfo: SCBSceneInfo): void {
    let primaryAppBundleName: string = primaryAppSceneInfo.bundleName;
    let secondaryAppBundleName: string = secondaryAppSceneInfo.bundleName;
    log.showInfo(TAG, `[notifyListenerToSetIntent] (${this.viewSplitListenerList.length}) bundle Name: ` +
      `${primaryAppBundleName}, ${secondaryAppBundleName}`);
    this.viewSplitListenerList.forEach((listener) => {
      listener.setSplitIntentByFrequentSwitch(primaryAppSceneInfo, secondaryAppSceneInfo);
    });
  }

  /**
   * Add listener of class SCBSceneWindowAiSplitSwitchUtils
   *
   * @param listener the listener needs to add.
   */
  public addViewSplitListener(listener: ViewSplitListener): void {
    log.showInfo(TAG, 'add a new viewSplitListener');
    this.viewSplitListenerList.add(listener);
  }

  /**
   * Delete listener of class SCBSceneWindowAiSplitSwitchUtils
   *
   * @param listener the listener needs to delete.
   */
  public removeViewSplitListener(listener: ViewSplitListener): void {
    log.showInfo(TAG, 'remove a new viewSplitListener');
    this.viewSplitListenerList.remove(listener);
  }

  /**
   * Judge whether the current window is target scene
   *
   * @return if is target scene
   */
  public isTargetScene(): boolean {
    let isPad: boolean = DeviceHelper.isPad();
    if (isPad) {
      log.showInfo(TAG, '[isTargetScene] is pad product');
      return true;
    }
    let isLargeInFoldProduct: boolean = DeviceHelper.isLargeInFoldProduct();
    if (isLargeInFoldProduct && DeviceHelper.isFoldExpandedOrHalf()) {
      log.showInfo(TAG, '[isTargetScene] is large fold product and expand status');
      return true;
    }
    let isThreeFoldProduct: boolean = DeviceHelper.isThreeFoldProduct();
    if (isThreeFoldProduct) {
      let currentFoldStatus: SCBTripleFoldState = SCBTriFoldManager.getInstance().getCurTriFoldState();
      // expand foldStatus for three fold product: M or G state
      if (currentFoldStatus === SCBTripleFoldState.M) {
        log.showInfo(TAG, '[isTargetScene] is three fold product and M status');
        return true;
      }
      if (currentFoldStatus === SCBTripleFoldState.G) {
        log.showInfo(TAG, '[isTargetScene] is three fold product and G status');
        return true;
      }
    }
    log.showInfo(TAG, '[isTargetScene] not target scene');
    return false;
  }

  /**
   * Judge whether the current scene of window switch is the scene of natural switch
   *
   * @return if is natural scene
   */
  public isNaturalScene(fromSceneInfo: SCBSceneInfo, toSceneInfo: SCBSceneInfo): boolean {
    let fromWindowMode: SCBSceneMode = fromSceneInfo.windowMode;
    let toWindowMode: SCBSceneMode = toSceneInfo.windowMode;
    log.showInfo(TAG, `[isNaturalScene] fromWindowMode: ${fromWindowMode}, toWindowMode: ${toWindowMode}`);
    if (fromWindowMode === SCBSceneMode.FULLSCREEN && toWindowMode === SCBSceneMode.FULLSCREEN) {
      return true && !this.getRateLimitLock();
    }
    return false;
  }

  /**
   * Judge whether the current scene allows spliting window
   *
   * @return isSplitScene
   */
  public isSplitScene(): boolean {
    log.showInfo(TAG, `[isSplitScene] isTiming: ${this.isTiming}, current aiSceneState: ${this.aiSceneState}`);
    if (this.aiSceneState === AiSceneState.SECOND_A && !this.isTiming) {
      return true;
    }
    return false;
  }

  /**
   * Initialize or refresh frequently switched scene as container state changed
   *
   * @param appContainerSession App's containerSession
   */
  public startAiSplitSwitchHandlerByContainer(appContainerSession: SCBSceneContainerSession): void {
    if (!appContainerSession) {
      log.showWarn(TAG, 'cannot start AI split by container: containerSession is null');
      return;
    }
    let appSceneSession: SCBSceneSession | null = appContainerSession.primarySession;
    if (!appSceneSession) {
      log.showWarn(TAG, 'cannot start AI split by container: sceneSession is null');
      return;
    }
    let appSceneInfo: SCBSceneInfo | null = appSceneSession.sceneInfo;
    if (!appSceneInfo) {
      log.showWarn(TAG, 'cannot start AI split by container: sceneInfo is null');
      return;
    }
    this.startAiSplitSwitchHandler(appSceneInfo, appSceneSession.isSupportSplitMode());
  }

  /**
   * Initialize or refresh frequently switched scene
   *
   * @param appSceneInfo App's sceneInfo
   */
  public startAiSplitSwitchHandler(appSceneInfo: SCBSceneInfo, isSupportSplitMode: boolean): void {
    if (!AI_SPLIT_FREQUENT_SWITCH_ENABLE) {
      log.showWarn(TAG, '[START] frequent switch not enabled');
      return;
    }
    let bundleName: string = appSceneInfo.bundleName;
    let moduleName: string = appSceneInfo.moduleName;
    let abilityName: string = appSceneInfo.abilityName;
    log.showInfo(TAG, `[START] bundleName: ${bundleName}, moduleName: ${moduleName}, ` +
      `abilityName: ${abilityName}, is support split: ${isSupportSplitMode}`);
    if (this.isShowingIntent) {
      log.showInfo(TAG, '[START] is showing intent, no need to start');
      return;
    }
    if (!isSupportSplitMode) {
      this.endAiSplitSwitchHandler();
      return;
    }
    let checkResult: boolean = this.validityCheck(bundleName, moduleName, abilityName, appSceneInfo);
    if (!checkResult) {
      log.showWarn(TAG, '[START] check validity failed');
      return;
    }
    let isNeedTurnToNextState: boolean = this.isNeedTurnToNextState(bundleName);
    log.showInfo(TAG, `[START] is need turn to next state: ${isNeedTurnToNextState}`);
    if (isNeedTurnToNextState) {
      this.setNextAiSceneState(bundleName, moduleName, abilityName, appSceneInfo);
    }
  }

  /**
   * Exit frequently switched scene
   *
   */
  public endAiSplitSwitchHandler(): void {
    log.showInfo(TAG, '[END] release switch handler');
    if (this.isShowingIntent) {
      log.showInfo(TAG, '[END] showing intent, no need to release handler');
      return;
    }
    this.setSwitchType(SwitchType.INVALID);
    this.clearAllSavedInfo();
    this.clearTimer();
  }

  /**
   * Exit frequently switched scene from SCBSceneContainer
   *
   * @param containerState the current SCBSceneContainerState
   */
  public endAiSplitSwitchHandlerByContainerState(containerState: SCBSceneContainerState): void {
    log.showInfo(TAG, `[END] release switch handler: containerState ${containerState}`);
    if ((this.aiSceneState === AiSceneState.FIRST_A || (this.aiSceneState === AiSceneState.FIRST_B &&
      !this.isTiming)) && (containerState === SCBSceneContainerState.RECENT ||
      containerState === SCBSceneContainerState.HIDDEN)) {
      log.showInfo(TAG, '[END] no need to end');
      return;
    }
    this.endAiSplitSwitchHandler();
  }

  /**
   * Proceed AI split switch by state change
   *
   * @param oldState the last ScreenState
   * @return newState the next ScreenState
   */
  public AiSplitSwitchByStateChange(oldState: ScreenState, newState: ScreenState): void {
    log.showInfo(TAG, `[AiSplitSwitch] screen state change ${oldState} -> ${newState}`);
    // 三折叠M/G态切换不影响前台判定，不作处理
    if ((oldState === ScreenState.G || oldState === ScreenState.M) && newState === ScreenState.F) {
      this.endAiSplitSwitchHandler();
    }
  }

  /**
   * Proceed AI split switch by screen property change
   *
   * @param reason the reason of screen property change
   */
  public AiSplitSwitchByPropertyChange(reason: SCBPropertyChangeReason): void {
    log.showInfo(TAG, `[AiSplitSwitch] screen property change ${reason}`);
    if (reason === SCBPropertyChangeReason.EXPAND_TO_FOLD && DeviceHelper.isLargeInFoldProduct()) {
      this.endAiSplitSwitchHandler();
    }
  }

  /**
   * Set AI split screen's type
   *
   * @param switchType the type of AI split scene
   */
  public setSwitchType(switchType: SwitchType): void {
    log.showInfo(TAG, `set switch type as ${switchType}`);
    this.switchType = switchType;
  }

  /**
   * Get AI split screen's type
   *
   * @return switchType is Natural or Frequent or Invalid
   */
  public getSwitchType(): SwitchType {
    log.showInfo(TAG, `get switch type ${this.switchType}`);
    return this.switchType;
  }

  /**
   * Save sceneInfo of natural split screen
   *
   * @param fromSceneInfo the sceneInfo of last app
   * @param toSceneInfo the sceneInfo of next app
   */
  public saveNaturalSceneInfo(fromSceneInfo: SCBSceneInfo, toSceneInfo: SCBSceneInfo): void {
    this.fromSceneInfo = fromSceneInfo;
    this.toSceneInfo = toSceneInfo;
  }

  // public processShareIntent(viewSplitScreen: insightIntent.InsightIntent): void {
  //   this.isShowingIntent = true;
  //   clearTimeout(this.intentTimer);
  //   this.intentTimer = setTimeout(() => {
  //     if (this.isShowingIntent) {
  //       log.showInfo(TAG, '[getIntent] intent-showing is time out');
  //       this.isShowingIntent = false;
  //       this.endAiSplitSwitchHandler();
  //     }
  //   }, INTENT_SHOWING_TIME);
  //   this.viewSplitScreen = viewSplitScreen;
  // }

  // public getDeleteIntent(): insightIntent.InsightIntent {
  //   log.showInfo(TAG, `[getIntent] get delete intent: ${this.viewSplitScreen?.intentEntityInfo.entityId}`);
  //   if (!this.viewSplitScreen) {
  //     return;
  //   }
  //   this.viewSplitScreen.intentEntityInfo.eventType = 'ExitScene';
  //   return this.viewSplitScreen;
  // }

  /**
   * Delete intent of spliting window
   */
  // public deleteSplitIntent(): void {
  //   try {
  //     let viewSplitScreen: insightIntent.InsightIntent = this.getDeleteIntent();
  //     let context: common.ServiceExtensionContext = GlobalContext.getContext() as common.ServiceExtensionContext;
  //     if (viewSplitScreen && context) {
  //       insightIntent.shareIntent(context, [viewSplitScreen]).then(() => {
  //         this.viewSplitScreen = null;
  //         log.showInfo(TAG, '[SCBSplit] shareDeleteIntent succeed');
  //       }).catch((err: BusinessError) => {
  //         log.showError(TAG, `[SCBSplit] shareDeleteIntent error.code: ${err?.code}, failed because ${err?.message}`);
  //       });
  //     }
  //   } catch (error) {
  //     log.showError(TAG, `[SCBSplit] error.code: ${error?.code}, error.message: ${error?.message}`);
  //   }
  // }

  public deleteIntentInRequestActivation(sceneInfo: SCBSceneInfo): void {
    if (this.switchType === SwitchType.FREQUENT_SWITCH) {
      if (sceneInfo.bundleName !== this.primaryAppBundleName || sceneInfo.windowMode !== SCBSceneMode.FULLSCREEN) {
        this.notifyListenerToDeleteIntent();
      }
    }
    if (this.switchType === SwitchType.NATURAL_SWITCH) {
      if (sceneInfo.bundleName !== this.toSceneInfo?.bundleName || sceneInfo.windowMode !== SCBSceneMode.FULLSCREEN) {
        this.notifyListenerToDeleteIntent();
      }
    }
  }

  /**
   * Proceed AI split switch from SceneSession
   *
   * @param windowMode the current windowMode
   * @param sceneInfo the current sceneInfo
   * @param isSupportFloating whether the app supports floating or not
   */
  public aiSplitSwitchBySceneSession(windowMode: SCBSceneMode, sceneInfo: SCBSceneInfo,
    isSupportSplitMode: boolean): void {
    if(!sceneInfo) {
      log.showWarn(TAG, 'sceneInfo is null');
      return;
    }
    let isTargetScene: boolean = this.isTargetScene();
    if (isTargetScene && !this.isShowingIntent) {
      if (windowMode === SCBSceneMode.FULLSCREEN) {
        this.startAiSplitSwitchHandler(sceneInfo, isSupportSplitMode);
      } else {
        this.endAiSplitSwitchHandler();
      }
    }
  }

  /**
   * Get current switch type
   *
   * @return switchTypeName
   */
  public getAiSplitReason(): AiSplitReason {
    if (this.switchType === SwitchType.NATURAL_SWITCH) {
      return AiSplitReason.NATURAL_SWITCH;
    }
    if (this.switchType === SwitchType.FREQUENT_SWITCH) {
      return AiSplitReason.FREQUENT_SWITCH;
    }
    return AiSplitReason.INVALID;
  }

  /**
   * Start scene of natural switch
   *
   * @param fromSceneInfo left App's sceneInfo
   * @param toSceneInfo right App's sceneInfo
   */
  public startNaturalSwitchScene(fromSceneInfo: SCBSceneInfo, toSceneInfo: SCBSceneInfo): void {
    setTimeout(() => {
      this.viewSplitListenerList.forEach((listener) => {
        listener.setSplitIntentByNaturalSwitch(fromSceneInfo, toSceneInfo);
      });
    }, NATURAL_SWITCH_TIME);
  }

  /**
   * Judge whether need to share intent as natural switch or not
   *
   * @param fromSceneInfo left App's sceneInfo
   * @param toSceneInfo right App's sceneInfo
   * @param topSceneInfo current top App's sceneInfo
   * @return is need to share intent as natural switch
   */
  public isNeedToShareIntentAsNaturalSwitch(fromSceneInfo: SCBSceneInfo, toSceneInfo: SCBSceneInfo,
    containerSession: SCBSceneContainerSession | null): boolean {
    if (!toSceneInfo.want?.parameters) {
      log.showWarn(TAG, 'toSceneInfo parameters is null');
      return false;
    }
    let parameters = toSceneInfo.want?.parameters;
    let uiExtensionTargetType = parameters['ability.want.params.uiExtensionTargetType'];
    let launchReasonMessage = parameters['ohos.params.launchReasonMessage'];
    let uriHeader = toSceneInfo.want?.uri?.split(':')[0];
    log.showInfo(TAG, `uiExtensionTargetType: ${uiExtensionTargetType}` +
      `, launchReasonMessage ${launchReasonMessage}, uriHeader ${uriHeader}`);
    if (!uiExtensionTargetType && launchReasonMessage !== 'ReasonMessage_SystemShare' &&
      !['mailto', 'file', 'maps'].includes(uriHeader ?? '')) {
      log.showWarn(TAG, 'Not satisfied with the pull-up scene');
      return false;
    }
    if (!containerSession) {
      log.showWarn(TAG, 'cannot share intent as natural switch: top containerSession is null');
      return false;
    }
    let sceneSession: SCBSceneSession | null = containerSession.primarySession;
    if (!sceneSession) {
      log.showWarn(TAG, 'cannot share intent as natural switch: top sceneSession is null');
      return false;
    }
    let topSceneInfo: SCBSceneInfo | null = sceneSession.sceneInfo;
    if (!topSceneInfo) {
      log.showWarn(TAG, 'cannot share intent as natural switch: top sceneInfo is null');
      return false;
    }
    log.showInfo(TAG, `toSceneInfo: ${toSceneInfo.bundleName}, topSceneInfo ${topSceneInfo.bundleName}`);
    if (topSceneInfo.bundleName === toSceneInfo.bundleName) {
      return true;
    }
    return false;
  }

  private clearSavedPrimaryInfo(): void {
    this.primaryAppBundleName = '';
    this.primaryAppModuleName = '';
    this.primaryAppAbilityName = '';
    this.primaryAppSceneInfo = null;
  }

  private clearSavedSecondaryInfo(): void {
    this.secondaryAppBundleName = '';
    this.secondaryAppModuleName = '';
    this.secondaryAppAbilityName = '';
    this.secondaryAppSceneInfo = null;
  }

  private setAppInfoToPrimary(bundleName: string, moduleName: string, abilityName: string,
    sceneInfo: SCBSceneInfo): void {
    this.primaryAppBundleName = bundleName;
    this.primaryAppModuleName = moduleName;
    this.primaryAppAbilityName = abilityName;
    this.primaryAppSceneInfo = sceneInfo;
  }

  private writeAppInfoToSecondary(bundleName: string, moduleName: string, abilityName: string,
    sceneInfo: SCBSceneInfo): void {
    this.secondaryAppBundleName = bundleName;
    this.secondaryAppModuleName = moduleName;
    this.secondaryAppAbilityName = abilityName;
    this.secondaryAppSceneInfo = sceneInfo;
  }

  private resetAiSceneState(): void {
    this.aiSceneState = AiSceneState.INITIAL_STATE;
  }

  private clearTimer(): void {
    if (this.frequentControlTimer >= 0) {
      clearTimeout(this.frequentControlTimer);
      this.isTiming = false;
    }
  }

  private setStepFirst(bundleName: string, moduleName: string, abilityName: string,
    sceneInfo: SCBSceneInfo): void {
    this.aiSceneState = AiSceneState.FIRST_A;
    this.clearSavedAppInfo();
    this.setAppInfoToPrimary(bundleName, moduleName, abilityName, sceneInfo);
    this.clearTimer();
  }

  private insertSecondaryBackward(bundleName: string, moduleName: string, abilityName: string,
    sceneInfo: SCBSceneInfo): void {
    this.primaryAppBundleName = this.secondaryAppBundleName;
    this.primaryAppModuleName = this.secondaryAppModuleName;
    this.primaryAppAbilityName = this.secondaryAppAbilityName;
    this.primaryAppSceneInfo = this.secondaryAppSceneInfo;
    this.clearSavedSecondaryInfo();
    this.writeAppInfoToSecondary(bundleName, moduleName, abilityName, sceneInfo);
  }

  private startTiming(timerType: TimerType): void {
    this.clearTimer();
    if (timerType === TimerType.INVALID) {
      log.showWarn(TAG, '[Timer] TimerType is invalid');
      return;
    }
    log.showInfo(TAG, `[Timer] start Timer ${timerType}`);
    this.isTiming = true;
    this.frequentControlTimer = setTimeout(() => {
      if (timerType === TimerType.PRIMARY_TIMER) {
        log.showInfo(TAG, '[Timer] Primary Timer is time out');
      }
      if (timerType === TimerType.SECONDARY_TIMER) {
        log.showInfo(TAG, '[Timer] Secondary Timer is time out');
        this.notifyAiSplit();
      }
      this.isTiming = false;
    }, FREQUENT_SWITCH_TIME);
  }

  private setNextAiSceneState(bundleName: string, moduleName: string, abilityName: string,
    sceneInfo: SCBSceneInfo): void {
    if (this.isTiming) {
      log.showInfo(TAG, '[setNextAiSceneState] interrupt as isTiming');
      this.setStepFirst(bundleName, moduleName, abilityName, sceneInfo);
      return;
    }
    if (this.aiSceneState === AiSceneState.INITIAL_STATE) {
      log.showInfo(TAG, '[setNextAiSceneState] INITIAL_STATE -> FIRST_A');
      this.setStepFirst(bundleName, moduleName, abilityName, sceneInfo);
      return;
    }
    if (this.aiSceneState === AiSceneState.FIRST_A) {
      log.showInfo(TAG, '[setNextAiSceneState] FIRST_A -> FIRST_B');
      this.aiSceneState = AiSceneState.FIRST_B;
      this.clearSavedSecondaryInfo();
      this.writeAppInfoToSecondary(bundleName, moduleName, abilityName, sceneInfo);
      this.startTiming(TimerType.PRIMARY_TIMER);
      return;
    }
    if (this.aiSceneState === AiSceneState.FIRST_B) {
      if (bundleName !== this.primaryAppBundleName) {
        // at step FIRST_B, if user opened App C, then refresh as B -> C -> (B)
        log.showInfo(TAG, '[setNextAiSceneState] FIRST_B -> FIRST_B');
        this.insertSecondaryBackward(bundleName, moduleName, abilityName, sceneInfo);
        this.startTiming(TimerType.PRIMARY_TIMER);
      } else {
        // A -> B -> A: to next step SECOND_A
        log.showInfo(TAG, '[setNextAiSceneState] FIRST_B -> SECOND_A');
        this.aiSceneState = AiSceneState.SECOND_A;
        this.startTiming(TimerType.SECONDARY_TIMER);
      }
      return;
    }
    // refresh infos of App A and B, as switch Apps more than twice
    if (this.aiSceneState === AiSceneState.SECOND_A) {
      if (bundleName !== this.secondaryAppBundleName) {
        // A -> B -> A -> C: refresh as A -> C -> (A)
        this.aiSceneState = AiSceneState.FIRST_B;
        log.showInfo(TAG, '[setNextAiSceneState] SECOND_A -> FIRST_B');
        this.clearSavedSecondaryInfo();
        this.writeAppInfoToSecondary(bundleName, moduleName, abilityName, sceneInfo);
        this.startTiming(TimerType.PRIMARY_TIMER);
      } else {
        // A -> B -> A -> B: refresh as B -> A -> (B)
        log.showInfo(TAG, '[setNextAiSceneState] SECOND_A -> SECOND_A');
        this.insertSecondaryBackward(bundleName, moduleName, abilityName, sceneInfo);
        this.startTiming(TimerType.SECONDARY_TIMER);
      }
      return;
    }
  }

  private validityCheck(bundleName: string, moduleName: string, abilityName: string,
    appSceneInfo: SCBSceneInfo): boolean {
    if (!bundleName || !moduleName || !abilityName || !appSceneInfo) {
      log.showWarn(TAG, '[validityCheck] name invalid');
      return false;
    }
    return true;
  }

  private isNeedTurnToNextState(bundleName: string): boolean {
    if (this.aiSceneState === AiSceneState.INITIAL_STATE) {
      return true;
    }
    if (this.aiSceneState === AiSceneState.FIRST_A && bundleName !== this.primaryAppBundleName) {
      return true;
    }
    if (this.aiSceneState === AiSceneState.FIRST_B && bundleName !== this.secondaryAppBundleName) {
      return true;
    }
    if (this.aiSceneState === AiSceneState.SECOND_A && bundleName !== this.primaryAppBundleName) {
      return true;
    }
    return false;
  }

  private notifyAiSplit(): void {
    log.showInfo(TAG, `[notifyAiSplit] App: ${this.primaryAppBundleName} and ${this.secondaryAppBundleName}`);
    if (this.primaryAppBundleName === this.secondaryAppBundleName) {
      log.showWarn(TAG, `[SCBSplit] same app, cannot notifyAiSplit`);
      return;
    }
    if (!this.getRateLimitLock()) {
      this.setSwitchType(SwitchType.FREQUENT_SWITCH);
      this.notifyListenerToSetIntent(this.primaryAppSceneInfo, this.secondaryAppSceneInfo);
      this.setRateLimitLock(true);
    }
  }

  private clearSavedAppInfo(): void {
    this.clearSavedPrimaryInfo();
    this.clearSavedSecondaryInfo();
  }

  private clearAllSavedInfo(): void {
    this.clearSavedAppInfo();
    this.resetAiSceneState();
    // this.viewSplitScreen = null;
  }

  private notifyListenerToDeleteIntent(): void {
    this.viewSplitListenerList.forEach((listener) => {
      listener.deleteSplitIntent();
    });
  }
}