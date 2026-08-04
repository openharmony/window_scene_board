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

import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy display from '@ohos.display';
import lazy { Configuration } from '@ohos.app.ability.Configuration';
import lazy ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import lazy DeviceInfo from '@ohos.deviceInfo';
import lazy { ThemeConstant } from '../utils/ThemeConstant';
import lazy { EngineProxy } from './EngineProxy';
import { Log } from '../utils/Log';
import { ResourceReloadStrategy } from '../reloadmanager/ResourceReloadStrategy';
import { DeviceUtil } from '../utils/DeviceUtil';

const TAG: string = 'EngineStateHelper';

const UNFOLDED_IDENTIFIER: number = 4;
const LAND_IDENTIFIER: number = 2;
const DARK_IDENTIFIER: number = 1;
const SECOND_EXPAND_IDENTIFIER: number = 8;

const FOLD_BIT_POSITION: number = 2;
const ORIENTATION_BIT_POSITION: number = 1;
const COLOR_BIT_POSITION: number = 0;
const EXPAND_TO_FULL_EXPAND_PORTRAIT: number = 6;
const EXPAND_TO_FULL_EXPAND_LAND: number = 2;
const PORTRAIT_FULL_EXPAND_TO_BASE: number = 8;
const BASE_TO_FULL_EXPAND: number = 10;
const TRI_FOLD_FULL_EXPAND: number = 11;
const LEFT_HALF_RIGHT_EXPAND: number = 21;
const FOLD_LEFT_HALF_INVALID: number = 22;
const FOLD_INVALID: number = 12;
const LEFT_EXPAND_RIGHT_HALF: number = 13;
const LEFT_HALF_RIGHT_HALF: number = 23;

const TRI_BASE_IDENTIFIER: number = 0;
const TRI_UNFOLDED_IDENTIFIER: number = 4;
const TRI_UNFOLDED_LAND_IDENTIFIER: number = 6;
const TRI_FULL_EXPAND_IDENTIFIER: number = 8;
const TRI_FULL_EXPAND_LAND_IDENTIFIER: number = 10;

const TRI_BASE_RATE: number = 0.5;
const TRI_FULL_EXPAND_LAND_RATE: number = 0.8;
const TRI_UNFOLDED_LAND_RATE: number = 1;
const TRI_UNFOLDED_RATE: number = 1.25;
const TRI_FULL_EXPAND_RATE: number = 2;

/**
 * Helper class to monitor and get initial device status for engine to load the correct resource
 *
 * @since 2024-03-15
 */
export class EngineStateHelper {
  private config?: Configuration;

  private colorMode: ConfigurationConstant.ColorMode = ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;

  private screenDirection: display.Orientation = display.Orientation.PORTRAIT;

  private foldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_FOLDED;

  private stateIdentifier: number = 0;

  private isNotifyColorChange: boolean = false;

  private isNotifyOrientationChange: boolean = false;

  private isNotifyFoldExpandChange: boolean = false;

  private isNotifyWindowSizeChange: boolean = false;

  private isNotifyLayoutChange: boolean = false;

  private screenWidth: number = 0;

  private screenHeight: number = 0;

  private isPandoraTheme: boolean = false;

  private isPad: boolean = DeviceUtil.isPad();

  private session?: UIExtensionContentSession;

  private context: Context;

  private isSupportStateChange(): boolean {
    // 除了超级折叠设备，在任何时候都支持状态变化
    if (!ThemeConstant.getIsSuperFoldDevices()) {
      return true;
    }
    // 超级折叠设备只有壁纸处于前台时，才允许触发状态变化
    if (EngineProxy.getInstance().getSceneState() === 0 || EngineProxy.getInstance().getSceneState() === -1) {
      return true;
    }
    return false;
  }

  private isFold: boolean = DeviceUtil.isFold();

  private onWindowSizeChange: () => void = () => {
    let currentDisplayWidth: number = 0;
    let currentDisplayHeight: number = 0;
    try {
      currentDisplayWidth = display.getDefaultDisplaySync().width;
      currentDisplayHeight = display.getDefaultDisplaySync().height;
    } catch (error) {
      Log.error(`getDefaultDisplaySync fail, code = ${error?.code}, message = ${error?.message}`);
    }

    let isSizeChange: boolean = this.screenWidth !== currentDisplayWidth || this.screenHeight !== currentDisplayHeight;
    if (!isSizeChange) {
      return;
    }
    this.screenWidth = currentDisplayWidth;
    this.screenHeight = currentDisplayHeight;
    Log.info(TAG, `listenWindowSizeChange, screen size change, width: ${this.screenWidth},` +
      `height: ${this.screenHeight}`);

    this.isNotifyWindowSizeChange = true;
    this.sendConfigurationUpdate();
  };

  private onOrientationChange: () => void = () => {
    // 不支持状态更新的场景，不发送动画
    if (!this.isSupportStateChange()) {
      return;
    }

    let currentDirection: display.Orientation = this.getRealOrientation();
    Log.info(TAG, `onOrientationChange, lastOrientation: ${this.screenDirection}, newDirection: ${currentDirection}`);
    if (currentDirection !== this.screenDirection) {
      let isUpdateQualifier: boolean = true;
      // No need to update qualifier under essentially same direction
      if ((currentDirection & 1) === (this.screenDirection & 1)) {
        isUpdateQualifier = false;
      }
      this.screenDirection = currentDirection;
      Log.info(TAG, `onChange screen direction change, orientation: ${this.screenDirection}`);

      if (isUpdateQualifier) {
        // bit reverse manipulation
        this.stateIdentifier ^= (1 << ORIENTATION_BIT_POSITION);
      }
      this.isNotifyOrientationChange = true;
      AppStorage.setOrCreate<boolean>('isNotifyOrientationChange', this.isPad || this.isFold);
      this.sendConfigurationUpdate();
    }
  };

  private onFoldStatusChange: (data: display.FoldStatus) => void = (data: display.FoldStatus) => {
    let newFoldStatus: display.FoldStatus = this.getActualFoldStatus(data);
    Log.info(TAG, `onFoldStatusChange, origin: ${data}, last: ${this.foldStatus}, new: ${newFoldStatus}`);
    if (newFoldStatus === this.foldStatus) {
      return;
    }
    if (DeviceUtil.isTriFoldProduct()) {
      this.setFoldChangeQualifier(newFoldStatus);
    } else {
      this.stateIdentifier ^= (1 << FOLD_BIT_POSITION);
    }
    this.foldStatus = newFoldStatus;
    Log.info(TAG, `onFoldStatusChange, change foldStatus to ${this.foldStatus}`);

    this.isNotifyFoldExpandChange = true;
    AppStorage.setOrCreate<boolean>('isNotifyOrientationChange', false);
    this.sendConfigurationUpdate();
  };

  private onListenLayoutChange: () => void = () => {
    Log.info(TAG, 'listenLayoutChange');
    this.isNotifyLayoutChange = true;
    if (DeviceUtil.isTriFoldProduct()) {
      this.reviseIdentifier();
    }
    this.sendConfigurationUpdate();
  };

  private reviseIdentifier(): void {
    let rate: number = 1;
    try {
      const width: number = display.getDefaultDisplaySync().width;
      const height: number = display.getDefaultDisplaySync().height;
      if (width !== 0 && height !== 0) {
        rate = height / width;
      }
    } catch (error) {
      Log.error(`getDefaultDisplaySync fail, code = ${error?.code}, message = ${error?.message}`);
    }
    let realStateIdentifier: number = TRI_BASE_IDENTIFIER;
    if (rate < TRI_BASE_RATE) {
      realStateIdentifier = TRI_BASE_IDENTIFIER;
    } else if (rate < TRI_FULL_EXPAND_LAND_RATE) {
      realStateIdentifier = TRI_FULL_EXPAND_LAND_IDENTIFIER;
    } else if (rate < TRI_UNFOLDED_LAND_RATE) {
      realStateIdentifier = TRI_UNFOLDED_LAND_IDENTIFIER;
    } else if (rate < TRI_UNFOLDED_RATE) {
      realStateIdentifier = TRI_UNFOLDED_IDENTIFIER;
    } else if (rate < TRI_FULL_EXPAND_RATE) {
      realStateIdentifier = TRI_FULL_EXPAND_IDENTIFIER;
    }
    if (this.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      realStateIdentifier |= DARK_IDENTIFIER;
    }
    if (this.stateIdentifier !== realStateIdentifier) {
      Log.warn(TAG,
        `rate: ${rate}, realStateIdentifier: ${realStateIdentifier}, stateIdentifier: ${this.stateIdentifier}`);
      this.stateIdentifier = realStateIdentifier;
      this.isNotifyFoldExpandChange = true;
    }
  }

  private setFoldChangeQualifier(newFoldStatus: display.FoldStatus): void {
    // Tri-fold,M2G、G2M has foldStatus and orientation,just respond foldStatus
    let isPortrait: boolean = this.screenDirection === display.Orientation.PORTRAIT ||
      this.screenDirection === display.Orientation.PORTRAIT_INVERTED;
    Log.info(TAG, `onFoldStatusChange, screenDirection: ${this.screenDirection}, isPortrait: ${isPortrait}`);
    if (this.foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED &&
      newFoldStatus === TRI_FOLD_FULL_EXPAND) {
      this.stateIdentifier += isPortrait ? EXPAND_TO_FULL_EXPAND_PORTRAIT : EXPAND_TO_FULL_EXPAND_LAND;
      this.screenDirection = isPortrait ? display.Orientation.LANDSCAPE : display.Orientation.PORTRAIT;
    } else if (this.foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED &&
      newFoldStatus === TRI_FOLD_FULL_EXPAND) {
      this.stateIdentifier += BASE_TO_FULL_EXPAND;
      this.screenDirection = display.Orientation.LANDSCAPE;
    } else if (this.foldStatus === TRI_FOLD_FULL_EXPAND &&
      newFoldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      this.stateIdentifier -= isPortrait ? EXPAND_TO_FULL_EXPAND_LAND : EXPAND_TO_FULL_EXPAND_PORTRAIT;
      this.screenDirection = isPortrait ? display.Orientation.LANDSCAPE : display.Orientation.PORTRAIT;
    } else if (this.foldStatus === TRI_FOLD_FULL_EXPAND &&
      newFoldStatus === display.FoldStatus.FOLD_STATUS_FOLDED) {
      this.stateIdentifier -= isPortrait ? PORTRAIT_FULL_EXPAND_TO_BASE : BASE_TO_FULL_EXPAND;
      this.screenDirection = display.Orientation.PORTRAIT;
    } else {
      this.stateIdentifier ^= (1 << FOLD_BIT_POSITION);
    }
  }

  constructor(context: Context) {
    this.context = context;
  }

  private getActualFoldStatus(incomingStatus: display.FoldStatus): display.FoldStatus {
    // 双折叠半折和M态半折更新为展开态
    if (incomingStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED) {
      return display.FoldStatus.FOLD_STATUS_EXPANDED;
    }

    if (incomingStatus === FOLD_LEFT_HALF_INVALID || incomingStatus === FOLD_INVALID) {
      return display.FoldStatus.FOLD_STATUS_FOLDED;
    }

    // 13表示半折和展开 23表示半折和半折，21表示展开和半折，更新为G态
    if (incomingStatus === LEFT_EXPAND_RIGHT_HALF || incomingStatus === LEFT_HALF_RIGHT_HALF ||
      incomingStatus === LEFT_HALF_RIGHT_EXPAND) {
      return TRI_FOLD_FULL_EXPAND;
    }

    // 展开态、G态
    return incomingStatus;
  }

  /**
   * Update state identifier when onConfigurationUpdate is called in UIExtensionAbility
   *
   * @param newConfig New config including information for color/orientation/dpi
   */
  public onConfigurationUpdate(newConfig: Configuration): void {
    this.config = newConfig;
    if (this.config.colorMode !== undefined && this.config.colorMode !== this.colorMode) {
      this.colorMode = this.config.colorMode;
      Log.info(TAG, `onConfigurationUpdate color mode change, colorMode: ${this.colorMode}`);

      // bit reverse manipulation
      this.stateIdentifier ^= (1 << COLOR_BIT_POSITION);
      this.isNotifyColorChange = true;
      AppStorage.setOrCreate<boolean>('isNotifyOrientationChange', false);
      this.sendConfigurationUpdate();
    }
  }

  private getRealOrientation(): display.Orientation {
    if (!this.needRealOrientation()) {
      // 如果不支持旋转，则默认返回常规竖屏
      return display.Orientation.PORTRAIT;
    }
    return DeviceUtil.getOrientation();
  }

  private needRealOrientation(): boolean {
    // portrait phone never response to orientation change
    if (DeviceUtil.isPhone() && !DeviceUtil.isFold()) {
      return false;
    }

    // 三折叠G态可以旋转
    if (this.foldStatus === TRI_FOLD_FULL_EXPAND) {
      return true;
    }

    // 平板、大折叠展开态、新小折叠折叠态，可以真正旋转
    return DeviceUtil.isDoubleDisplayPocketProduct() && this.foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED ||
      !DeviceUtil.isDoubleDisplayPocketProduct() && this.foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED ||
    DeviceUtil.isPad();
  }

  /**
   * listen the window size change
   */
  public listenWindowSizeChange(): void {
    try {
      display.on('change', this.onWindowSizeChange);
    } catch (err) {
      Log.error(TAG, `listenWindowSizeChange, listen failed, code: ${err.code}`);
    }
  }

  /**
   * listen the screen orientation change
   */
  public listenOrientationChange(): void {
    let isPortrait: boolean = DeviceUtil.isPhone() && !DeviceUtil.isFold();
    if (isPortrait) {
      Log.info(TAG, 'listenOrientationChange, this device is the portrait phone');
      return;
    }
    try {
      display.on('change', this.onOrientationChange);
    } catch (err) {
      Log.error(TAG, `listenWindowChange, listen failed, code: ${err.code}`);
    }
  }

  /**
   * listen the opening and closing status of the foldable display
   */
  public listenFoldStatusChange(): void {
    try {
      if (!DeviceUtil.isFold() && !DeviceUtil.isSmallFoldProduct()) {
        Log.info(TAG, 'listenFoldStatusChange, this device unsupported fold.');
        return;
      }
      display.on('foldStatusChange', this.onFoldStatusChange);
    } catch (err) {
      Log.error(TAG, `listenFoldStatusChange, listen failed, code: ${err.code}`);
    }
  }

  /**
   * listen the proxy window size change to refresh layout
   *
   * @param themeEngine UIExtensionContentSession
   */
  public listenLayoutChange(session: UIExtensionContentSession): void {
    this.session = session;
    try {
      session.getUIExtensionHostWindowProxy()?.on('windowSizeChange', this.onListenLayoutChange);
    } catch (err) {
      Log.error(TAG, `listenLayoutChange failed, code: ${err?.code}, message: ${err?.message}}`);
    }
  }

  /**
   * Set initial state identifier on first load
   *
   * @param config Context configuration
   */
  public setInitState(config: Configuration | undefined): void {
    if (!config) {
      return;
    }
    try {
      this.screenWidth = display.getDefaultDisplaySync().width;
      this.screenHeight = display.getDefaultDisplaySync().height;
    } catch (error) {
      Log.error(`getDefaultDisplaySync fail, code = ${error?.code}, message = ${error?.message}`);
    }
    if (config.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.colorMode = ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
      this.stateIdentifier |= DARK_IDENTIFIER;
    }
    try {
      if (DeviceUtil.isFoldExpanded()) {
        if (display.getFoldStatus() >= TRI_FOLD_FULL_EXPAND) {
          this.foldStatus = TRI_FOLD_FULL_EXPAND;
          this.stateIdentifier |= SECOND_EXPAND_IDENTIFIER;
        } else {
          this.foldStatus = display.FoldStatus.FOLD_STATUS_EXPANDED;
          this.stateIdentifier |= UNFOLDED_IDENTIFIER;
        }
      }
    } catch (err) {
      Log.error(TAG, `getFoldStatus failed, code: ${err.code}`);
    }

    if (this.needRealOrientation() && (DeviceUtil.getOrientation() === display.Orientation.LANDSCAPE ||
      DeviceUtil.getOrientation() === display.Orientation.LANDSCAPE_INVERTED)) {
      this.screenDirection = DeviceUtil.getOrientation();
      this.stateIdentifier |= LAND_IDENTIFIER;
    }

    Log.info(TAG, `Initial status identifier is ${this.stateIdentifier}`);
    AppStorage.setOrCreate<number>('resourceQualifier', this.stateIdentifier);
  }

  private sendConfigurationUpdate(): void {
    let modeParam: object = [];
    modeParam['resourceQualifier'] = this.stateIdentifier;
    try {
      modeParam['screenWidth'] = display.getDefaultDisplaySync().width;
      modeParam['screenHeight'] = display.getDefaultDisplaySync().height;
    } catch (error) {
      Log.error(`getDefaultDisplaySync fail, code = ${error?.code}, message = ${error?.message}`);
    }

    Log.info(TAG,
      `Sending new configuration：resourceQualifier = ${this.stateIdentifier}, width = ${modeParam['screenWidth']},` +
        `height = ${modeParam['screenHeight']}`);
    if (this.isNotifyColorChange || this.isNotifyOrientationChange || this.isNotifyFoldExpandChange) {
      // 如果引擎启动，则使用引擎更新资源。如果引擎未启动（使用静态壁纸），则使用ResourceReloadStrategy直接加载资源
      ResourceReloadStrategy.getInstance().onReloadRequested(modeParam);
    }

    this.isNotifyColorChange = false;
    this.isNotifyOrientationChange = false;
    this.isNotifyFoldExpandChange = false;
    this.isNotifyWindowSizeChange = false;
    this.isNotifyLayoutChange = false;
  }

  /**
   * destroy foldStatus and window change listeners
   */
  public destroyListener(): void {
    try {
      display.off('change', this.onWindowSizeChange);
      display.off('change', this.onOrientationChange);
      display.off('foldStatusChange', this.onFoldStatusChange);
      this.session?.getUIExtensionHostWindowProxy().off('windowSizeChange', this.onListenLayoutChange);
    } catch (err) {
      Log.error(`Failed to unregister callback. error code: ${err?.code}, message: ${err?.message}}`);
    }
  }

  /**
   * Set whether current theme is pandora theme
   *
   * @param isPandoraTheme current theme is pandora theme
   */
  public setPandoraThemeState(isPandoraTheme: boolean): void {
    this.isPandoraTheme = isPandoraTheme
  }
}