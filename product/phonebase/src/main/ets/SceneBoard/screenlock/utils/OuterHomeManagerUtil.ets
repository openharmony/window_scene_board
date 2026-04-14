/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
  SCBPropertyChangeReason,
  SCBSceneMode, SCBSceneSessionManager, SCBScreenSessionManager, sSCBOobeManager } from '@ohos/windowscene';
import lazy { sceneMissionInterceptor } from '@ohos/windowscene';
import {
  ScreenLockStateManager,
  ScreenLockToDesktopConsts,
  ScreenLockUnlockService,
  ScreenLockVerifyService,
} from '@ohos/screenlockcommon';
import { sFontScaleUtil } from '@ohos/screenlockwidget/src/main/ets/common/utils/FontScaleUtil';
import ScreenLockThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import { LockscreenThemeConfig } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import MultiSceneThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/MultiSceneThemeManager';
import { BouncerStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/BouncerFsm';
import { CoreEventType } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { CoreStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import { Qualifier } from '@ohos/themeservicekit';
import { slStateHelper } from '../model/helper/SlStateHelper';
import { systemParameter } from '@kit.BasicServicesKit';
import lazy {
  OuterScreenLockImmersiveChangeAnimationVc
} from '../component/subviewcontrol/OuterScreenLockImmersiveChangeAnimationVc';
import MirrorAnimationUtil from '@ohos/screenlockcomponent/src/main/ets/onemirror/utils/MirrorAnimationUtil';
import { OuterAppManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAppManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { obtainLocalEvent, sEventManager } from '@ohos/frameworkwrapper';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';

const TAG: string = 'OuterHomeManagerUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const ACCESS_WHITELIST: string[] = OuterAppManager.getInstance().getOuterScreenFollowPkgList();


/**
 * 外部锁屏管理
 */
export class OuterHomeManagerUtil {
  private static sInstance: OuterHomeManagerUtil;
  private screenLockThemeManager: ScreenLockThemeManager = ScreenLockThemeManager.getInstance();
  private appContinuationEnable: boolean = false;
  private _persistentId: number = 0;
  private isFoldExpandChange: boolean = false;
  private outerScreenLockImmersiveChangeAnimationVc: OuterScreenLockImmersiveChangeAnimationVc =
    new OuterScreenLockImmersiveChangeAnimationVc();

  public static getInstance(): OuterHomeManagerUtil {
    if (!OuterHomeManagerUtil.sInstance) {
      OuterHomeManagerUtil.sInstance = new OuterHomeManagerUtil();
    }
    return OuterHomeManagerUtil.sInstance;
  }

  public setPersistentId(persistentId: number) {
    this._persistentId = persistentId;
  }

  private processSinglePocketExpandToFold() {
    if (ScreenLockStateManager.getInstance().isInEdite) {
      ScreenLockFsmProxy.getInstance(this._persistentId).submitCoreEvent(CoreEventType.BACK_TO_MAIN_PAGE);
    }
    this.screenLockThemeManager.switchThemeWithFoldStateChange({
      onMultiThemeActivate: (themeParams: Map<Qualifier, LockscreenThemeConfig>) => {
        this.isFoldExpandChange = false;
        MultiSceneThemeManager.cacheThemeInfoByQualifier(themeParams);
      }
    });
    sFontScaleUtil.setOuterScreenKeyBoardLayout();
    if (this.isSkipFoldToLockScreen()) {
      this.onInterceptedFromUnlockToForeground();
      return;
    }
    let currentBouncerState: BouncerStateType = ScreenLockFsmProxy.getInstance(this._persistentId).bouncerFsm.currentStateType;
    if (currentBouncerState === BouncerStateType.PWD_CHECK_STATE) {
      ScreenLockFsmProxy.getInstance(this._persistentId).submitCoreEvent(CoreEventType.BACK_TO_MAIN_PAGE);
    }
    // 默认进沉浸态，仅在非锁屏面板时生效
    if (!ScreenLockStateManager.getInstance().isPageShow) {
      MirrorAnimationUtil.checkShouldDefaultImmersive(true);
    }
    ScreenLockUnlockService.getInstance().requestLock();
    sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.DESKTOP_CLOCK_ANIMATION_START, null));
    this.onInterceptedFromUnlockToForeground();
  }

  private processSinglePocketFoldToExpand() {
    sceneMissionInterceptor.setIsFirstExpandToFold(true);
    if (ScreenLockStateManager.getInstance().isInEdite) {
      ScreenLockFsmProxy.getInstance(this._persistentId).submitCoreEvent(CoreEventType.BACK_TO_MAIN_PAGE);
    }
    this.outerScreenLockImmersiveChangeAnimationVc.clearAnimationState();
    this.screenLockThemeManager.switchThemeWithFoldStateChange({
      onMultiThemeActivate: (themeParams: Map<Qualifier, LockscreenThemeConfig>) => {
        MultiSceneThemeManager.cacheThemeInfoByQualifier(themeParams);
        this.isFoldExpandChange = false;
      }
    });
    sFontScaleUtil.setInnerScreenKeyBoardLayout();
  }

  /**
   * 设置小外屏标志位
   *
   * @param reason
   */
  public setIsSmallOuterScreen(reason: SCBPropertyChangeReason){
      return;
  }

  /**
   * 折展处理
   *
   * @param reason
   */
  public processSinglePocketExpandAndFold(reason: SCBPropertyChangeReason) {
    this.isFoldExpandChange = true;
    if (reason === SCBPropertyChangeReason.EXPAND_TO_FOLD) {
      this.processSinglePocketExpandToFold();
      // Verde折叠到外屏，关闭人脸识别交互开关
      ScreenLockVerifyService.getInstance().setOperateOpenState(AuthType.FACE, false, false, 'expandToFold');
    } else if(reason === SCBPropertyChangeReason.FOLD_TO_EXPAND) {
      this.processSinglePocketFoldToExpand();
    }
    log.showInfo(`processSinglePocketExpandAndFold reason: ${reason}`);
  }

  /**
   * 判断当前是否为折叠或展开操作
   */
  public isFoldStatusChange(): boolean {
    return this.isFoldExpandChange;
  }

  /**
   * 刷新当前场景是否为开合状态
   */
  public refreshFoldStatusChange(): void {
    // 如果进入编辑模式，关闭开合操作标记，放行组件动画
    if (ScreenLockStateManager.getInstance().isInEdite) {
      log.showInfo('set isFoldExpandChange false for edit mode');
      this.isFoldExpandChange = false;
    }
  }

  private isNeedContinuationInOuterSrc(): boolean {
    if (!this.getAppSwitchContinuation()) {
      return false;
    }
    let activeSession = SCBSceneSessionManager.getInstance().getContainerSessionList().getTopActiveSession();
    if (activeSession === undefined || activeSession === null) {
      log.showInfo('topActiveSession is undefined or null');
      return false;
    }
    let bundleName = activeSession.primarySession?.sceneInfo?.bundleName;
    let windowMode = activeSession.primarySession?.sceneInfo?.windowMode;
    if (bundleName === undefined || windowMode === undefined) {
      log.showInfo('bundleName or windowMode is undefined')
      return false;
    }
    log.showInfo(`bundleName is: ${bundleName}, windowMode is: ${windowMode}`);
    if (ACCESS_WHITELIST.indexOf(bundleName) === -1 || windowMode !== SCBSceneMode.FULLSCREEN) {
      return false;
    }
    return true;
  }

  private isSkipFoldToLockScreen(): boolean {
    if (this.isNeedContinuationInOuterSrc()) {
      log.showInfo('skip lockScreen, directly enter to finger print settings');
      return true;
    }
    // MMI测试场景下不拉起锁屏
    if (this.checkIsMmiTestRunningForbidden()) {
      log.showInfo(`now mmi test is running, forbidden to lockScreen`);
      return true;
    }
    // OOBE场景下不拉起锁屏
    if (sSCBOobeManager.isOobeActivated()) {
      log.showInfo('skip lockScreen, because in oobe view');
      return true;
    }
    // 锁屏加锁状态/SIM卡校验状态 折叠无需走加锁逻辑，直接返回，其它场景重新加锁
    let currentCoreState: CoreStateType = ScreenLockFsmProxy.getInstance(this._persistentId).coreFsm.currentStateType;
    if (currentCoreState === CoreStateType.MAIN_PAGE_LOCK_STATE ||
      currentCoreState=== CoreStateType.BOUNCER_SIM_CHECK_STATE) {
      log.showInfo(`currentStateType: ${currentCoreState}, in pageShow or in simCheck no need to requestLock`);
      return true;
    }
    return false;
  }

  /**
   * 设置扩展新形态小折叠到外屏应用接续使能
   */
  public setAppSwitchContinuation(enable: boolean): void {
    log.showInfo(`setAppSwitchContinuation enable is ${enable}`);
    this.appContinuationEnable = enable;
  }

  /**
   * 获取扩展新形态小折叠到外屏应用接续使能
   *
   * @returns enable true: 折叠后进入应用， false: 折叠后进入锁屏
   */
  public getAppSwitchContinuation(): boolean {
    return this.appContinuationEnable;
  }

  /**
   * 判断是否处于MMI测试状态
   */
  private checkIsMmiTestRunningForbidden(): boolean {
    let isRunningFlag: boolean = false;
    try {
      isRunningFlag = systemParameter.getSync('persist.mmitest.isrunning', 'false') === 'true';
    } catch (error) {
      log.showError(`get mmi test running flag fail. code: ${error?.code}, msg: ${error?.message}`);
    }
    return isRunningFlag;
  }

  private onInterceptedFromUnlockToForeground(): void {
    let activeSessionList = SCBSceneSessionManager.getInstance().getActiveSessionList();
    if (SCBSceneSessionManager.getInstance().isSplitMode(activeSessionList[0])) {
      log.showInfo('need to intercept when in split mode');
      sceneMissionInterceptor.setAppInterceptState(true);
      return;
    }
    let containerSession =
      SCBSceneSessionManager.getInstance().getSceneContainerSessionFromScenePanel(activeSessionList[0]);
    let bundleName = containerSession?.primarySession?.sceneInfo.bundleName;
    let abilityName = containerSession?.primarySession?.sceneInfo.abilityName;
    let isBlockApp = OuterAppManager.getInstance().isBlockApp(bundleName, abilityName);
    let isTrustedCard = OuterAppManager.getInstance().isTrustedCard(bundleName);
    log.showInfo('EXPAND_TO_FOLD, bundleName:' + bundleName + ', abilityName:' + abilityName +
      ', isBlockApp:' + isBlockApp + ', isTrustedCard:' + isTrustedCard +
      ', active ids:' + activeSessionList.join(','));
    if (!isBlockApp && !isTrustedCard) {
      log.showInfo('no need to intercept')
      sceneMissionInterceptor.setAppInterceptState(false);
      return;
    }
    log.showInfo('default intercept');
    sceneMissionInterceptor.setAppInterceptState(true);
  }
}