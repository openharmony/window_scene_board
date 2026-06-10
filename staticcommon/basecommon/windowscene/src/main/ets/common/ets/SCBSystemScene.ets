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

import { SCBScreenProperty, SCBScreenSession } from '../../screen/session/SCBScreenSession'
import { SCBSystemSceneSession, SystemSessionInfo, SystemSessionChangeCallback,
  SystemBarType } from '../../scene/session/SCBSystemSceneSession'
import { SCBSceneSessionManager } from '../../scene/session/SCBSceneSessionManager'
import { SCBSessionRect } from '../../scene/session/SCBSessionRect'
import { viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { windowMgr } from '../../windowmanager/WindowManagerProxy';
import { SCBScreenSessionManager, SCBPropertyChangeReason } from '../../screen/session/SCBScreenSessionManager';
import { RotationConstants, SCBConstants, SceneConstants } from '@ohos/commonconstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { PluginSlot } from '@ohos/frameworkwrapper';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBWindowRotateController } from '../../scene/manager/SCBWindowRotateController';
import { SCBKeyboardManager } from '../../scene/session/SCBKeyboardManager';
import { SCBKeyboardSession } from '../../scene/session/SCBKeyboardSession';
import sceneSessionManager from '@ohos.sceneSessionManager';
import systemDateTime from '@ohos.systemDateTime';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { WinLog, WinLogDomain } from '../../utils/WinLog';

const TAG = 'SCBSystemScene';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const ROTATE_POLICY: number = Number.parseInt(systemParameterEnhance.getSync('const.window.device.rotate_policy', '0'));
const ROTATE_STRATEGY_WINDOW: number = 0;

export interface SystemSceneBuilderParam {
  persistentId: number;
  screenProp: SCBScreenProperty;
}

interface SystemSceneOptionsInterface {
  focusable?: boolean;
  blockingFocus?: boolean;
  touchable?: boolean;
  privacyMode?: boolean;
  hitTestMode?: HitTestMode;
  rotatable?: boolean;
  visibility?: boolean;
  opacity?: number;
  scbKeepKeyboardFlag?: boolean;
  systemBarType?: SystemBarType;
  sceneType?: sceneSessionManager.SceneType;
  responseRegion?:Array<Rectangle>;
  landscapeStartRotatable?: boolean;
  followDeskTop?: boolean;
  enableActiveModeChange?: boolean;
  alwaysNeedAnimateWhenRotation?: boolean;
}

export class SystemSceneOptions {
  public focusable: boolean = false;
  public blockingFocus: boolean = false;
  public touchable: boolean = false;
  public privacyMode: boolean = false;
  public hitTestMode: HitTestMode = HitTestMode.None;
  public rotatable: boolean = false;
  public visibility: boolean = false;
  public opacity: number = 1;
  public followDeskTop: boolean = false;
  public scbKeepKeyboardFlag: boolean = false;
  public systemBarType: SystemBarType = SystemBarType.UNDEFINE;
  public sceneType: sceneSessionManager.SceneType = sceneSessionManager.SceneType.SYSTEM_WINDOW_SCENE;
  public responseRegion:Array<Rectangle> = [];
  public landscapeStartRotatable: boolean = true;
  public enableActiveModeChange: boolean = true;
  public alwaysNeedAnimateWhenRotation: boolean = false;

  constructor(obj: SystemSceneOptionsInterface) {
    this.focusable = obj.focusable ?? false;
    this.blockingFocus = obj.blockingFocus ?? false;
    this.touchable = obj.touchable ?? false;
    this.privacyMode = obj.privacyMode ?? false;
    this.hitTestMode = obj.hitTestMode ?? HitTestMode.None;
    this.rotatable = obj.rotatable ?? false;
    this.visibility = obj.visibility ?? false;
    this.opacity = obj.opacity ?? 1;
    this.scbKeepKeyboardFlag = obj.scbKeepKeyboardFlag ?? false;
    this.systemBarType = obj.systemBarType ?? SystemBarType.UNDEFINE;
    this.sceneType = obj.sceneType ?? sceneSessionManager.SceneType.SYSTEM_WINDOW_SCENE;
    this.responseRegion = obj.responseRegion ?? [];
    this.landscapeStartRotatable = obj.landscapeStartRotatable ?? true;
    this.followDeskTop = obj.followDeskTop ?? false;
    this.enableActiveModeChange = obj.enableActiveModeChange ?? true;
    this.alwaysNeedAnimateWhenRotation = obj.alwaysNeedAnimateWhenRotation ?? false;
  }
};

@Component
export struct SCBSystemScene {
  @BuilderParam contextBuilder: undefined | (($$: SystemSceneBuilderParam) => void);
  @State sysSceneSession: SCBSystemSceneSession | null = null;
  systemSessionInfo: SystemSessionInfo = {systemType: 0, sceneName: '', sceneZIndex: 0,
    hitTestMode: HitTestMode.Default, systemBarType:SystemBarType.UNDEFINE,
    sceneType: sceneSessionManager.SceneType.SYSTEM_WINDOW_SCENE};
  @Link screenProperty: SCBScreenProperty;
  @State transformRect: SCBSessionRect = new SCBSessionRect();
  /**
   * 转场动效回调
   */
  private transitionCallBack: undefined | (() => TransitionEffect);

  private sysSessionChangeCallback: SystemSessionChangeCallback = {
    onActiveChange: (isActive: boolean) => {
      if (!this.sysSceneSession) {
        log.showError(`${this.systemSessionInfo.sceneName} onActiveChange: ${isActive} is null`);
        return;
      }
      log.showInfo(`onActiveChange: ${isActive} systemName: ${this.sysSceneSession.name}`);
      this.sysSceneSession.isActive = isActive;
    },

    onVisibilityChange: (visibility: boolean) => {
      if (!this.sysSceneSession) {
        log.showError(`${this.systemSessionInfo.sceneName} onVisibilityChange: ${visibility} is null `);
        return;
      }
      log.showInfo(`onVisibilityChange: ${visibility} systemName: ${this.sysSceneSession.name}`);
      this.sysSceneSession.visibility = visibility;
      if (this.sysSceneSession.systemBarType != SystemBarType.UNDEFINE) {
        SCBSceneSessionManager.getInstance().refreshAvailableArea(this.screenProperty.screenId);
      }
    },
    onFocusableChange: (isFocusable: boolean) => {
      if (!this.sysSceneSession) {
        log.showError(`${this.systemSessionInfo.sceneName} onFocusableChange: ${isFocusable} is null `);
        return;
      }
      log.showInfo(`onFocusableChange: ${isFocusable} systemName: ${this.sysSceneSession.name}`);
      this.sysSceneSession.isFocusable = isFocusable;
    },

    onHitTestModeChange: (hitTestMode: HitTestMode) => {
      if (!this.sysSceneSession) {
        log.showError(`${this.systemSessionInfo.sceneName} onHitTestModeChange: ${hitTestMode} is null `);
        return;
      }
      log.showInfo(`onHitTestModeChange: ${hitTestMode} systemName: ${this.sysSceneSession.name}`);
      this.sysSceneSession.hitTestMode = hitTestMode;
    },

    onRotationChange: (screenProperty: SCBScreenProperty) => {
      if (!this.sysSceneSession) {
        log.showError(`${this.systemSessionInfo.sceneName} onRotationChange: ${screenProperty.rotation} is null `);
        return;
      }
      const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
      if ((!this.sysSceneSession.isRotatable || !this.sysSceneSession.isLandscapeStartRotatable) &&
        (uiType === SCBConstants.UITYPE_PHONE || uiType === SCBConstants.UITYPE_PAD)) {
        return;
      }

      // need change rect with rotation
      this.transformRect.setSizeNum(screenProperty.width, screenProperty.height);
      // pc no need to rotate since screen has rotate, only phone need set since screen not rotate
      if ((uiType === SCBConstants.UITYPE_PHONE) ||
        uiType === SCBConstants.UITYPE_PAD) {
        this.transformRect.setPosNum(screenProperty.getTranslateX(), screenProperty.getTranslateY());
        this.sysSceneSession.rotation = screenProperty.rotation;
      }
      log.showDebug('[SCBSystem]onRotationChange after systemName: ' + this.sysSceneSession.name + ' transformRect: ' +
        this.transformRect.printPx() + ' rotation: ' + screenProperty.rotation +
        ' screenProperty: ' + JSON.stringify(screenProperty));
    },

    onActiveModeChange: (oldScreenProperty : SCBScreenProperty, newScreenProperty: SCBScreenProperty) => {
      if (!this.sysSceneSession) {
        log.showError(`${this.systemSessionInfo.sceneName} onActiveModeChange: sysSceneSession is null `);
        return;
      }
      log.showDebug('onActiveModeChange systemName: ' + this.sysSceneSession.name +
        'before change currRect: ' + JSON.stringify(this.sysSceneSession.currRect));
      let left = this.sysSceneSession.currRect.left.getPx() * newScreenProperty.width / oldScreenProperty.width;
      let top = this.sysSceneSession.currRect.top.getPx() * newScreenProperty.height / oldScreenProperty.height;
      this.sysSceneSession.currRect.setPosNum(left, top);
      log.showDebug('onActiveModeChange systemName: ' + this.sysSceneSession.name + ' currRect: ' +
        JSON.stringify(this.sysSceneSession.currRect) + ' rotation: ' + newScreenProperty.rotation +
       ' screenProperty: ' + JSON.stringify(newScreenProperty));
    },

    onFoldChange: (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
      if (!this.sysSceneSession) {
        log.showError(`${this.systemSessionInfo.sceneName} onFoldChange: ${screenProperty.rotation} is null `);
        return;
      }

      if (SCBWindowRotateController.getInstance().isFullScreenRotatePolicy()) {
        if (this.sysSceneSession.isRotatable) {
          this.transformRect.setPosNum(screenProperty.getTranslateX(), screenProperty.getTranslateY());
          this.sysSceneSession.rotation = screenProperty.rotation;
        } else {
          this.transformRect.setPosNum(0, 0);
          this.sysSceneSession.rotation = 0;
          if (screenProperty.rotation === RotationConstants.ROTATION_90 ||
            screenProperty.rotation === RotationConstants.ROTATION_270) {
            this.transformRect.setSizeNum(screenProperty.height, screenProperty.width);
            return;
          }
        }
      } else {
        // pc no need to rotate since screen has rotate, only phone need set since screen not rotate
        let screenSession: SCBScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
        if (screenSession === null || screenSession === undefined) {
          WinLog.showError(WinLogDomain.WMS_ROTATION, 'onFoldChange screenSession is null');
          return;
        }
        if (reason === SCBPropertyChangeReason.EXPAND_TO_FOLD || reason === SCBPropertyChangeReason.FOLD_TO_EXPAND) {
          if (screenSession.isRotateScreenPolicy()) {
            this.transformRect.setPosNum(0, 0);
            this.sysSceneSession.rotation = 0;
          } else {
            if (!this.sysSceneSession.isRotatable) {
              this.transformRect.setPosNum(0, 0);
              this.sysSceneSession.rotation = 0;
              if (screenProperty.rotation === RotationConstants.ROTATION_90 ||
                screenProperty.rotation === RotationConstants.ROTATION_270) {
                this.transformRect.setSizeNum(screenProperty.height, screenProperty.width);
                return;
              }
            } else {
              this.transformRect.setPosNum(screenProperty.getTranslateX(), screenProperty.getTranslateY());
              this.sysSceneSession.rotation = screenProperty.rotation;
            }
          }
        } else {
          this.transformRect.setPosNum(0, 0);
          this.sysSceneSession.rotation = 0;
        }
      }
      // need change rect with rotation
      this.transformRect.setSizeNum(screenProperty.width, screenProperty.height);
      log.showDebug('onFoldChange after systemName: ' + this.sysSceneSession.name + ' transformRect: ' +
        this.transformRect.printPx() + ' rotation: ' + screenProperty.rotation +
        ' screenProperty: ' + JSON.stringify(screenProperty));
    },

    onUpdateRect: (rect: SCBSessionRect) => {
      if (!this.sysSceneSession || rect.isEmpty()) {
        log.showError(`${this.systemSessionInfo.sceneName} onUpdateRect failed ${JSON.stringify(rect)}`);
        return;
      }
      log.showInfo('[SCBSystem][WMSLayout]onUpdateRect: ' + JSON.stringify(rect) + ' name: ' + this.sysSceneSession?.name);
      if (this.sysSceneSession.currRect.equals(rect)) {
        log.showDebug('session rect not change');
        return;
      }
      if (!this.floatNearEqual(rect.width.getPx(), 0) && !this.floatNearEqual(rect.height.getPx(), 0)) {
        this.sysSceneSession.currRect = rect;
      }
    },

    onTouchOutside: (x, y) => {
      log.showDebug(`onTouchOutside ${this.systemSessionInfo.sceneName}`);
      let allIconCaches = windowMgr.getAllStatusIconCaches();
      if (allIconCaches === undefined || allIconCaches === null || allIconCaches.size === 0) {
        return;
      }
      let panelName: string | undefined = undefined;
      allIconCaches.forEach((area, windowName) => {
        if (!windowName) {
          return;
        }
        if (this.systemSessionInfo.sceneName.indexOf(windowName) > -1) {
          panelName = windowName;
        }
      });
      if (!panelName) {
        return;
      }
      // touch on statusbar icon or screenshot
      if (this.isTouchInside(x, y, panelName, allIconCaches)) {
        return;
      }

      let viewType = windowMgr.getViewType(panelName);
      if (viewType === undefined || viewType === null) {
        log.showInfo(`onTouchOutside viewType is undefined`)
        return;
      }
      if (viewMgrPolicy.isViewShowing(viewType)) {
        if ((viewType === PluginSlot.SLOT_STATUS_QUICK_NOTE) &&
          (this.isClickOnSoftInput(x, y) || this.isClickOnKeyBoardPanel(x, y))) {
          log.showInfo(`onTouchOutside ${viewType} click on softInput or click on keyboard panel`);
          return;
        }
        if (viewType === ViewType.NOTIFICATION_CENTER) {
          return;
        }
        if (this.isTouchInside(x, y, PluginSlot.SLOT_STATUS_CAPSULE_SCREENSHOT, allIconCaches)) {
          setTimeout(() => {
            windowMgr.hideWindowWithAnim(panelName);
          }, 150);
          return;
        }
        // 从控制中心点击蓝牙WiFi，不响应onTouchOutside触发的隐藏蓝牙WiFi窗口
        if (DeviceHelper.isPC() && this.isClickFromControlCenterPanel(viewType)) {
          log.showInfo('click Bluetooth and WiFi from the Control Center，not response hideWindow')
          return;
        }
        // 业务实现dealTouchOutSide，由业务自己处理
        if (viewMgrPolicy.dealTouchOutSide(viewType)) {
          log.showInfo('deal onTouchOutSide');
          return;
        }

        log.showInfo(`onTouchOutside ${viewType} outside hide`);
        windowMgr.hideWindowWithAnim(panelName);
      }
    },

    onTranslateChange: (x: number, y: number, z: number) => {
      if (!this.sysSceneSession) {
        log.showError(`${this.systemSessionInfo.sceneName} onTranslateChange: {${x}, ${y}, ${z}}, is null`);
        return;
      }
      log.showInfo(`onTranslateChange: {${x}, ${y}, ${z}} systemName: ${this.sysSceneSession.name}`);
      this.sysSceneSession.translateX = x;
      this.sysSceneSession.translateY = y;
      this.sysSceneSession.translateZ = z;
    },

    onBackgroundColorChange: (backgroundColor: string) => {
      if (!this.sysSceneSession) {
        log.showError(`${this.systemSessionInfo.sceneName} onBackgroundColorChange: ${backgroundColor}, is null`);
        return;
      }
      log.showInfo(`onBackgroundColorChange: ${backgroundColor} systemName: ${this.sysSceneSession.name}`);
      this.sysSceneSession.backgroundColor = backgroundColor;
    },

    onBackdropBlurChange: (backdropBlur: number) => {
      if (!this.sysSceneSession) {
        log.showError(`${this.systemSessionInfo.sceneName} onBackdropBlurChange: ${backdropBlur}, is null`);
        return;
      }
      log.showInfo(`onBackdropBlurChange: ${backdropBlur} systemName: ${this.sysSceneSession.name}`);
      this.sysSceneSession.backdropBlur = backdropBlur;
    },

    onBorderRadiusChange: (borderRadius: number) => {
      if (!this.sysSceneSession) {
        log.showError(`${this.systemSessionInfo.sceneName} onBorderRadiusChange: ${borderRadius}, is null`);
        return;
      }
      log.showInfo(`onBorderRadiusChange: ${borderRadius} systemName: ${this.sysSceneSession.name}`);
      this.sysSceneSession.borderRadius = borderRadius;
    },

    onShadowChange: (radius: number, color: string, offsetX: number, offsetY: number) => {
      if (!this.sysSceneSession) {
        log.showError(`${this.systemSessionInfo.sceneName} onShadowChange: {${radius}, ${color}, ${offsetX}, ${offsetY}}, is null`);
        return;
      }
      log.showInfo(`onShadowChange: {${radius}, ${color}, ${offsetX}, ${offsetY}} systemName: ${this.sysSceneSession.name}`);
      this.sysSceneSession.radius = radius;
      this.sysSceneSession.color = color;
      this.sysSceneSession.offsetX = offsetX;
      this.sysSceneSession.offsetY = offsetY;
    },

    onOpacityChange: (opacity: number) => {
      if (!this.sysSceneSession) {
        log.showError(`${this.systemSessionInfo.sceneName} onOpacityChange: ${opacity}, is null`);
        return;
      }
      log.showInfo(`onOpacityChange: ${opacity} systemName: ${this.sysSceneSession.name}`);
      this.sysSceneSession.opacity = opacity;
    },

    onTouchableChange: (touchable: boolean) => {
      if (!this.sysSceneSession) {
        log.showError(`${this.systemSessionInfo.sceneName} onTouchableChange: ${touchable}, is null`);
        return;
      }
      log.showInfo(`onTouchableChange: ${touchable} systemName: ${this.sysSceneSession.name}`);
      this.sysSceneSession.isTouchable = touchable;
    },

    onZIndexChange: (zIndex: number) => {
      if (!this.sysSceneSession) {
        log.showError(`${this.systemSessionInfo.sceneName} onZIndexChange: ${zIndex}, is null`);
        return;
      }
      log.showInfo(`onZIndexChange: ${zIndex} systemName: ${this.sysSceneSession.name}`);
      this.sysSceneSession.zIndex = zIndex;
      SCBSceneSessionManager.getInstance().sortSystemScene();
    },
    onResponseRegionChange: (responseRegion: Array<Rectangle>) => {
      if (!this.sysSceneSession) {
        log.showError(`${this.systemSessionInfo.sceneName} onResponseRegionChange is null`);
        return;
      }
      this.sysSceneSession.responseRegion = responseRegion;
    },
  }

  private isClickFromControlCenterPanel(viewType: string | ViewType): boolean {
    if (viewType === ViewType.PLUGIN_WIFI || viewType === ViewType.PLUGIN_BLUETOOTH) {
      try {
        const currentTime = systemDateTime.getTime(false);
        const clickBluetoothAndWiFiTime = Number(GlobalContext.getInstance().getObject('clickBluetoothAndWiFiTime')) ?? 0;
        if (currentTime > clickBluetoothAndWiFiTime && currentTime - clickBluetoothAndWiFiTime < 20) {
          log.showInfo(`bluetooth wifi is showing, not showed -- ${currentTime - clickBluetoothAndWiFiTime}`);
          GlobalContext.getInstance().setObject('clickBluetoothAndWiFiTime', 0);
          return true;
        }
      } catch (error) {
        log.showError(`Failed to get time. message: ${error.message}`);
      }
    }
    return false;
  }

  private isTouchInside(x: number, y: number, pluginSlot: string,
                        allIconCaches: Map<string, Area>): boolean {
    let iconArea: Area | undefined = allIconCaches.get(pluginSlot);
    if (!iconArea) {
      log.showInfo('icon not exist ' + pluginSlot);
      return false;
    }
    let tmp = (iconArea as Area).globalPosition;
    if (x >= vp2px(tmp.x as number) && x <= vp2px((tmp.x as number +
      ((iconArea as Area).width as number))) && y >= vp2px(tmp.y as number) &&
      y <= vp2px((tmp.y as number + ((iconArea as Area).height as number)))) {
      log.showInfo('touch on icon ' + pluginSlot);
      return true;
    }
    log.showInfo('touch out icon ' + pluginSlot);
    return false;
  }

  private isClickOnSoftInput(x: number, y: number): boolean {
    const inputRect: SCBSessionRect = windowMgr.getActiveInputMethodRect();
    return inputRect && inputRect.contains(x, y);
  }

  private isClickOnKeyBoardPanel(x: number, y: number): boolean {
    if (!SCBKeyboardManager.getInstance().getKeyboardSession()?.isKeyboardShowing()) {
      return false;
    }
    let rect = (SCBKeyboardManager.getInstance().getKeyboardSession() as SCBKeyboardSession).currRect;
    return rect && rect.contains(x, y);
  }

  private floatNearEqual(a: number, b: number): boolean {
    return Math.abs(a - b) < 0.001;
  }

  private setTransformRect(): void {
    this.transformRect.setRectNum(this.screenProperty.getTranslateX(), this.screenProperty.getTranslateY(),
                                  this.screenProperty.width, this.screenProperty.height);
    
    let screenSession: SCBScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (screenSession === null || screenSession === undefined) {
      log.showError('[SCBSystem] setTransformRect screenSession is null');
      return;
    }

    if (screenSession.isRotateScreenPolicy()) {
      this.transformRect.setRectNum(0, 0, this.screenProperty.width, this.screenProperty.height);
    }
  }

  aboutToAppear() {
    log.showInfo(`[SCBSystem]${this.systemSessionInfo.sceneName} aboutToAppear! ` );
    if (this.sysSceneSession === undefined || this.sysSceneSession === null) {
      this.sysSceneSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession(this.systemSessionInfo,
        this.sysSessionChangeCallback, undefined, this.screenProperty.screenId);
    }
    if (this.sysSceneSession === undefined || this.sysSceneSession === null) {
      log.showWarn(`${this.systemSessionInfo.sceneName} system scene session is null! ` )
      return;
    }
    if (this.sysSceneSession.currRect.isEmpty()) {
      this.sysSceneSession.currRect = new SCBSessionRect(this.screenProperty.left, this.screenProperty.top,
        this.screenProperty.width, this.screenProperty.height);
      log.showInfo(`[SCBSystem] systemName: ${this.sysSceneSession?.name} change rect!`)
    }
    this.sysSceneSession.setActive(true);
    this.sysSceneSession.sessionData.id = this.sysSceneSession.session.persistentId;
    this.setTransformRect();
    this.sysSceneSession.rotation = this.screenProperty.rotation;
    this.sysSceneSession.setTransformRect(this.transformRect);

    log.showInfo('[SCBSystem] systemName: ' + this.sysSceneSession.name + ' aboutToAppear currRect: ' +
      this.sysSceneSession.currRect.printPx() + ' transformRect: ' + this.transformRect.printPx() +
      ' rotation:' + this.sysSceneSession.rotation);
  }

  aboutToDisappear() {
    log.showInfo(`[SCBSystem]${this.systemSessionInfo.sceneName} aboutToDisappear! ` )
    SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(
      this.sysSceneSession as SCBSystemSceneSession, this.screenProperty.screenId);
  }

  getVisibility(isVisible: boolean | undefined): Visibility {
    return isVisible ? Visibility.Visible : Visibility.Hidden;
  }

  getTransformPosition(): Position {
    return {x: this.transformRect.left.getPxStr(), y: this.transformRect.top.getPxStr()};
  }

  @Styles
  windowSceneStyles() {
    .id(`session${this.sysSceneSession?.session.persistentId}`)
    .position({
      x: this.sysSceneSession?.currRect.left.getPxStr(),
      y: this.sysSceneSession?.currRect.top.getPxStr() })
    .size({ width: this.sysSceneSession?.currRect.width.getPxSizeStr(),
      height: this.sysSceneSession?.currRect.height.getPxSizeStr()})
    .focusable(this.sysSceneSession?.isFocusable)
    .hitTestBehavior(this.sysSceneSession?.hitTestMode)
    .enabled(this.sysSceneSession?.isTouchable)
    .opacity(this.sysSceneSession?.opacity)
    .translate({
      x: this.sysSceneSession?.translateX,
      y: this.sysSceneSession?.translateY,
      z: this.sysSceneSession?.translateZ
    })
    .visibility(this.getVisibility(this.transitionCallBack == null || this.sysSceneSession?.visibility))
    .transition(this.transitionCallBack == null ? TransitionEffect.IDENTITY : this.transitionCallBack())
    .backgroundColor(this.sysSceneSession?.backgroundColor)
    .borderRadius(this.sysSceneSession?.borderRadius)
    .backdropBlur(this.sysSceneSession?.backdropBlur, undefined, { disableSystemAdaptation: true })
    .shadow({
      radius: this.sysSceneSession?.radius,
      color: this.sysSceneSession?.color,
      offsetX: this.sysSceneSession?.offsetX,
      offsetY: this.sysSceneSession?.offsetY
    })
    .responseRegion(this.sysSceneSession?.responseRegion)
  }

  @Styles
  transformSceneStyles() {
      .accessibilityLevel('no')
      .id(`transformScene${this.sysSceneSession?.name}`)
      .zIndex(this.sysSceneSession?.zIndex)
      .position(this.getTransformPosition())
      .size({width: this.transformRect.width.getPxSizeStr(), height: this.transformRect.height.getPxSizeStr()})
      .rotate(this.getTransformSceneRotateOptions())
      .hitTestBehavior(HitTestMode.None)
      .visibility(this.getVisibility(this.transitionCallBack != null || this.sysSceneSession?.visibility))
  }

  @Builder
  sceneViewBuilder() {
    if (this.contextBuilder) {
      WindowScene(this.sysSceneSession?.id) {
        this.contextBuilder({persistentId: this.sysSceneSession!.id, screenProp: this.screenProperty})
      }
      .windowSceneStyles();
    }
  }

  private getTransformSceneRotateOptions(): RotateOptions {
    let option: RotateOptions = {
      x: 0,
      y: 0,
      z: 1,
      angle: (SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType === SCBConstants.UITYPE_PHONE ||
        SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType === SCBConstants.UITYPE_PAD) ?
        -this.sysSceneSession!.rotation : 0,
      centerX: '50%',
      centerY: '50%'
    };
    return option;
  }

  build() {
    if (this.sysSceneSession?.isActive) {
      WindowScene(SceneConstants.TRANSFORM_SCENE) { // transform scene, always full screen
        this.sceneViewBuilder()
      }
      .transformSceneStyles();
    }
  }
}