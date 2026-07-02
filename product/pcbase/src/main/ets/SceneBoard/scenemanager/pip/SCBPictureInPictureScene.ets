/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBPropertyChangeReason,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSessionRect,
  SCBSpecificSession,
  SCBSystemSceneSession,
  SystemSessionInfo,
  SCBSceneContainerSession,
  SCBSceneMode,
  SCBEventId,
  scbEventExclusiveManager,
  EventType,
  ResUtils,
  ScenePanelState,
  SCBScreenSessionManager
} from '@ohos/windowscene';
import { CommonUtils, LogDomain, LogHelper, Trace, } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { RotationConstants } from '@ohos/commonconstants';
import curves from '@ohos.curves';
import hiSysEvent from '@ohos.hiSysEvent';
import { BusinessError } from '@ohos.base';
import { SCBDefaultZIndex } from '../SCBScreen';
import { PiPOverlay } from './overlay/PiPOverlay';
import { Constants, PipRectUpdateReason } from './utils/PictureInPictureConstants';
import { PipRectCalculator, RectChangeItem, ScaleLevel } from './utils/PiPUtils';
import { Queue } from '@kit.ArkTS';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import image from '@ohos.multimedia.image';
import { SCBPiPManager } from './SCBPiPManager';
import { systemDateTime } from '@kit.BasicServicesKit';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { PipOneShotAnimHelper } from './utils/PipOneShotAnimHelper';
import { PipSceneManager } from '@ohos/systemuicommon/newTsIndex';
import screenSessionManager from '@ohos.screenSessionManager';

const TAG = 'SCBPictureInPictureScene';
const SIDE_EDGE_BAR_DARK_COLOR = '#66666666';
const SIDE_EDGE_BAR_LIGHT_COLOR = '#667e7e7e';
const LIGHT_BAR_BORDER_COLOR = '#66666666';
const DARK_BAR_BORDER_COLOR = '#66FFFFFF';
const DEFAULT_SIZE: number = 500;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const id = 'pip_window_frame';
const MID_ZOOM_RATIO = 0.8875;
const SIZE_UPDATE_DELAY_TIME = 50;
const SIZE_NOTIFY_DELAY_TIME = 100;
export class PipReportEventUtil {
  private static readonly MULTIWINDOW_UE: string = 'MULTIWINDOW_UE';
  private static readonly PNAMEID: string = 'SCB';
  private static readonly PVERSION: string = '1.0';

  private static reportEvent(eventName: string, msg: Object): void {
    hiSysEvent.write({
      domain: PipReportEventUtil.MULTIWINDOW_UE,
      name: eventName,
      eventType: hiSysEvent.EventType.BEHAVIOR,
      params: msg
    }).then((val) => {
      log.showDebug('success');
    }).catch((err: BusinessError) => {
      log.showError('report false ' + err.message);
    })
  }

  static reportPipDisplayEvent(isShow: number, reason: number, operationPackage: string): void {
    let eventName: string = 'DISPLAY_PIP';
    let params: PipDisplayParams = {
      PNAMEID: PipReportEventUtil.PNAMEID,
      PVERSION: PipReportEventUtil.PVERSION,
      IS_SHOW: isShow,
      REASON: reason,
      OPERATION_PACKAGE_NAME: operationPackage
    };
    PipReportEventUtil.reportEvent(eventName, params);
  }

  static reportPipMoveEvent(operationPackage: string) {
    let params: PipMoveParams = {
      PNAMEID: PipReportEventUtil.PNAMEID,
      PVERSION: PipReportEventUtil.PVERSION,
      OPERATION_PACKAGE_NAME: operationPackage
    };
    PipReportEventUtil.reportEvent('MOVE_PIP', params);
  }

  static reportPipResizeEvent(scaleLevel: number, width: number, height: number, operationPackage: string) {
    let params: PipResizeParams = {
      PNAMEID: PipReportEventUtil.PNAMEID,
      PVERSION: PipReportEventUtil.PVERSION,
      SCALE_LEVEL: scaleLevel,
      WINDOW_WIDTH: width,
      WINDOW_HEIGHT: height,
      OPERATION_PACKAGE_NAME: operationPackage
    };
    PipReportEventUtil.reportEvent('RESIZE_PIP_SIZE', params);
  }
}

interface PipDisplayParams {
  PNAMEID: string;
  PVERSION: string;
  IS_SHOW: number;
  REASON: number;
  OPERATION_PACKAGE_NAME: string;
}

interface PipResizeParams {
  PNAMEID: string;
  PVERSION: string;
  SCALE_LEVEL: number;
  WINDOW_WIDTH: number;
  WINDOW_HEIGHT: number;
  OPERATION_PACKAGE_NAME: string;
}

interface PipMoveParams {
  PNAMEID: string;
  PVERSION: string;
  OPERATION_PACKAGE_NAME: string;
}

export enum DisplayReason {
  DEFAULT,
  BORDER,
  FILE,
  RECENT
}

@Component
export struct SCBPictureInPictureScene {
  isAvoidNavigationIndicator: boolean = false;
  isRotating: boolean = false;
  timeoutIds: number[] = [];

  // HiView info
  bundleName: string = '';
  private rectCalculator: PipRectCalculator = new PipRectCalculator();
  // real specificSession rect
  @State realRectWidth: number = 0;
  @State realRectHeight: number = 0;
  private sourceRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  private parentId: number = -1;
  private lastMode: SCBSceneMode = SCBSceneMode.UNDEFINED;
  private useSnapshot: boolean = false;
  private isRestoreFromBg: boolean = false;
  private shouldAnimToSource: boolean = false;
  @State isShowDefaultBackground: boolean = true;
  @ObjectLink specificSession: SCBSpecificSession;
  @Link screenProperty: SCBScreenProperty;
  @ObjectLink rect: SCBSessionRect;
  @State @Watch('overlayRectChange') overlayRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  @State moveStartOverlayRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  @State moveStartRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  @State isInSideManager: boolean = false;
  @State @Watch('scaleValueChange')scaleValue: number = 1;
  @State moveStartScale: number = 1;
  @State centerScaleX: string = '0';
  @State centerScaleY: string = '0';
  @State pipBorderRadius: number = 4;
  @State opacityNum: number = 1;
  @State transX: number = 0;
  @State transY: number = 0;
  // used to move pip to an offset position when dragging. pip real translateX = transX + transXOffset
  @State transXOffset: number = 0;
  @State transYOffset: number = 0;
  // trans change caused by move pip
  @State moveEndTransX: number = 0;
  @State moveEndTransY: number = 0;
  @State shadowStyle: ShadowStyle | undefined = undefined;
  // trans change caused by pip scale anim
  @State scaleTransX: number = 0;
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;
  @State showSideBar: boolean = false;
  @State clipPiPWindow: boolean = false;
  @Prop @Watch('onScreenPropChange') propChangeReason: SCBPropertyChangeReason;
  @Link msgQueue: Queue<RectChangeItem>;
  @State closed: boolean = false;
  @State cachePixMap: image.PixelMap | null = null;
  @State foregroundBlur: number = -1;
  @Link panelZIndex: number;
  @State overlayZIndex: number = this.panelZIndex + 1;
  @State moveAnimateCount: number = 0;

  @Link delayRotation: boolean;
  @Link pipBackgroundOpacity: number;
  @State isPiPVisibility: boolean = true;
  private restoreOneShot: boolean = false;
  private isRestoreFromRecent: boolean = false;
  private shouldDoRestore: boolean = false;
  private isRestoreDone: boolean = false;
  activeRotation?: () => void;
  recoverRotation?: () => void;

  // pip overlay
  private overlaySystemSessionInfo: SystemSessionInfo = {
    systemType: sceneSessionManager.SessionType.TYPE_PIP,
    sceneName: 'pip_overlay',
    sceneZIndex: SCBDefaultZIndex.PIP_SCENE_PANEL_OVERLAY,
    isFocusable: false,
    isTouchable: true,
    privacyMode: false,
    isRotatable: true,
    hitTestMode: HitTestMode.None,
    sceneType: sceneSessionManager.SceneType.SYSTEM_WINDOW_SCENE,
  };

  private overlaySceneSession: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
    .requestSystemSceneSession(this.overlaySystemSessionInfo, undefined, false, this.screenProperty.screenId);

  onMoveEdgeSpringBackAnimationFinished = (): void => {
    this.moveAnimateCount--;
    SCBPiPManager.getInstance().isPipShowAnimating = false;
    if (this.moveAnimateCount == 0) {
      // restore zIndex after edge spring back.
      if (this.panelZIndex !== SCBDefaultZIndex.PIP_SCENE_PANEL) {
        this.updatePanelZIndex(SCBDefaultZIndex.PIP_SCENE_PANEL);
      }
    }
  }

  recentCallback = (property: boolean): void => {
    this.processEdgeSpringBack();
  }

  private onParentForeground = (): void => {
    SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
    this.processDoRestore();
  }

  private onSceneRaiseToTop = (persistentId?: number): void => {
    if (!persistentId) {
      return;
    }
    if (persistentId !== this.parentId) {
      return;
    }
    this.lastMode = this.getParentWindowMode();
    log.showInfo(`onSceneRaiseToTop lastMode = ${this.lastMode}`);
  }

  private updatePanelZIndex(zIndex: number): void {
    log.showInfo(`updatePanelZIndex from ${this.panelZIndex} to ${zIndex}`);
    this.panelZIndex = zIndex;
  }

  enableShow(): boolean {
    if (this.specificSession === null || this.specificSession === undefined) {
      log.showError('enable show is false, specificSession is null');
      return false;
    }

    if (this.specificSession.isCustomAnimationPlaying) {
      log.showDebug('enable show is true, is playing custom animation');
      return true;
    }

    if (this.specificSession.isActive) {
      log.showDebug('enable show is true, is in active state');
      return true;
    }

    log.showError('enable show is false');
    return false;
  }

  private enableShowWindowScene(): boolean {
    log.showDebug(`enableShowWindowScene persistentId:${this.specificSession.session.persistentId}, ` +
      `screenId:${this.specificSession.screenId}, screenProperty:${this.screenProperty.screenId}, ` +
      `isCrossingScreen:${this.specificSession.isCrossingScreen}`);
    if (this.specificSession.screenId !== this.screenProperty.screenId) {
      return false;
    }

    // 非跨屏场景
    if (!this.specificSession.isCrossingScreen) {
      return true;
    }

    this.specificSession.isCrossingScreen = false;
    return true;
  }

  private getSCBSessionRectInfo(rect?: SCBSessionRect): string {
    if (rect === null || rect === undefined) {
      return '[]';
    }
    return `[ ${rect.left.getPx()}, ${rect.top.getPx()}, ${rect.width.getPx()}, ${rect.height.getPx()} ]`;
  }

  overlayRectChange() {
    if (this.isInSideManager) {
      log.showInfo(`overlayRectChange overlayRect: ${this.getSCBSessionRectInfo(this.overlayRect)}`);
      SCBPiPManager.getInstance().pipSideManagerInfo.originRect.setRect(this.overlayRect.left, this.overlayRect.top,
        this.rect.width, this.rect.height);
    }
  }

  scaleValueChange() {
    if (this.isInSideManager) {
      log.showInfo(`scaleValueChange scaleValue: ${this.scaleValue}`);
      SCBPiPManager.getInstance().pipSideManagerInfo.originScale = this.scaleValue;
    }
  }

  private init() {
    this.initBundleInfo();
    this.initMessage();
    this.initCallbacks();
    this.initOverlay();
  }

  private initBundleInfo() {
    this.specificSession?.addRefCount();
    let parentSession = SCBSceneSessionManager.getInstance().getSessionById(this.specificSession.session.parentId);
    if (parentSession !== null && parentSession instanceof SCBSceneSession) {
      this.bundleName = parentSession.sceneInfo.bundleName;
      this.parentId = this.specificSession.session.parentId;
      let isPrivacyMode: boolean = parentSession.sessionData.isPrivacyWindow;
      log.showInfo(`bundleName: ${this.bundleName} parentId: ${this.parentId} PrivacyMode: ${isPrivacyMode}}`);
      this.specificSession.session.setPrivacyMode(isPrivacyMode);
    }
  }

  private initMessage() {
    while (this.msgQueue.length > 0) {
      let rectItem: RectChangeItem = this.msgQueue.pop();
      log.showInfo(`execute cached sessionRectChange msg, reason:${rectItem.reason}`);
      this.specificSession?.currRect.setRectNum(
        rectItem.rect.posX_, rectItem.rect.posY_, rectItem.rect.width_, rectItem.rect.height_);
      this.onSessionRectChange(rectItem.rect, rectItem.reason);
    }
  }

  private initCallbacks() {
    this.specificSession?.registerSessionRectChangeCallback(
      (rect: sceneSessionManager.SessionRect, reason: sceneSessionManager.SessionSizeChangeReason) => {
        this.onSessionRectChange(rect, reason);
      }, this.screenProperty.screenId);
    this.specificSession?.registerSessionTouchableChangeCallback((isTouchable: boolean) => {
      this.onSessionTouchableChange(isTouchable);
    });
    this.specificSession?.registerClosePiPCallback(() => {
      this.onActionClose();
    });
    this.specificSession?.registerSessionCustomAnimationPlayingCallback((isPlaying: boolean) => {
      log.showInfo('set isCustomAnimationPlaying ' + isPlaying);
      this.specificSession.isCustomAnimationPlaying = isPlaying;
    });
    this.specificSession?.registerSessionPrepareCloseCallback(() => {
      log.showInfo('registerSessionPrepareCloseCallback ');
      this.processClose(Constants.ACTION_REQUEST_CLOSE);
      if (this.isInSideManager) {
        this.isInSideManager = false;
      }
    });
    SCBSceneSessionManager.getInstance().registerSystemBarPropertyRecentCallbacks(this.recentCallback);
    SCBSceneSessionManager.getInstance().registerPiPOcclusiveChangeCallback((occluded: boolean) => {
      try {
        this.specificSession?.session?.notifyPipOcclusionChange(occluded);
      } catch (err) {
        log.showError(`notifyPipOcclusionChange ${occluded} err`);
      }
    });
    this.lastMode = this.getParentWindowMode();
    SCBSceneSessionManager.getInstance().on(SCBEventId.SESSION_RAISE_TO_TOP, this.screenProperty.screenId,
      this.onSceneRaiseToTop);
    let parentSession = SCBSceneSessionManager.getInstance().getSessionById(this.specificSession.session.parentId);
    if (parentSession !== null && parentSession instanceof SCBSceneSession) {
      parentSession.registerForegroundCallback(this.onParentForeground);
    }
    if (this.screenProperty.screenId === SCBSceneSessionManager.getInstance().mainScreenId) {
      SCBSceneSessionManager.getInstance().registerUpdatePipExtendSessionCallback((extendScreenId: number) => {
        this.notifyExtendScreenDisconnect(extendScreenId);
      }, this.screenProperty.screenId);
    }
  }

  private initOverlay() {
    this.overlaySceneSession?.setVisibility(true);
    this.overlaySceneSession?.setActive(true);
    if (this.overlaySceneSession !== null && this.overlaySceneSession !== undefined) {
      this.overlaySceneSession.visibility = true;
    }
  }

  aboutToAppear(): void {
    log.showDebug(`aboutToAppear, id: ${this.specificSession?.session.persistentId}, ` +
      `currRect: ${this.getSCBSessionRectInfo(this.specificSession?.currRect)}`);
    this.init();
    SCBSceneSessionManager.getInstance().registerPipCallback((persistentId: number) => {
      if (this.specificSession?.session?.parentId === persistentId) {
        log.showInfo(`onActionRestore: persistentId = ${persistentId}`);
        this.onActionRestore();
      }
    });
  }

  aboutToDisappear() {
    let parentSession = SCBSceneSessionManager.getInstance().getSessionById(this.specificSession.session.parentId);
    if (parentSession !== null && parentSession instanceof SCBSceneSession) {
      parentSession.unregisterForegroundCallback();
    }
    if (this.screenProperty.screenId === this.specificSession?.screenId) {
      this.rectCalculator.saveScaleLevel();
    }
    this.specificSession?.decRefCount();
    this.specificSession?.unRegisterAll();
    this.specificSession?.unregisterSessionRectChangeCallback(this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(this.overlaySceneSession,
      this.screenProperty.screenId);
    SCBSceneSessionManager.getInstance().off(SCBEventId.SESSION_RAISE_TO_TOP, this.screenProperty.screenId,
      this.onSceneRaiseToTop);
    SCBSceneSessionManager.getInstance().unRegisterSystemBarPropertyRecentCallbacks(this.recentCallback);
    SCBSceneSessionManager.getInstance().unRegisterPiPOcclusiveChangeCallback();
    this.specificSession?.unregisterClosePiPCallback();
    this.cachePixMap?.release();
    this.cachePixMap = null;
    this.timeoutIds.forEach((id) => {
      clearTimeout(id);
    });
    SCBSceneSessionManager.getInstance().unregisterPipCallback();
    if (this.screenProperty.screenId === SCBSceneSessionManager.getInstance().mainScreenId) {
      SCBSceneSessionManager.getInstance().unregisterUpdatePipExtendSessionCallback(this.screenProperty.screenId);
    }
  }

  private equalSize(oldRect: SCBSessionRect, newRect: SCBSessionRect, oldScale: number, newScale: number) {
    return oldRect.width.getPx() === newRect.width.getPx() && oldRect.height.getPx() === newRect.height.getPx() &&
      oldScale === newScale;
  }

  onSessionTouchableChange(isTouchable: boolean): void {
    log.showDebug(`onSessionTouchableChange, touchable: ${isTouchable}`);
    this.specificSession?.setTouchable(isTouchable);
  }

  onScreenPropChange() {
    if (this.propChangeReason === SCBPropertyChangeReason.UNDEFINED) {
      return;
    }
    let oldRect = this.rect.copy();
    let oldScale = this.scaleValue;

    if (this.propChangeReason === SCBPropertyChangeReason.ROTATION ||
      this.propChangeReason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION) {
      log.showInfo('ScreenPropChange change: ROTATION');
      let scbRect: SCBSessionRect = this.rect.copy();
      let newRect: SCBSessionRect = this.rectCalculator.updatePipRect(
        scbRect, PipRectUpdateReason.REASON_ROTATION_CHANGE, this.screenProperty);
      log.showInfo(`rotationRect = ${this.getSCBSessionRectInfo(newRect)}`);
      setTimeout(()=> {
        this.processRotation(newRect);
      })
    }
    if (!this.equalSize(oldRect, this.rect, oldScale, this.scaleValue)) {
      SCBPiPManager.getInstance().notifyPipSizeChange(this.rect.width.getPx(), this.rect.height.getPx(),
        this.scaleValue);
    }
  }

  onSessionRectChange(rect: sceneSessionManager.SessionRect, reason: sceneSessionManager.SessionSizeChangeReason) {
    if (this.specificSession === null || this.specificSession === undefined) {
      log.showError('onRectChange: specificSession is null');
      return;
    }
    log.showInfo(`onSessionRectChange start, id: ${this.specificSession.session.persistentId}, reason: ${reason}, ` +
      `rect: [ ${rect.posX_}, ${rect.posY_}, ${rect.width_}, ${rect.height_} ], ` +
      `currRect: ${this.getSCBSessionRectInfo(this.specificSession.currRect)}`);

    if ((rect.width_ === 0 || rect.height_ === 0) &&
      reason !== sceneSessionManager.SessionSizeChangeReason.PIP_RESTORE) {
      rect.width_ = DEFAULT_SIZE;
      rect.height_ = DEFAULT_SIZE;
    }
    let oldRect = this.rect.copy();
    let oldScale = this.scaleValue;
    let scbRect = new SCBSessionRect(rect.posX_, rect.posY_, rect.width_, rect.height_);
    switch (reason) {
      case sceneSessionManager.SessionSizeChangeReason.UNDEFINED:
      case sceneSessionManager.SessionSizeChangeReason.PIP_START:
        // UNDEFINED & PIP_START's purpose is to record source window position
        this.specificSession.visibility = false;
        this.processStart(rect);
        break;
      case sceneSessionManager.SessionSizeChangeReason.PIP_SHOW:
        // PIP_SHOW's purpose is to display the window and move it to the recorded position
        this.processShow(scbRect);
        break;
      case sceneSessionManager.SessionSizeChangeReason.PIP_AUTO_START:
        this.delayRotation = false;
        this.processAutoStart(rect, scbRect);
        break;
      case sceneSessionManager.SessionSizeChangeReason.PIP_RATIO_CHANGE:
        // PIP_RATIO_CHANGE's purpose is to adapt to content size change and delay time is to adjust size after rotation
        setTimeout(() => {
          this.processRatioChange(scbRect, rect);
        }, SIZE_UPDATE_DELAY_TIME);
        break;
      case sceneSessionManager.SessionSizeChangeReason.TRANSFORM:
        // TRANSFORM's purpose is to update source window position
        this.sourceRect.setRectNum(rect.posX_, rect.posY_, rect.width_, rect.height_);
        break;
      case sceneSessionManager.SessionSizeChangeReason.PIP_RESTORE:
        this.processAfterRestore(rect);
        break;
    }
    setTimeout(() => {
      if (!this.equalSize(oldRect, this.rect, oldScale, this.scaleValue)) {
        SCBPiPManager.getInstance().notifyPipSizeChange(this.rect.width.getPx(), this.rect.height.getPx(),
          this.scaleValue);
      }
    }, SIZE_NOTIFY_DELAY_TIME)
    log.showInfo(`onSessionRectChange end, id: ${this.specificSession.session.persistentId}, reason: ${reason}, ` +
      `rect: ${this.getSCBSessionRectInfo(this.rect)}, overlayRect: ${this.getSCBSessionRectInfo(this.overlayRect)} ` +
      `centerX: ${this.centerScaleX} centerY: ${this.centerScaleY} scaleValue: ${this.scaleValue}`);
  }

  private processShow(scbRect: SCBSessionRect) {
    Trace.start(`processShow_${id}`);
    let showRect = this.rectCalculator.updatePipRect(scbRect, PipRectUpdateReason.REASON_PIP_START,
      this.screenProperty);
    let isReuseWindow: boolean = !this.overlayRect.isEmpty();
    let largeRect = this.getLargeRealSize(scbRect, PipRectUpdateReason.REASON_PIP_START);
    if (isReuseWindow) {
      this.rect.setPosNum(showRect.left.getPx(), showRect.top.getPx());
    }
    this.rect.setSizeNum(largeRect.width.getPx(), largeRect.height.getPx());
    // update rect to source rect directly
    this.centerScaleX = '0';
    this.centerScaleY = '0';
    this.scaleValue = 1;
    let targetScale: number = this.getScaleValue(this.rect, showRect);
    if (!isReuseWindow) {
      this.setRectToSource();
      this.specificSession.visibility = true;
      SCBPiPManager.getInstance().isPipShowAnimating = true;
      animateTo({ curve: curves.responsiveSpringMotion(0.55, 0.825, 0.25), onFinish: () => {
        this.isShowDefaultBackground = true;
        SCBPiPManager.getInstance().isPipShowAnimating = false;
        Trace.end(`processShow_${id}`);
      }}, () => {
        this.pipBorderRadius = Constants.DEFAULT_PIP_RADIUS;
        this.scaleValue = targetScale;
        this.rect.setPosNum(showRect.left.getPx(), showRect.top.getPx());
        this.shadowStyle = ShadowStyle.OUTER_FLOATING_SM;
      });
    } else {
      this.isShowDefaultBackground = true;
      this.pipBorderRadius = Constants.DEFAULT_PIP_RADIUS;
      this.specificSession.visibility = true;
      this.scaleValue = targetScale;
      this.shadowStyle = ShadowStyle.OUTER_FLOATING_SM;
      this.rect.setPosNum(showRect.left.getPx(), showRect.top.getPx());
    }
    if (this.recoverRotation !== undefined) {
      this.recoverRotation();
    }
    this.overlayRect = showRect.copy();
    SCBPiPManager.getInstance().sendAccessibilityEvent(ResUtils.getInnerString($r('app.string.pip_window_show')));

    // 通知systemUI手动拉起画中画
    const containerSession = this.getParentContainerSession();
    if (containerSession) {
      PipSceneManager.instance.addPipScene(containerSession);
    }
  }

  private processRatioChange(scbRect: SCBSessionRect, rect: sceneSessionManager.SessionRect) {
    let ratioRect = this.rectCalculator.updatePipRect(scbRect,
      PipRectUpdateReason.REASON_PIP_RATIO_CHANGE, this.screenProperty);
    let largeRect = this.getLargeRealSize(scbRect, PipRectUpdateReason.REASON_PIP_RATIO_CHANGE);
    this.rect.setSizeNum(largeRect.width.getPx(), largeRect.height.getPx());
    this.overlayRect = ratioRect.copy();
    let targetScale: number = this.getScaleValue(this.rect, ratioRect);
    this.centerScaleX = '0';
    this.centerScaleY = '0';
    this.rect.setPosNum(ratioRect.left.getPx(), ratioRect.top.getPx());
    this.scaleValue = targetScale;
  }

  processAutoStart(rect: sceneSessionManager.SessionRect, scbRect: SCBSessionRect): void {
    let oldRect = this.rect.copy();
    let oldScale = this.scaleValue;
    let showRect = this.rectCalculator.updatePipRect(scbRect, PipRectUpdateReason.REASON_PIP_START,
      this.screenProperty);
    let largeRect = this.getLargeRealSize(scbRect, PipRectUpdateReason.REASON_PIP_START);
    this.rect.setSizeNum(largeRect.width.getPx(), largeRect.height.getPx());
    this.overlayRect = showRect.copy();
    let targetScale: number = this.getScaleValue(this.rect, showRect);
    this.centerScaleX = '0';
    this.centerScaleY = '0';
    this.rect.setPosNum(showRect.left.getPx(), showRect.top.getPx());
    this.scaleValue = targetScale;
    this.updateScaleWithoutMove(0.5, 0.5);

    let containerSession = this.getParentContainerSession();
    if (containerSession?.isAutoPiPOneShot) {
      log.showInfo(`processAutoStart: processAutoStartOneShot`);
      this.processAutoStartOneShot(oldRect, targetScale, oldScale);
    } else {
      log.showInfo(`processAutoStart: processAutoStartNormal`);
      this.processAutoStartDefault(oldRect, targetScale, oldScale);
    }
  }

  private processAutoStartOneShot(oldRect: SCBSessionRect, targetScale: number, oldScale: number): void {
    let originScale: number = targetScale;
    this.scaleValue = originScale;
    this.opacityNum = 0;
    this.specificSession.visibility = true;
    this.pipBorderRadius = 16;
    let delayTime = 250;
    if (DeviceHelper.isEmulator()) {
      delayTime = 0;
    }
    setTimeout(() => {
      SCBSceneSessionManager.getInstance().setVmaCacheStatus(true, 'pipAutoStart');
      this.foregroundBlur = 0;
      animateTo({
        curve: Curve.Linear, duration: 600,
        onFinish: () => {
          SCBPiPManager.getInstance().sendAccessibilityEvent(ResUtils.getInnerString($r('app.string.pip_window_show')));
          SCBSceneSessionManager.getInstance().setVmaCacheStatus(false, 'pipAutoStart');
        }
      }, () => {
        this.scaleValue = targetScale;
        this.opacityNum = 1;
      });
      if (!this.equalSize(oldRect, this.rect, oldScale, this.scaleValue)) {
        SCBPiPManager.getInstance().notifyPipSizeChange(this.rect.width.getPx(), this.rect.height.getPx(),
          this.scaleValue);
      }
    }, delayTime);
  }

  private processAutoStartDefault(oldRect: SCBSessionRect, targetScale: number, oldScale: number): void {
    let originScale: number = targetScale / 4;
    this.scaleValue = originScale;
    this.opacityNum = 0;
    this.specificSession.visibility = true;
    let delayTime = 250;
    if (DeviceHelper.isEmulator()) {
      delayTime = 0;
    }
    this.shadowStyle = undefined;
    SCBPiPManager.getInstance().isPipShowAnimating = true;
    setTimeout(() => {
      SCBSceneSessionManager.getInstance().setVmaCacheStatus(true, 'pipAutoStart');
      this.foregroundBlur = 200;
      animateTo({ curve: curves.cubicBezierCurve(0, 0, 0.67, 1.00), duration: 200,
        onFinish: () => {
          this.foregroundBlur = -1;
        }
      }, () => {
        this.foregroundBlur = 0;
      });
      animateTo({ curve: curves.springMotion(0.55, 0.825),
        onFinish: () => {
          SCBPiPManager.getInstance().sendAccessibilityEvent(ResUtils.getInnerString($r('app.string.pip_window_show')));
          SCBSceneSessionManager.getInstance().setVmaCacheStatus(false, 'pipAutoStart');
          SCBPiPManager.getInstance().isPipShowAnimating = false;
        }
      }, () => {
        this.pipBorderRadius = Constants.DEFAULT_PIP_RADIUS;
        this.scaleValue = targetScale;
        this.opacityNum = 1;
        this.shadowStyle = ShadowStyle.OUTER_FLOATING_SM;
      });
      if (!this.equalSize(oldRect, this.rect, oldScale, this.scaleValue)) {
        SCBPiPManager.getInstance().notifyPipSizeChange(this.rect.width.getPx(), this.rect.height.getPx(),
          this.scaleValue);
      }
    }, delayTime);
  }

  private getLargeRealSize(scbRect: SCBSessionRect, reason: PipRectUpdateReason) {
    let rotation = this.screenProperty.rotation;
    let isLandscape: boolean = (rotation === RotationConstants.ROTATION_90 ||
      rotation === RotationConstants.ROTATION_270);
    let largeRect = this.rectCalculator.getRectByScale(this.screenProperty.width, this.screenProperty.height,
      ScaleLevel.SCALE_LEVEL_LARGE, scbRect, isLandscape, reason);
    this.rectCalculator.fixRectSizeIfNeeded(largeRect, this.screenProperty.width, this.screenProperty.height,
      isLandscape);
    return largeRect;
  }

  private getParentContainerSession(): SCBSceneContainerSession | null {
    log.showInfo(`getParentContainerSession parentId: ${this.parentId}`);
    if (this.parentId < 0) {
      return null;
    }
    let containerSessionList =
      SCBSceneSessionManager.getInstance().getAllContainerSessionList();
    let containerSession = containerSessionList.findByPersistentId(this.parentId);
    if (containerSession === null) {
      log.showInfo(`getParentContainerSession containerSession is null, persistId: ${this.parentId}`);
    }
    return containerSession;
  }

  private getParentWindowMode(): SCBSceneMode {
    let parentSession = SCBSceneSessionManager.getInstance().getSessionById(this.parentId);
    if (parentSession && parentSession instanceof SCBSceneSession) {
      return (parentSession as SCBSceneSession).sceneInfo.windowMode;
    }
    return SCBSceneMode.UNDEFINED;
  }

  private getParentScreenId(): number {
    let parentSession = SCBSceneSessionManager.getInstance().getSessionById(this.parentId);
    if (parentSession && parentSession instanceof SCBSceneSession) {
      return (parentSession as SCBSceneSession).sceneInfo.screenId;
    }
    return SCBSceneSessionManager.getInstance().mainScreenId;
  }

  processStart(rect: sceneSessionManager.SessionRect): void {
    this.isShowDefaultBackground = false;
    this.delayRotation = true;
    let containerSession = this.getParentContainerSession();
    if (containerSession === null || containerSession === undefined) {
      log.showError(`processStart: container session not valid`);
      return;
    }

    try {
      if (containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.FLOATING) {
        this.calculateFloatSourceRect(containerSession, rect);
      } else if (containerSession.isSplit) {
        this.calculateSplitSourceRect(containerSession, rect);
      } else {
        this.calculateNormalSourceRect(containerSession, rect);
      }
    } catch (err) {
      log.showError(`processStart: error occured, use normal replace.`);
      this.calculateNormalSourceRect(containerSession, rect);
    }
  }

  processPreRestore(): void {
    log.showInfo(`processPreRestore is called`);
    this.delayRotation = true;
    this.shouldDoRestore = true;
    this.isShowDefaultBackground = false;
    let containerSession = this.getParentContainerSession();
    if (containerSession === null) {
      log.showInfo(`processPreRestore, parent containerSession is null`);
    }
    const screenSession = SCBScreenSessionManager.getInstance()
      .getScreenSession(containerSession?.screenProperty.screenId);
    if (!screenSession) {
      log.showError('processPreRestore: fail to get screenSession');
      return;
    }
    // 通知systemUI退出画中画
    if (containerSession) {
      PipSceneManager.instance.removePipScene(containerSession);
    }

    if (containerSession?.isMidScene || AppStorage.get('scenePanelState') === ScenePanelState.SPLIT ||
        this.isRestoreFromRecent) {
      log.showInfo(`processPreRestore: processPreRestoreDefault`);
      this.processPreRestoreDefault();
    } else {
      log.showInfo(`processPreRestore: processPreRestoreOneShot`);
      this.restoreOneShot = true;
      this.processPreRestoreOneShot();
    }
    // make sure black background can be destroy
    setTimeout(() => {
      this.makeSureRestore();
    }, Constants.RESTORE_TIME_OUT);
  }

  private processPreRestoreDefault(): void {
    this.updateScaleWithoutMove(0, 0);
    animateTo({ curve: curves.springMotion(0.45, 0.825)}, () => {
      this.setRectToFitScreen();
      this.pipBorderRadius = 4;
    });
    animateTo({ curve: Curve.Linear, duration: 200, onFinish: ()=> {
      SCBSceneSessionManager.getInstance().startSceneByPipRestore(this.parentId, false, this.getParentScreenId());
      const restoreTimeId = setTimeout(()=> {
        SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
      }, Constants.RESET_PIP_RESTORE_TIMEOUT);
      this.timeoutIds.push(restoreTimeId);
    }}, () => {
      this.pipBackgroundOpacity = 1;
    });
  }

  private processPreRestoreOneShot(): void {
    SCBSceneSessionManager.getInstance().startSceneByPipRestore(this.parentId, true, this.getParentScreenId());
    const restoreTimeId = setTimeout(()=> {
      SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
    }, Constants.RESET_PIP_RESTORE_TIMEOUT);
    this.timeoutIds.push(restoreTimeId);
    this.restoreOneShot = true;
    animateTo({
      curve: Curve.Linear,
      duration: 200,
      onFinish: () => {
        this.isPiPVisibility = false;
      }
    }, () => {
      this.opacityNum = 0;
    });
  }

  processDoRestore(): void {
    if (this.shouldDoRestore) {
      log.showInfo(`processDoRestore is called`);
      this.shouldDoRestore = false;
      // when app is in foreground state, get XComponent position
      setTimeout(() => {
        this.fetchComponentRect();
      }, 200)
    }
  }

  fetchComponentRect() {
    this.specificSession?.session?.setPipActionEvent(Constants.ACTION_PREPARE_SOURCE);
    setTimeout(() => {
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_LOCATE_SOURCE);
    }, Constants.DELAY_CLOSE_FOR_SNAPSHOT)
  }

  processAfterRestore(rect: sceneSessionManager.SessionRect): void {
    log.showInfo(`processAfterRestore is called`);
    if (!this.isRestoreFromBg) {
      this.processAfterRestoreFromFg(rect);
      return;
    }
    this.shouldAnimToSource = (rect.width_ > 0 && rect.height_ > 0) &&
      this.nearEqual(this.overlayRect.width.getPx() * rect.height_, this.overlayRect.height.getPx() * rect.width_);
    if (!this.restoreOneShot && this.shouldAnimToSource) {
      this.processAfterRestoreFromBgWithAnim(rect);
    } else {
      this.processAfterRestoreFromBg(id, rect);
    }
  }

  private processAfterRestoreFromBg(id: string, rect: sceneSessionManager.SessionRect): void {
    Trace.start(`processAfterRestoreFromBg-${id}`);
    componentSnapshot.get(id).then((pixelMap: image.PixelMap) => {
      this.processAfterRestoreInner(pixelMap, rect);
      Trace.end(`processAfterRestoreFromBg-${id}`);
    }).catch((err: Error) => {
      log.showError(`processAfterRestoreFromBg error, msg: ${err.message}`);
      this.processAfterRestoreInner(null, rect);
      Trace.end(`processAfterRestoreFromBg-${id}`);
    })
  }

  private processAfterRestoreInner(pixelMap: image.PixelMap | null, rect: sceneSessionManager.SessionRect) {
    let containerSession = this.getParentContainerSession();
    if (containerSession === null || containerSession === undefined) {
      log.showInfo(`processAfterRestore: container session not valid`);
      scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, false);
      return;
    }
    this.useSnapshot = true;
    this.cachePixMap = pixelMap;
    const restoreInnerTimeoutId = setTimeout(()=> {
      this.specificSession.visibility = false;
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_RESTORE);
    }, Constants.DELAY_CLOSE_FOR_SNAPSHOT);
    this.timeoutIds.push(restoreInnerTimeoutId);
    this.calculateSourceRect(rect, containerSession);
    if (!this.restoreOneShot) {
      this.opacityNum = 1;
      animateTo({ delay: 150, curve: Curve.Linear, duration: 150}, () => {
        this.pipBackgroundOpacity = 0;
        this.opacityNum = 0;
      });
    }
    if (this.activeRotation !== undefined) {
      this.activeRotation();
    }
    const restoreActionTimeoutId = setTimeout(() => {
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_DESTROY);
      scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, false);
    }, 300);
    this.timeoutIds.push(restoreActionTimeoutId);
  }

  private processAfterRestoreFromBgWithAnim(rect: sceneSessionManager.SessionRect) {
    log.showInfo(`processAfterRestoreFromBgWithAnim is called`);
    let containerSession = this.getParentContainerSession();
    if (containerSession === null || containerSession === undefined) {
      log.showInfo(`processAfterRestore: container session not valid`);
      scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, false);
      return;
    }
    Trace.start(`processAfterRestoreFromBgWithAnim_${id}`);
    this.calculateSourceRect(rect, containerSession);
    animateTo({ curve: Curve.Linear, duration: 400}, () => {
      this.pipBackgroundOpacity = 0;
    });

    if (this.activeRotation !== undefined) {
      this.activeRotation();
    }
    animateTo({ curve: curves.springMotion(0.2733, 1.157), onFinish: () => {
      Trace.end(`processAfterRestoreFromBgWithAnim_${id}`);
    }}, () => {
      this.setRectToSource();
      this.pipBorderRadius = 4;
    });

    setTimeout(() => {
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_RESTORE);
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_DESTROY);
      scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, false);
    }, 400);
  }

  private processAfterRestoreFromFg(rect: sceneSessionManager.SessionRect) {
    log.showInfo(`processAfterRestoreFromFg is called`);
    if (rect.width_ === 0 || rect.height_ === 0) {
      this.processClose();
      scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, false);
      return;
    }
    let containerSession = this.getParentContainerSession();
    if (containerSession === null || containerSession === undefined) {
      log.showInfo(`processAfterRestore: container session not valid`);
      scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, false);
      return;
    }
    Trace.start(`processAfterRestoreFromFg_${id}`);
    this.calculateSourceRect(rect, containerSession);
    this.updateScaleWithoutMove(0, 0);
    if (this.activeRotation !== undefined) {
      this.activeRotation();
    }
    animateTo({ curve: curves.springMotion(0.2733, 1.157), onFinish: () => {
      Trace.end(`processAfterRestoreFromFg_${id}`);
    }}, () => {
      this.setRectToSource();
      this.isShowDefaultBackground = false;
      this.pipBorderRadius = 4;
    });
    const restoreFromFgTimeId = setTimeout(() => {
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_RESTORE);
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_DESTROY);
      scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, false);
    }, 500);
    this.timeoutIds.push(restoreFromFgTimeId);
  }

  private nearEqual(a: number, b: number): boolean {
    return Math.abs(a - b) < Constants.MINI_VALUE;
  }

  private calculateSourceRect(rect: sceneSessionManager.SessionRect, containerSession: SCBSceneContainerSession) {
    this.isRestoreDone = true;
    if (rect.width_ === 0 || rect.height_ === 0) {
      rect.width_ = this.sourceRect.width.getPx();
      rect.height_ = this.sourceRect.height.getPx();
    }
    try {
      if (containerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.FLOATING) {
        this.calculateFloatSourceRect(containerSession, rect);
      } else if (containerSession.isSplit && containerSession.isActive) {
        this.calculateSplitSourceRect(containerSession, rect);
      } else if (containerSession.isMidScene && containerSession.isActive) {
        this.calculateMidSourceRect(containerSession, rect);
      } else {
        this.calculateNormalSourceRect(containerSession, rect);
      }
    } catch (err) {
      log.showError(`processAfterRestore: error occured, use normal replace.`);
      this.calculateNormalSourceRect(containerSession, rect);
    }
  }

  makeSureRestore() {
    if (this.isRestoreDone) {
      return;
    }
    log.showInfo(`makeSureRestore is called`);
    animateTo({ curve: Curve.Linear, duration: 100, onFinish: () => {
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_RESTORE);
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_DESTROY);
    }}, () => {
      this.opacityNum = 0;
      this.pipBackgroundOpacity = 0;
    });
    if (this.activeRotation !== undefined) {
      this.activeRotation();
    }
  }

  calculateNormalSourceRect(containerSession: SCBSceneContainerSession, rect: sceneSessionManager.SessionRect): void {
    if (containerSession === null || containerSession === undefined || containerSession.primarySession === null) {
      throw new Error(`container session is not valid`);
    }
    let posX = containerSession.primarySession.currRect.left.getPx();
    let posY = containerSession.primarySession.currRect.top.getPx();
    this.sourceRect.setRectNum(rect.posX_ + posX, rect.posY_ + posY, rect.width_, rect.height_);
    log.showInfo(`calculateNormalSourceRect, normal source rect = ${this.getSCBSessionRectInfo(this.sourceRect)}`);
  }

  calculateFloatSourceRect(containerSession: SCBSceneContainerSession, rect: sceneSessionManager.SessionRect): void {
    if (containerSession === null || containerSession === undefined || containerSession.primarySession === null) {
      throw new Error(`container session is not valid`);
    }
    let scale = containerSession.floatingParam.scale;
    let posX = containerSession.primarySession.currRect.left.getPx();
    let posY = containerSession.primarySession.currRect.top.getPx();
    log.showInfo(`scale: ${scale}, posX: ${posX}, posY: ${posY}`);
    this.sourceRect.setRectNum(posX + scale * rect.posX_, posY + scale * rect.posY_,
      rect.width_ * scale, rect.height_ * scale);
    log.showInfo(`calculateFloatSourceRect, floating source rect = ${this.getSCBSessionRectInfo(this.sourceRect)}`);
  }

  calculateSplitSourceRect(containerSession: SCBSceneContainerSession, rect: sceneSessionManager.SessionRect): void {
    if (containerSession === null || containerSession === undefined) {
      throw new Error(`container session is not valid`);
    }
    if (!containerSession.isSplit) {
      throw new Error(`container session is not in split`);
    }
    if (containerSession.isOneStepSplit()) {
      log.showInfo(`calculateSplitSourceRect: one step`);
      SCBSceneSessionManager.getInstance().maximizeSplit(this.screenProperty.screenId, this.parentId);
      this.calculateNormalSourceRect(containerSession, rect);
      return;
    }
    let session: SCBSceneSession | null = null;
    if (containerSession.primarySession?.session.persistentId === this.parentId) {
      session = containerSession.primarySession;
    } else if (containerSession.secondarySession?.session.persistentId === this.parentId) {
      session = containerSession.secondarySession;
    } else {
      throw new Error(`container session can't find parent session`);
    }
    if (session === null) {
      throw new Error(`container session can't find parent session`);
    }
    let posX = session?.currRect.left.getPx();
    let posY = session?.currRect.top.getPx();
    this.sourceRect.setRectNum(posX + rect.posX_, posY + rect.posY_, rect.width_, rect.height_);
    log.showInfo(`calculateSplitSourceRect: split source rect = ${this.getSCBSessionRectInfo(this.sourceRect)}`);
  }

  calculateMidSourceRect(containerSession: SCBSceneContainerSession, rect: sceneSessionManager.SessionRect): void {
    if (containerSession === null || containerSession === undefined) {
      throw new Error(`container session is not valid`);
    }
    if (!containerSession.isMidScene) {
      throw new Error(`container session is not in midScene`);
    }

    let session: SCBSceneSession | undefined = undefined;
    for (let value of containerSession.midSceneMap) {
      if (value[1]?.session.persistentId === this.parentId) {
        session = value[1];
        break;
      }
    }
    if (!session) {
      throw new Error(`container session can't find parent session`);
    }
    let posX = session?.currRect.left.getPx();
    let posY = session?.currRect.top.getPx();
    this.sourceRect.setRectNum(posX + rect.posX_ * MID_ZOOM_RATIO, posY + rect.posY_ * MID_ZOOM_RATIO,
      rect.width_ * MID_ZOOM_RATIO, rect.height_ * MID_ZOOM_RATIO);
    log.showInfo(`calculateMidSourceRect: mid source rect = ${this.getSCBSessionRectInfo(this.sourceRect)}`);
  }

  private setRect(targetRect: SCBSessionRect) {
    this.rect && this.rect.copyFrom(targetRect);
    this.centerScaleX = '0';
    this.centerScaleY = '0';
    this.scaleValue = 1;
    this.overlayRect.copyFrom(targetRect);
  }

  private setRectToFitScreen(): void {
    let screenRect = new SCBSessionRect(0, 0, this.screenProperty.width, this.screenProperty.height);
    let screenScale: number = this.getScaleValue(this.rect, screenRect);
    let sourceWidth = this.rect.width.getPx() * screenScale;
    let sourceHeight = this.rect.height.getPx() * screenScale;
    let x = screenRect.left.getPx() + screenRect.width.getPx() / 2;
    let y = screenRect.top.getPx() + screenRect.height.getPx() / 2;
    let newX = x - sourceWidth / 2;
    let newY = y - sourceHeight / 2;
    this.scaleValue = screenScale;
    this.shouldAnimToSource = (newY !== 0 || newX === 0);
    this.rect && this.rect.setPosNum(newX, newY);
    this.overlayRect.setRectNum(newX, newY, sourceWidth, sourceHeight);
  }

  private setRectToSource(): void {
    if (this.screenProperty.screenId !== this.getParentScreenId()) {
      log.showInfo(`pip screenId is not consistent with parent`);
      return;
    }
    let sourceScale: number = this.getScaleValue(this.rect, this.sourceRect);
    let sourceWidth = this.rect.width.getPx() * sourceScale;
    let sourceHeight = this.rect.height.getPx() * sourceScale;
    let x = this.sourceRect.left.getPx() + this.sourceRect.width.getPx() / 2;
    let y = this.sourceRect.top.getPx() + this.sourceRect.height.getPx() / 2;
    let newX = x - sourceWidth / 2;
    let newY = y - sourceHeight / 2;
    this.scaleValue = sourceScale;
    this.rect && this.rect.setPosNum(newX, newY);
  }

  private getScaleValue(originRect: SCBSessionRect, targetRect: SCBSessionRect): number {
    let scaleX = targetRect.width.getPx() / originRect.width.getPx();
    let scaleY = targetRect.height.getPx() / originRect.height.getPx();
    return Math.min(scaleX, scaleY);
  }

  private overlayRectMoveTo(x: number, y: number) {
    let offsetX = x - this.overlayRect.left.getPx();
    let offsetY = y - this.overlayRect.top.getPx();
    this.overlayRect.setPosNum(x, y);
    this.rect.setPosNum(this.rect.left.getPx() + offsetX, this.rect.top.getPx() + offsetY);
}

  private checkSafePadding() {
    let finalPosX = this.avoidHorizontalOfScreen(this.overlayRect.left.getPx());
    let avoidCreasePosY = this.avoidFoldCreaseOfScreen(this.overlayRect.top.getPx());
    let finalPosY = this.avoidVerticalOfScreen(avoidCreasePosY);

    this.overlayRectMoveTo(finalPosX, finalPosY);
  }

  private avoidHorizontalOfScreen(posX: number): number {
    let finalPosX = posX;
    let displayWidth: number = this.screenProperty.width;
    let safePaddingHorizontal: number = vp2px(Constants.SAFE_PADDING_HORIZONTAL_VP);
    if (posX < safePaddingHorizontal) {
      finalPosX = safePaddingHorizontal;
    } else if ((posX + this.overlayRect.width.getPx()) >
      (displayWidth - safePaddingHorizontal)) {
      finalPosX = displayWidth - safePaddingHorizontal - this.overlayRect.width.getPx()
    }
    return finalPosX;
  }

  private avoidVerticalOfScreen(posY: number): number {
    let finalPosY = posY;
    let statusBarHeight = this.rectCalculator.getStatusBarHeight(this.screenProperty.screenId);
    let dockHeight = this.rectCalculator.getDockHeight(this.screenProperty.screenId);
    let availableHeight = this.screenProperty.height;
    if (posY < statusBarHeight + vp2px(Constants.DEFAULT_PIP_CONTENT_AVOID_AREA)) {
      finalPosY = statusBarHeight + vp2px(Constants.DEFAULT_PIP_CONTENT_AVOID_AREA);
    } else if ((posY + this.overlayRect.height.getPx()) >
      (availableHeight - dockHeight - vp2px(Constants.DEFAULT_PIP_CONTENT_AVOID_AREA))) {
      finalPosY = availableHeight - dockHeight -
      vp2px(Constants.DEFAULT_PIP_CONTENT_AVOID_AREA) - this.overlayRect.height.getPx();
    }
    return finalPosY;
  }

  private avoidFoldCreaseOfScreen(posY: number): number {
    let finalPosY = posY;
    return finalPosY;
  }

  private updateScaleWithoutMove(px: number, py: number) {
    let x = this.overlayRect.left.getPx() + px * this.overlayRect.width.getPx() - px * this.rect.width.getPx();
    let y = this.overlayRect.top.getPx() + py * this.overlayRect.height.getPx() - py * this.rect.height.getPx();
    log.showInfo(`updateScaleWithoutMove x = ${x}, y = ${y}, px = ${px}, py = ${py}`);
    this.centerScaleX = (px * 100) + '%';
    this.centerScaleY = (py * 100) + '%';
    this.rect && this.rect.setPosNum(x, y);
  }

  private processEdge(onFinishCallback?: () => void) {
    this.processEdgeSpringBack(onFinishCallback);
  }

  private processEdgeSpringBack(onFinishCallback?: () => void) {
    log.showInfo('processEdgeSpringBack: start');
    animateTo({
      curve: curves.springMotion(0.45, 0.825),
      onFinish: onFinishCallback
    }, () => {
      this.checkSafePadding();
    });
    log.showInfo(`processEdgeSpringBack, overlayRect: ${this.getSCBSessionRectInfo(this.overlayRect)}, ` +
      `rect: ${this.getSCBSessionRectInfo(this.rect)} centerX: ${this.centerScaleX} centerY: ${this.centerScaleY} ` +
      `scaleValue: ${this.scaleValue}`);
  }

  private processRotation(newRect: SCBSessionRect) {
    if (newRect.width.getPx() === 0 || newRect.height.getPx() === 0) {
      log.showWarn('rotation failed: rect not valid');
      return;
    }
    log.showInfo('process rotation');
    this.isRotating = true;
    let largeRect = this.getLargeRealSize(newRect, PipRectUpdateReason.REASON_ROTATION_CHANGE);
    this.rect.setSizeNum(largeRect.width.getPx(), largeRect.height.getPx());
    animateTo({
      curve: curves.springMotion(0.45, 0.825, 0),
      onFinish: () => {
        this.isRotating = false;
        SCBPiPManager.getInstance().isNeedRotation = false;
        this.processEdgeSpringBack();
        }
      }, () => {
      if (this.isInSideManager === true) {
        this.setRect(newRect);
        this.scaleValue = this.getScaleValue(this.rect, newRect);
      } else {
        this.rect.setPosNum(newRect.left.getPx(), newRect.top.getPx());
        this.overlayRect = newRect.copy();
        this.scaleValue = this.getScaleValue(largeRect, newRect);
        this.centerScaleX = '0';
        this.centerScaleY = '0';
        log.showInfo(`rotaion show rect move to ${this.getSCBSessionRectInfo(this.rect)}, overlayRect: ` +
          `${this.getSCBSessionRectInfo(this.overlayRect)} ` +
          `centerX: ${this.centerScaleX} centerY: ${this.centerScaleY} scaleValue: ${this.scaleValue}`);
      }
    })
  }

  private processScale(): void {
    Trace.start(`processScale_${id}`);
    let oldRect = this.overlayRect.copy();
    let oldWindowRect = this.rect;
    let oldScale = this.scaleValue;
    let newRect = this.rectCalculator.updatePipRect(oldRect, PipRectUpdateReason.REASON_PIP_SCALE_CHANGE,
      this.screenProperty);
    log.showInfo(`scale: newRect = ${this.getSCBSessionRectInfo(newRect)}, ` +
      `oldRect = ${this.getSCBSessionRectInfo(oldRect)}`);
    if (newRect.width.getPx() === 0 || newRect.height.getPx() === 0 ||
      newRect.width.getPx() == oldRect.width.getPx() || newRect.height.getPx() == oldRect.height.getPx()) {
      log.showError('scale: rect not valid');
      return;
    }
    // update new center
    let centerX = (newRect.left.getPx() - oldRect.left.getPx()) / (oldRect.width.getPx() - newRect.width.getPx());
    let centerY = (newRect.top.getPx() - oldRect.top.getPx()) / (oldRect.height.getPx() - newRect.height.getPx());
    this.updateScaleWithoutMove(centerX, centerY);

    let scaleValue = this.getScaleValue(this.rect, newRect);
    SCBPiPManager.getInstance().isPipShowAnimating = true;
    animateTo({
      curve: curves.springMotion(0.45, 0.825, 0),
      onFinish: () => {
        SCBPiPManager.getInstance().isPipShowAnimating = false;
        Trace.end(`processScale_${id}`);
      }
    }, () => {
      this.scaleValue = scaleValue;
    });
    this.overlayRect && this.overlayRect.copyFrom(newRect);
    let scaleLevel: number = this.rectCalculator.getScaleLevelInt();
    PipReportEventUtil.reportPipResizeEvent(
      scaleLevel, this.rect.width.getPx(), this.rect.height.getPx(), this.bundleName);
    this.processEdgeSpringBack();
    if (!this.equalSize(oldWindowRect, this.rect, oldScale, this.scaleValue)) {
      SCBPiPManager.getInstance().notifyPipSizeChange(this.rect.width.getPx(), this.rect.height.getPx(),
        this.scaleValue);
    }
    let containerSession = this.getParentContainerSession();
    if (containerSession && containerSession.isStartPiPInterrupt) {
      PipOneShotAnimHelper.onFinishStartPiPInterrupt(containerSession);
    }
    log.showInfo(`scale: end. overlayRect = ${this.getSCBSessionRectInfo(this.overlayRect)}, ` +
      `rect = ${this.getSCBSessionRectInfo(this.rect)}`);
  }

  private processClose(closeType: string = Constants.ACTION_CLOSE) {
    Trace.start(`processClose_snapshot_${id}`);
    componentSnapshot.get(id).then((pixelMap: image.PixelMap) => {
      this.processCloseInner(pixelMap, closeType);
      Trace.end(`processClose_snapshot_${id}`);
    }).catch((err: Error) => {
      log.showError(`processClose error, msg: ${err.message}`);
      this.processCloseInner(null, closeType);
      Trace.end(`processClose_snapshot_${id}`);
    })
  }

  private processCloseInner(pixelMap: image.PixelMap | null, closeType: string): void {
    this.closed = true;
    this.useSnapshot = true;
    this.opacityNum = 1;
    this.updateScaleWithoutMove(0.5, 0.5);
    this.cachePixMap = pixelMap;
    const closeTimeId = setTimeout(()=> {
      this.specificSession.visibility = false;
      this.specificSession?.session?.setPipActionEvent(closeType);
    }, Constants.DELAY_CLOSE_FOR_SNAPSHOT);
    this.timeoutIds.push(closeTimeId);
    this.shadowStyle = undefined;
    SCBSceneSessionManager.getInstance().setVmaCacheStatus(true, 'pipClose');
    animateTo({ curve: curves.springMotion(0.55, 1, 0), onFinish: ()=> {
      SCBSceneSessionManager.getInstance().setVmaCacheStatus(false, 'pipClose');
    }}, () => {
      this.scaleValue = this.scaleValue * 0.25;
      this.pipBorderRadius = 4;
    });
    this.foregroundBlur = 25;
    animateTo({
      curve: Curve.Linear, duration: 200, onFinish: ()=> {
        this.specificSession?.session?.setPipActionEvent(Constants.ACTION_DESTROY);
        this.foregroundBlur = -1;
      }
    }, () => {
      this.opacityNum = 0;
      this.foregroundBlur = 200;
    });

    // 通知systemUI退出画中画
    const containerSession = this.getParentContainerSession();
    if (containerSession) {
      PipSceneManager.instance.removePipScene(containerSession);
    }
  }

  private onActionMoveStart(event: GestureEvent): void {
    if (this.isMouseWheelEvent(event)) {
      return;
    }
    log.showInfo('onActionMoveStart');
    // adjust zIndex to show above the input method when move.
    this.moveAnimateCount++;
    SCBPiPManager.getInstance().isPipShowAnimating = true;
    this.updatePanelZIndex(SCBDefaultZIndex.INPUT_METHOD_BELOW_KEYGUARD + 2);
    let containerSession = this.getParentContainerSession();
    if (containerSession && containerSession.isStartPiPInterrupt) {
      PipOneShotAnimHelper.onFinishStartPiPInterrupt(containerSession);
    }
    let rectHeight = this.rect.height.getPx();
    let rectWidth = this.rect.width.getPx();
    if (rectHeight === 0 || rectWidth === 0) {
      log.showError('rectHeight or rectWidth is zero');
      return;
    }
    this.updateScaleWithoutMove(0.5, 0);
    PipReportEventUtil.reportPipMoveEvent(this.bundleName);
    this.moveStartOverlayRect.copyFrom(this.overlayRect);
    this.moveStartRect.copyFrom(this.rect);
    this.moveStartScale = this.scaleValue;
    this.doGestureMoveStartScale();
  }

  private onActionMove(event: GestureEvent): void {
    if (this.isMouseWheelEvent(event)) {
      return;
    }
    animateTo({
      curve: Constants.DRAG_MOVE_CURVE
    }, () => {
      this.transX = event.offsetX;
      this.transY = event.offsetY;
    });
  }

  private onActionMoveEndOrCancel(event?: GestureEvent): void {
    if (this.moveAnimateCount === 0 || this.isMouseWheelEvent(event)) {
      return;
    }
    log.showInfo('onActionMoveEndOrCancel');
    this.doGestureMoveRestore();
    this.doGestureMoveInertialSliding(event);
    this.rect.setPosNum(this.rect.left.getPx() + vp2px(this.transX) + vp2px(this.transXOffset),
      this.rect.top.getPx() + vp2px(this.transY) + vp2px(this.transYOffset));
    this.overlayRect.setPosNum(this.overlayRect.left.getPx() + vp2px(this.transX) + vp2px(this.transXOffset),
      this.overlayRect.top.getPx() + vp2px(this.transY) + vp2px(this.transYOffset));
    // restore transX
    this.moveEndTransX = this.transX + this.transXOffset;
    this.moveEndTransY = this.transY + this.transYOffset;
    this.transX = 0;
    this.transY = 0;
    this.transXOffset = 0;
    this.transYOffset = 0;
    this.processEdge(this.onMoveEdgeSpringBackAnimationFinished);
    let newRect: SCBSessionRect = this.overlayRect.copy();
    this.rectCalculator.savePipPositionAndLevel(this.overlayRect.left.getPx(), this.overlayRect.top.getPx());
    this.rectCalculator.updatePipRectPivotInfo(newRect, this.screenProperty.width, this.screenProperty.height);
    this.rectCalculator.updateQuadrantAndPos(this.overlayRect, this.screenProperty.width, this.screenProperty.height);
  }

  private isMouseWheelEvent(event?: GestureEvent): boolean {
    return event?.axisHorizontal !== 0 || event?.axisVertical !== 0;
  }

  private doGestureMoveStartScale() {
    animateTo({
      curve: Constants.DRAG_MOVE_SCALE_CURVE
    }, () => {
      this.scaleValue *= Constants.DRAG_MOVE_SCALE;
    })
  }

  private doGestureMoveRestore() {
    animateTo({
      curve: Constants.DRAG_MOVE_SCALE_CURVE
    }, () => {
      this.scaleValue = this.moveStartScale;
      this.opacityNum = 1;
    })
  }

  private doGestureMoveInertialSliding(event?: GestureEvent) {
    if (!event) {
      return;
    }
    // move distance = speed * 1 * 0.08
    let distanceX = event.velocityX * Constants.DRAG_MOVE_INERTIAL_SLIDING_PERCENTAGE;
    let distanceY = event.velocityY * Constants.DRAG_MOVE_INERTIAL_SLIDING_PERCENTAGE;
    animateTo({
      curve: Constants.DRAG_MOVE_INERTIAL_SLIDING_CURVE
    }, () => {
      this.transX += distanceX;
      this.transY += distanceY;
    });
  }

  private onDoubleClick(): void {
    log.showDebug('onDoubleClick');
    this.processScale();
  }

  private onActionClose(): void {
    log.showDebug('onActionClose');
    this.rectCalculator.savePipPositionAndLevel(this.overlayRect.left.getPx(), this.overlayRect.top.getPx());
    this.processClose(Constants.ACTION_PANEL_CLOSE);
  };

  private onActionRestore(): void {
    log.showInfo('onActionRestore');
    let scenePanelState: ScenePanelState | undefined = AppStorage.get('scenePanelState');
    if (scenePanelState === ScenePanelState.RECENT) {
      log.showInfo('Restore in recent');
      this.isRestoreFromRecent = true;
      SCBSceneSessionManager.getInstance().exitRecent(this.screenProperty.screenId);
    }
    this.closed = true;
    // Save point
    this.rectCalculator.savePipPositionAndLevel(this.overlayRect.left.getPx(), this.overlayRect.top.getPx());
    // get valid parentId and start scene, return when not valid
    if (this.parentId < 0) {
      this.parentId = this.specificSession.session.parentId;
      if (this.parentId < 0) {
        log.showError(`Failed to restore pip as invalid parentId: ${this.parentId}`);
        return;
      }
    }
    scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, true);
    SCBPiPManager.getInstance().startExcludeEventTimeStamp =
      systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
    this.specificSession?.session?.setPipActionEvent(Constants.ACTION_PRE_RESTORE);
    let containerSession = this.getParentContainerSession();
    if (!containerSession?.isActive) {
      this.isRestoreFromBg = true;
      this.processPreRestore();
      return;
    }
    log.showInfo(`onActionRestore: active animation`);
    this.isRestoreFromBg = false;
    this.fetchComponentRect();
    SCBSceneSessionManager.getInstance().startSceneByPipRestore(this.parentId, false, this.getParentScreenId());
    const actionRestoreTimeId = setTimeout(()=> {
      SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
    }, Constants.RESET_PIP_RESTORE_TIMEOUT);
    this.timeoutIds.push(actionRestoreTimeId);
  }

  private notifyExtendScreenDisconnect(extendScreenId: number) {
    log.showInfo(`notifyExtendScreenDisconnect extendScreenId: ${extendScreenId}`);
    this.processShow(this.rect);
  }

  @Builder
  defaultBackgroundBuilder() {
    Stack() {
      Stack()
        .size({ width: '100%', height: '100%' })
        .backgroundColor(Color.Black)
        .borderRadius(this.pipBorderRadius / this.scaleValue)
    }
    .size({ width: this.rect?.width.getPxSizeStr(), height: this.rect?.height.getPxSizeStr() })
    .borderRadius(this.pipBorderRadius / this.scaleValue)
    .opacity(this.opacityNum)
    .visibility(this.isShowDefaultBackground ? Visibility.Visible : Visibility.Hidden)
    .padding(2)
  }

  @Builder
  sideBarBackgroundBuilder() {
    Stack() {
      Stack()
        .size({ width: '100%', height: '100%' })
        .backgroundBlurStyle(this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
        BlurStyle.COMPONENT_THIN : BlurStyle.COMPONENT_THICK)
        .backgroundColor(this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
          SIDE_EDGE_BAR_DARK_COLOR : SIDE_EDGE_BAR_LIGHT_COLOR)
        .border({
          width: 0.5,
          color: this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
            DARK_BAR_BORDER_COLOR : LIGHT_BAR_BORDER_COLOR
        })
        .borderRadius(this.pipBorderRadius / this.scaleValue)
    }
    .size({ width: '100%', height: '100%' })
    .borderRadius(this.pipBorderRadius / this.scaleValue)
    .visibility(this.showSideBar ? Visibility.Visible : Visibility.None)
    .opacity(1 - this.opacityNum)
  }

  build() {
    if (this.enableShow() && !this.isInSideManager) {
      if (this.enableShowWindowScene()) {
        Stack({ alignContent: Alignment.Center }) {
          Stack({ alignContent : this.moveEndTransX > 0 ? Alignment.Start : Alignment.End }) {
            this.defaultBackgroundBuilder();
            WindowScene(this.specificSession?.session.persistentId)
              .zIndex(this.panelZIndex)
              .id(`session${this.specificSession?.session.persistentId}`)
              .size({ width: this.rect?.width.getPxSizeStr(), height: this.rect?.height.getPxSizeStr() })
              .visibility(this.specificSession?.visibility ? Visibility.Visible : Visibility.Hidden)
              .borderRadius(this.pipBorderRadius / this.scaleValue)
              .opacity(this.opacityNum)
            Image(this.cachePixMap)
              .size({ width: this.rect?.width.getPxSizeStr(), height: this.rect?.height.getPxSizeStr() })
              .visibility(this.useSnapshot ? Visibility.Visible : Visibility.None)
              .opacity(this.opacityNum)
            this.sideBarBackgroundBuilder();
          }
          .position({ x: this.rect?.left.getPxStr(), y: this.rect?.top.getPxStr() })
          .size(this.showSideBar ? { width: this.realRectWidth / this.scaleValue,
            height: this.realRectHeight / this.scaleValue } :
            { width: this.rect?.width.getPxSizeStr(), height: this.rect?.height.getPxSizeStr() })
          .scale({
            x: this.scaleValue,
            y: this.scaleValue,
            centerX: this.centerScaleX,
            centerY: this.centerScaleY
          })
          .foregroundEffect(CommonUtils.equals(this.foregroundBlur, -1) ? null : {radius: this.foregroundBlur})
          .focusable(this.specificSession?.isFocusable)
          .hitTestBehavior(this.specificSession?.isTouchable ? HitTestMode.Block : HitTestMode.None)
          .borderRadius(this.pipBorderRadius / this.scaleValue)
          .clip(this.specificSession?.specialBoarderRadius > 0 || this.clipPiPWindow ? true : false)
          .shadow(this.shadowStyle)
          .translate({ x: this.transX + this.transXOffset, y: this.transY + this.transYOffset, z: 0 })
          .id(id)
          this.overlayBuilder();
        }
        .hitTestBehavior(HitTestMode.None)
        .visibility(this.isPiPVisibility ? Visibility.Visible : Visibility.Hidden)
        .width('100%')
        .height('100%')
      }
    }
  }

  @LocalBuilder
  overlayBuilder() {
    WindowScene(this.overlaySceneSession?.session.persistentId) {
      PiPOverlay({
        radius: this.pipBorderRadius,
        onActionMoveStart: (event: GestureEvent): void => this.onActionMoveStart(event),
        onActionMove: (event: GestureEvent): void => this.onActionMove(event),
        onActionMoveEnd: (event?: GestureEvent): void => this.onActionMoveEndOrCancel(event),
        onDoubleClick: (): void => this.onDoubleClick(),
        onActionClose: (): void => this.onActionClose(),
        onActionRestore: (): void => this.onActionRestore(),
      })
      .position({ x: 0, y: 0 })
      .size({ width: '100%', height: '100%' });
    }
    .responseRegion(
      {
        x:0,
        y:0,
        width:this.overlayRect?.width.getPxSizeStr(),
        height: this.overlayRect?.height.getPxSizeStr()
      })
    .backgroundColor(Color.Transparent)
    .borderRadius(this.pipBorderRadius)
    .position({ x: this.overlayRect?.left.getPxStr(), y: this.overlayRect?.top.getPxStr() })
    .size({ width: this.overlayRect?.width.getPxSizeStr(), height: this.overlayRect?.height.getPxSizeStr() })
    .id('SCBPipSceneOverlay')
    .focusable(true)
    .visibility(this.specificSession?.visibility && !this.closed ? Visibility.Visible : Visibility.None)
    .zIndex(this.overlayZIndex)
    .hitTestBehavior(HitTestMode.Default)
  }
}
