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

import type { Callback } from './@ohos.base';
import type { UIContext } from '@ohos.arkui.UIContext';
import Image from '@ohos.multimedia.image';

/**
 * Screen session manager.
 *
 * @syscap SystemCapability.Window.SceneSessionManager
 * @systemapi Hide this for inner system use.
 * @since 10
 */
declare namespace screenSessionManager {
  /**
   * Round rect.
   */
  interface RRect {
    /**
     * The X-axis coordinate of the upper left vertex of the round rect, in pixels.
     */
    left: number;

    /**
     * The Y-axis coordinate of the upper left vertex of the round rect, in pixels.
     */
    top: number;

    /**
     * Width of the round rect, in pixels.
     */
    width: number;

    /**
     * Height of the round rect, in pixels.
     */
    height: number;

    /**
     * Radius of the round corner of the round rect, in pixels.
     */
    radius: number;
  }
  /**
   * The display rect.
   */
  interface DMRect {
    /**
     * The X-axis coordinate of the upper left vertex of the display rect, in pixels.
     */
    posX: number;
    /**
     * The Y-axis coordinate of the upper left vertex of the display rect, in pixels.
     */
    posY: number;
    /**
     * Width of the display rect, in pixels.
     */
    width: number;
    /**
     * Height of the display rect, in pixels.
     */
    height: number;
  }
  /**
   * The property of a screen.
   */
  interface ScreenProperty {
    /**
     * Reason of the propertyChange.
     */
    propertyChangeReason?: string;

    /**
     * Rotation of the screen.
     */
    rotation: number;

    /**
     * Bounds of the screen.
     */
    bounds: RRect;

    /**
     * Fake Bounds of the screen.
     */
    fakeBounds: RRect;

    /**
     * Is Fake Bounds in use.
     */
    isFakeInUse: boolean;

    /**
     * RS ID.
     */
    rsId?: number;
  }

  /**
   * The direction info of screen.
   */
  interface ScreenDirectionInfo {
    /**
     * original notification rotation before PAD angle rectification.
     */
    notifyRotation: number;

    /**
     * rotation of the screen component.
     */
    screenRotation: number;

    /**
     * rotation relative to sensor's natural orientation.
     */
    rotation: number;

    /**
     * physical rotation.
     */
    phyRotation: number;
  }

  /**
   * The reson of screenConnectChange.
   *
   * @enum { number }
   * @syscap SystemCapability.Window.ScreenSessionManager
   * @systemapi Hide this for inner system use.
   * @since 10
   */
  enum ScreenPropertyChangeReason {
    /**
     * Undefined reason.
     */
    UNDEFINED,
    /**
     * Rotation.
     */
    ROTATION,
    /**
     * Change activeMode.
     */
    CHANGE_MODE,
    /**
     * Folding screen expand.
     */
    FOLD_SCREEN_EXPAND,
    /**
     * Screen connect.
     */
    SCREEN_CONNECT,
    /**
     * Screen disconnect.
     */
    SCREEN_DISCONNECT,
    /**
     * Folding screen folding.
     */
    FOLD_SCREEN_FOLDING,
    /**
     * Virtural screen resize.
     */
    VIRTUAL_SCREEN_RESIZE,
    /**
     * Relative position change.
     */
    RELATIVE_POSITION_CHANGE,
    /**
     * super fold status change.
     */
    BIG_SCREEN_STATUS_CHANGE,
  }

  /**
   * The event of display power.
   *
   * @enum { number }
   * @syscap SystemCapability.Window.ScreenSessionManager
   * @systemapi Hide this for inner system use.
   * @since 10
   */
  enum DisplayPowerEvent {
    /**
     * Wake up.
     */
    WAKE_UP,
    /**
     * Sleep.
     */
    SLEEP,
    /**
     * Display on.
     */
    DISPLAY_ON,
    /**
     * Display off.
     */
    DISPLAY_OFF,
    /**
     * Desktop ready.
     */
    DESKTOP_READY,
  }

  /**
   * The event of status.
   *
   * @enum { number }
   * @syscap SystemCapability.Window.ScreenSessionManager
   * @systemapi Hide this for inner system use.
   * @since 10
   */
  enum EventStatus {
    /**
     * Begin.
     */
    BEGIN,
    /**
     * End.
     */
    END,
  }

  /**
   * The reson of power state change.
   *
   * @enum { number }
   * @syscap SystemCapability.Window.ScreenSessionManager
   * @systemapi Hide this for inner system use.
   * @since 10
   */
  enum PowerStateChangeReason {
    /**
     * Init.
     */
    STATE_CHANGE_REASON_INIT = 0,
    /**
     * Timeout.
     */
    STATE_CHANGE_REASON_TIMEOUT = 1,
    /**
     * Running lock.
     */
    STATE_CHANGE_REASON_RUNNING_LOCK = 2,
    /**
     * Battery.
     */
    STATE_CHANGE_REASON_BATTERY = 3,
    /**
     * Thermal.
     */
    STATE_CHANGE_REASON_THERMAL = 4,
    /**
     * Work.
     */
    STATE_CHANGE_REASON_WORK = 5,
    /**
     * System.
     */
    STATE_CHANGE_REASON_SYSTEM = 6,
    /**
     * Application.
     */
    STATE_CHANGE_REASON_APPLICATION = 10,
    /**
     * Settings.
     */
    STATE_CHANGE_REASON_SETTINGS = 11,
    /**
     * Hard key.
     */
    STATE_CHANGE_REASON_HARD_KEY = 12,
    /**
     * Touch.
     */
    STATE_CHANGE_REASON_TOUCH = 13,
    /**
     * Cable.
     */
    STATE_CHANGE_REASON_CABLE = 14,
    /**
     * Sensor.
     */
    STATE_CHANGE_REASON_SENSOR = 15,
    /**
     * Lid.
     */
    STATE_CHANGE_REASON_LID = 16,
    /**
     * Camera.
     */
    STATE_CHANGE_REASON_CAMERA = 17,
    /**
     * Accessibility.
     */
    STATE_CHANGE_REASON_ACCESSIBILITY = 18,
    /**
     * Reset.
     */
    STATE_CHANGE_REASON_RESET = 19,
    /**
     * Power key.
     */
    STATE_CHANGE_REASON_POWER_KEY = 20,
    /**
     * Keyboard.
     */
    STATE_CHANGE_REASON_KEYBOARD = 21,
    /**
     * Mouse.
     */
    STATE_CHANGE_REASON_MOUSE = 22,
    /**
     * Double click.
     */
    STATE_CHANGE_REASON_DOUBLE_CLICK = 23,
    /**
     * Remote.
     */
    STATE_CHANGE_REASON_REMOTE = 100,
    /**
     * Unknown.
     */
    STATE_CHANGE_REASON_UNKNOWN = 1000,
  }

  /**
   * Enumerates the fold status.
   *
   * @enum { number }
   * @syscap SystemCapability.Window.SessionManager
   * @since 10
   */
  enum FoldStatus {
    /**
     * Fold Status Unknown.
     *
     * @syscap SystemCapability.Window.SessionManager
     * @since 10
     */
    FOLD_STATUS_UNKNOWN = 0,
    /**
     * Fold Status Expanded.
     *
     * @syscap SystemCapability.Window.SessionManager
     * @since 10
     */
    FOLD_STATUS_EXPANDED,
    /**
     * Fold Status Folded.
     *
     * @syscap SystemCapability.Window.SessionManager
     * @since 10
     */
    FOLD_STATUS_FOLDED,
    /**
     * Fold Status Half Folded.
     *
     * @syscap SystemCapability.Window.SessionManager
     * @since 10
     */
    FOLD_STATUS_HALF_FOLDED
  }

  /**
   * Enumerates the super fold status.
   *
   * @enum { number }
   * @syscap SystemCapability.Window.SessionManager
   * @since 14
   */
  enum BigScreenStatus {
    /**
     * Super Fold Status Unknown.
     *
     * @syscap SystemCapability.Window.SessionManager
     * @since 14
     */
    BIG_SCREEN_STATUS_UNKNOWN = 0,
    /**
     * Super Fold Status Folded.
     *
     * @syscap SystemCapability.Window.SessionManager
     * @since 14
     */
    BIG_SCREEN_STATUS_FOLDED,
    /**
     * Super Fold Status Half Folded.
     *
     * @syscap SystemCapability.Window.SessionManager
     * @since 14
     */
    BIG_SCREEN_STATUS_HALF_FOLDED,
    /**
     * Super Fold Status Expanded.
     *
     * @syscap SystemCapability.Window.SessionManager
     * @since 14
     */
    BIG_SCREEN_STATUS_EXPANDED,
    /**
     * Super Fold Status keyboard.
     *
     * @syscap SystemCapability.Window.SessionManager
     * @since 14
     */
    BIG_SCREEN_STATUS_KEYBOARD
  }

  /**
   * Enumerates the screen mode change event.
   *
   * @enum { number }
   * @syscap SystemCapability.Window.SessionManager
   * @since 19
   */
  enum ScreenModeChangeEvent {
    /**
     * Screen Mode Change Event Unknown.
     *
     * @syscap SystemCapability.Window.SessionManager
     * @since 19
     */
    SCREEN_MODE_CHANGE_EVENT_UNKNOWN = 0,
    /**
     * Screen Mode Change Event Begin.
     *
     * @syscap SystemCapability.Window.SessionManager
     * @since 19
     */
    SCREEN_MODE_CHANGE_EVENT_BEGIN,
    /**
     * Screen Mode Change Event End.
     *
     * @syscap SystemCapability.Window.SessionManager
     * @since 19
     */
    SCREEN_MODE_CHANGE_EVENT_END,
  }

  /**
   * DeviceScreenConfig.
   *
   * @syscap SystemCapability.Window.ScreenSessionManager
   * @systemapi Hide this for inner system use.
   */
  interface DeviceScreenConfig {
    rotationPolicy: string;
    defaultRotationPolicy: string;
    isRightPowerButton: boolean;
  }

  /**
   * The session of a screen.
   */
  interface ScreenSession {
    /**
     * Identifier of the screen.
     */
    readonly screenId: number;

    /**
     * Identifier of the displayGroup.
     */
    readonly displayGroupId: number;

    /**
     * Identifier of the virtual screen.
     */
    name?: string;

    /**
     * Identifier of the screen type.
     */
    isExtend?: boolean;

    /**
     * Identifier of the virtual screen.
     */
    innerName?: string;

    /**
     * Register the callback of screen connection.
     * @param type 'connect'
     */
    on(type: 'connect', callback: Callback<ScreenProperty>): void;

    /**
     * Register the callback of screen disconnection.
     * @param type 'disconnect'
     */
    on(type: 'disconnect', callback: Callback<void>): void;

    /**
     * Register the callback of screen property change.
     * @param type 'propertyChange'
     */
    on(type: 'propertyChange', callback: Callback<ScreenProperty, ScreenPropertyChangeReason>): void;

    /**
     * Register the callback of screen power status change.
     * @param type 'propertyChange'
     */
    on(type: 'powerStatusChange', callback: Callback<DisplayPowerEvent, EventStatus, PowerStateChangeReason>): void;

    /**
     * Register the callback of screen sensor rotation.
     * @param type 'sensorRotationChange'
     */
    on(type: 'sensorRotationChange', callback: Callback<number>): void;

    /**
     * Register the callback of screen hover status rotation.
     * @param type 'hoverStatusChange'
     */
    on(type: 'hoverStatusChange', callback: Callback<number, boolean>): void;

    /**
     * Register the callback of screen orientation change.
     * @param type 'screenOrientationChange'
     */
    on(type: 'screenOrientationChange', callback: Callback<number>): void;

    /**
     * Register the callback of screen rotation change from system.
     * @param type 'screenRotationLockedChange'
     */
    on(type: 'screenRotationLockedChange', callback: Callback<boolean>): void;

    /**
     * Register the callback of screen density change from system.
     * @param type 'screenDensityChange'
     */
    on(type: 'screenDensityChange', callback: Callback<void>): void;

    /**
     * Register the callback of screen extend change from system.
     * @param type 'screenExtendChange'
     */
    on(type: 'screenExtendChange', callback: Callback<number, number>): void;

    /**
     * Register the callback of camera backSelfie status.
     * @param type 'cameraBackSelfieChange'
     */
    on(type: 'cameraBackSelfieChange', callback: Callback<boolean>): void;

    /**
     * Register the callback of screen capture notify from system.
     * @param type 'screenCaptureNotify'
     */
    on(type: 'screenCaptureNotify', callback: Callback<number, number, string>): void;

    /**
     * Register the callback of super fold status change from system.
     * @param type 'bigScreenStatusChange'
     */
    on(type: 'bigScreenStatusChange', callback: Callback<number, BigScreenStatus>): void;

    /**
     * Register the callback of extend screen connect status change from system.
     * @param type 'extendScreenConnectStatusChange'
     */
    on(type: 'extendScreenConnectStatusChange', callback: Callback<number, ExtendScreenConnectStatus>): void;

    /**
     * Register the callback of secondary  reflexion change from system.
     * @param type 'secondaryReflexionChange'
     */
    on(type: 'secondaryReflexionChange', callback: Callback<number, boolean>): void;

    /**
     * Register the callback of screen mode change from system.
     * @param type 'screenModeChange'
     */
    on(type: 'screenModeChange', callback: Callback<number, ScreenModeChangeEvent>): void;

    /**
     * Register the callback of screen property display mode change from system.
     * @param type 'beforeScreenPropertyChange'
     */
    on(type: 'beforeScreenPropertyChange', callback: Callback<number>): void;

    /**
     * SetScreenRotationLocked.
     * @param type 'isLocked'
     */
    setScreenRotationLocked(isLocked: boolean): void;

    /**
     * Load the ui content of the screen scene.
     * @param path: Path of the page which the root scene will be loaded
     * @param context: Context of the service extension
     */
    loadContent(path: string, context: ServiceExtensionContext, storage?: LocalStorage): void;

    /**
     * setTouchEnabled
     * @param isTouchEnabled: boolean
     */
    setTouchEnabled(isTouchEnabled: boolean): void;

    /**
     * release screen session resource
     */
    releaseResource(): void;

    /**
    * get screenUIContext.
    * @returns the object of uiContent
    */
    getScreenUIContext(): UIContext;

    /**
    * destroyContent
    */
    destroyContent(): void;
  }

  /**
   * Type of the screen connection.
   */
  enum ScreenConnectChangeType {
    /**
     * Screen connection.
     */
    CONNECT = 0,

    /**
     * Screen disconnection.
     */
    DISCONNECT,
  }

  /**
   * Type of the screen connection.
   */
  enum ExtendScreenConnectStatus {
    UNKNOWN = 0,

    /**
     * Screen connection.
     */
    CONNECT,

    /**
     * Screen disconnection.
     */
    DISCONNECT,
  }

  /**
   * Type of the fold display mode.
   */
  enum FoldDisplayMode {
    UNKNOWN = 0,

    /**
     * FoldDisplayMode full.
     */
    FULL,
  
    /**
     * FoldDisplayMode main.
     */
    MAIN,

    /**
     * FoldDisplayMode sub.
     */
    SUB,

    /**
     * FoldDisplayMode coordination.
     */
    COORDINATION,

    /**
     * FoldDisplayMode global full.
     */
    GLOBAL_FULL,
  }

  /**
   * Register the callback of screen connection.
   * @param type 'screenConnectChange'
   */
  function on(type: 'screenConnectChange',
    callback: Callback<{ screenSession: ScreenSession, screenConnectChangeType: ScreenConnectChangeType }>): void;

  enum ScreenPropertyChangeType {
    UNSPECIFIED = 0,
    /**
     * rotate begin.
     */
    ROTATION_BEGIN,
  
    /**
     * rotate end.
     */
    ROTATION_END,

    /**
     * rotate update property only.
     */
    ROTATION_UPDATE_PROPERTY_ONLY,

    /**
     * rotate update property only but not notify app.
     */
    ROTATION_UPDATE_PROPERTY_ONLY_NOT_NOTIFY,

    /**
     * switch single hand mode.
     */
    SINGLE_HAND_SWITCH,
  }

  /**
   * update screenProperty.
   * @param bounds screenProperty bounds and rotation
   */
  function updateScreenRotationProperty(screenId: number, bounds: RRect,
    directionInfo: ScreenDirectionInfo, type?: ScreenPropertyChangeType): void;

  /**
   * register callback for shutdown
   */
  function registerShutdownCallback(callback: Callback<string, boolean>): void;

  /**
   * unregister callback for shutdown
   */
  function unRegisterShutdownCallback(): void;

  /**
   * send screenLock event to window mode
   */
  function notifyScreenLockEvent(event: number): void;

  /**
   * GetPhyScreenProperty.
   * @param type 'isLocked'
   */
  function getPhyScreenProperty(screenId: number): ScreenProperty;

  /**
   * updateAvailableArea
   * @param screenId number
   * @param area DMRect
   */
  function updateAvailableArea(screenId: number, area: DMRect): void;

  /**
   * updateBigScreenAvailableArea
   * @param screenId number
   * @param bArea DMRect
   * @param cArea DMRect
   */
  function updateBigScreenAvailableArea(screenId: number, bArea: DMRect, cArea: DMRect): void;

  /**
   * updateBigScreenBCAvailableArea
   * @param screenId number
   * @param area DMRect
   */
  function updateBigScreenExpandAvailableArea(screenId: number, area: DMRect): void;

  /**
   * Get the current fold status of the foldable device.
   *
   * @returns { FoldStatus } fold status of device.
   * @throws { BusinessError } 801 - Capability not supported on this device.
   * @throws { BusinessError } 1400003 - This display manager service works abnormally.
   * @syscap SystemCapability.Window.SessionManager
   * @since 10
   */
  function getFoldStatus(): FoldStatus;

  /**
   * Get the current super fold status of the super fold device.
   * @returns Returns super fold status of device.
   */
  function getBigScreenStatus(): BigScreenStatus;

  /**
   * Get the current super rotation of the super fold device.
   * @returns Returns rotation of the super fold device.
   */
  function getSuperRotation(): number;

  /**
   * Get Screen Snapshot
   * @param screenId
   * @param scaleX
   * @param scaleY
   * @returns Image.PixelMap
   */
  function getScreenSnapshot(screenId: number, scaleX: number, scaleY: number): Promise<Image.PixelMap>;

  /**
   * Get Screen Snapshot Sync
   * @param screenId
   * @param scaleX
   * @param scaleY
   * @returns Image.PixelMap
   */
   function getScreenSnapshotSync(screenId: number, scaleX: number, scaleY: number): Image.PixelMap;

  /**
   * Get Extend Screen Connect Status
   * @returns ExtendScreenConnectStatus
   */
  function getExtendScreenConnectStatus(): ExtendScreenConnectStatus;

  /**
  * notifyFoldToExpandCompletion
  * @foldToExpand fold to expand
  */
  function notifyFoldToExpandCompletion(foldToExpand: boolean): void;

  /**
   * Get device screen config.
   * @returns Returns the config value of the device screen.
   */
  function getDeviceScreenConfig(): DeviceScreenConfig;

  /**
   * Set the delay time of screen off.
   * @param delay
   */
  function setScreenOffDelayTime(delay: number): void;

  /**
   * Set Camera status and position.
   * @param cameraStatus
   * @param cameraPosition
   */
  function setCameraStatus(cameraStatus: number, cameraPosition: number): void;

  /**
   * Set the delay time of screen on.
   * @param delay
   */
  function setScreenOnDelayTime(delay: number): void;

  /**
  * Record event to screen event tracker
  * @param description
  * @param needRecordEvent
  */
  function recordEventFromScb(description: string, needRecordEvent: boolean): void;

  /**
   * Set Landscape Lock Status
   * @param isLocked
   */
  function setLandscapeLockStatus(isLocked: boolean): void;

  /**
   * Set Force Close Hdr 
   * @param screenId
   * @param isForceCloseHdr
   */
  function setForceCloseHdr(screenId: number, isForceCloseHdr: boolean): void;

  /**
   * Set Default Multi Screen Mode When Switch User
   */
  function setDefaultMultiScreenModeWhenSwitchUser(): void;

  /**
   * notify Extend Screen create finish
   */
  function notifyExtendScreenCreateFinish(): void;

  /**
   * notify Extend Screen destroy finish
   */
  function notifyExtendScreenDestroyFinish(): void;

  /**
   * notify Screen Mask Appear
   */
  function notifyScreenMaskAppear(): void;

  /**
   * set Primary Display System Dpi
   */
  function setPrimaryDisplaySystemDpi(dpi: number): void;

  /**
   * get Primary Display System Dpi
   */
  function getPrimaryDisplaySystemDpi(): number;

  /**
   * Get the current fold display mode.
   * @returns Returns fold display mode of device.
   */
  function getFoldDisplayMode(): FoldDisplayMode;

  /**
   * notify screen and 0-level system scene ready
   * @param screenId screen id
   */
  function notifyScreenConnectCompletion(screenId: number): void;
}

export default screenSessionManager;
