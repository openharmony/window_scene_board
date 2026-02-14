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
import { PipTemplate } from './utils/PictureInPictureConstants';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { SCBSceneInfo, SCBSceneContainerSession, SCBScreenSessionManager, SCBSpecificSession } from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBSessionRect,
} from '@ohos/windowscene';
import { AccessibilityManager, GlobalContext, sSettingsUtil } from '@ohos/frameworkwrapper';
import { SCBSceneMode } from '@ohos/windowscene';
import { BusinessError, settings } from '@kit.BasicServicesKit';
const TAG = 'SCBPiPManager';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const PIP_AUTO_START_KEY: string = 'auto_start_pip_status';

export interface PiPSideManagerInfo {
  sideDirect: string;
  originScale: number;
  originRadius: number;
  originRect: SCBSessionRect;
}

/**
 * picture in picture manager
 */
export class SCBPiPManager {
  public startExcludeEventTimeStamp: number = 0;
  private static instance: SCBPiPManager | null = null;
  private pipSpecificSession: SCBSpecificSession | null = null;
  private pipSceneSession: SCBSceneSession | null = null;
  private _oneShotContainerId: number = -1;
  private _startingContainerId: number = -1;
  private context = GlobalContext.getContext();
  private autoStartPipStatus: boolean = this.getSettingAutoStartPipStatus();
  public pipSideManagerInfo: PiPSideManagerInfo = {
    sideDirect: 'right',
    originScale: 1,
    originRadius: 16,
    originRect: new SCBSessionRect(0, 0, 0, 0)
  };
  public isNeedRotation: boolean = false;

  // actively or passively start the pip window
  public isActiveStartPiP = true;

  // whether pip show animation is running
  public isPipShowAnimating: boolean = false;

  private constructor() {}

  public get oneShotContainerId() {
    return this._oneShotContainerId;
  }

  public set oneShotContainerId(containerId: number) {
    this._oneShotContainerId = containerId;
  }

  public get startingContainerId() {
    return this._startingContainerId;
  }

  public set startingContainerId(containerId: number) {
    this._startingContainerId = containerId;
  }

  public autoStartPiPCallback = (persistentId: number): void => {
    this.isNeedStartPiP(persistentId)
  }
  /**
   * Get the singleton of the picture in picture manager.
   */
  public static getInstance(): SCBPiPManager {
    if (SCBPiPManager.instance === null) {
      SCBPiPManager.instance = new SCBPiPManager();
      SCBPiPManager.instance.init();
    }
    return SCBPiPManager.instance;
  }

  private init() {
    AccessibilityManager.getInstance().initAccessibilityModeListener();
  }

  public hasPipSpecificSession() {
    return this.pipSpecificSession !== null;
  }

  public attachPiPWindowSession(pipSpecificSession: SCBSpecificSession): void {
    this.pipSpecificSession = pipSpecificSession;
  }

  public detachPiPWindowSession(persistentId: number): void {
    if (this.pipSpecificSession?.session.persistentId === persistentId) {
      this.pipSpecificSession = null;
    }
  }

  /**
   * attach PiP window scene session
   * @param pipSceneSession
   */
  public attachPiPWindowSceneSession(pipSceneSession: SCBSceneSession): void {
    this.pipSceneSession = pipSceneSession;
  }

  /**
   * detach PiP window scene session
   * @param persistentId
   */
  public detachPiPWindowSceneSession(persistentId: number): void {
    if (this.pipSceneSession?.session.persistentId === persistentId) {
      this.pipSceneSession = null;
    }
  }

  public sendActionControlEvent(action: string, status: number): void {
    log.showInfo(`setPipActionEvent action:${action}, status:${status}`);
    try {
      this.pipSpecificSession?.session.setPipActionEvent(action, status);
    } catch (err) {
      log.showError(`setPipActionEvent ${action} ${status} err`);
    }
  }

  public sendControlEvent(control: sceneSessionManager.PiPControlType, status:
    sceneSessionManager.PiPControlStatus): void {
    log.showInfo(`setPiPControlEvent control:${control}, status:${status}`);
    try {
      this.pipSpecificSession?.session.setPiPControlEvent(control, status);
    } catch (err) {
      log.showError(`setPiPControlEvent ${control} ${status} err`);
      return;
    }
    SCBPiPManager.getInstance().setControlGroupsControlStatus(control, status);
  }

  /**
   * notify app window size info via pip control
   *
   * @param { number } width
   * @param { number } height
   * @param { number } scale
   */
  public notifyPipSizeChange(width: number, height: number, scale: number): void {
    log.showInfo(`notifyPipSizeChange width:${width}, height:${height}, scale:${scale}`);
    try {
      this.pipSpecificSession?.session.notifyPipSizeChange(width, height, scale);
    } catch (err) {
      log.showError(`notifyPipSizeChange width:${width}, height:${height}, scale:${scale} err`);
    }
  }

  public registerControlStatusChangeCallback(callback: (controlType: sceneSessionManager.PiPControlType,
    status: sceneSessionManager.PiPControlStatus) => void) {
    this.pipSpecificSession?.registerSessionControlStatusChangeCallback(callback);
  }

  public unRegisterControlStatusChangeCallback() {
    this.pipSpecificSession?.unregisterSessionControlStatusChangeCallback();
  }

  public getTemplateType(): PipTemplate | undefined {
    return this.pipSpecificSession?.session.pipTemplateInfo.pipTemplateType;
  }

  public getControlGroups(): number[] {
    if (this.pipSpecificSession === null || this.pipSpecificSession === undefined) {
      return [];
    }
    return this.pipSpecificSession.session.pipTemplateInfo.controlGroup;
  }

  /**
   * get pip scene session
   * @returns the scene session of the pip window
   */
  public getPipSceneSession(): SCBSceneSession | null {
    return this.pipSceneSession;
  }

  public setControlGroupsControlStatus(controlType: sceneSessionManager.PiPControlType,
    status: sceneSessionManager.PiPControlStatus) {
    log.showInfo(`setControlGroupsControlStatus controlType: ${controlType}, enabled: ${status}`);
    if (this.pipSpecificSession === null || this.pipSpecificSession === undefined) {
      return;
    }
    // save control panel control status after pip window is opened
    for (const pipControlStatusInfo of this.pipSpecificSession.session.pipTemplateInfo.pipControlStatusInfoList) {
      if (pipControlStatusInfo.controlType === controlType) {
        pipControlStatusInfo.status = status;
        return;
      }
    }
    this.pipSpecificSession.session.pipTemplateInfo.pipControlStatusInfoList.push({controlType: controlType,
      status: status});
  }

  public setControlGroupsControlEnable(controlType: sceneSessionManager.PiPControlType,
    enabled: sceneSessionManager.PiPControlStatus) {
    log.showInfo(`setControlGroupsControlEnable controlType: ${controlType}, enabled: ${enabled}`);
    if (this.pipSpecificSession === null || this.pipSpecificSession === undefined) {
      return;
    }
    // save control panel control enable status after pip window is opened
    for (const pipControlEnabledInfo of this.pipSpecificSession.session.pipTemplateInfo.pipControlEnableInfoList) {
      if (pipControlEnabledInfo.controlType === controlType) {
        pipControlEnabledInfo.enabled = enabled;
        return;
      }
    }
    this.pipSpecificSession.session.pipTemplateInfo.pipControlEnableInfoList.push({controlType: controlType,
      enabled: enabled});
  }

  public getTemplateInfo(): sceneSessionManager.PipTemplateInfo | undefined {
    return this.pipSpecificSession?.session.pipTemplateInfo;
  }

  public isDefaultControlVisible(): boolean {
    if (this.getTemplateType() === PipTemplate.TYPE_VIDEO_CALL ||
      this.getTemplateType() === PipTemplate.TYPE_VIDEO_MEETING) {
      // Restore button and Close button will be invisible when Call and Meeting template control groups is emtpy
        return this.getControlGroups().length !== 0;
    }
    return true;
  }

  /**
   * whether is need start pip
   *
   * @param { number } persistentId
   */
  private isNeedStartPiP(persistentId: number): void {
    let scbSceneSession = SCBSceneSessionManager.getInstance().getSessionById(persistentId);
    let pipSwitchState: boolean = this.getAutoStartPipStatus();
    log.showInfo(`get pip_auto_start_value, result: ${pipSwitchState}`);
    if (scbSceneSession === null || !(scbSceneSession instanceof SCBSceneSession)) {
      log.showInfo(`scbSceneSession is null or scbSceneSession not instanceof SCBSceneSession`);
      return;
    }
    if (this.isPiPForbidden(scbSceneSession.sceneInfo)) {
      log.showInfo('forbid autostart');
      return;
    }
    if (this.hasPipSpecificSession()) {
      log.showInfo('pipWindow already exist, return');
      return;
    }
    log.showInfo(`isNeedStartPiP: ${scbSceneSession.isNeedStartPiP}`);
    if (pipSwitchState === false || !scbSceneSession.isNeedStartPiP) {
      // restore the auto start status to the default value
      scbSceneSession.isNeedStartPiP = true;
      return;
    }
    try {
      scbSceneSession?.session.setPipActionEvent('background_auto_start', -1);
      this.isActiveStartPiP = false;
    } catch (err) {
      log.showError(`sendActionControlEvent background_auto_start -1 err`);
    }
  }

  public isPiPForbidden(sceneInfo: SCBSceneInfo): boolean {
    if (!sceneInfo) {
      log.showError('invalid sceneInfo');
      return false;
    }
    const screenName: string | undefined =
      SCBScreenSessionManager.getInstance().getScreenSession(sceneInfo.screenId)?.session?.name;
    if (!screenName) {
      log.showError('invalid screen name');
      return false;
    }
    if (screenName === 'PadWithCar') {
      log.showInfo(`current screen is ${screenName}`);
      return true;
    }
    return false;
  }

  /**
   * 判断当前是否在无障碍模式下
   */
  public isAccessibilityMode(): boolean {
    return AccessibilityManager.getInstance().getIsAccessibilityMode();
  }

  /**
   * 在无障碍模式下主动播报信息
   * @param readThing 主动播报信息 string
   */
  public sendAccessibilityEvent(readThing: string): void {
    if (!readThing || !this.isAccessibilityMode()) {
      return;
    }
    let accessibilityManager = AccessibilityManager.getInstance();
    accessibilityManager.sendTextAnnouncedForAccessibility(readThing,
      'announceForScbPipManger');
  }

  public resetContainerWithPipStartSceneIfNeed(containerSession: SCBSceneContainerSession | null) {
    if (containerSession === null || containerSession === undefined) {
      return;
    }
    log.showInfo(`resetContainerWithStartSceneIfNeed containerId: ${containerSession?.containerId}` +
      `oneShotContainerId: ${this.oneShotContainerId} startingContainerId: ${this.startingContainerId}`)
    this.startingContainerId = containerSession.containerId;
    if (this.oneShotContainerId === this.startingContainerId && containerSession.isAutoPiPOneShot) {
      if (containerSession.isSplitView()) {
        containerSession.containerBlurScale = 0;
      } else {
        containerSession.dividerParam.primary.blurScale = 0;
      }
      containerSession.dividerParam.releaseSceneFreeze('startAutoPiP');
    }
  }

  public onOneShotAnimationStart(containerSession: SCBSceneContainerSession) {
    log.showInfo(`onOneShotAnimationStart containerId: ${containerSession?.containerId}`)
    this.oneShotContainerId = containerSession.containerId;
    this.startingContainerId = -1;
  }

  public onOneShotAnimationEnd() {
    log.showInfo(`onOneShotAnimationEnd`)
    this.oneShotContainerId = -1;
    this.startingContainerId = -1;
  }

  // get the status of autoStartPipSwitch in setting
  private getSettingAutoStartPipStatus(): boolean {
    let autoStartPipStateStr: string = sSettingsUtil.getSystemValue('auto_start_pip_status', 'true', this.context);
    log.showInfo(`auto_start_pip_status: ${autoStartPipStateStr}`);
    return (autoStartPipStateStr === 'true');
  }

  // monitor the change of autoStartPipSwitch in setting
  public registerAutoStartPipStatusChange(): void {
    try {
      settings.registerKeyObserver(this.context, PIP_AUTO_START_KEY,
        settings.domainName.USER_PROPERTY, () => {
          this.autoStartPipStatus = this.getSettingAutoStartPipStatus();
          SCBSceneSessionManager.getInstance().setPiPSwitchStatus(this.autoStartPipStatus);
        });
    } catch (err) {
      let errInfo: BusinessError = err as BusinessError;
      log.showError(`registerAutoStartPipObserver, catch err code: ${errInfo?.code} msg: ${errInfo?.message}`);
    }
  }

  public unregisterAutoStartPipStatusChange(): void {
    settings.unregisterKeyObserver(this.context, PIP_AUTO_START_KEY, settings.domainName.USER_PROPERTY);
  }

  public getAutoStartPipStatus(): boolean {
    log.showInfo(`autoStartPipStatus: ${this.autoStartPipStatus}`);
    return this.autoStartPipStatus;
  }
}