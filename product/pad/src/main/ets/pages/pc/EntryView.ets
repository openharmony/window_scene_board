/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  HiSysEventUtil,
  windowCommonEventManager,
  viewMgrPolicy,
  ViewType,
  sEventManager,
  rdbStoreConfig,
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
import { PowerStatus } from '@ohos/commonconstants';
import { EventConstants, RdbStoreManager } from '@ohos/launchercommon';
import { SCBScreen } from '@ohos/pcbase/src/main/ets/SceneBoard/scenemanager/SCBScreen';
import { CommonStyleManager, StatusBarType, SystemUIInitiator } from '@ohos/systemuicommon';
import commonEventManager from '@ohos.commonEventManager';
import { MultiInputViewModel, multiInputManager } from '@ohos/multiinput';
import { AppCenterViewModel } from '@ohos/appcenter';
import { MultiFingerPinchUtil } from '@ohos/launchercommon/Index';
import curves from '@ohos.curves';
import inputMonitor from '@ohos.multimodalInput.inputMonitor';
import { Pinch, ActionType } from '@ohos.multimodalInput.gestureEvent';
import PcStage from '@ohos/pcbase/src/main/ets/common/PcStage';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { SwipeGestureManager, SCBPcScenePanelManager } from '@ohos/pcmode';
import ctrlAltDelPanelModel from '@ohos/pcbase/src/main/ets/SceneBoard/ctrlaltdelpanel/model/CtrlAltDelPanelModel';
import {EsDockEventManager} from '@ohos/pcsmartdock';
import { sPcModeUtils } from '@ohos/pcmode/src/main/ets/utils/SCBPcModeUtils';
import { CommonScbScreen } from '@ohos/commonscbscreen';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import screenSessionManager from '@ohos.screenSessionManager';
import {DesktopSwitchController} from '@ohos/pcbase/src/main/ets/SceneBoard/virtualmachine/DesktopSwitchController';
import {FourFingerSwipeController} from '@ohos/pcbase/src/main/ets/SceneBoard/virtualmachine/FourFingerSwipeController';
import { SystemSceneBuilderParam } from '@ohos/windowscene/Index';
import { SCBSceneRegisterManager } from '@ohos/pcbase/src/main/ets/SceneBoard/scenemanager/SCBSceneRegisterManager';
import { SCBScreenLock } from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock/SCBScreenLock';

const TAG = 'SCBEntryView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const CUSTOM_SCB_SCREEN: string = 'CustomScbScreen';

let storage = LocalStorage.GetShared();
const TOUCHPAD_EVENT_INTERVAL = 7;
const REFRESH_DESKTOP_INTERVAL = 200;

let that: EntryView;

@Entry(storage)
@Component
struct EntryView {
  private rootSceneSession: SCBRootSceneSession = SCBSceneSessionManager.getInstance().getRootSceneSession();
  @State
  screenSessionList: SCBScreenSessionArray = new SCBScreenSessionArray();
  @StorageLink('AppCenterItemPosX')
  appItemPosX: Array<number> = [];
  @StorageLink('AppCenterItemPosY')
  appItemPosY: Array<number> = [];
  @StorageLink('AppCenterItemOpacity')
  appItemOpacity: Array<number> = [];
  @StorageLink('AppCenterBkBlur')
  bkBlur: number = 0;
  @StorageLink('AppCenterBkOpacity')
  bkOpacity: number = 0;
  @StorageLink('isLock') @Watch('onLock')
  isLock: boolean = true;
  @StorageLink('accountSwitch') @Watch('onUserSwitch')
  accountSwitch: boolean = false;
  private isAppCenterShown: boolean = false;
  private isAppCenterShownDuringPinching: boolean = false;
  private scaleInfo: MultiFingerPinchUtil = new MultiFingerPinchUtil();
  private mMultiInputViewModel: MultiInputViewModel | null = null;
  private mSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private mStage: PcStage = new PcStage();
  private isHandMultiPinch: boolean = false;
  private isFirstMove: boolean = true;
  private totalProcessTime: number = 0;

  @Builder
  screenLockBuilder($$: SystemSceneBuilderParam) {
    SCBScreenLock({persistentId: $$.persistentId, screenProp: $$.screenProp});
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');

    // Configuration Initialized
    that = this;
    this.mStage.onCreate();

    SCBSceneRegisterManager.getInstance().setSystemSceneBuilder('SCBScreenLock', this.screenLockBuilder);

    // 原来在StatusBar/DropdownPanel等处setAbilityPageName会相互覆盖，导致Style不对
    CommonStyleManager.setAbilityPageName(TAG);
    SCBScreenSessionManager.getInstance().setScreenSessionList(this.screenSessionList);
    this.registerScreenConnectionListener();

    // Register Multi modal event listener
    this.mMultiInputViewModel = MultiInputViewModel.getInstance();
    SCBSceneSessionManager.getInstance().registerRequestFocusCallback(this.onRequestFocus);
    multiInputManager.registerInputEvent();

    // Subscribe common event - screen lock for the multi finger pinch event listener registration
    this.subscribeMultiFingerPinchEvent();

    // systemUI组件初始化baseState
    SystemUIInitiator.init();

    this.setSystemParameter();

    this.initDesktopDBConfig();
  }

  private initDesktopDBConfig(): void {
    RdbStoreManager.getInstance().updateLayoutTableNameByName(rdbStoreConfig.pc_mode_gridLayoutInfo.tableName);
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

    this.mStage.onDestroy();
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
      commonEventManager.createSubscriber(subscribeInfo, (err, data) => {
        // Ignore create subscribe when error happens
        if (err) {
          log.showError(`Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
          return;
        }

        // Initialize subscriber info
        this.mSubscriber = data;

        // Subscribe message now
        try {
          commonEventManager.subscribe(this.mSubscriber, (err, data) => {
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
   * 多指捏合事件处理器
   *
   * @param gesture 手势
   */
  private onPinchEvent(gesture: Pinch) {
    let type = gesture.type;
    let scale = gesture.scale;

    if (AppStorage.get('powerStatus') !== PowerStatus.RUNNING || FourFingerSwipeController.getInstance().getVmDesktop()) {
      log.showDebug('OnPinchBegin shutting down or reboot or vm desktop, do not begin pinch.');
      return;
    }
    if (!MultiInputViewModel.getInstance()?.isPinchOpenAppCenterEnable()) {
      log.showWarn('Pinch Open AppCenter disable!');
      return;
    }
    if (ctrlAltDelPanelModel?.checkCtrlAltDelPanelShow()) {
      log.showWarn(TAG, 'ctrlAltDel Panel Show');
      return;
    }
    log.showInfo(`OnPinchEvent, type=${type}, scale=${scale}`);

    if (type === ActionType.BEGIN) {
      that.onPinchBegin(scale);
    } else if (type === ActionType.UPDATE) {
      that.onPinchUpdate(scale, Date.now());
    } else if (type === ActionType.END) {
      that.onPinchEnd(scale);
    }
  }

  /**
   *
   * 多指捏合事件处理器 - 开始捏合
   *
   * @param scale 缩放比例
   */
  private onPinchBegin(scale: number): void {
    if (sSCBOobeManager.isEnable()) {
      return;
    }

    try {
      commonEventManager.publish(windowCommonEventManager.TOUCH_PINCH_BEGIN_EVENT, (err) => {
        if (err) {
          log.showError(`publish TOUCH_PINCH_BEGIN_EVENT failed, err=${err.message}`);
        } else {
          log.showDebug('publish TOUCH_PINCH_BEGIN_EVENT success');
        }
      });
    } catch (error) {
      log.error('OnPinchBegin commonEventManager publish', error);
    }

    AppStorage.setOrCreate('showUninstallDialog', false);
    AppStorage.setOrCreate('isShortcutKeyPanelShow', false);

    let isRecentPanel: boolean = AppStorage.get('showRecent') as boolean;
    if (isRecentPanel === true) {
      log.showDebug('multi pinch is not supported in recent');
      return;
    }

    that.isAppCenterShown = viewMgrPolicy.isViewShowing(ViewType.APP_CENTER);
    this.isHandMultiPinch = true;
    this.totalProcessTime = 0;
    AppStorage.setOrCreate('isHandMultiPinch', true);
    log.showDebug(`isAppCenterShown=${that.isAppCenterShown}, isAppCenterShownDuringPinching=${that.isAppCenterShownDuringPinching}`);
  }

  /**
   *
   * 多指捏合事件处理器 - 更新
   *
   * @param scale 缩放比例
   */
  private onPinchUpdate(scale: number, time: number): void {
    if (this.totalProcessTime > TOUCHPAD_EVENT_INTERVAL) {
      this.totalProcessTime -= TOUCHPAD_EVENT_INTERVAL;
      return;
    }

    if (!this.isHandMultiPinch) {
      return;
    }

    if (that.isAppCenterShown && scale <= that.scaleInfo.startScale) {
      log.showDebug('App center view is already shown');
      return;
    }

    if (!that.isAppCenterShown && scale >= that.scaleInfo.startScale) {
      log.showDebug('App center view is already hidden');
      return;
    }
    if (!that.isAppCenterShownDuringPinching && !that.isAppCenterShown && scale < that.scaleInfo.startScale) {
      that.isAppCenterShownDuringPinching = true;
      AppStorage.setOrCreate('onPinchUpdating', true);
      this.showAppCenterByPinch();
    }

    // Correct scale to make sure it's in valid range
    if (scale > that.scaleInfo.validMaxScale) {
      log.showWarn(`correct to upper limit ${that.scaleInfo.validMaxScale}`);
      scale = that.scaleInfo.validMaxScale;
    } else if (scale < that.scaleInfo.validMinScale) {
      log.showWarn(`correct to lower limit ${that.scaleInfo.validMinScale}`);
      scale = that.scaleInfo.validMinScale;
    }

    // To show
    if (scale < that.scaleInfo.startScale) {
      if (this.isFirstMove) {
        performanceMonitor.begin(HiSysEventUtil.PC_APP_CENTER_GESTURE_OPERATION,
          performanceMonitor.ActionType.FIRST_MOVE, HiSysEventUtil.PC_GESTURE_TO_APP_CENTER);
        this.isFirstMove = false;
      }

      if (that.scaleInfo.scale > that.scaleInfo.startScale) {
        log.showWarn(`out in critical point, scale=${scale}, that.scaleInfo.scale=${that.scaleInfo.scale}`);
        that.scaleInfo.crossBoundary = true;
        return;
      }

      that.scaleInfo.crossBoundary = false;
      that.scaleInfo.scale = scale;

      animateTo({
        curve: curves.responsiveSpringMotion(),
      }, () => {
        let targetScale = that.innerScaleRangeMapping(scale);
        let appItemEdgePos = AppCenterViewModel.getInstance().getAppItemEdgePos();

        log.showDebug(`to show, scale=${scale}, targetScale=${targetScale}`);

        for (let index = 0; index < that.appItemPosX.length; index++) {
          that.appItemPosX[index] = (appItemEdgePos[index][0] * targetScale);
          that.appItemPosY[index] = (appItemEdgePos[index][1] * targetScale);
          that.appItemOpacity[index] = 1 - targetScale;
        }

        that.bkBlur = 1 - targetScale;
        that.bkOpacity = AppCenterViewModel.APP_CENTER_BK_OPACITY * (1 - targetScale);
      });
    } else if (scale > that.scaleInfo.startScale) { // to hide
      if (this.isFirstMove) {
        performanceMonitor.begin(HiSysEventUtil.PC_APP_CENTER_GESTURE_OPERATION,
          performanceMonitor.ActionType.FIRST_MOVE, HiSysEventUtil.PC_GESTURE_EXIT_APP_CENTER);
        this.isFirstMove = false;
      }

      if (that.scaleInfo.scale < that.scaleInfo.startScale) {
        log.showWarn(`in out critical point, scale=${scale}, that.scaleInfo.scale=${that.scaleInfo.scale}`);
        that.scaleInfo.crossBoundary = true;
        return;
      }

      that.scaleInfo.crossBoundary = false;
      that.scaleInfo.scale = scale;

      animateTo({
        curve: curves.responsiveSpringMotion(),
      }, () => {
        let targetScale = that.outerScaleRangeMapping(scale);
        let appItemEdgePos = AppCenterViewModel.getInstance().getAppItemEdgePos();

        log.showDebug(`to hide, scale=${scale}, targetScale=${targetScale}`);

        for (let index = 0; index < that.appItemPosX.length; index++) {
          that.appItemPosX[index] = (appItemEdgePos[index][0] * (1 - targetScale));
          that.appItemPosY[index] = (appItemEdgePos[index][1] * (1 - targetScale));
          that.appItemOpacity[index] = targetScale;
        }

        that.bkBlur = targetScale;
        that.bkOpacity = AppCenterViewModel.APP_CENTER_BK_OPACITY * targetScale;
      });
    }

    this.totalProcessTime += Date.now() - time;
  }

  private showAppCenterByPinch() {
    HiSysEventUtil.reportPullAppCenter(HiSysEventUtil.APPCENTER_TYPE_PINCH);
    if (AppStorage.get<boolean>('split')) {
      SCBSceneSessionManager.getInstance().exitActiveSplit(-1);
    }
    viewMgrPolicy.showView(ViewType.APP_CENTER);
  }

  /**
   *
   * 多指捏合事件处理器 - 结束捏合
   *
   * @param scale 缩放比例
   */
  private onPinchEnd(scale: number): void {
    let isRecentPanel: boolean = AppStorage.get('showRecent') as boolean;
    if (isRecentPanel === true) {
      AppStorage.setOrCreate('showRecent', false);
    }

    if (this.isHandMultiPinch) {
      if (that.scaleInfo.crossBoundary) {
        if (scale > that.scaleInfo.startScale) {
          that.continueToHide();
        } else {
          that.continueToShow();
        }
      } else {
        if (scale > that.scaleInfo.scaleThreshold2) {
          that.continueToHide();
        } else if (scale <= that.scaleInfo.scaleThreshold2 && scale > that.scaleInfo.startScale) {
          that.continueToShow();
        } else if (scale < that.scaleInfo.startScale && scale > that.scaleInfo.scaleThreshold1) {
          that.continueToHide();
        } else if (scale <= that.scaleInfo.scaleThreshold1) {
          that.continueToShow();
        }
      }
    }

    this.isHandMultiPinch = false;
    that.resetScaleInfo();
    AppStorage.setOrCreate('isHandMultiPinch', false);
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
      onScreenDisconnect: (screenId) => this.onScreenDisconnect(screenId),
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
      return;
    }

    if (screenSession.session.name === 'DevEcoViewer') {
      log.showInfo('On DevEcoViewer screen connect loadcontent.');
      let para: Record<string, SCBScreenSession> = { 'screenSession': screenSession };
      let storage: LocalStorage = new LocalStorage(para);
      screenSession.session.loadContent('pages/DevView', getContext(this), storage);
      return;
    }

    if (screenSession.session.screenId == SCBSceneSessionManager.getInstance().mainScreenId) {
      DisplayMgr.init(screenSession);
      SCBSceneSessionManager.getInstance().onScreenConnect(screenSession);
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
  }

  private onScreenDisconnect(screenId: number): void {
    log.showInfo('On screen disconnect.');
    this.mergeContainerSessionList(screenId);
    this.mergeContainerSessionListNotShowRecent(screenId);
    SCBPcScenePanelManager.getInstance().mergeSpecificSessionList(screenId);
    this.removeScreenSession(screenId);
    EsDockEventManager.getInstance().handleScreenDisconnect(screenId);
    SCBKeyboardManager.getInstance().keyboardStateChangeForPCScreenDisconnect(screenId);
    screenSessionManager.notifyExtendScreenDestroyFinish();
    sPcModeUtils.hideAppCenter();
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

    this.screenSessionList.splice(screenSessionIndex, 1);
  }

  /**
   *
   * 捏合过程中应用中心执行显示
   *
   */
  private continueToShow() {
    log.showInfo('continue to show');

    animateTo({ curve: curves.springMotion() }, () => {
      for (let index = 0; index < that.appItemPosX.length; index++) {
        that.appItemPosX[index] = 0;
        that.appItemPosY[index] = 0;
        that.appItemOpacity[index] = 1;
      }

      performanceMonitor.end(HiSysEventUtil.PC_APP_CENTER_GESTURE_OPERATION);

      this.isFirstMove = true;
      that.bkBlur = 1.0;
      that.bkOpacity = AppCenterViewModel.APP_CENTER_BK_OPACITY;
    });
  }

  /**
   * 缩小比例参数映射
   *
   * @param input
   * @returns
   * @param input
   * @returns
   */
  private innerScaleRangeMapping(input: number): number {
    let output = ((input - 0.5) * (1 - 0)) / (1 - 0.5) + 0;

    return output;
  }

  /**
   * 放大比例参数映射
   *
   * @param input
   * @returns
   * @param input
   * @returns
   */
  private outerScaleRangeMapping(input: number): number {
    let output = ((input - 1) * (0 - 1)) / (2 - 1) + 1;

    return output;
  }

  /**
   *
   * 初始比例参数设定
   *
   */
  private resetScaleInfo() {
    AppStorage.setOrCreate('onPinchUpdating', false);
    that.isAppCenterShownDuringPinching = false;
    that.scaleInfo.crossBoundary = false;
    that.scaleInfo.scale = 1;
  }

  /**
   *
   * 执行应用中心隐藏的过程显示
   *
   */
  private continueToHide() {
    log.showDebug('continue to hide');

    animateTo({
      curve: curves.springMotion(), onFinish: () => {
        this.isFirstMove = true;
      }
    }, () => {
      let appItemEdgePos = AppCenterViewModel.getInstance().getAppItemEdgePos();

      for (let index = 0; index < that.appItemPosX.length; index++) {
        that.appItemPosX[index] = appItemEdgePos[index][0];
        that.appItemPosY[index] = appItemEdgePos[index][1];
        that.appItemOpacity[index] = 0;
      }

      that.bkBlur = 0;
      that.bkOpacity = 0;
    });

    // set max duration for hiding animation
    setTimeout(() => {
      AppStorage.setOrCreate('openAppCenterPageIndex', 0);
      viewMgrPolicy.hideView(ViewType.APP_CENTER);
      performanceMonitor.end(HiSysEventUtil.PC_APP_CENTER_GESTURE_OPERATION);
    }, 300);
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
