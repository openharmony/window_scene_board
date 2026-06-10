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
import { Constants, PipTemplate } from './utils/PictureInPictureConstants';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import {
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBScreenSession,
  SCBScreenSessionManager,
  SCBSpecificSession
} from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBSessionRect,
  SCBSideManagerConstant,
  SideFloatingAnimParams
} from '@ohos/windowscene';
import { AccessibilityManager, GlobalContext, sSettingsUtil, DeviceHelper } from '@ohos/frameworkwrapper';
import { curves } from '@kit.ArkUI';
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
  private pipActionCallback: Function | null = null;
  private _oneShotContainerId: number = -1;
  private _startingContainerId: number = -1;
  private context = GlobalContext.getContext();
  private autoStartPipStatus: boolean = this.getSettingAutoStartPipStatus();
  private pipRotationCallback: ((container: SCBSceneContainerSession, screenSession: SCBScreenSession,
    fromUser: boolean) => number) | null = null;
  private updatePIPPanelZIndexCallback?: (zIndex: number) => void;
  private idToColdStartScaleMap: Map<number, number> = new Map();
  public pipSideManagerInfo: PiPSideManagerInfo = {
    sideDirect: 'right',
    originScale: 1,
    originRadius: 16,
    originRect: new SCBSessionRect(0, 0, 0, 0)
  };
  public isNeedRotation: boolean = false;
  // actively or passively start the pip window
  public isActiveStartPiP = true;
  public needBlockShowOverlayCount: number = 0;
  public isRotationDelayed: boolean = false;

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

  /** get cold start scale
   *
   * @param persistentId
   * @returns
   */
  public getColdStartScale(persistentId: number): number {
    return this.idToColdStartScaleMap.get(persistentId) ?? -1;
  }

  /** set cold start scale
   *
   * @param persistentId
   * @param scaleLevel
   */
  public recordColdStartScale(persistentId: number, scaleLevel: number): void {
    log.showInfo(`setColdStartScale, persistentId = ${persistentId} scaleLevel = ${scaleLevel}`);
    this.idToColdStartScaleMap.set(persistentId, scaleLevel);
  }

  /** delete cold start scale if record is in map
   *
   * @param persistentId
   */
  public deleteColdStartScale(persistentId: number): void {
    if (this.idToColdStartScaleMap.has(persistentId)) {
      log.showInfo(`deleteColdStartScale, persistentId = ${persistentId}`);
      this.idToColdStartScaleMap.delete(persistentId);
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
   * @param { SCBSessionRect } notifyRect
   * @param { SCBSessionRect } newRect
   * @param { number } oldScale
   * @param { number } newScale
   */
  public notifyPipSizeChange(notifyRect: SCBSessionRect, newRect: SCBSessionRect, oldScale: number,
    newScale: number): boolean {
    if (!newRect.equalsOfSize(notifyRect) || oldScale !== newScale) {
      notifyRect.copyFrom(newRect);
      log.showInfo(`notifyPipSizeChange: ` + notifyRect.printPx());
      try {
        this.pipSpecificSession?.session.notifyPipSizeChange(notifyRect.width.getPx(),
          notifyRect.height.getPx(), newScale);
      } catch (err) {
        log.showError(`notifyPipSizeChange err: ` + notifyRect.printPx());
      }
      return true;
    }
    return false;
  }

  public registerControlStatusChangeCallback(callback: (controlType: sceneSessionManager.PiPControlType,
    status: sceneSessionManager.PiPControlStatus) => void) {
    this.pipSpecificSession?.registerSessionControlStatusChangeCallback(callback);
  }

  public unRegisterControlStatusChangeCallback() {
    this.pipSpecificSession?.unregisterSessionControlStatusChangeCallback();
  }

  public registerUpdatePIPPanelZIndexCallback(callback: (zIndex: number) => void): void {
    this.updatePIPPanelZIndexCallback = callback;
  }

  public notifyUpdatePIPPanelZIndex: (zIndex: number) => void = (zIndex) => {
    if (this.updatePIPPanelZIndexCallback) {
      this.updatePIPPanelZIndexCallback(zIndex);
    }
  };

  public unregisterUpdatePIPPanelZIndexCallback(): void {
    this.updatePIPPanelZIndexCallback = undefined;
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
  /**
   * The callback of register whether restore is need to rotate
   *
   * @param callback
   */
  public registerRestoreWithRotation(callback: ((container: SCBSceneContainerSession, screenSession: SCBScreenSession,
    fromUser: boolean) => number) | null): void {
    this.pipRotationCallback = callback;
  }

  /**
   * The callback of unregister whether restore is need to rotate
   */
  public unregisterRestoreWithRotation(): void {
    this.pipRotationCallback = null;
  }

  /**
   * Gets the targetRotation on restore
   *
   * @param container
   * @param screenSession
   * @param fromUser
   * @returns target rotation
   */
  public executeRestoreWithRotationCallback(container: SCBSceneContainerSession, screenSession: SCBScreenSession,
    fromUser: boolean): number {
    if (this.pipRotationCallback) {
      return this.pipRotationCallback(container, screenSession, fromUser);
    }
    return 0;
  }

  public registerPiPActionEvent(callback: Function): void {
    log.showInfo('registerPiPActionEvent');
    this.pipActionCallback = callback;
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

  public unregisterPiPActionEvent(callback: Function): void {
    log.showInfo('unregisterPiPActionEvent');
    if (this.pipActionCallback && this.pipActionCallback === callback) {
      this.pipActionCallback = null;
    } else {
      log.showWarn("unregisterPiPActionEvent callback is not same, don't set null");
    }
  }

  public executePiPActionCallback(action: string):void {
    if (this.pipActionCallback) {
      this.pipActionCallback(action);
    } else {
      log.showWarn('executePiPActionCallback callback is null');
    }
  }

  public animateOnTouchPiP(sideFloatingAnimParams: SideFloatingAnimParams):void {
    let persistentId = sideFloatingAnimParams.persistentId;
    let container: SCBSpecificSession | null = null;
    let touchWidth = sideFloatingAnimParams.width * (1 - SCBSideManagerConstant.SIDE_MANAGER_TOUCH_SCALE) / 2;
    let touchHeight = sideFloatingAnimParams.height * (1 - SCBSideManagerConstant.SIDE_MANAGER_TOUCH_SCALE) / 2;
    // 侧边管理器按压动效
    animateTo({
      curve: Curve.Sharp,
      duration: 250
    }, () => {
      if (container !== null) {
        container.sideEdgeManagerParam.sideManagerScale =
          container.sideEdgeManagerParam.sideManagerScale * SCBSideManagerConstant.SIDE_MANAGER_TOUCH_SCALE;
        container.sideEdgeManagerParam.sideManagerPosX = container.sideEdgeManagerParam.sideManagerPosX + touchWidth;
        container.sideEdgeManagerParam.sideManagerPosY = container.sideEdgeManagerParam.sideManagerPosY + touchHeight;
      }
    })
  }

  public animateOnRecoverMinFromSideManager(sideFloatingAnimParams: SideFloatingAnimParams):void {
    log.showInfo(`pipSideManagerInfo.originScale: ${this.pipSideManagerInfo.originScale}`);
    let persistentId = sideFloatingAnimParams.persistentId;
    let container: SCBSpecificSession | null = null;
    // 侧边管理器按压后画中画一镜到底动效
    animateTo({
      curve: curves.springMotion(0.4, 0.8),
      delay: 250,
      onFinish: () => {
        this.executePiPActionCallback(Constants.ACTION_DOCK_RESTORE);
      }
    }, () => {
      if (container !== null) {
        container.sideEdgeManagerParam.sideManagerScale =
          container.sideEdgeManagerParam.sideManagerScale * SCBSideManagerConstant.SIDE_MANAGER_TOUCH_SCALE;
        container.sideEdgeManagerParam.sideManagerPosX = this.pipSideManagerInfo.originRect.left.getVp();
        container.sideEdgeManagerParam.sideManagerPosY = this.pipSideManagerInfo.originRect.top.getVp() -
          36 * container.sideEdgeManagerParam.sideManagerScale + sideFloatingAnimParams.scrollOffsetY - 36;
        container.sideEdgeManagerParam.sideManagerOpacity = 0;
        container.sideEdgeManagerParam.sideWindowRadius = this.pipSideManagerInfo.originRadius *
        this.pipSideManagerInfo.originScale / container.sideEdgeManagerParam.sideManagerScale
      }
    })
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

  public isNeedVisualEffectChange(): boolean {
    return ['SDM', 'ZMG', 'YNB', 'XHA'].some(type => DeviceHelper.PRODUCT_MODEL.includes(type));
  }
}