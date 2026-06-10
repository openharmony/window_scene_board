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
import {
  sEventManager,
  localEventManager
} from '@ohos/frameworkwrapper';
import {
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  SCBScreenSession,
  SCBSceneContainerSessionArray,
  sSCBOobeManager,
  SCBSceneSession,
  SCBSpecificSession,
  SCBSystemSceneSession,
  DisplayMgr,
  SCBKeyboardManager,
  SCBRootSceneSession,
  SCBScreenSessionArray,
  OOBE_CHANGE_EVENT
} from '@ohos/windowscene';
import { EventConstants, } from '@ohos/launchercommon';
import { SCBScreen } from '@ohos/pcbase/src/main/ets/SceneBoard/scenemanager/SCBScreen';
import { CommonStyleManager, SystemUIInitiator } from '@ohos/systemuicommon';
import commonEventManager from '@ohos.commonEventManager';
import { MultiInputViewModel, multiInputManager } from '@ohos/multiinput';
import PcStage from '@ohos/pcbase/src/main/ets/common/PcStage';
import {EsDockEventManager} from '@ohos/pcsmartdock';
import { sPcModeUtils } from '@ohos/pcmode/src/main/ets/utils/SCBPcModeUtils';
import { BusinessError, power, systemParameterEnhance } from '@kit.BasicServicesKit';
import screenSessionManager from '@ohos.screenSessionManager';
import { SCBPcScenePanelManager, SwipeGestureManager, } from '@ohos/pcmode';
import {DesktopSwitchController} from '@ohos/pcbase/src/main/ets/SceneBoard/virtualmachine/DesktopSwitchController';

const TAG = 'SCBEntryView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const CUSTOM_SCB_SCREEN: string = 'CustomScbScreen';

let storage = LocalStorage.GetShared();
const REFRESH_DESKTOP_INTERVAL = 200;

let that: EntryView;

@Entry(storage)
@Component
struct EntryView {
  private rootSceneSession: SCBRootSceneSession = SCBSceneSessionManager.getInstance().getRootSceneSession();
  @State
  screenSessionList: SCBScreenSessionArray = new SCBScreenSessionArray();
  @StorageLink('AppCenterItemPosX')
  appItemPosX: number[] = [];
  @StorageLink('AppCenterItemPosY')
  appItemPosY: number[] = [];
  @StorageLink('AppCenterItemOpacity')
  appItemOpacity: number[] = [];
  @StorageLink('AppCenterBkBlur')
  bkBlur: number = 0;
  @StorageLink('AppCenterBkOpacity')
  bkOpacity: number = 0;
  @StorageLink('isLock') @Watch('onLock')
  isLock: boolean = true;
  @StorageLink('accountSwitch') @Watch('onUserSwitch')
  accountSwitch: boolean = false;
  private mMultiInputViewModel: MultiInputViewModel | null = null;
  private mSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private mStage: PcStage = new PcStage();
  private mPowerSaveSubscriber: commonEventManager.CommonEventSubscriber | null = null;

  aboutToAppear() {
    log.showInfo('aboutToAppear');

    // Configuration Initialized
    that = this;

    // 原来在StatusBar/DropdownPanel等处setAbilityPageName会相互覆盖，导致Style不对
    CommonStyleManager.setAbilityPageName(TAG);
    SCBScreenSessionManager.getInstance().setScreenSessionList(this.screenSessionList);
    this.registerScreenConnectionListener();
    this.mStage.onCreate();

    // Register Multi modal event listener
    this.mMultiInputViewModel = MultiInputViewModel.getInstance();
    SCBSceneSessionManager.getInstance().registerRequestFocusCallback(this.onRequestFocus);
    multiInputManager.registerInputEvent();

    // Subscribe common event - screen lock for the multi finger pinch event listener registration
    this.subscribeMultiFingerPinchEvent();
    this.mPowerSaveSubscribe();

    // systemUI组件初始化baseState
    SystemUIInitiator.init();

    this.setSystemParameter();
  }

  private setSystemParameter(): void {
    try {
      log.showInfo('set system parameter');
      systemParameterEnhance.setSync('persist.ace.title.style.enabled', 'true');
    } catch (error) {
      log.showError(`set system parameter failed, errror: ${error?.code}-${error?.message}`);
    }
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');

    // Unregister Multi modal event listener
    this.mMultiInputViewModel?.unregisterEventListener();

    // Unsubscribe common event - screen lock for the multi finger pinch event listener registration
    this.unsubscribeMultiFingerPinchEvent();
    this.mPowerSaveUnsubscribe();

    this.mStage.onDestroy();
  }

  private mPowerSaveSubscribe(): void {
    this.eventWhenPowerModeChange();
    let powerSaveSubscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [
        commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED
      ]
    };
    this.mPowerSaveSubscriber = commonEventManager.createSubscriberSync(powerSaveSubscribeInfo);
    if (this.mPowerSaveSubscriber !== null) {
      commonEventManager.subscribe(this.mPowerSaveSubscriber,
        (err: BusinessError, data: commonEventManager.CommonEventData): void => {
          if (err) {
            log.showError(`Can't handle common event, err: ${err.code}, err: ${err.message}`);
            return;
          }
          if (data.event === commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED) {
            this.eventWhenPowerModeChange(data);
          }
        });
    } else {
      log.showError(`Need create powerSaveSubscriber!`);
    }
  }

  private mPowerSaveUnsubscribe(): void {
    commonEventManager.unsubscribe(this.mPowerSaveSubscriber, (err:ESObject) => {
      if (err != null) {
        log.showInfo(`unSubscriber failure ${(err as BusinessError).code}:${(err as BusinessError).message}`);
      } else {
        log.showInfo('unSubscriber success');
      }
    });
  }

  private eventWhenPowerModeChange(data: commonEventManager.CommonEventData | undefined = undefined): void {
    let curPowerMode: power.DevicePowerMode = data && data.code !== undefined ? data.code : this.getPowerMode();
    log.showInfo(`Received power save mode change notification, curPowerMode: ${curPowerMode}`);
    if (curPowerMode === power.DevicePowerMode.MODE_POWER_SAVE) {
      SCBSceneSessionManager.getInstance().setBehindWindowFilterEnabled(false);
    } else {
      SCBSceneSessionManager.getInstance().setBehindWindowFilterEnabled(true);
    }
  }

  private getPowerMode(): power.DevicePowerMode {
    let curPowerMode: power.DevicePowerMode = power.DevicePowerMode.MODE_NORMAL;
    try {
      curPowerMode = power.getPowerMode();
    } catch (err) {
      log.showError(`Get device power mode failed , err: ${err.code}, errMessage: ${err.message}`);
    }
    return curPowerMode;
  }

  onPageShow() {
    log.showInfo('EntryView onPageShow');

    // In order to avoid timing issues caused by recovery containerSceneSession, start the recovery process from here
    SCBSceneSessionManager.getInstance().setStartRecovery(true);
  }

  /**
   * 锁屏解锁事件订阅
   */
  private subscribeMultiFingerPinchEvent(): void {
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [commonEventManager.Support.COMMON_EVENT_SCREEN_LOCKED,
        commonEventManager.Support.COMMON_EVENT_SCREEN_UNLOCKED]
    }

    try {
      commonEventManager.createSubscriber(subscribeInfo, (err:ESObject, data:ESObject) => {
        // Ignore create subscribe when error happens
        if (err) {
          log.showError(`Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
          return;
        }

        // Initialize subscriber info
        this.mSubscriber = data;

        // Subscribe message now
        try {
          commonEventManager.subscribe(this.mSubscriber, (err:ESObject, data:ESObject) => {
            // Ignore exception
            if (err) {
              log.showError(`Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
              return;
            }

            log.showInfo('receive event data, event:%{public}s', data.event);
          });
        } catch (error) {
          log.error('commonEventManager subscribe error', error);
        }
      });
    } catch (error) {
      log.error('commonEventManager createSubscriber error', error);
    }

    // Listen for oobe data change
    if (sSCBOobeManager.isEnable()) {
      log.showInfo('in oobe subscribe OOBE_CHANGE_EVENT');

      sEventManager.subscribe(OOBE_CHANGE_EVENT, (enable: boolean) => {
        if (!enable) {
          try {
            AppStorage.setOrCreate('isLock', false);
          } catch (error) {
            log.showError('oobe inputMonitor on error', error);
          }
        }
      });
    }
  }

  /**
   * 取消锁屏解锁事件订阅
   */
  private unsubscribeMultiFingerPinchEvent():void {
    if (this.mSubscriber) {
      try {
        commonEventManager.unsubscribe(this.mSubscriber);
        this.mSubscriber = null;
      } catch (error) {
        log.error('aboutToDisappear commonEventManager unsubscribe error', error);
      }
    }
  }

  /**
   *
   * 根据焦点事件自动获焦
   *
   * @param scbSession
   * @param scbSession
   * @param scbSession
   */
  private onRequestFocus(scbSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession): void {
    log.showDebug(`onRequestFocus: ${scbSession.session.persistentId}`);
    focusControl.requestFocus(`session${scbSession.session.persistentId}`);
  }

  private registerScreenConnectionListener(): void {
    SCBScreenSessionManager.getInstance().registerScreenConnectionListener({
      onScreenConnect: (session) => this.onScreenConnect(session),
      onScreenDisconnect: (screenId, displayGroupId) => this.onScreenDisconnect(screenId, displayGroupId),
    });

    SCBScreenSessionManager.getInstance().registerScreenModeChangeListener({
      onScreenModeChange: (mainScreenId, extendScreenId) => this.onScreenModeChange(mainScreenId, extendScreenId)
    })
  }

  private onScreenModeChange(mainScreenId: number, extendScreenId: number): void {
    for (let i = 0; i < this.screenSessionList.length; ++i) {
      let screenSession = this.screenSessionList[i];
      if (screenSession.session.screenId == mainScreenId) {
        screenSession.setScreenExtendStatus(false);
        screenSession.setScreenMainStatus(true);
        SCBSceneSessionManager.getInstance().mainScreenId = screenSession.session.screenId;
      }
      if (screenSession.session.screenId == extendScreenId) {
        screenSession.setScreenExtendStatus(true);
        screenSession.setScreenMainStatus(false);
      }
      log.showInfo('On screen mode change screenId: ' + screenSession.session.screenId + '; isExtendScreen: ' +
        screenSession.isExtendScreen + '; isMainScreen:' + screenSession.isMainScreen);
    }
    this.handleDesktopRefresh();

    EsDockEventManager.getInstance().handleScreenModeChange(mainScreenId, extendScreenId);
    SCBKeyboardManager.getInstance().keyboardStateChangeForPCScreenModeChange(mainScreenId);
  }

    private traversesAndResetScreenMode(screenSession: SCBScreenSession): void {
    let isExtendScreen = screenSession.isExtendScreen;
    if (isExtendScreen) {
      return;
    }
    if (screenSession.session.name === 'DevEcoViewer') {
      return;
    }
    if (screenSession.session.innerName === CUSTOM_SCB_SCREEN) {
      return;
    }
    for (let i = 0; i < this.screenSessionList.length; ++i) {
      let sessionItem = this.screenSessionList[i];
      if (sessionItem.isMainScreen) {
        sessionItem.setScreenMainStatus(false);
        sessionItem.setScreenExtendStatus(true);
        break;
      }
    }
  }

  private onScreenConnect(screenSession: SCBScreenSession): void {
    log.showInfo('onScreenConnect isExtend: ' + screenSession.session.isExtend + '; screenId:' +
      screenSession.session.screenId);
    this.addScreenSession(screenSession);

    if (screenSession.session.innerName === CUSTOM_SCB_SCREEN) {
      let para: Record<string, SCBScreenSession> = { 'screenSession': screenSession };
      let storage: LocalStorage = new LocalStorage(para);
      screenSession.session.loadContent('pages/CommonScbView', getContext(this), storage);
      SCBSceneSessionManager.getInstance().onScreenConnect(screenSession);
      return;
    }

    if (screenSession.session.name === 'DevEcoViewer') {
      log.showInfo('On DevEcoViewer screen connect loadcontent.');
      let para: Record<string, SCBScreenSession> = { 'screenSession': screenSession };
      let storage: LocalStorage = new LocalStorage(para);
      screenSession.session.loadContent('pages/DevView', getContext(this), storage);
      SCBSceneSessionManager.getInstance().onScreenConnect(screenSession);
      return;
    }
    if (screenSession.session.screenId == SCBSceneSessionManager.getInstance().mainScreenId) {
      DisplayMgr.init(screenSession);
    }

    let isExtendScreen = screenSession.isExtendScreen;
    if (isExtendScreen) {
      log.showInfo('On screen connect loadcontent.');
      let para: Record<string, SCBScreenSession> = { 'screenSession': screenSession };
      let storage: LocalStorage = new LocalStorage(para);
      screenSession.session.loadContent('pages/ExtendView', getContext(this), storage);
    } else {
      EsDockEventManager.getInstance().handleScreenConnect(screenSession);
      SCBKeyboardManager.getInstance().keyboardStateChangeForPCScreenConnect(screenSession);
    }
    sPcModeUtils.hideAppCenter();
    SCBSceneSessionManager.getInstance().onScreenConnect(screenSession);
  }

  private onScreenDisconnect(screenId: number, displayGroupId: number): void {
    log.showInfo('On screen disconnect.');
    this.mergeContainerSessionList(screenId);
    this.mergeContainerSessionListNotShowRecent(screenId);
    this.mergePipSessionToMainScreen(screenId);
    SCBPcScenePanelManager.getInstance().mergeSpecificSessionList(screenId);
    this.removeScreenSession(screenId);
    EsDockEventManager.getInstance().handleScreenDisconnect(screenId);
    SCBKeyboardManager.getInstance().keyboardStateChangeForPCScreenDisconnect(screenId);
    screenSessionManager.notifyExtendScreenDestroyFinish();
    sPcModeUtils.hideAppCenter();
    SCBSceneSessionManager.getInstance().onScreenDisconnect(screenId, displayGroupId);
  }

  /**
   * 合并扩展屏containerSessionList到主屏
   *
   * @param screenId
   */
  private mergeContainerSessionList(screenId: number): void {
    let extendContainerSessionList: SCBSceneContainerSessionArray = SCBSceneSessionManager.getInstance()
      .getContainerSessionList(screenId);
    log.showInfo(`mergeContainerSessionList screenId: ${screenId}, ` +
      `extendContainerSessionList.length: ${extendContainerSessionList.length}`);
    SCBSceneSessionManager.getInstance().onAddExtendContainerSession(extendContainerSessionList, screenId,
      SCBSceneSessionManager.getInstance().mainScreenId);
    SCBSceneSessionManager.getInstance().unregisterGetContainerSessionListCallback(screenId);
  }

  /**
   * 合并扩展屏containerSessionListNotShowRecent 到主屏
   *
   * @param screenId
   */
  private mergeContainerSessionListNotShowRecent(screenId: number): void {
    let extendContainerSessionListNotShowRecent: SCBSceneContainerSessionArray = SCBSceneSessionManager.getInstance()
      .getContainerSessionListNotShowRecent(screenId);
    log.showInfo(`mergeContainerSessionListNotShowRecent screenId: ${screenId}, ` +
      `length: ${extendContainerSessionListNotShowRecent.length}`);
    SCBSceneSessionManager.getInstance().onAddExtendNotShowRecentContainerSession(
      extendContainerSessionListNotShowRecent, screenId, SCBSceneSessionManager.getInstance().mainScreenId);
    SCBSceneSessionManager.getInstance()
      .unregisterGetContainerSessionListNotShowRecentCallback(screenId);
  }

  /**
   * 合并扩展屏画中画窗口到主屏
   *
   * @param screenId
   */
  private mergePipSessionToMainScreen(screenId: number): void {
    SCBSceneSessionManager.getInstance().updatePipWhenExtendScreenDisconnect(screenId,
      SCBSceneSessionManager.getInstance().mainScreenId);
  }

  private addScreenSession(screenSession: SCBScreenSession) {
    const screenSessionIndex = this.screenSessionList.findIndex(item => {
      return item.session.screenId === screenSession.session.screenId;
    });

    if (screenSessionIndex != -1) {
      log.showError('Failed to add screen session, screen id:%{public}d', screenSession.session.screenId);
      return;
    }

    this.traversesAndResetScreenMode(screenSession);
    this.screenSessionList.push(screenSession);
    if (screenSession.isMainScreen) {
      log.showInfo('add main screen session, screen id:%{public}d', screenSession.session.screenId);
      SCBSceneSessionManager.getInstance().mainScreenId = screenSession.session.screenId;
      SCBSceneSessionManager.getInstance().initSystemSceneList(screenSession.session.screenId);
      this.handleDesktopRefresh();
    }
    log.showInfo(`addScreenSession with screenId: ${screenSession.session.screenId}, mainSreenId: ${SCBSceneSessionManager.getInstance()
      .mainScreenId}`);
  }

  private handleDesktopRefresh(): void {
    setTimeout(() => {
      // 主屏元素刷新
      localEventManager.sendLocalEvent(EventConstants.EVENT_LAYOUT_INIT_FINISHED, null);
    }, REFRESH_DESKTOP_INTERVAL);
  }

  private removeScreenSession(screenId: number) {
    const screenSessionIndex = this.screenSessionList.findIndex(item => {
      return item.session.screenId === screenId;
    });

    if (screenSessionIndex == -1) {
      log.showError('Failed to remove screen session, screen id:%{public}d', screenId);
      return;
    }
    let scbScreenSession: SCBScreenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenId);
    if (!scbScreenSession) {
        log.showError('Failed to get screensession');
        return;
    }
    let screenSession = scbScreenSession.session;
    if (screenSession) {
      screenSession.releaseResource();
    }
    scbScreenSession.setSessionRegisterOff();
    log.showInfo('release resource');
    this.screenSessionList.splice(screenSessionIndex, 1);
  }

  private isExtendScreen(item: SCBScreenSession): boolean {
    log.showInfo(`build isExtendScreen: ${item?.isExtendScreen}`);
    return item.isExtendScreen;
  }

  private onLock(): void {
    if (this.isLock) {
      log.showDebug(`onLock isLock = ${this.isLock}, threeFingersSwipe off.`);
      SwipeGestureManager.getInstance().offFourFingersSwipe();
      SwipeGestureManager.getInstance().offScreenFourFingersSwipe();
    } else {
      log.showInfo(`onLock isLock = ${this.isLock}, threeFingersSwipe on.` +
        `isVmDesktop: ${DesktopSwitchController.getInstance().isVmDesktop()}.`);
      SwipeGestureManager.getInstance().onFourFingersSwipe();
      if (DesktopSwitchController.getInstance().hasVmAbility()) {
        SwipeGestureManager.getInstance().onScreenFourFingersSwipe();
      }
    }
  }

  private onUserSwitch(): void {
    if (!this.accountSwitch) {
      return;
    }
    SCBScreenSessionManager.getInstance().setDefaultMultiScreenMode();
  }

  build() {
    RootScene(this.rootSceneSession.session) {
      ForEach(this.screenSessionList, (item: SCBScreenSession) => {
        if (item.session.innerName === CUSTOM_SCB_SCREEN) {
            /* CustomScb Screen use another way to load screen */ 
        } else if (this.isExtendScreen(item)) {
          /* extend Screen use another way to load screen */
        } else if (item.session.name === 'DevEcoViewer') {
          /* DevEcoViewer Screen use another way to load screen */
        } else {
          SCBScreen({ screenSession: item })
        }
      }, (item: SCBScreenSession) => item.session.screenId.toString())
    }
  }
}
