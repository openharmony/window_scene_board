/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { MultiInputViewModel } from '@ohos/multiinput';
import {
  LogDomain,
  LogHelper,
  CommonUtils
} from '@ohos/basicutils';
import commonEventManager from '@ohos.commonEventManager';
import Base from '@ohos.base';
// import virtualization from '@hms.virtService.vmManagerInner';
import {
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSessionManager,
  SCBSceneSession,
  SCBScreenSessionManager,
  INVALID_SCREEN_ID
} from '@ohos/windowscene';
import image from '@ohos.multimedia.image';
import { FourFingerSwipeController } from './FourFingerSwipeController';
import bundleManager from '@ohos.bundle.bundleManager';
import { HiSysEventUtil, ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import { BusinessError } from '@ohos.base';
import bundleMonitor from '@ohos.bundle.bundleMonitor';
import { settingsDataManager } from '@ohos/frameworkwrapper';
import { SCBSessionListManager, SwipeGestureManager } from '@ohos/pcmode';
import { AccountHelper } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { PcSmartDockModel } from '@ohos/pcsmartdock/src/main/ets/default/model/PcSmartDockModel';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { systemDateTime } from '@kit.BasicServicesKit';

const TAG = '[DesktopWorld]DesktopSwitchController';
const INVALID_IDX = -1;
const PUBLISH_EVENT = 'common.event.vmStart';
const PUBLISH_EVENT_NOT_ENTRY = 'common.event.vmNotEntry';
const DATA_SHARE_BUNDLE_NAME = 'hwf.bundle.name';
const DATA_SHARE_TOKEN_ID = 'hwf.emulator.token';
const DATA_SHARE_ABILITY_NAME = 'windows_abilityName';
const URI_SHARE: string = 'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=';
const FIRST_START_VIRTUAL: string = 'FIRST_START_VIRTUAL';
const CLINK_NOTIFICATION_SWIPE: string = 'CLINK_NOTIFICATION_SWIPE';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class DesktopSwitchController {
  private mBundleName: string = '';
  private mVmAbilityName: string = '';
  private mTokenId: string = '';
  private mVmSceneContainerSession?: SCBSceneContainerSession | null;
  private mHasVmAbility: boolean = false;
  private mIsVmDesktop: boolean = false;
  private subscriber?: commonEventManager.CommonEventSubscriber;
  private vmStateCallbacks: Set<VmStateCallBack> = new Set();
  private static instance: DesktopSwitchController;
  private mRecentClosed: boolean = true;
  private mVmSwitchTime: number = 0;

  public static getInstance(): DesktopSwitchController {
    if (!DesktopSwitchController.instance) {
      DesktopSwitchController.instance = new DesktopSwitchController();
    }
    return DesktopSwitchController.instance;
  }

  constructor() {
    this.init();
    this.subUninstall();
  }

  public registerVmStateCallback(callback: VmStateCallBack): void {
    if (callback) {
      if (this.vmStateCallbacks && !this.vmStateCallbacks.has(callback)) {
        this.vmStateCallbacks.add(callback);
      }
    }
  }

  public unregisterVmStateCallback(callback: VmStateCallBack): void {
    this.vmStateCallbacks?.delete(callback);
  }

  public getMotionPrefabrication(): image.PixelMap | null {
    return this.getVmStartSnapshotSync();
  }

  public getVmSceneInfo(): SCBSceneInfo | undefined {
    log.showInfo(`get vm scene info: ${this.mVmSceneContainerSession?.primarySession?.sceneInfo.bundleName}`);
    return this.mVmSceneContainerSession?.primarySession?.sceneInfo
  }

  public setVmSceneContainerSession(vmSceneContainerSession: SCBSceneContainerSession | null): void {
    this.mVmSceneContainerSession = vmSceneContainerSession;
  }

  public getVmSceneContainerSession(): SCBSceneContainerSession | null | undefined {
    log.showInfo(`get vm session: ${this.mVmSceneContainerSession?.primarySession?.sceneInfo.bundleName}`);
    return this.mVmSceneContainerSession;
  }

  public getVmPersistentId(): number | undefined {
    log.showInfo(`get vm persistent id is: ${this.mVmSceneContainerSession?.primarySession?.sceneInfo.persistentId}`);
    return this.mVmSceneContainerSession?.primarySession?.sceneInfo.persistentId;
  }

  public getVmSwitchTime(): number {
    return this.mVmSwitchTime;
  }

  public setVmSwitchTime(closeVm: boolean): void {
    log.showInfo(`setVmSwitchTime closeVm: ${closeVm}`)
    if (closeVm) {
      this.mVmSwitchTime = 0;
      return;
    }
    try {
      // this.mVmSwitchTime = virtualization.queryVmSwitchTime();
    } catch (error) {
      log.showError(`virtualization.queryVmSwitchTime() failed, code: ${error?.code}, msg: ${error?.message}`);
    }
  }

  public startVmAbility(): void {
    log.showInfo('startVmAbility');
    this.mHasVmAbility = true;
    this.addHideTitle();
    this.addHideInRecentList();
    SwipeGestureManager.getInstance().onScreenFourFingersSwipe();
    this.setVmSwitchTime(false);
  }

  public recoverVmAbility(): void {
    log.showInfo('recoverVmAbility');
    this.mHasVmAbility = true;
    this.addHideTitle();
    this.addHideInRecentList();
    SwipeGestureManager.getInstance().onScreenFourFingersSwipe();
    this.setVmSwitchTime(false);
  }

  public closeVmAbility(): void {
    log.showInfo('closeVmAbility');
    this.setRecentClosed(true);
    this.mHasVmAbility = false;
    FourFingerSwipeController.getInstance().setVmDesktop(false);
    FourFingerSwipeController.getInstance().setCanInterrupt(true);
    FourFingerSwipeController.getInstance().updateShowPrefabrication(true);
    FourFingerSwipeController.getInstance().releaseVmSnapshot();
    FourFingerSwipeController.getInstance().closeVmInit();
    FourFingerSwipeController.getInstance().memoryReleaseEnd();
    ViewManagerPolicy.hideView(ViewType.DESKTOP_SWITCHER);
    this.deleteHideTitle();
    this.deleteHideInRecentList();
    this.setVmSceneContainerSession(null);
    SwipeGestureManager.getInstance().offScreenFourFingersSwipe();
    FourFingerSwipeController.getInstance().unregisterTabletSwitchStateChange();
    this.setVmSwitchTime(true);
  }

  public minimizeVmWindow(): void {
    if (!this.mVmSceneContainerSession) {
      log.showError('minimize vm window without animation vm container session is null');
      return;
    }
    log.showInfo('minimize vm window without animation');
    this.mVmSceneContainerSession.requestBackground();
    let primarySession = this.mVmSceneContainerSession.primarySession;
    if (primarySession) {
      primarySession.isMinimizing = false;
      primarySession.initSceneState();
      primarySession.opacity = 0.0;
    } else {
      log.showError('minimize vm window without animation primarySession is null');
    }
    this.mVmSceneContainerSession.needRenderVisibility.setVisibilityWithDfx(false, TAG, 'setVisibilityVmSceneSession',
      this.mVmSceneContainerSession.getName());
  }

  public hasVmAbility(): boolean {
    return this.mHasVmAbility;
  }

  public setVmDesktop(vmDesktop: boolean): void {
    log.showInfo(`setVmDesktop: ${vmDesktop}`);
    this.mIsVmDesktop = vmDesktop;
    let vmScreenId = this.mVmSceneContainerSession?.screenProperty?.screenId;
    if (vmScreenId === undefined || vmScreenId === INVALID_SCREEN_ID) {
      log.showError(`VM screenId Wrong! screenId is ${vmScreenId}`);
      return;
    }
    if (this.mIsVmDesktop) {
      this.notifyVmStateChange(this.mIsVmDesktop, vmScreenId);
    } else {
      this.notifyVmStateChange(this.mIsVmDesktop, INVALID_SCREEN_ID);
    }
  }

  public notifyVmStateChange(isVm: boolean, tarVmScreenId: number): void {
    if (isVm && tarVmScreenId === INVALID_SCREEN_ID) {
      log.showError('notifyVmStateChange, isVm but INVALID_SCREEN_ID! return');
      return;
    }
    log.showInfo(`notifyVmStateChange, isVmDesktop: ${isVm}, tarVmScreenId: ${tarVmScreenId}`);
    this.vmStateCallbacks.forEach((callback: VmStateCallBack) => {
      if (callback) {
        callback(isVm, tarVmScreenId);
      }
    })
  }

  public isVmDesktop(screenId?: number): boolean {
    if (typeof screenId !== 'number') {
      return this.mIsVmDesktop;
    }
    log.showInfo(`check isVmDesktop, ask screenId: ${screenId}`);
    return this.mIsVmDesktop && screenId === this.mVmSceneContainerSession?.screenProperty?.screenId;
  }

  public isVmSceneSession(sceneInfo: SCBSceneInfo | undefined): boolean {
    log.showInfo(`mBundleName: ${this.mBundleName}, mVmAbilityName: ${this.mVmAbilityName}, ` +
      `sceneBundleName: ${sceneInfo?.bundleName}, sceneAbilityName: ${sceneInfo?.abilityName}`);
    return this.mBundleName === sceneInfo?.bundleName && this.mVmAbilityName === sceneInfo?.abilityName;
  }

  public unSubDataShareChange(): void {
    log.showInfo('unSubDataShareChange');
    let bundleNameSubChange = settingsDataManager.unregisterKeyObserver(DATA_SHARE_BUNDLE_NAME);
    if (bundleNameSubChange) {
      log.showInfo('unSubDataShareChange success');
    } else {
      log.showError('unSubDataShareChange is failed');
    }
    let tokenIdSubChange = settingsDataManager.unregisterKeyObserver(DATA_SHARE_TOKEN_ID);
    if (tokenIdSubChange) {
      log.showInfo('unSubDataShareChange success');
    } else {
      log.showError('unSubDataShareChange is failed');
    }
  }

  public setBundleName(value: string) {
    this.mBundleName = value;
  }

  public setVmAbilityName(value: string) {
    this.mVmAbilityName = value;
  }

  /**
   * sort the list to move the topmost containerSessions to the end
   */
  public vmTopmost(): void {
    log.showInfo(`VM TopMost`);
    if (!this.mVmSceneContainerSession) {
      log.showError('vm topmost container session is null');
      return;
    }
    log.showInfo(`getMotionScreenId(): ${FourFingerSwipeController.getInstance().getMotionScreenId()}`);
    const containerSessionList = SCBSceneSessionManager
      .getInstance()
      .getContainerSessionList(FourFingerSwipeController.getInstance().getMotionScreenId());
    log.showInfo('this.mVmSceneContainerSession.containerId: ' + this.mVmSceneContainerSession?.containerId);
    let index = containerSessionList.findIndexByContainerId(this.mVmSceneContainerSession?.containerId);
    log.showInfo(`index: ${index}`);
    if (index === -1) {
      log.showError('VM scene container session not in the container sessionList');
      return;
    }
    containerSessionList.splice(index, 1);
    containerSessionList.push(this.mVmSceneContainerSession);
    SCBSessionListManager.refreshZOrder();
  }

  public onVmDesktopHide(): void {
    this.mVmSceneContainerSession?.requestBackground();
  }

  public onVmDesktopShow(): void {
    this.mVmSceneContainerSession?.requestActivation();
  }

  public vmBackHarmonyDesktopInAbnormalRecovery(sceneContainerSession: SCBSceneContainerSession,
    sceneInfo: sceneSessionManager.SceneRecoverInfo): void {
    log.showInfo('vmBackHarmonyDesktopInAbnormalRecovery');
    if (sceneContainerSession.primarySession?.sceneInfo.bundleName !==
      settingsDataManager.getValue(null, DATA_SHARE_BUNDLE_NAME, '') ||
      sceneContainerSession.primarySession?.sceneInfo.abilityName !==
      settingsDataManager.getValue(null, DATA_SHARE_ABILITY_NAME, '')) {
      log.showWarn('vmBackHarmonyDesktop failed');
      return;
    }
    if (!sceneContainerSession.primarySession) {
      log.showWarn('vmBackHarmonyDesktop sceneContainerSession.primarySession is null');
      return;
    }
    settingsDataManager.setValue(null, 'enable_combine_key', 'true');
    this.setVmSceneContainerSession(sceneContainerSession);
    this.setBundleName(settingsDataManager.getValue(null, DATA_SHARE_BUNDLE_NAME, ''));
    this.setVmAbilityName(settingsDataManager.getValue(null, DATA_SHARE_ABILITY_NAME, ''));
    sceneInfo.sessionState = sceneSessionManager.SessionState.STATE_BACKGROUND;
    SCBSceneSessionManager.getInstance().minimize(this.getVmSceneInfo()?.screenId, this.getVmSceneInfo()?.persistentId);
    this.getVmSnapshot(sceneContainerSession.primarySession.sceneInfo.persistentId);
    this.recoverVmAbility();
  }

  public skipMinimizeForVmScene(primarySession: SCBSceneSession): boolean {
    let isVmSceneSession = this.isVmSceneSession(primarySession.sceneInfo);
    if (isVmSceneSession) {
      let screenId = primarySession.sceneInfo.screenId;
      this.switchToHarmony(screenId, 'VM_WINDOW_MINIMIZE');
      return true;
    }
    if (this.getVmSceneInfo()?.bundleName === primarySession.sceneInfo.bundleName &&
      this.getVmSceneInfo()?.abilityName !== primarySession.sceneInfo.abilityName &&
      SCBScreenSessionManager.getInstance().getScreenSessionList().length !== 1 &&
      this.isVmDesktop()) {
      log.showInfo('Exiting the VM When the Console Is hide');
      let time: number = systemDateTime.getTime(false);
      HiSysEventUtil.reportSwitchingDesktopEvent('SYSTEM_WINDOW_SHOW', time);
      FourFingerSwipeController.getInstance().oneTimeRightSwipeMotionSnapshot();
      return true;
    }
    return false;
  }

  public switchToHarmony(screenID: number, switchType: string = CLINK_NOTIFICATION_SWIPE): void {
    log.showInfo(`[DesktopWorld] switch to harmony screenID: ${screenID}, switchType: ${switchType}`);
    if (screenID !== FourFingerSwipeController.getInstance().getMotionScreenId()) {
      return;
    }
    if (this.isVmDesktop()) {
      log.showInfo(`notification start oneTimeRightSwipeMotionSnapshot`);
      FourFingerSwipeController.getInstance().oneTimeRightSwipeMotionSnapshot();
      let time: number = systemDateTime.getTime(false);
      HiSysEventUtil.reportSwitchingDesktopEvent(switchType, time);
    }
  }

  public switchToVmIfNeeded(toContainerSession: SCBSceneContainerSession): void {
    if (toContainerSession === null) {
      log.showWarn('[DesktopWorld] toContainerSession is null');
    }
    if (this.isVmSceneSession(toContainerSession.primarySession?.sceneInfo)) {
      log.showWarn('onSceneStartTransition isVmSceneSession');
      const sceneInfo = toContainerSession.primarySession?.sceneInfo;
      this.setVmSceneContainerSession(toContainerSession);
      this.startVmAbility();
      FourFingerSwipeController.getInstance().startVmMotionSnapshot();
      let time: number = systemDateTime.getTime(false);
      HiSysEventUtil.reportSwitchingDesktopEvent(FIRST_START_VIRTUAL, time);
    }
  }

  /**
   * getVmSnapshot
   */
  private async getVmSnapshot(persistentId: number): Promise<void> {
    await sceneSessionManager.getSessionSnapshotPixelMap(persistentId, 1).then((result: image.PixelMap) => {
      if (result) {
        FourFingerSwipeController.getInstance().updateVmSnapshot(result);
      } else {
        log.showWarn('vm imagePixelMap is null');
      }
    }).catch(() => {
      log.showWarn('getVmSnapshot failed');
    });
  }

  private addHideTitle(): void {
    if (!this.mVmSceneContainerSession) {
      log.showInfo('addHideTitle VmSceneContainerSession is null');
      return;
    }
    MultiInputViewModel.getInstance().addHideTitleSessionList(this.mVmSceneContainerSession);
  }

  private deleteHideTitle(): void {
    if (!this.mVmSceneContainerSession) {
      log.showInfo('deleteHideTitle VmSceneContainerSession is null');
      return;
    }
    MultiInputViewModel.getInstance().deleteHideTitleSessionList(this.mVmSceneContainerSession);
  }

  private addHideInRecentList(): void {
    if (!this.mVmSceneContainerSession) {
      log.showInfo('addHideInRecentList VmSceneContainerSession is null');
      return;
    }
    PcSmartDockModel.getInstance().addHideInRecentListSessions(this.mVmSceneContainerSession);
  }

  private deleteHideInRecentList(): void {
    if (!this.mVmSceneContainerSession) {
      log.showInfo('deleteHideInRecentList VmSceneContainerSession is null');
      return;
    }
    PcSmartDockModel.getInstance().deleteHideInRecentListSessions(this.mVmSceneContainerSession);
  }

  private init(): void {
    log.showInfo('init');
    this.subDataShareChange();
    this.updateAbilityName();
    this.updateBundleName();
    this.updateTokenId();
    log.showInfo('init success');
  }

  private subscribeUninstall(bundleName: string): void {
    if (bundleName === '') {
      log.showError('subscribe Uninstall error');
      return;
    }
    try {
      bundleMonitor.on('remove', (bundleChangeInfo) => {
        log.showInfo('subscribeUninstall Succeeded');
        if (bundleChangeInfo.bundleName === bundleName) {
          this.unSubscribeCommonEvent(this.mBundleName);
          this.setValue(DATA_SHARE_BUNDLE_NAME, '');
          this.setValue(DATA_SHARE_ABILITY_NAME, '');
          this.setValue(DATA_SHARE_TOKEN_ID, '');
          this.mBundleName = '';
          this.mVmAbilityName = '';
          this.mTokenId = '';
          this.mVmSceneContainerSession = null;
        }
      })
    } catch (errData) {
      let message = (errData as BusinessError).message;
      let errCode = (errData as BusinessError).code;
      log.showWarn(`errData is errCode:${errCode}  message:${message}`);
    }
  }

  /**
   * Update settingData by settingDataKey.
   */
  private async setValue(settingDataKey: string, value: string): Promise<void> {
    settingsDataManager.setValue(null, settingDataKey, value);
    log.showInfo(`setValue settingDataKey: ${settingDataKey}, value: ${value}`);
  }

  private async subUninstall(): Promise<void> {
    let value: string = settingsDataManager.getValue(null, DATA_SHARE_ABILITY_NAME, '');
    this.subscribeUninstall(value);
  }

  private async updateAbilityName(): Promise<void> {
    this.mVmAbilityName = settingsDataManager.getValue(null, DATA_SHARE_ABILITY_NAME, '');
    log.showInfo(`updateAbilityName: ${this.mVmAbilityName}`);
  }

  private async updateBundleName(): Promise<void> {
    this.mBundleName = settingsDataManager.getValue(null, DATA_SHARE_BUNDLE_NAME, '');
    if (this.mBundleName !== '') {
      this.subscribeCommonEvent(this.mBundleName);
    }
    log.showInfo(`updateBundleName: ${this.mBundleName}`);
  }

  private async updateTokenId(): Promise<void> {
    this.mTokenId = settingsDataManager.getValue(null, DATA_SHARE_TOKEN_ID, '');
    log.showInfo(`updateTokenId: ${this.mTokenId}`);
  }

  private getVmStartSnapshotSync(): PixelMap | null {
    try {
      let data: Uint8Array = getContext().resourceManager.getMediaByNameSync('static_vm_start_snapshot');
      let imageSource = image.createImageSource(data.buffer);
      if (imageSource != undefined) {
        return imageSource.createPixelMapSync()
      }
    } catch (error) {
      log.showError(`getMediaByName error= ${error}`);
    }
    return null;
  }

  private subDataShareChange(): void {
    let bundleNameValueChange = settingsDataManager.registerKeyObserver(DATA_SHARE_BUNDLE_NAME, () => {
      log.showInfo('on dataChange');
      this.onDataShareChange();
    });
    if (bundleNameValueChange) {
      log.showInfo('bundleName SubDataShareChange success');
    } else {
      log.showError('bundleName SubDataShareChange error');
    }
    let tokenIdValueChange = settingsDataManager.registerKeyObserver(DATA_SHARE_TOKEN_ID, () => {
      log.showInfo('on dataChange');
      this.onDataShareChange();
    });
    if (tokenIdValueChange) {
      log.showInfo('tokenId SubDataShareChange success');
    } else {
      log.showError('tokenId SubDataShareChange error');
    }
  }

  private onDataShareChange(): void {
    log.showInfo('onDataShareChange');
    if (this.mBundleName !== '') {
      this.unSubscribeCommonEvent(this.mBundleName);
    }
    this.updateBundleName();
    this.updateTokenId();
  }

  public publishCommonEvent(): void {
    let options:commonEventManager.CommonEventPublishData = {
      code: 0,
      data: 'The entry to VM is not allowed'
    }
    // 发布公共事件
    try {
      let userId: number = AccountHelper.getInstance().currentLocalId;
      commonEventManager.publishAsUser(PUBLISH_EVENT_NOT_ENTRY, userId, options, () => {
        log.showInfo('publish success');
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      log.showError(`publish failed, code is ${err.code}` + `, message is ${err.message}`);
    }
  }

  private subscribeCommonEvent(bundleName: string): void {
    //订阅者信息
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [PUBLISH_EVENT],
      publisherBundleName: bundleName
    };
    //创建订阅者
    try {
      commonEventManager.createSubscriber(subscribeInfo).then((res) => {
        log.showInfo('publish createSubscriber');
        this.subscriber = res;
        commonEventManager.subscribe(this.subscriber, this.bundleNameCallback);
      });
    } catch (error) {
      let err: Base.BusinessError = error as Base.BusinessError;
      log.showInfo(`publish createSubscriber failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  private bundleNameCallback = async (err: BusinessError, data: commonEventManager.CommonEventData) => {
    if (err) {
      log.showInfo('publish subscribe failed');
      return;
    }
    if (CommonUtils.isInvalid(data.data)) {
      return;
    }
    try {
      let appData: VmAppConfig = JSON.parse(data.data!);
      log.showInfo('subscribe appData');
      let tokenId = await this.getAccessTokenId(this.mBundleName);
      if (tokenId === this.mTokenId) {
        this.mVmAbilityName = appData.abilityName;
        this.setValue(DATA_SHARE_ABILITY_NAME, this.mVmAbilityName);
        log.showInfo('TokenId verification succeeded');
      } else {
        log.showError(`TokenId verification FAIL! Bundle tokenId : ${tokenId}, this.mTokenId : ${this.mTokenId}`);
      }
    } catch (err) {
      log.showError(`parse abilityName failed, code is ${err.code}, message is ${err.message}`);
    }
  };

  private unSubscribeCommonEvent(bundleName: string): void {
    //订阅者信息
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [PUBLISH_EVENT],
      publisherBundleName: bundleName
    };
    //创建订阅者
    try {
      commonEventManager.createSubscriber(subscribeInfo).then((res) => {
        log.showInfo('unSubscribeCommonEvent');
        this.subscriber = res;
        //订阅公共事件
        commonEventManager.unsubscribe(this.subscriber, (err) => {
          log.showInfo(`publish unsubscribe failed, message is ${err}`);
        });
      });
    } catch (error) {
      let err: Base.BusinessError = error as Base.BusinessError;
      log.showInfo(`publish createSubscriber failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  private async getAccessTokenId(bundleName: string): Promise<string> {
    log.showInfo('start getAccessTokenId Succeeded');
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION;
    try {
      let applicationInfo = await bundleManager.getApplicationInfo(bundleName, bundleFlags);
      let tokenId: number = applicationInfo.accessTokenId;
      log.showInfo(`getApplicationInfo TokenId Succeeded, tokenId : ${tokenId.toString()}`);
      return tokenId.toString();
    } catch (err) {
      log.showError(`getApplicationInfo failed, code is ${err.code}, message is ${err.message}`);
    }
    return '';
  }

  public setRecentClosed(recentClosed: boolean): void {
    this.mRecentClosed = recentClosed;
  }

  public getRecentClosed(): boolean {
    return this.mRecentClosed;
  }

  public onRearAni(isToVm: boolean): void {
    log.showInfo(`followHandAni end, onRearAni begin, isToVm: ${isToVm}`);
    // 仅 HOST->VM 时
    if (isToVm && !this.mIsVmDesktop) {
      settingsDataManager.setValue(null, 'enable_combine_key', 'false');
    }
  }

}

export interface VmAppConfig {
  /**
   * 虚拟机hap abilityName
   */
  abilityName: string;
}

/**
 * 虚拟机状态变更回调
 *
 * @Param isVm: true 虚拟机进前台; false 虚拟机离前台
 * @Param tarVmScreenId: 虚拟机进前台的屏幕id; 离前台时传 INVALID_SCREEN_ID
 */
export type VmStateCallBack = (isVm: boolean, tarVmScreenId: number) => void;